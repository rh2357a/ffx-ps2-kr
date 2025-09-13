@echo off

setlocal enabledelayedexpansion

set input_iso=ffxkr.iso
set target=ffxkr_patched.iso

echo extract '%input_iso%'
if exist build rmdir /s /q build
tools\ffxiso -e %input_iso% build

rem ============================================================

echo copy patch...
for %%i in (patch\*.*) do (
  echo.  %%i
  copy %%i build\files >nul
)

rem ============================================================

echo build font...
rem                             0x1000
rem tools\ffxftcx font/font_kr.galmuri.bmp   4096  build\files\file_00455.ftcx
tools\ffxftcx font/font_kr.dotum.bmp   4096  build\files\file_00455.ftcx

echo asm files...
for %%i in (asm\*.asm) do (
  echo.  %%i
  tools\armips %%i
)

rem ============================================================

echo ev1 files...
for %%i in (texts\event\*.ev1.ko.txt) do (
  set "filename=%%~ni"
  set "filename=!filename:.ev1.ko=!"
  set "ev_name=build\files\!filename!.ev1"
  set "ev_script_name=texts\event\!filename!.ev1.bin"
  set "lz_name=build\files\!filename!.ev.lz1"

  echo.  %%i
  tools\ffxcx -d !lz_name! !ev_name!
  tools\ffxev -i1 -t font\ko.tbs !ev_name! %%i
  if exist !ev_script_name! tools\ffxev -i0 !ev_name! !ev_script_name!

  del !lz_name!
  tools\ffxcx -c1 !ev_name! !lz_name!
  del !ev_name!
)

echo ev2 files...
for %%i in (texts\event\*.ev2.ko.txt) do (
  set "filename=%%~ni"
  set "filename=!filename:.ev2.ko=!"
  set "ev_name=build\files\!filename!.ev2"
  set "ev_script_name=texts\event\!filename!.ev2.bin"
  set "lz_name=build\files\!filename!.ev.lz2"

  echo.  %%i
  tools\ffxcx -d !lz_name! !ev_name!
  tools\ffxev -i1 -t font\ko.tbs !ev_name! %%i
  if exist !ev_script_name! tools\ffxev -i0 !ev_name! !ev_script_name!

  del !lz_name!
  tools\ffxcx -c2 !ev_name! !lz_name!
  del !ev_name!
)

rem ============================================================

echo bt1 files...
for %%i in (texts\battle\*.bt1.txt) do (
  set "filename=%%~ni"
  set "filename=!filename:.bt1=!"
  set "bt_name=build\files\!filename!.bt1"
  set "lz_name=build\files\!filename!.bt.lz1"

  echo.  %%i
  tools\ffxcx -d !lz_name! !bt_name!
  tools\ffxbt -i4 -t font\ko.tbs !bt_name! %%i

  del !lz_name!
  tools\ffxcx -c1 !bt_name! !lz_name!
  del !bt_name!
)

echo bt2 files...
for %%i in (texts\battle\*.bt2.txt) do (
  set "filename=%%~ni"
  set "filename=!filename:.bt2=!"
  set "bt_name=build\files\!filename!.bt2"
  set "lz_name=build\files\!filename!.bt.lz2"

  echo.  %%i
  tools\ffxcx -d !lz_name! !bt_name!
  tools\ffxbt -i4 -t font\ko.tbs !bt_name! %%i

  del !lz_name!
  tools\ffxcx -c2 !bt_name! !lz_name!
  del !bt_name!
)

rem ============================================================

echo bts files...
for %%i in (texts\battle2\*.bts.txt) do (
  set "filename=%%~ni"
  set "filename=!filename:.bts=!"
  set "bt_name=build\files\!filename!.bts"

  echo.  %%i
  tools\ffxbts -i2 -w -t font\ko.tbs !bt_name! %%i
)

rem ============================================================

echo etc text files...
for %%i in (texts\etc\*.txt) do (
  set "filename=%%~ni"
  set "target_filename=build\files\!filename!.bin"

  echo.  %%i
  tools\ffxdlg -i -t font\ko.tbs !target_filename! %%i
)

rem ============================================================

echo name files...
tools\ffxname -e file_00459 build\files

for %%i in (texts\name\*.txt) do (
  set "filename=%%~ni"
  set "target_filename=build\files\file_00459.bin"
  set "part_filename=build\files\!filename!.bin"

  echo.  %%i
  tools\ffxdlg2 -i -t font\ko.tbs !part_filename! %%i
)

tools\ffxname -i file_00459 build\files
tools\ffxname -c file_00459 build\files

rem ============================================================

echo repack '%input_iso%'
tools\ffxiso -i build %target%

pause
