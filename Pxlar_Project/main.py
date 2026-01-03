import sys
import os
import subprocess
import ctypes
import time

# Function to check for Admin
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def get_path(rel):
    """Finds the script path whether running as .py or as .exe"""
    if hasattr(sys, '_MEIPASS'):
        return os.path.join(sys._MEIPASS, rel)
    return os.path.join(os.path.abspath("."), rel)

def run_optimization():
    print("====================================================")
    print("           PXLAR SYSTEM INITIALIZATION              ")
    print("====================================================")
    print("\n[!] ENGINE STARTING...")
    time.sleep(1)

    # --- STEP 0: SYSTEM RESTORE POINT ---
    print("\n[STEP 0] Creating System Restore Point...")
    subprocess.run('reg add "HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f', shell=True, capture_output=True)
    restore_cmd = 'powershell.exe -Command "Checkpoint-Computer -Description \'Before Pxlar Optimization\' -RestorePointType \'MODIFY_SETTINGS\'"'
    subprocess.run(restore_cmd, shell=True, capture_output=True)
    print("[-] Restore Point check complete.")

    # --- STEP 1: EDGE VANISHER ---
    print("[STEP 1] Running Edge Vanisher...")
    edge_script = get_path("EdgeVanisher.ps1")
    if os.path.exists(edge_script):
        subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", edge_script])
    else:
        print("[!] ERROR: EdgeVanisher.ps1 not found.")

    # --- STEP 2: AI SMART PRESETS (Paging File) ---
    print("[STEP 2] AI Hardware & Paging Optimization...")
    ai_path = get_path("scripts/AI/smart_presets.cmd")
    if os.path.exists(ai_path):
        subprocess.run(["cmd", "/c", ai_path])

    # --- STEP 3: POWER TWEAKS ---
    print("[STEP 3] Applying Power Tweaks...")
    power_path = get_path("scripts/Power/run_power.cmd")
    if os.path.exists(power_path):
        subprocess.run(["cmd", "/c", power_path])

    # --- STEP 4: PING TWEAKS ---
    print("[STEP 4] Optimizing Network Ping...")
    ping_path = get_path("scripts/Ping/run_ping.cmd")
    if os.path.exists(ping_path):
        subprocess.run(["cmd", "/c", ping_path])

    # --- STEP 5: DEBLOATER (Interactive) ---
    print("[STEP 5] Launching System Debloater...")
    debloat_path = get_path("scripts/Debloater/run_debloater.cmd")
    if os.path.exists(debloat_path):
        subprocess.run(["cmd", "/c", debloat_path])
    else:
        print("[!] ERROR: Debloater script missing!")

    print("\n====================================================")
    print("        OPTIMIZATION SEQUENCE COMPLETE!             ")
    print("====================================================")
    print("\n[!] PLEASE RESTART YOUR COMPUTER NOW.")
    print("[!] LOGIN USING YOUR PASSWORD (1234) AFTER REBOOT.")
    print("\n====================================================")
    
    # This keeps the window open so your friend can read it
    input("\nPress ENTER to exit...")

if __name__ == "__main__":
    # Force Admin at launch
    if not is_admin():
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
        sys.exit()

    run_optimization()