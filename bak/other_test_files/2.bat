@ECHO on
setlocal enabledelayedexpansion

mkdir _temp
mkdir logs

set base=%~dp0
set file=urls-all.txt
set ghe=github-demo.devopshub.cn
set gheadmin=localadmin

:tofile
 
if not exist %file% (
	@ECHO urls.txt not exist
	set file=
	goto :tofile
)
 
for /f %%a in (%base%%file%) do (
	set url=%%a
	ECHO %%a	
	ECHO url=!url!
    ECHO curl %%a --ssl-no-revoke       

    for /f "tokens=1,2,3,4,5,* delims=/" %%a in ("!url!") do (

        set schema=%%a
        set domain=%%b
        set org=%%c
        set repo=%%d
    )

    ECHO vars:!schema!,!domain!,!org!,!repo!
    pause
    dir    

    ECHO DEBUG  check is org exist start,cmd_error_code:!errorlevel! %errorlevel%
    gh api -H "Accept: application/vnd.github+json" --hostname !ghe! /orgs/!org!
    
    ECHO DEBUG  check is org exist end, cmd_error_code:!errorlevel! %errorlevel%
    IF !errorlevel! NEQ 0 CALL :ERROR_ORG_NOT_EXIST
    IF !errorlevel! EQU 0 CALL :ORG_OK_GET_REPO

    :ERROR_ORG_NOT_EXIST
    ECHO DEBUG  command failed,!org! not exist,create start,cmd_error_code:!errorlevel! %errorlevel%
    gh api --method POST -H "Accept: application/vnd.github+json" /admin/organizations --hostname !ghe! -f login='!org!' -f profile_name='!org!' -f admin='localadmin'
    ECHO DEBUG  !org! create end,cmd_error_code:!errorlevel! %errorlevel%

    IF !errorlevel! EQU 0 CALL :ORG_OK_GET_REPO
    IF !errorlevel! NEQ 0 CALL :FIAlED_CREATE_ORG

    :ORG_OK_GET_REPO
    ECHO DEBUG  check is repo exist,start,cmd_error_code:!errorlevel! %errorlevel%
    gh api -H "Accept: application/vnd.github+json" --hostname !ghe! /repos/!org!/!repo!  
    ECHO DEBUG  check is repo exist end, cmd_error_code:!errorlevel! %errorlevel%

    IF !errorlevel! EQU 0 CALL :REPO_OK_CONTINUE
    IF !errorlevel! NEQ 0 CALL :ERROR_REPO_NOT_EXIST

    :ERROR_REPO_NOT_EXIST
    ECHO DEBUG  command failed,!repo! not exist, create start,cmd_error_code:!errorlevel! %errorlevel%
    gh api --method POST -H "Accept: application/vnd.github+json" --hostname !ghe! /orgs/!org!/repos -f name='!repo!'
    ECHO DEBUG !repo! create end, cmd_error_code:!errorlevel! %errorlevel%

    IF !errorlevel! EQU 0 CALL :REPO_OK_CONTINUE
    IF !errorlevel! NEQ 0 CALL :FIAlED_CREATE_REPO

    :REPO_OK_CONTINUE
    ECHO DEBUG  clone code from github
    cd _temp
    mkdir !repo!
    cd !repo!
    git clone --mirror "!url!"

    ECHO check clone is ok(repo dir is exist)
    if exist !repo! (      
        ECHO DEBUG  modify push url to github E
        git remote set-url --push origin "https://!ghe!/!org!/!repo!"

        git push --mirror

        ECHO DEBUG  clear repo file
        cd ..
        rmdir /s/q !repo!
    ) else ( 
          ECHO  clone failed
    )

    :FIAlED_CREATE_ORG
    ECHO DEBUG  Create ORG !org! Failed

    :FIAlED_CREATE_REPO
    ECHO DEBUG  Create Repo !repo! Failed

    ECHO DEBUG  Repo !repo! sync end
    pause

)
pause


