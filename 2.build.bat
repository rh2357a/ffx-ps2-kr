@echo off

set target=new_ffxkr.iso

rem �ӽ� ���� ����
if exist temp del /q "temp\*"
if not exist temp mkdir temp
xcopy "extracted\*" "temp\" /s /e /y /q

rem �Ͼ� ���� ��ġ
tools\fcopy -idx temp\0000.elf 0x46AD70 "00000000"

rem ev1 ���� ����
FOR %%i IN (temp\*.ev1) DO (
    tools\ffxcx -c1 -m %%i temp\%%~ni.ev.c1
    del %%i
)

rem ev2 ���� ����
FOR %%i IN (temp\*.ev2) DO (
    tools\ffxcx -c2 -m %%i temp\%%~ni.ev.c2
    del %%i
)

rem ftcx1 ���� ����
FOR %%i IN (temp\*.ftcx1) DO (
    tools\ffxcx -c1 -m %%i temp\%%~ni.ftcx.c1
    del %%i
)

rem iso ����
copy iso\ffxkr.iso %target%
FOR %%i IN (temp\**) DO (
    tools\ffxlba -i %target% %%i
)

pause
