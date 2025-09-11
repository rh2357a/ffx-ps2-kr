@echo off

setlocal enabledelayedexpansion

set input_iso=ffxkr.iso
set target=ffxkr_patched.iso

echo extract '%input_iso%'
if exist build rmdir /s /q build
tools\ffxiso -e %input_iso% build

echo build font...
rem                             0x1000
tools\ffxftcx font/font_kr.bmp   4096  build\files\file_455.ftcx

echo asm files...
for %%i in (asm\*.asm) do (
  echo.  %%i
  tools\armips %%i
)

echo ev1 files...
for %%i in (texts\*.ev1.ko.txt) do (
  set "filename=%%~ni"
  set "filename=!filename:.ev1.ko=!"
  set "ev_name=build\files\!filename!.ev1"
  set "lz_name=build\files\!filename!.ev.lz1"

  echo.  %%i
  tools\ffxcx -d !lz_name! !ev_name!
  tools\ffxev -i1 -t font\ko.tbs !ev_name! %%i

  del !lz_name!
  tools\ffxcx -c1 !ev_name! !lz_name!
)

echo ev2 files...
for %%i in (texts\*.ev2.ko.txt) do (
  set "filename=%%~ni"
  set "filename=!filename:.ev2.ko=!"
  set "ev_name=build\files\!filename!.ev2"
  set "lz_name=build\files\!filename!.ev.lz2"

  echo.  %%i
  tools\ffxcx -d !lz_name! !ev_name!
  tools\ffxev -i1 -t font\ko.tbs !ev_name! %%i

  del !lz_name!
  tools\ffxcx -c2 !ev_name! !lz_name!
)

echo repack '%input_iso%'
tools\ffxiso -i build %target%

pause
