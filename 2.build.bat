@echo off

set target=new_ffxkr.iso

rem 임시 폴더 생성
if exist temp del /q "temp\*"
if not exist temp mkdir temp
xcopy "extracted\*" "temp\" /s /e /y /q

rem 일어 설정 패치
tools\fcopy -idx temp\0000.elf 0x46AD70 "00000000"

rem ev1 파일 압축
FOR %%i IN (temp\*.ev1) DO (
    tools\ffxcx -c1 -m %%i temp\%%~ni.ev.c1
    del %%i
)

rem ev2 파일 압축
FOR %%i IN (temp\*.ev2) DO (
    tools\ffxcx -c2 -m %%i temp\%%~ni.ev.c2
    del %%i
)

rem ftcx1 파일 압축
FOR %%i IN (temp\*.ftcx1) DO (
    tools\ffxcx -c1 -m %%i temp\%%~ni.ftcx.c1
    del %%i
)

rem iso 적용
copy iso\ffxkr.iso %target%
FOR %%i IN (temp\**) DO (
    tools\ffxlba -i %target% %%i
)

pause
