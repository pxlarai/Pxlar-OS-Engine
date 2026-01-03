import sys
import os
import subprocess
import ctypes
import time

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def get_path(rel):
    if hasattr(sys, '_MEIPASS'):
        return os.path.join(sys._MEIPASS, rel)
    return os.path.join(os.path.abspath("."), rel)

def run_optimization():
    print("====================================================")
    print("           PXLAR SYSTEM INITIALIZATION              ")
    print("====================================================")
    
    # --- STEP 0: RESTORE POINT (Safety First) ---
    print("\n[STEP 1/3] Creating Safety Restore Point...")
    subprocess.run('powershell.exe -Command "Checkpoint-Computer -Description \'Before Pxlar Optimization\' -RestorePointType \'MODIFY_SETTINGS\'"', shell=True)

    # --- STEP 1: EDGE VANISHER & PRESETS ---
    print("\n[STEP 2/3] Applying Pxlar Core Presets...")
    edge_script = get_path("EdgeVanisher.ps1")
    if os.path.exists(edge_script):
        subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", edge_script])

    # --- STEP 2: ZUSIER MASTER TWEAKS (The Main Event) ---
    print("\n[STEP 3/3] Launching Zusier Master Tweaks...")
    print("[!] Follow the prompts in the window below.")
    
    # Look for Zusier in the root level
    debloat_path = get_path("run_debloater.cmd")
    
    if os.path.exists(debloat_path):
        root_folder = os.path.dirname(debloat_path)
        # Running this LAST so it can finalize all system changes
        subprocess.run(["cmd", "/c", "run_debloater.cmd"], cwd=root_folder, shell=True)
    else:
        print(f"[!] ERROR: run_debloater.cmd not found!")

    print("\n====================================================")
    print("        OPTIMIZATION SEQUENCE COMPLETE!             ")
    print("====================================================")
    print("\n[!] Please RESTART your computer now.")
    input("\nPress ENTER to exit...")

if __name__ == "__main__":
    if not is_admin():
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
        sys.exit()
    run_optimization()