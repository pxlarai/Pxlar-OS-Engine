@echo off
title Pxlar - Network Optimizer
color 0B

echo [Pxlar] Optimizing Network Stack for Low Latency...

:: 1. Disable Nagle's Algorithm (TcpNoDelay)
:: This forces Windows to send small packets immediately instead of waiting.
for /f "tokens=3*" %%i in ('reg query "HKLM\Software\Microsoft\MSTCPIP\Parameters\Interfaces" /s /f "IPAddress" ^| findstr "HKEY"') do (
    reg add "%%i" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%i" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%i" /v "TcpDelAckTicks" /t REG_DWORD /d 0 /f >nul 2>&1
)

:: 2. Netsh Global Optimizations
:: Optimizes the Receive Window and disables features that cause jitter.
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global scalingstate=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1

:: 3. Disable Network Throttling
:: Prevents Windows from limiting non-multimedia traffic.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1

:: 4. Flush DNS
:: Clears cache to ensure clean routing.
ipconfig /flushdns >nul 2>&1

echo [SUCCESS] Network latency optimizations applied.
timeout /t 3 >nul
exit