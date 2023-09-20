; This script allows you to set a hotkey that will
; * Open a windows terminal in the current directory you are in
;   (via file exporer), and the windows terminal is launched in
;   maximized mode, if windows terminal is not open
; * Minimize the windows terminal, if it's currently active
; * Bring trhe focus back to the windows terminal, if it not active

#SingleInstance Force ; old instance replaced without dialog with new instance

; hwnd: is "handle to window"
; the directory we are currently at: We return its path
GetActiveFileExplorerPath() {
	explorerHwnd := WinActive("ahk_class CabinetWClass")
	if (explorerHwnd) 	{
		for window in ComObjCreate("Shell.Application").Windows {
			if (window.hwnd==explorerHwnd) {
				return window.Document.Folder.Self.Path
			}
		}
	}
}  


; Terminal Time:
;   If terminal not running: Open in terminal in the current directory
;   If terminal running and is active: Minimize terminal
;   If termilal running and is not active: Bring Focus to terminal 
ActivateWinTerminal(curDir) { ; current directory we are in 

  terminalWinID := WinExist("ahk_exe WindowsTerminal.exe")
  terminalRunning := terminalWinID > 0

  if (terminalRunning) { 
    terminalIsActive := (WinExist("A") == terminalWinID)
    if (terminalIsActive) {
      WinMinimize, "ahk_id %terminalWinID%"
    } else { ; terminal running but not active; put terminal in focus.      
      WinActivate, "ahk_id %terminalWinID%"
      WinShow, "ahk_id %terminalWinID%"
    }
  }else {
    Run, wt --maximized -d %curDir%
  }
}

;Hotkey: Ctrl+Shift+Insert launches/minimizes/focuses the Windows Terminal.
^+Insert::
    currentPath := GetActiveFileExplorerPath()
    ; msgbox % currentPath
    ActivateWinTerminal(currentPath)
