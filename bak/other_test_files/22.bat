@echo off
setlocal enabledelayedexpansion

mkdir _temp
mkdir logs

set base=%~dp0
set file=urls.txt
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

    echo gh api -H "Accept: application/vnd.github+json" --hostname !ghe! /orgs/!org!
    echo IF %errorlevel% NEQ 0 GOTO ERROR_ORG_NOT_EXIST
    echo IF %errorlevel% EQU 0 GOTO ORG_OK_GET_REPO

    :ERROR_ORG_NOT_EXIST
    ECHO command failed,!org! not exist,need create
    echo gh api --method POST -H "Accept: application/vnd.github+json" /admin/organizations --hostname !ghe! -f login='!org!' -f profile_name='!org!' -f admin='!gheadmin!'
    
    echo IF %errorlevel% EQU 0 GOTO ORG_OK_GET_REPO
    echo IF %errorlevel% NEQ 0 GOTO FIAlED_CREATE_ORG

    :CREATE_ORG_OK_GET_REPO
    echo gh api -H "Accept: application/vnd.github+json" --hostname !ghe! /repos/!org!/!repo!  

    echo IF %errorlevel% EQU 0 GOTO REPO_OK_CONTINUE
    echo IF %errorlevel% NEQ 0 GOTO ERROR_REPO_NOT_EXIST

    :ERROR_REPO_NOT_EXIST
    ECHO command failed,!repo! not exist,need create    
    echo gh api --method POST -H "Accept: application/vnd.github+json" --hostname !ghe! /orgs/!org!/repos -f name='!repo!'

    echo IF %errorlevel% EQU 0 GOTO REPO_OK_CONTINUE
    echo IF %errorlevel% NEQ 0 GOTO FIAlED_CREATE_REPO

    :REPO_OK_CONTINUE
    echo cd _temp
    echo git clone --mirror "!url!" !repo!
    echo cd !repo!

    echo git remote set-url --push origin "https://!ghe!/!org!/!repo!"

    echo git push --mirror

    echo cd ..
    echo rmdir /s/q !repo!

    :FIAlED_CREATE_ORG
    ECHO Create ORG !org! Failed

    :FIAlED_CREATE_REPO
    ECHO Create Repo !repo! Failed

    pause

)
pause


