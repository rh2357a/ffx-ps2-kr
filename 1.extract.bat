@echo off

if exist extracted del /q "extracted\*"
if not exist extracted mkdir extracted

tools\ffxlba -e -f iso\ffxkr.iso extract_list.txt extracted/

FOR %%i IN (extracted\*.ev.c1) DO (
    tools\ffxcx -d %%i extracted\%%~ni1
    del %%i
)

FOR %%i IN (extracted\*.ev.c2) DO (
    tools\ffxcx -d %%i extracted\%%~ni2
    del %%i
)

FOR %%i IN (extracted\*.ftcx.c1) DO (
    tools\ffxcx -d %%i extracted\%%~ni1
    del %%i
)

pause
