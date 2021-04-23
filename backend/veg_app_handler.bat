CALL D:\Python\pyenv3.8\Scripts\activate.bat
set config_file=%1
set "reserve_codes=%2"
set email_addr=%3
python.exe D:\\scripts\\veg_app\\veg_app_request_process.py --ConfigFile=%config_file% --ReservesRequest=%reserve_codes% --EmailAddr=%email_addr%
CALL D:\Python\pyenv3.8\Scripts\deactivate.bat
exit 0