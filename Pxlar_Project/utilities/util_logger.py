import logging
import os
from datetime import datetime

# 1. Determine the path to the User's Desktop
desktop_path = os.path.join(os.path.join(os.environ['USERPROFILE']), 'Desktop')
log_file = os.path.join(desktop_path, "Pxlar_Log.txt")

# 2. Create a custom logger
logger = logging.getLogger("PxlarLogger")
logger.setLevel(logging.DEBUG)

# 3. Create formatters
# Console format: [12:00:00] INFO: Message
# File format: 2026-01-01 12:00:00 | INFO | Message
console_formatter = logging.Formatter('[%(asctime)s] %(levelname)s: %(message)s', datefmt='%H:%M:%S')
file_formatter = logging.Formatter('%(asctime)s | %(levelname)s | %(message)s')

# 4. Console Handler (Shows logs in the CMD window)
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
console_handler.setFormatter(console_formatter)

# 5. File Handler (Saves logs to the Desktop)
file_handler = logging.FileHandler(log_file, mode='a', encoding='utf-8')
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(file_formatter)

# 6. Add handlers to the logger
logger.addHandler(console_handler)
logger.addHandler(file_handler)

# Initial log entry for every run
logger.info("--- PXLAR SESSION STARTED ---")