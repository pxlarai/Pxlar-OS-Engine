@echo off
setlocal enabledelayedexpansion
title Pxlar - AI Smart Tuner
color 03

echo [Pxlar AI] Analyzing hardware components...

:: 1. GET TOTAL RAM (in Kilobytes then converted to MB)
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /Value') do set /a "TotalRAM=%%a / 1024"

:: 2. GET CPU THREAD COUNT
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfLogicalProcessors /Value') do set "Threads=%%a"

echo [System Info] Detected RAM: %TotalRAM% MB
echo [System Info] Detected CPU Threads: %Threads%
echo.

:: 3. AI DECISION ENGINE: RAM OPTIMIZATION
:: Logic: Set Page File to 1.5x RAM for stability if < 8GB, or fixed 4GB if > 16GB.
if %TotalRAM% LSS 8192 (
    echo [AI Decision] Low RAM detected. Optimizing virtual memory for stability...
    set "MinPage=4096"
    set "MaxPage=8192"
) else (
    echo [AI Decision] Sufficient RAM detected. Setting high-speed fixed Page File...
    set "MinPage=4096"
    set "MaxPage=4096"
)

:: Apply Page File Tweaks
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul 2>&1
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=%MinPage%,MaximumSize=%MaxPage% >nul 2>&1

:: 4. AI DECISION ENGINE: CPU PRIORITY
:: Logic: High core counts get different "SystemResponsiveness" values.
if %Threads% GEQ 12 (
    echo [AI Decision] High Core Count CPU found. Setting Gaming Profile Alpha...
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
) else (
    echo [AI Decision] Standard CPU found. Setting Balanced Performance Profile...
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 10 /f >nul
)

:: 5. MEMORY COMBINING (Reduces RAM usage for background apps)
echo [AI Decision] Enabling Memory Compression and Combining...
powershell -Command "Enable-MMAgent -MemoryCompression" >nul 2>&1
powershell -Command "Enable-MMAgent -PageCombining" >nul 2>&1

echo.
echo [DONE] AI Smart Presets have been customized for your hardware.
timeout /t 5 >nul
exit