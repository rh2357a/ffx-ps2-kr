@echo off

setlocal enabledelayedexpansion

pushd ..

echo extract 'base.iso'
if exist build rmdir /s /q build
tools\ffxiso -e base.iso build

popd

pause
