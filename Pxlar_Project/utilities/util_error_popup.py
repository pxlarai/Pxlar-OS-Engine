import ctypes

def show_error_popup(message, title="Pxlar Optimizer - Error"):
    """
    Displays a native Windows error message box.
    Style 16 = Stop-sign icon (Error) + OK button.
    """
    # 16 = MB_ICONERROR (Displays a red 'X' and plays the error sound)
    # 0 = MB_OK (Only shows the 'OK' button)
    style = 16 | 0
    
    return ctypes.windll.user32.MessageBoxW(0, message, title, style)

def show_warning_popup(message, title="Pxlar Optimizer - Warning"):
    """
    Displays a native Windows warning message box.
    Style 48 = Exclamation-point icon (Warning) + OK button.
    """
    style = 48 | 0
    return ctypes.windll.user32.MessageBoxW(0, message, title, style)