@echo off
set LOGFILE=%TEMP%\choco-autoupdate-update.log
del /q %LOGFILE%
echo Git pull...
echo Git pull: > %LOGFILE%
git pull origin master >> %LOGFILE%
echo.
echo. >> %LOGFILE%
set packages=openaudible minio-client minio-server gajim lanconfig lanmonitor streamwriter usbdlm
for %%a in (%packages%) do (
    del /q %%a\*.nupkg
    echo Checking %%a for update...
    python autoupdate\update_%%a.py >> %LOGFILE%
    IF %ERRORLEVEL% EQU 0 (echo No update available) ELSE (echo Package updated and commited)
    echo.
    echo. >> %LOGFILE%
)

type %LOGFILE% | telegram-send --stdin
echo Sent log file as Telegram message

