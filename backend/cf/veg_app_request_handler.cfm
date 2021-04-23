<cfparam name="form.first_name" default="">
<cfparam name="form.last_name" default="">
<cfparam name="form.email_addr" default="">
<cfparam name="form.organization" default="">
<cfparam name="form.occupation" default="">
<cfparam name="form.purpose" default="">
<cfparam name="form.staff" default="">
<cfparam name="form.comments" default="">
<cfparam name="form.reserve_codes" default="">


<cfscript>
variables.reserves_info = ListToArray(form.reserve_codes, '~');
variables.config_file="D:\\scripts\\veg_app\\veg_data.ini";
variables.station_list= ArrayNew(1);
variables.years_requested= ArrayNew(1);
variables.file_names = ArrayNew(1);
variables.data_type="";
</cfscript>

<!---
 * The reserve data and years comes through in the following format:
 * reserve_code;year1,year2,...;data_type~reserve_code2;year1,year2,...;data_type
 * We split apart the reserve info above on the '~' which gives us an array of each reserve,
 * then we get the reserve code and years requested in the loop below.
 * The '~' delimits the reserves requested, then the ';' delimits the individual pieces for the reserve.
 * We use this to store the user info in the database.
--->
<cfloop array="#variables.reserves_info#" index="reserve_data">
	<cfset reserve_info = ListToArray(reserve_data, ';')>
	<cfscript>
		ArrayAppend(variables.station_list, variables.reserve_info[1]);
		ArrayAppend(variables.years_requested, variables.reserve_info[2]);
	</cfscript>
    <!--- We need to build a list of reserve code and years for the filename db column --->
    <cfset data_years = ListToArray(variables.reserve_info[2], ',')>
    <cfloop array="#variables.data_years#" index="years_data">
        <cfscript>
            ArrayAppend(variables.file_names, variables.reserve_info[1] & years_data);
    	</cfscript>
    </cfloop>

	<cfif len(variables.data_type) eq 0>
		<cfif variables.reserve_info[3] eq "Mangroves">
			<cfscript>
				variables.data_type='M';
			</cfscript>
			<cfelseif variables.reserve_info[3] eq "SubmergedAquaticVegetation">
				<cfscript>
					variables.data_type='SAV';
				</cfscript>
			<cfelseif variables.reserve_info[3] eq "MarshVegetation">
				<cfscript>
					variables.data_type='MV';
				</cfscript>
			<cfelse>
				<cfscript>
					variables.data_type='';
				</cfscript>

		</cfif>
	</cfif>
</cfloop>

<cfscript>
    variables.reserve_codes_replaced = replace(#form.reserve_codes#, ";", ":", "all");
</cfscript>
<!---
<cflog
    text = "#variables.config_file# #variables.reserve_codes_replaced# #form.email_addr#"
    type = "Informational"
    file = "cdmo"
    application = "yes">
--->
<cfexecute name="C:\\Windows\\SysWOW64\\cmd.exe"
			arguments="/c D:\scripts\veg_app\veg_app_handler.bat #variables.config_file# #variables.reserve_codes_replaced# #form.email_addr#"
			outputFile="d:\\scripts\\logs\\veg_handler.log"
			errorFile="d:\\scripts\\logs\\veg_handler_error.log"
			timeout="180">
</cfexecute>

<cfoutput>
	#form.first_name#,


    thank you for your interest in NERRS vegetation monitoring data.
    If you do not receive your data request from us within thirty minutes,
    please verify that you entered your correct email address and check your
    junk mail folder.  If you still have not received your data request, or
    have any questions or comments about the website or vegetation monitoring application,
    please contact us at cdmowebmaster@baruch.sc.edu.
</cfoutput>

<!---
<cfexecute name="D:\\python27\\python.exe"
			arguments="D:\\scripts\\veg_app\\veg_app_request_process.py --ConfigFile=#variables.config_file# --ReservesRequest=#form.reserve_codes# --EmailAddr=#form.email_addr#"
			outputfile="d:\\scripts\\logs\\veg_handler.log">
</cfexecute>
--->
<!---WANT TO CATCH ANY ERRORS INSERTING INFORMATION WRAP IN TRY/CATCH--->
<cftry>

	<!---SET DATE AND FULL NAME VARS--->
	<cfset dateNow = now()>
	<cfset fullName = #form.first_name# & " " & #form.last_name#>

    <!--- Build filenames string from the array --->
    <cfset filenames = ArrayToList(variables.file_names, ",")>

	<!---HERE CHECK TO SEE IF THIS IS A UNIQUE ENTRY OR NOT--->
	<cfquery name="isUnique" datasource="CDMO">
	SELECT id FROM Guests WHERE email LIKE '#form.email_addr#'
	</cfquery>

	<!---SET UNIQUE VAL--->
	<cfif #isUnique.recordCount# gt 0>
		<cfset unique = 'NO'>
	<cfelse>
		<cfset unique = 'YES'>
	</cfif>
	<!--- Reserve codes requested, multiple reserves separated by ';' --->
	<cfset reserve_codes = #ArrayToList(variables.station_list, ';')#>
	<!--- Years for each reserve. Years for a reserve separated by ',', reserve groupings of years separated by ';' --->
	<cfset reserve_years_requested = #ArrayToList(variables.years_requested, ';')#>
	<!---THIS WILL INSERT INFO INTO GUESTS TABLE--->
	<cfquery name="insertIntoGuests" datasource="cdmo_apps">
	INSERT INTO Guests (Full_Name, comments, Email, Organization, datause, Purpose, LogDate, station_list, appFrom,filetype,uniqueEntry,nerrsStaff, filename)
	VALUES ('#fullName#','#form.comments#', '#form.email_addr#','#form.organization#','#form.occupation#','#form.purpose#',#dateNow#, '#reserve_codes#','VegApp','#variables.data_type#','#unique#','#form.staff#', '#filenames#')
	</cfquery>
	<!---IF COMMENTS LEFT SEND THEM OUT--->
	<cfif #form.comments# neq ''>
		<cfmail to="#form.email_addr#,cdmowebmaster@baruch.sc.edu"
			from="cdmowebmaster@baruch.sc.edu"
			subject="[CDMO New Server]Comments on the Vegetation App"
			type="html">
			Thank you for leaving the following comments: #form.comments#.
		</cfmail>
	</cfif>

<!---CATCH ANY EXCEPTION--->
<cfcatch type="any">
      <cfmail to="dan@inlet.geol.sc.edu,cdmowebmaster@baruch.sc.edu" from="cdmosupport@baruch.sc.edu" subject="[CDMO New Server] Vegetation App ERROR INSERTING GUEST INFO" type="html">
		ERROR:
    	<br />Never inserted guests info:
		<br />Form entries
		<br />First Name: #form.first_name#
		<br />Last Name: #form.last_name#
		<br />Email: #form.email_addr#
		<br />Reserves: #reserve_codes#
		<br />Occupation: #form.occupation#
		<br />Organization: #form.organization#
		<br />Purpose: #form.purpose#
		<br />Staff: #form.staff#
		<br />Comments: #form.comments#
        <br />
		<br />#cfcatch.Message# #cfcatch.Detail# - #cfcatch.Type#
	</cfmail>
</cfcatch>

</cftry>
<!---END TRY--->

