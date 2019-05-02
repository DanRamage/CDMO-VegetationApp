import os
import optparse
import logging.config
import ConfigParser
import zipfile
import uuid
from string import Template

from utils import smtpClass,ConnectionError,LoginError,EmailSendError


class file_data_lookup(object):
  def __init__(self, parent_directory, logger=True):
    self.logger = None
    if logger:
      self.logger = logging.getLogger("veg_request_logger")

    self.parent_directory = parent_directory

  def get_file_list(self, data_type_name, reserve_code, year_list):

    file_list = []
    #Loop through the years and build a list of files to zip and send.
    for year in year_list:
      reserve_path = "%s/%s/%s" % (data_type_name, reserve_code, year)
      file_path = "%s/%s" % (self.parent_directory, reserve_path)
      for file in os.listdir(file_path):
        full_file_path = os.path.join(file_path, file)
        if not os.path.isdir(full_file_path):
          #Add tuple with the full path to the file to zip and the name we want it to be in
          #the zip file. Without the zip name, the full path from server would be used.
          #file_list.append((full_file_path, reserve_path + '/' + file))
          file_list.append((full_file_path, file))

    return file_list

  def zip_files(self, zip_list, zip_outfile):
    if self.logger:
      self.logger.debug("Start zipping files to: %s" % (zip_outfile))
    try:
      with zipfile.ZipFile(zip_outfile, "w") as zip_obj:
        for rec in zip_list:
          reserve_code = rec.keys()
          if self.logger:
            self.logger.debug("Reserve: %s zipping files." %(reserve_code[0]))
          for file in rec[reserve_code[0]]:
            if self.logger:
              self.logger.debug("Adding file: %s to zip, zipname: %s" % (file[0], file[1]))
            zip_obj.write(file[0], file[1])

    except Exception,e:
      if self.logger:
        self.logger.exception(e)

    if self.logger:
      self.logger.debug("Finished zipping files to: %s" % (zip_outfile))

    return


def email_results(**kwargs):
  logger = logging.getLogger("veg_request_logger")
  if logger:
    logger.debug("Preparing to send email to: %s" % (kwargs['to_addr']))
  details_template = Template("""
    Station Code - $reserve_code
    Years: $years
    Data Type: $data_type
    Type: Vegetation Data

  """)

  body_template = Template("""
Thank you for visiting the NOAA NERR Centralized Data Management Office website. Below you will find a link to download the files you requested using our Vegetation Monitoring Data Application.

Thank you, and if you have any questions/comments please do not hesitate to contact us at cdmowebmaster@baruch.sc.edu.

Click on the following link to download your data. If this link does not work for you, please copy and paste the URL into a new browser tab and hit enter. The URL is: $url

Your download details:
$details

Requested citation format: National Estuarine Research Reserve System (NERRS). 2012. System-wide Monitoring Program. Data accessed from the NOAA NERRS Centralized Data Management Office website: http://www.nerrsdata.org/; accessed 12 October 2012.
  """)
  try:
    details = ""
    for reserve_data in kwargs['reserves']:
      reserve_code,years,data_type_name = reserve_data.split(';')
      details += details_template.substitute(reserve_code=reserve_code, years=years, data_type=data_type_name)

    body = body_template.substitute(url=kwargs['zip_url'], details=details)
  except Exception,e:
    if logger:
      logger.exception(e)
  else:
    try:
      if logger:
        logger.debug("Email params: Server: %s From: %s To: %s Pwd: %s"\
          %(kwargs['email_server'], kwargs['from_addr'], kwargs['to_addr'], kwargs['email_pwd']))
      subject =  "[CDMO] Vegetation Data Request"
      smtp = smtpClass(kwargs['email_server'], kwargs['server_account'], kwargs['email_pwd'], 465, True)
      #smtp.from_addr("%s@%s" % (kwargs['from_addr'],kwargs['email_server']))
      smtp.from_addr(kwargs['from_addr'])
      smtp.rcpt_to([kwargs['to_addr']])
      smtp.subject(subject)
      smtp.message(body)
      smtp.send()
    except (ConnectionError,LoginError,EmailSendError,Exception) as e:
      if logger:
        logger.exception(e)
  if logger:
    logger.debug("Finished email.")

  return

def save_user_info():
  return

def main():
  parser = optparse.OptionParser()

  parser.add_option("-i", "--ConfigFile", dest="configFile",
                    help="INI File with the settings used.")

  parser.add_option("-r", "--ReservesRequest", dest="reservesRequest",
                    help="Reserve codes and years for request.")
  parser.add_option("-e", "--EmailAddr", dest="receiverEmail",
                    help="Email address to send results to.")
  (options, args) = parser.parse_args()

  configFile = ConfigParser.RawConfigParser()
  configFile.read(options.configFile)
  try:

    log_conf_file = configFile.get('logging', 'veg_request_config_file')
    if log_conf_file:
      logging.config.fileConfig(log_conf_file)
      logger = logging.getLogger("veg_request_logger")
      logger.info("Log file opened.")
      logger.info("Reserves Request: %s Email Address: %s" % (options.reservesRequest, options.receiverEmail))
  except ConfigParser.Error, e:
    print("No log configuration file given, logging disabled.")
  try:
    #Get the parent directory where the various vegetation sub directories reside.
    parent_dir = configFile.get('data', 'parent_directory')
    #Director to create zip file, should be web accesible directory.
    zip_out_directory = configFile.get('data', 'zip_out_directory')
    #Base url to send in the email link for the user to download. The filename is generated below.
    zip_link_base_url = configFile.get('data', 'zip_link_base_url')
    #Email server address the email is sent with.
    email_server = configFile.get('email_settings', 'server_address')
    #From address that the email will come from.
    from_addr = configFile.get('email_settings', 'from_addr')
    #Server email account.
    server_account = configFile.get('email_settings', 'server_account')
    #Password for the email account.
    email_pwd = configFile.get('email_settings', 'password')

  except ConfigParser.Error, e:
    if logger:
      logger.exception(e)
  else:
    reserve_files = file_data_lookup(parent_dir)
    reserve_info = []
    #split up the reserve request. The request is formated:
    #reserve_code;year1,year2,...;data_type~reserve_code2;year1,year2,...;data_type
    reserves = options.reservesRequest.split('~')
    for reserve_data in reserves:
      reserve_code,years,data_type_name = reserve_data.split(';')
      file_list = reserve_files.get_file_list(data_type_name, reserve_code, years.split(','))
      reserve_info.append({reserve_code: file_list})

    #Generate a uuid to use for the file name.
    zip_file_name = uuid.uuid4()
    #Build the local file path to save the zip to.
    zip_outfile = "%s%s.zip" % (zip_out_directory, zip_file_name)
    reserve_files.zip_files(reserve_info, zip_outfile)
    email_results(reserves=reserves,
                  zip_url="%s%s.zip" % (zip_link_base_url,zip_file_name),
                  email_server=email_server,
                  from_addr=from_addr,
                  email_pwd=email_pwd,
                  to_addr=options.receiverEmail,
                  server_account=server_account)
    if logger:
      logger.info("Log file closed.")

  return

if __name__ == '__main__':
  main()
