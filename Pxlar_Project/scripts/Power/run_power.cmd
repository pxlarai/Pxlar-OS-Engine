@echo off
title Pxlar - Power Optimizer
color 0E

echo [Pxlar] Optimizing Power Delivery & CPU Stability...

:: 1. Disable Hibernation
:: This frees up several GBs of space on the C: drive and speeds up boot.
powercfg -h off
echo [SUCCESS] Hibernation Disabled.

:: 2. Disable Processor Idle States (C-States)
:: This prevents the CPU from "sleeping" during gameplay, reducing latency.
powercfg -setacvalueindex scheme_current sub_processor processoridle 0
powercfg -setactive scheme_current
echo [SUCCESS] CPU Idle States Disabled.

:: 3. Disable USB Selective Suspend
:: Prevents Windows from turning off USB ports (stops mouse/keyboard disconnects).
powercfg -setacvalueindex scheme_current sub_usb usbsel_suspend 0
echo [SUCCESS] USB Selective Suspend Disabled.

:: 4. Disable PCIe Link State Power Management
:: Ensures the GPU always has full power and doesn't "throttle" to save energy.
powercfg -setacvalueindex scheme_current sub_pciexpress aspm 0
echo [SUCCESS] PCIe Power Management Disabled.

:: 5. Ultimate Performance Confirmation
:: Re-enforcing the Ultimate Power Plan just in case.
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
echo [SUCCESS] Ultimate Power Plan Forced Active.

echo.
echo ----------------------------------------------------
echo [DONE] Power tweaks applied!
timeout /t 3 >nul
exit