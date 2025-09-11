@echo off

pushd ..

setlocal enabledelayedexpansion

set input_iso=ffxkr.iso

echo extract '%input_iso%'
if exist build rmdir /s /q build
tools\ffxiso -e %input_iso% build

popd

pause
