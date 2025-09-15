@echo off

pushd tools

set input_iso=base.iso
set target_iso=ffx_kr_dotum.iso
set target_patch=ffx_kr_dotum.xdelta
set font_path=font/font_kr.dotum.bmp
call build.bat

popd

pause
