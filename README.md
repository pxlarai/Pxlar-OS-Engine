# 🌌 Pxlar Optimizer
**The all-in-one system refinement engine for high-performance Windows environments.**

Pxlar is a modular optimization suite designed to strip away Windows bloat, stabilize frame rates, and minimize network jitter. Unlike generic "one-click" tweakers, Pxlar follows a logical, structured sequence to ensure your system is cleaned, tuned, and safely backed up before any modifications are made.

---

## 🚀 The PXLAR Sequence
Pxlar executes optimizations in a specific order to ensure maximum effectiveness:

1. **Step 0: Safety First** – Automatically creates a **System Restore Point** and adjusts system frequency limits to ensure a backup is always available.
2. **Step 1: Edge Vanisher** – Completely removes Microsoft Edge and its background telemetry tasks.
3. **Step 2: AI Hardware Analysis** – Intelligently calculates and sets the optimal **Virtual Memory (Paging File)** size based on your physical RAM capacity.
4. **Step 3: Power Tuning** – Forces high-performance power delivery and optimizes CPU core parking/idle states.
5. **Step 4: Ping & Network** – Fine-tunes the TCP stack, disables Nagle's Algorithm, and flushes DNS to lower in-game latency.
6. **Step 5: Interactive Debloater** – Launches a final suite for manual control over Windows Defender, Xbox services, and advanced telemetry.

---

## 🛠️ Installation & Usage

### For Users (Recommended)
1. Download the latest `Pxlar_Optimizer.exe` from the [Releases](https://github.com/YourUsername/Pxlar-Optimizer/releases) tab.
2. Right-click the file and select **Run as Administrator**.
3. Follow the GUI progress bar and wait for the Interactive Debloater to launch.

### For Developers (Build from Source)
If you want to modify Pxlar, ensure you have Python 3.10+ and the following dependencies:
```bash
pip install PyQt6 pyinstaller
Build the executable using:

Bash

python -m PyInstaller --noconfirm --onefile --windowed --uac-admin --name "Pxlar_Optimizer" --add-data "scripts;scripts" --add-data "utilities;utilities" --add-data "EdgeVanisher.ps1;." main.py
🛡️ Safety & Reversion
Your system safety is our priority.

Restore Points: Before every run, Pxlar creates a restore point named Before Pxlar Optimization.

How to Undo: If you encounter issues, search for "Create a restore point" in Windows Start, click System Restore, and select the Pxlar snapshot to revert all registry and service changes.

🤝 Contributing & Bug Reports
Since this is a community-driven project, we rely on your feedback!

Found a bug? Open an Issue.

Have a new tweak? Feel free to submit a Pull Request.

📜 License
This project is licensed under the MIT License - see the LICENSE file for details.

Disclaimer: This tool makes deep system changes. Use at your own risk. While we provide safety backups, the developers are not responsible for any system instability.
