@echo off
setlocal enabledelayedexpansion
set base=%~dp0
set file=urls.txt
:tofile
 
if not exist %file% (
	@echo urls.txt not exist
	set file=
	goto :tofile
)
 
for /f %%a in (%base%%file%) do (
	set url=%%a
	ECHO %%a	
	ECHO line=!line!
    ECHO curl %%a --ssl-no-revoke



    pause
)
pause