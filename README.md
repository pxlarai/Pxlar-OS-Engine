🌌 Pxlar Optimizer
The all-in-one system refinement engine for high-performance Windows environments.

Pxlar is a modular optimization suite designed to strip away Windows bloat, stabilize frame rates, and minimize network jitter. Built and tested on Windows 11 Insider Build 26200, this engine has successfully reduced background processes from 192 down to 104 while gaming.

⚠️ CRITICAL: READ BEFORE RUNNING
ACCOUNT SECURITY WARNING: This engine disables Windows Hello, PIN Login, and Biometrics to reduce background service latency.

YOU MUST KNOW YOUR MICROSOFT/WINDOWS ACCOUNT PASSWORD.

Your PIN will be removed. Upon reboot, Windows will require your full password to log in.

If you do not know your password, do not run this script until you have reset/verified it in Settings > Accounts.

🚀 The PXLAR Sequence
Pxlar executes optimizations in a specific order to ensure maximum effectiveness:

Step 0: Safety First – Automatically creates a System Restore Point and adjusts system frequency limits.

Step 1: Edge Vanisher – Completely removes Microsoft Edge, its updaters, and background telemetry.

Step 2: AI Hardware Analysis – Intelligently calculates and sets the optimal Static Paging File size based on your RAM.

Step 3: Power Tuning – Forces high-performance power delivery and optimizes CPU core parking.

Step 4: Ping & Network – Fine-tunes the TCP stack, disables Nagle's Algorithm, and flushes DNS.

Step 5: Interactive Debloater – Advanced manual control over Windows Defender, Xbox services, and telemetry.

🛠️ Installation & Usage
For Users (Recommended)
Download the latest Pxlar_Optimizer.exe from the Releases tab.

Right-click the file and select Run as Administrator.

Click YES on the Windows UAC prompt.

Follow the progress bar and wait for the Interactive Debloater to launch.

Note: If the Edge Vanisher fails to run, ensure no Edge processes are open in the background before starting.

For Developers (Build from Source)
Ensure you have Python 3.10+ and dependencies: pip install PyQt6 pyinstaller

Build the executable:

Bash

python -m PyInstaller --noconfirm --onefile --windowed --uac-admin --name "Pxlar_Optimizer" --add-data "scripts;scripts" --add-data "utilities;utilities" --add-data "EdgeVanisher.ps1;." main.py
🛡️ Safety & Reversion
Restore Points: Every run creates a restore point named Before Pxlar Optimization.

How to Undo: Search "Create a restore point" in Start > Click System Restore > Select the Pxlar snapshot to revert all changes.
