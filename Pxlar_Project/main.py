import sys
import os
import subprocess
import ctypes
from PyQt6.QtWidgets import QApplication, QWidget, QVBoxLayout, QLabel, QProgressBar, QMessageBox
from PyQt6.QtCore import Qt, QTimer

# Importing from your utilities folder
from utilities.util_logger import logger
from utilities.util_error_popup import show_error_popup

def is_admin():
    """Checks if the script is running with Administrative privileges."""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

class PxlarAutomator(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Pxlar Optimizer Engine")
        self.setFixedSize(450, 250)
        # Keeps the progress window on top so the user sees it
        self.setWindowFlags(Qt.WindowType.WindowStaysOnTopHint)
        
        # --- MODERN DARK THEME ---
        self.setStyleSheet("""
            QWidget { background-color: #0F0F0F; color: #FFFFFF; font-family: 'Segoe UI'; }
            QLabel { font-size: 14px; color: #0078D4; font-weight: bold; }
            QProgressBar {
                border: 2px solid #333;
                border-radius: 5px;
                text-align: center;
                background-color: #1E1E1E;
            }
            QProgressBar::chunk {
                background-color: #0078D4;
                width: 10px;
            }
        """)

        layout = QVBoxLayout()
        self.header = QLabel("PXLAR SYSTEM INITIALIZATION")
        self.header.setStyleSheet("font-size: 18px; color: white;")
        self.header.setAlignment(Qt.AlignmentFlag.AlignCenter)
        
        self.status_label = QLabel("Initializing Engine...")
        self.status_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        
        self.pbar = QProgressBar()
        self.pbar.setValue(0)
        
        layout.addStretch()
        layout.addWidget(self.header)
        layout.addWidget(self.status_label)
        layout.addWidget(self.pbar)
        layout.addStretch()
        self.setLayout(layout)

        # Wait 1 second for the window to appear, then start the sequence
        QTimer.singleShot(1000, self.start_sequence)

    def get_path(self, rel):
        """Finds the script path whether running as .py or as .exe"""
        if hasattr(sys, '_MEIPASS'):
            return os.path.join(sys._MEIPASS, rel)
        return os.path.join(os.path.abspath("."), rel)

    def start_sequence(self):
        logger.info("Starting PXLAR optimization sequence.")

        # --- STEP 0: SYSTEM RESTORE POINT ---
        self.status_label.setText("Step 0: Creating System Restore Point...")
        self.pbar.setValue(5)
        # Bypass frequency limit and create point
        subprocess.run('reg add "HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f', shell=True, capture_output=True)
        restore_cmd = 'powershell.exe -Command "Checkpoint-Computer -Description \'Before Pxlar Optimization\' -RestorePointType \'MODIFY_SETTINGS\'"'
        subprocess.run(restore_cmd, shell=True, capture_output=True)

        # --- STEP 1: EDGE VANISHER ---
        self.status_label.setText("Step 1: Running Edge Vanisher...")
        self.pbar.setValue(20)
        edge_script = self.get_path("EdgeVanisher.ps1")
        if os.path.exists(edge_script):
            subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", edge_script], creationflags=subprocess.CREATE_NO_WINDOW)

        # --- STEP 2: AI SMART PRESETS (Paging File) ---
        self.status_label.setText("Step 2: AI Hardware & Paging Optimization...")
        self.pbar.setValue(40)
        ai_path = self.get_path("scripts/AI/smart_presets.cmd")
        if os.path.exists(ai_path):
            subprocess.run(["cmd", "/c", ai_path], creationflags=subprocess.CREATE_NO_WINDOW)

        # --- STEP 3: POWER TWEAKS ---
        self.status_label.setText("Step 3: Applying Power Tweaks...")
        self.pbar.setValue(60)
        power_path = self.get_path("scripts/Power/run_power.cmd")
        if os.path.exists(power_path):
            subprocess.run(["cmd", "/c", power_path], creationflags=subprocess.CREATE_NO_WINDOW)

        # --- STEP 4: PING TWEAKS ---
        self.status_label.setText("Step 4: Optimizing Network Ping...")
        self.pbar.setValue(80)
        ping_path = self.get_path("scripts/Ping/run_ping.cmd")
        if os.path.exists(ping_path):
            subprocess.run(["cmd", "/c", ping_path], creationflags=subprocess.CREATE_NO_WINDOW)

        # --- STEP 5: DEBLOATER (Interactive) ---
        self.status_label.setText("Step 5: Launching System Debloater...")
        self.pbar.setValue(100)
        debloat_path = self.get_path("scripts/Debloater/run_debloater.cmd")
        
        if os.path.exists(debloat_path):
            # Launch in a new visible window for user interaction (Y/N questions)
            subprocess.Popen(["cmd", "/c", "start", "cmd", "/c", f'"{debloat_path}"'], shell=True)
        else:
            logger.error("Debloater script missing!")
            show_error_popup("Debloater script missing from scripts/Debloater/run_debloater.cmd")

        # Close the progress window after 3 seconds
        QTimer.singleShot(3000, self.close)

if __name__ == "__main__":
    # Force Admin at launch (Required for Restore Point and Registry tweaks)
    if not is_admin():
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
        sys.exit()

    app = QApplication(sys.argv)
    window = PxlarAutomator()
    window.show()
    sys.exit(app.exec())