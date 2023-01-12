@echo off

set url=https://github.com/Infineon/TARGET_CYW943907AEVAL1F

for /f "tokens=1,2,3,4,5,* delims=/" %%a in ("%url%") do (

	set schema=%%a
	set domain=%%b
	set org=%%c
	set repo=%%d
)

echo -
echo %schema%,%domain%,%org%,%repo%
echo -
pause
