@echo off
title PXLAR • System Optimization Utility
setlocal EnableDelayedExpansion

:: ############################################################
:: PXLAR SYSTEM OPTIMIZATION UTILITY
:: Version: PXLAR v1.0
:: Purpose: Performance • Privacy • Latency
:: ############################################################

set "VERSION=PXLAR v1.0"
set "LOG=pxlar_log.txt"

:: ================= START =================
cls
echo ==================================================
echo PXLAR SYSTEM OPTIMIZATION UTILITY
echo %VERSION%
echo ==================================================
echo.

break > "%LOG%"
echo PXLAR Optimization Log > "%LOG%"
echo Version: %VERSION% >> "%LOG%"
echo Timestamp: %DATE% %TIME% >> "%LOG%"

for /F "tokens=* skip=1" %%n in ('WMIC path Win32_VideoController get Name ^| findstr "."') do set "GPU_NAME=%%n"
echo GPU: %GPU_NAME% >> "%LOG%"

:: ================= RESTORE POINT =================
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'PXLAR Pre-Optimization Restore Point' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1

:: ================= PRIVACY =================
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection"          /v AllowTelemetry              /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent"           /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f >nul 2>&1

:: ================= FILE EXPLORER =================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt   /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisallowShaking /t REG_DWORD /d 1 /f >nul 2>&1

:: ================= SYSTEM =================
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled       /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control"            /v WaitToKillServiceTimeout /t REG_SZ    /d 5000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop"                       /v MenuShowDelay             /t REG_SZ    /d 0    /f >nul 2>&1

:: ================= GAME / POWER =================
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore"                                 /v GameDVR_Enabled      /t REG_DWORD /d 0 /f >nul 2>&1

:: ================= PRIORITY =================
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1

:: ================= SERVICE TRIMMING =================
for %%S in (
    AarSvc AJRouter ALG AppIDSvc AppMgmt AppReadiness autotimesvc AxInstSV BcastDVRUserService
    BluetoothUserService camsvc CaptureService cbdhsvc defragsvc dmwappushservice DoSvc fhsvc
    FrameServer MapsBroker MessagingService PhoneSvc PimIndexMaintenanceSvc QWAVE RemoteAccess
    SharedAccess SSDPSRV upnphost WSearch Wecsvc WerSvc
) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
)

:: ================= OPTIONAL MODULES =================
call :ask "Disable Windows Defender (PXLAR recommends caution)?"          defender
call :ask "Disable Windows Update (not recommended for most users)?"      updates
call :ask "Disable Xbox Services?"                                        xbox
call :ask "Disable Bluetooth?"                                            bluetooth

goto END

:: ================= ASK FUNCTION =================
:ask
echo.
echo [PXLAR] %~1
echo.
choice /C YN /N /M " "
if errorlevel 2 goto :eof
if errorlevel 1 goto %~2
goto :eof

:: ================= MODULES =================
:defender
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdFilter"  /v Start /t REG_DWORD /d 4 /f >nul 2>&1
echo [PXLAR] Windows Defender disabled.
goto :eof

:updates
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv"     /v Start /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
echo [PXLAR] Windows Update disabled.
goto :eof

:xbox
for %%X in (XboxNetApiSvc XblGameSave XblAuthManager xbgm XboxGipSvc) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%X" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
)
echo [PXLAR] Xbox services disabled.
goto :eof

:bluetooth
for %%B in (BTAGService bthserv BthAvctpSvc BluetoothUserService) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%B" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
)
echo [PXLAR] Bluetooth disabled.
goto :eof

:END
echo.
echo ==================================================
echo PXLAR OPTIMIZATION COMPLETE
echo Reboot strongly recommended
echo ==================================================
echo.
pause
exit /b