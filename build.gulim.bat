@echo off

pushd tools

set input_iso=base.iso
set target_iso=ffx_kr_gulim.iso
set target_patch=ffx_kr_gulim.xdelta
set font_path=font/font_kr.gulim.bmp
call build.bat

popd

pause
