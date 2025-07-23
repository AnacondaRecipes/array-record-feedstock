@echo off
setlocal enableextensions enabledelayedexpansion

REM Get Python version (e.g., "3.10" -> "cp310")
for /f %%i in ('python -c "import sys; print(f'cp{sys.version_info.major}{sys.version_info.minor}')"') do set PYTHON_VERSION=%%i
echo Detected Python version: %PYTHON_VERSION%
echo Platform info: Windows

REM Note: Google may not publish Windows wheels for array_record
REM Use pip install from PyPI (this will fail if no Windows wheels are available)
echo Installing array_record from PyPI
%PYTHON% -m pip install array_record==0.7.2 -vv --only-binary=all --index-url https://pypi.org/simple

if errorlevel 1 exit 1