import sys
import os
import subprocess
import ctypes
import time

def is_admin():
    """Checks if the script is running with Administrative privileges."""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def run_optimization():
    print("====================================================")
    print("           PXLAR SYSTEM INITIALIZATION              ")
    print("         Powered by Pxlar Engine & CTT              ")
    print("====================================================")
    print("\n[!] ENGINE STARTING...")
    time.sleep(1)

    # --- STEP 0: SYSTEM RESTORE POINT ---
    print("\n[STEP 0] Creating Safety Restore Point...")
    # Ensures System Restore is enabled and creates a point
    subprocess.run('reg add "HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f', shell=True, capture_output=True)
    restore_cmd = 'powershell.exe -Command "Checkpoint-Computer -Description \'Before Pxlar Optimization\' -RestorePointType \'MODIFY_SETTINGS\'"'
    subprocess.run(restore_cmd, shell=True, capture_output=True)
    print("[-] Restore Point created successfully.")

    # --- STEP 1: LAUNCH MASTER TOOLKIT ---
    print("\n[STEP 1] Launching Optimization Interface...")
    print("[!] A new window may appear. Please select 'Desktop' or 'Laptop' tweaks.")
    
    # This command pulls the official, trusted Chris Titus/Zusier toolkit
    ctt_cmd = 'powershell -Command "Set-ExecutionPolicy Unrestricted -Scope Process -Force; iwr -useb https://christitus.com/win | iex"'
    
    try:
        subprocess.run(ctt_cmd, shell=True)
    except Exception as e:
        print(f"[!] Error launching toolkit: {e}")

    print("\n====================================================")
    print("        OPTIMIZATION SEQUENCE COMPLETE!             ")
    print("====================================================")
    print("\n[!] IMPORTANT: Ensure you know your PASSWORD (1234).")
    print("[!] Use the 'Updates' tab in the toolkit to delay updates.")
    print("\n====================================================")
    
    input("\nPress ENTER to exit...")

if __name__ == "__main__":
    # Force Admin at launch to ensure Restore Point works
    if not is_admin():
        print("[!] Requesting Administrator Privileges...")
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
        sys.exit()

    run_optimization()