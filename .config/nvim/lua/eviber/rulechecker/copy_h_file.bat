@echo off
setlocal enabledelayedexpansion

REM Set source directory and destination directory
set "source_dir=C:\Users\FT999180\Documents\FADEX\OSS_PU_DEV-rulechecker\OSS_PU_SW"
set "destination_dir=C:\Users\FT999180\Documents\FADEX\.nvim_rulechecker\headers"

if exist "%destination_dir%" (
    rmdir /s /q "%destination_dir%"
)

REM Create destination directory
mkdir "%destination_dir%"

REM Loop through all .h files in the source directory and its subdirectories
for /r "%source_dir%" %%F in (*.h) do (
    REM Extract file name and extension
    set "filename=%%~nxF"
    REM Copy the file to the destination directory
    copy "%%F" "%destination_dir%" > nul
    REM Display the copied file
    echo Copied: "!filename!"
)

echo All .h files copied successfully.

REM pause
