@echo off

pushd tools

set input_iso=base.iso
set target_iso=ffx_kr_galmuri.iso
set target_patch=ffx_kr_galmuri.xdelta
set font_path=font/font_kr.galmuri.bmp
call build.bat

popd

pause
