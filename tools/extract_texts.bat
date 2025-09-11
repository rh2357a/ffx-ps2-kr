@echo off

pushd ..

setlocal enabledelayedexpansion

if not exist texts mkdir texts

echo extract ev.lz1 files...
for %%i in (build\files\*.ev.lz1) do (
  set "filename=%%~ni"
  set "filename=!filename:.ev=!"

  echo.  %%i
  tools\ffxcx -d %%i texts\!filename!
  tools\ffxev -e1 -t font\ja.tbs texts\!filename! texts\!filename!.ev1.ko.txt
  tools\ffxev -e1 -t font\ja.tbs texts\!filename! texts\!filename!.ev1.ja.txt
  tools\ffxev -e4 -t font\en.tbs texts\!filename! texts\!filename!.ev1.en.txt
  del texts\!filename!
)

echo extract ev.lz2 files...
for %%i in (build\files\*.ev.lz2) do (
  set "filename=%%~ni"
  set "filename=!filename:.ev=!"

  echo.  %%i
  tools\ffxcx -d %%i texts\!filename!
  tools\ffxev -e1 -t font\ja.tbs texts\!filename! texts\!filename!.ev2.ko.txt
  tools\ffxev -e1 -t font\ja.tbs texts\!filename! texts\!filename!.ev2.ja.txt
  tools\ffxev -e4 -t font\en.tbs texts\!filename! texts\!filename!.ev2.en.txt
  del texts\!filename!
)

popd

pause
