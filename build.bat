@echo off

set input_iso=ffxkr.iso
set target=ffxkr_patched.iso

echo extract '%input_iso%'
if exist build rmdir /s /q build
tools\ffxiso -e %input_iso% build

echo build font...
tools\ffxftcx 1008 1008 font/font.bin font/font_width.bin 16384 build\files\file_455.ftcx
REM                                                      0x4000

echo asm files...
for %%i in (asm\*.asm) do (
  echo.  %%i
  tools\armips %%i
)

echo ev1 files...
for %%i in (ev\*.ev1) do (
  echo.  %%i
  tools\ffxcx -c1 -m %%i build\files\%%~ni.ev.lz1
)

echo ev2 files...
for %%i in (ev\*.ev2) do (
  echo.  %%i
  tools\ffxcx -c2 -m %%i build\files\%%~ni.ev.lz2
)

echo repack '%input_iso%'
tools\ffxiso -i build %target%

:failure_exit
pause
