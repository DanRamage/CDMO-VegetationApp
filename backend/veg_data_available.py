import os
import optparse
import logging.config
import ConfigParser
import simplejson
import csv

def build_initial_reserve_info(reserve_info_file):
  logger = logging.getLogger("veg_data_logging")
  header_row = [
    "Row",
    "NERR Site ID ",
    "Station Code",
    "Station Name",
    "Lat Long",
    "Latitude ",
    "Longitude",
    "Status",
    "Active Dates",
    "State",
    "Reserve Name",
    "Real Time",
    "HADS ID",
    "GMT Offset",
    "Station Type",
    "Region",
    "isSWMP"
  ]
  reserve_info = {}
  try:
    if logger:
      logger.debug("Reading reserve info file: %s" % (reserve_info_file))

    reserve_file = open(reserve_info_file, "r")
    dict_file = csv.DictReader(reserve_file, delimiter=',', quotechar='"', fieldnames=header_row)
  except IOError,e:
    if logger:
      logger.exception(e)
  else:
    try:
      line_num = 0
      for row in dict_file:
        if line_num > 0:
          code = row["NERR Site ID "].strip().upper()
          if code not in reserve_info:
            state = row["State"].strip().upper()
            reserve_name = row["Reserve Name"].strip()
            reserve_info[code] = {
              'state': state,
              'reserve_name': reserve_name,
              'reserve_code': code,
              'Mangroves': [],
              'MarshVegetation': [],
              'SubmergedAquaticVegetation': []
            }
        line_num += 1
      if logger:
        logger.debug("%d reserves info processed" % (len(reserve_info)))

      reserve_file.close()
    except Exception, e:
      if logger:
        logger.exception(e)

  return reserve_info

def add_reserve_info(reserve_code):
  logger = logging.getLogger("veg_data_logging")
  if logger:
    logger.debug("Adding reserve information for code: %s" % (reserve_code))

  reserve_info = {
    'reserve_name': "",
    'reserve_code': reserve_code,
    'state': "",
    'Mangroves': [],
    'MarshVegetation': [],
    'SubmergedAquaticVegetation': []
  }
  return reserve_info

"""
Sample directory structure:
-parent_directory
--MarshVegetation
---CBM
    2011
      data files
    2012
      data files
---GRB
    2010
      data files
"""
def parse_directories(reserve_data, parent_directory):
  logger = logging.getLogger("veg_data_logging")

  #List the contents of the parent_directory, add only the directories to our list.
  for data_type_name in os.listdir(parent_directory):
    if os.path.isdir(os.path.join(parent_directory, data_type_name)):
      if logger:
        logger.debug("Adding data type: %s" % (data_type_name))
      parse_data_type_dir(reserve_data, parent_directory, data_type_name)

  #for data_type_subdirectory in data_type_sub_dirs:
  #  parse_data_type_dir(reserve_data, parent_directory, data_type_subdirectory)

  return

def parse_data_type_dir(reserve_data, parent_directory, data_type_subdirectory):
  logger = logging.getLogger("veg_data_logging")

  if logger:
    logger.debug("Processing data type: %s" % (data_type_subdirectory))
  #Walk the data directories, each sub directory at this level contains directories
  #named with reserve codes and under those directories are subdirectories
  #with year directories with the data files.
  reserves_sub_directory = parent_directory + '/' + data_type_subdirectory
  for reserve_code in os.listdir(reserves_sub_directory):
    if os.path.isdir(os.path.join(reserves_sub_directory, reserve_code)):
      if logger:
        logger.debug("Adding Reserve code: %s" % (reserve_code))
      #If the reserve_code is not one we already have, we add the base info.
      if reserve_code in reserve_data:
        #reserve_data[reserve_code] = add_reserve_info(reserve_code)
        reserve_info = reserve_data[reserve_code]
        #Loop through the reserve directory gathering the years.
        reserve_years_sub_directory = reserves_sub_directory + '/' + reserve_code
        for year_sub_dir_name in os.listdir(reserve_years_sub_directory):
          if os.path.isdir(os.path.join(reserve_years_sub_directory, year_sub_dir_name)):
            if logger:
              logger.debug("Adding year: %s" % (year_sub_dir_name))

            reserve_info[data_type_subdirectory].append(year_sub_dir_name)
      else:
        if logger:
          logger.error("Reserve Code: %s not found in the reserve info data." % (reserve_code))


  return

def make_json_file(reserve_data, jsonfullpath):
  logger = logging.getLogger("veg_data_logging")

  try:
    if logger:
      logger.debug("Opening JSON file: %s" % (jsonfullpath))
    json_outfile = open(jsonfullpath, "w")
  except IOError,e:
    if logger:
      logger.exception(e)
  else:
    reserves = {'reserves':[]}
    reserve_keys = reserve_data.keys()
    reserve_keys.sort()
    #We only want to write out the reserves which have data, so check the 3 data types for
    #years, if they are none, do not include reserve in the JSON file.
    for reserve_code in reserve_keys:
      reserve_info = reserve_data[reserve_code]
      #If any of the 3 have data in them, add them to the list.
      if len(reserve_info["Mangroves"])\
        or len(reserve_info["MarshVegetation"])\
        or len(reserve_info["SubmergedAquaticVegetation"]):
        reserves['reserves'].append(reserve_info)
    if logger:
      logger.debug("%d of %d reserves have vegetation data." % (len(reserves['reserves']), len(reserve_data)))
    simplejson.dump(reserves, json_outfile, indent="  ")
    json_outfile.close()

  return
def main():
  logger = None
  parser = optparse.OptionParser()

  parser.add_option("-i", "--ConfigFile", dest="configFile",
                    help="INI File with the settings used.")
  (options, args) = parser.parse_args()

  configFile = ConfigParser.RawConfigParser()
  configFile.read(options.configFile)
  try:

    log_conf_file = configFile.get('logging', 'config_file')
    if log_conf_file:
      logging.config.fileConfig(log_conf_file)
      logger = logging.getLogger("veg_data_logging")
      logger.info("Log file opened.")
  except ConfigParser.Error, e:
    print("No log configuration file given, logging disabled.")

  try:
    #Get the parent directory where the various vegetation sub directories reside.
    parent_dir = configFile.get('data', 'parent_directory')
    json_outpath = configFile.get('data', 'json_outfile')
    reserve_info_file = configFile.get('data', 'reserve_info_file')
  except ConfigParser.Error, e:
    if logger:
      logger.exception(e)
  else:
    reserve_info = build_initial_reserve_info(reserve_info_file)
    parse_directories(reserve_info, parent_dir)
    make_json_file(reserve_info, json_outpath)

  if logger:
    logger.info("Log file closed.")
  return

if __name__ == '__main__':
  main()