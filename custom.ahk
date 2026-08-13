;CapsLock::RCtrl ;RCtrl::CapsLock
;ScrollLock::Escape

; Legacy remaps kept for reference. They are disabled because CapsLock is now
; used as a prefix key for the Emacs-style bindings below.
;^[::
;   Send {Escape}
;return

;Insert::Backspace
#Requires AutoHotkey v2.0

; Load machine-local values without committing absolute paths to the repo.
LoadLocalEnv()

LoadLocalEnv() {
    envFiles := [A_ScriptDir "\.env", A_ScriptDir "\..\.env"]

    for envFile in envFiles {
        if !FileExist(envFile)
            continue

        Loop Read, envFile {
            line := Trim(A_LoopReadLine)
            if (line = "" || SubStr(line, 1, 1) = "#")
                continue

            separator := InStr(line, "=")
            if (separator <= 1)
                continue

            key := Trim(SubStr(line, 1, separator - 1))
            value := Trim(SubStr(line, separator + 1))
            if (StrLen(value) >= 2 && SubStr(value, 1, 1) = '"' && SubStr(value, -1) = '"')
                value := SubStr(value, 2, -1)

            EnvSet(key, value)
        }
        return
    }
}

; Quick Python import expansions.
::imp_bs4::from bs4 import BeautifulSoup
::imp_sess::from requests_html import HTMLSession
::imp_plt::import matplotlib.pyplot as plt


; Three in-memory clipboard slots. These save ClipboardAll data while restoring
; the real Windows clipboard after each copy/paste operation.
^Numpad1::Copy(1)
^Numpad4::Paste(1)

^Numpad2::Copy(2)
^Numpad5::Paste(2)

^Numpad3::Copy(3)
^Numpad6::Paste(3)


;^!f::Run nvim-qt.exe
; Copy the active window class for debugging is_target() exclusions.
^!f::WinGetClass("Clipboard", "A") ; Will copy the ahk_class of the Active Window to clipboard
; ^!f::WinGetClass(), Clipboard, A ; Will copy the ahk_class of the Active Window to clipboard

; Slot ID -> ClipboardAll payload.
ClipboardData := {}

Copy(clipboardID)
{
    global ClipboardData
	local oldClipboard := ClipboardAll ; Save the (real) clipboard
	
	Clipboard := "" ; Erase the clipboard first, or else ClipWait does nothing
	Send "^c"
	if !ClipWait(2, 1)  ; If ClipWait fails
	{
		Clipboard := oldClipboard ; Restore old (real) clipboard
		MsgBox "Clipboard copy failed!"
		return
	}
	
	ClipboardData[clipboardID] := ClipboardAll
	
	Clipboard := oldClipboard ; Restore old (real) clipboard
}

Cut(clipboardID) {
    ; This helper is kept for future slot cut hotkeys; no hotkey calls it yet.
    global ClipboardData
    local oldClipboard := ClipboardAll ; Save the (real) clipboard
    
    Clipboard := "" ; Erase the clipboard first, or else ClipWait does nothing
    Send "^x"
	if !ClipWait(2, 1)  ; If ClipWait fails
	{
		Clipboard := oldClipboard ; Restore old (real) clipboard
		MsgBox "Clipboard copy failed!"
		return
	}
    ClipboardData[clipboardID] := ClipboardAll
}

Paste(clipboardID)
{
	global ClipboardData
	local oldClipboard := ClipboardAll ; Save the (real) clipboard

	Clipboard := ClipboardData[clipboardID]
	Send "^v"

	Clipboard := oldClipboard ; Restore old (real) clipboard
	oldClipboard := ""
}


;F7 & F10::
   ;Send ^J
   ;Sleep 2500
   ;Send const x = document.getElementsByClassName("figure");const y = [];{Enter}
   ;Sleep 500
   ;Send for (var i = 1; i < 5; i{+}{+}) {{}y.push(x.item(i).innerText); {}};console.table(y){Enter}
;Return

;^[::
   ;Send {Escape}
;return










;;
;; Emacs-like key bindings on Windows.
;;
;#InstallKeybdHook
#UseHook
;#Persistent
; Disable the CapsLock state; CapsLock is used only as a modifier.
SetCapsLockState("AlwaysOff")

; The following line is a contribution of NTEmacs wiki http://www49.atwiki.jp/ntemacs/pages/20.html
SetKeyDelay 0

; Reserved state for old Emacs prefix behavior. No current hotkey sets these
; values to 1, but movement helpers still check is_pre_spc for selection mode.
is_pre_x := 0
is_pre_spc := 0

; Apps where native Ctrl shortcuts should win over Emacs-style translation.
is_target()
{
;  IfWinActive,ahk_class ConsoleWindowClass ; Cygwin
;    Return 1 
  if(WinActive("ahk_class MEADOW")) ; Meadow
    return 1
  if (WinActive("ahk_class cygwin/x X rl-xterm-XTerm-0"))
    return 1
  if (WinActive("ahk_class MozillaUIWindowClass")) ; keysnail on Firefox
    return 1
  ; Avoid VMwareUnity with AutoHotkey
  if (WinActive("ahk_class VMwareUnityHostWndClass"))
    return 1
  if (WinActive("ahk_class Vim")) ; GVIM
    return 1
  if (WinActive("ahk_class Qt5QWindowIcon")) ; nvim-qt
    return 1
  if (WinActive("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")) ; window terminal
    return 1
	
;  IfWinActive,ahk_class SWT_Window0 ; Eclipse
;    Return 1pr
;   IfWinActive,ahk_class Xming X
;     Return 1
;   IfWinActive,ahk_class SunAwtFrame
;     Return 1
;   IfWinActive,ahk_class Emacs ; NTEmacs
;     Return 1  
;   IfWinActive,ahk_class XEmacs ; XEmacs on Cygwin
;     Return 1
  Return 0
}

delete_char()
{
  Send("{Del}")
  global is_pre_spc := 0
  return
}

delete_backward_char()
{
  Send("{BS}")
  global is_pre_spc := 0
  return
}

delete_backward_word()
{
  Send ("{BS}")
  global is_pre_spc := 0
  return
}

kill_line() {
  Send("{ShiftDown}{End}{ShiftUp}")
  Sleep(50) ;[ms] this value depends on your environment
  Send("^x")
  global is_pre_spc := 0
  return
}

open_line()
{
  Send("{END}{Enter}{Up}")
  global is_pre_spc := 0
  return
}

quit()
{
  Send("{ESC}")
  global is_pre_spc := 0
  return
}

newline()
{
  Send("{Enter}")
  global is_pre_spc := 0
  return
}

indent_for_tab_command()
{
  Send("{Tab}")
  global is_pre_spc := 0
  return
}

newline_and_indent()
{
  Send("{Enter}{Tab}")
  global is_pre_spc := 0
  return
}

isearch_forward()
{
  Send("^f")
  global is_pre_spc := 0
  return
}

isearch_backward()
{
  Send("^f")
  global is_pre_spc := 0
  return
}

kill_region()
{
  Send("^x")
  global is_pre_spc := 0
  return
}

kill_ring_save()
{
  Send("^c")
  global is_pre_spc := 0
  return
}

yank()
{
  Send("^v")
  global is_pre_spc := 0
  return
}

undo()
{
  Send("^z")
  global is_pre_spc := 0
  return
}

find_file()
{
  Send("^o")
  global is_pre_x := 0
  return
}

save_buffer() {
  Send("^s")
  global is_pre_x := 0
  return
}

kill_emacs() {
  Send("!{F4}")
  global is_pre_x := 0
  return
}

move_beginning_of_line() {
  global is_pre_spc
  if (is_pre_spc)
    Send("+{Home}")
  else
    Send("{Home}")
  return
}

move_end_of_line() {
  global
  if is_pre_spc
    Send("+{END}")
  else
    Send("{END}")
  return
}

previous_line() {
  global is_pre_spc
  if (WinActive("ahk_class Framework::CFrame")) {
    Send("^{Up}")
    return
  }
  if (is_pre_spc)
    Send("+{Up}")
  else
    Send("{Up}")
  return
}

next_line() {
  global is_pre_spc
  if (WinActive("ahk_class Framework::CFrame")) {
    Send("^{Down}")
    return
  }
  if (is_pre_spc)
    Send("+{Down}")
  else
    Send("{Down}")
  return
}

forward_char() {
  global is_pre_spc
  if is_pre_spc
    Send("+{Right}")
  else
    Send("{Right}")
  return
}

backward_char() {
  global is_pre_spc
  if is_pre_spc
    Send("+{Left}")
  else
    Send("{Left}")
  return
}

scroll_up()
{
  global is_pre_spc
  if is_pre_spc
    Send("+{PgUp}")
  else
    Send("{PgUp}")
  return
}

scroll_down()
{
  global is_pre_spc
  if is_pre_spc
    Send("+{PgDn}")
  Else
    Send("{PgDn}")
  return
} 

; Straight CapsLock-to-Ctrl mappings for common app commands.
CapsLock & c:: Send("^c")
CapsLock & s:: Send("^s")
CapsLock & v:: Send("^v")
CapsLock & z:: Send("^z")
CapsLock & x:: Send("^x")
CapsLock & t:: Send("^t")
CapsLock & j:: Send("^j")
CapsLock & r:: Send("^r")
CapsLock & y:: Send("^y")
;CapsLock & k:: Send("^k")
;CapsLock & h:: Send("^h")
CapsLock & l:: Send("^l")
;CapsLock & w:: Send("^w")
CapsLock & Tab:: Send("^{Tab}")
;Ctrl & Shift & Tab:: Send("^+{Tab}")
CapsLock & o:: Send("^o")
CapsLock & i:: Send("^i")

; Emacs-style editing/navigation mappings. In target apps, send the native
; Ctrl shortcut instead of translating to arrow/delete operations.
CapsLock & d:: {
  if (is_target())
    Send("^d")
  else
    delete_char()
  return
}

CapsLock & k:: {
  if (is_target())
    Send("^k")
  else
    kill_line()
  return
}

CapsLock & a:: {
  if (is_target())
    Send("^a")
  else
    move_beginning_of_line()
  return
}

CapsLock & e:: {
  if (is_target())
    Send("^e")
  else
    move_end_of_line()
  return
}

CapsLock & p:: {
  If is_target()
    Send("^p")
  Else
    previous_line()
  return
}

CapsLock & n:: {
  If is_target()
    Send("^n")
  Else
    next_line()
  return
}

CapsLock & f:: {
  If is_target()
    Send("^f")
  Else
  {
      forward_char()
  }
  return
}

CapsLock & b:: {
  If is_target()
    Send("^b")
  Else
    backward_char()
  return
}

CapsLock & Space:: {
  if (is_target())
    Send(A_ThisHotkey)
  else
    Send("{LWin}")
  return
}

CapsLock & [:: {
  quit()
  return
}

CapsLock & w:: {
  if (is_target())
    Send("^w")
  else
    delete_backward_word()
  return
}

CapsLock & h:: {
  if (is_target())
    Send("^h")
  else
    delete_backward_char()
  return
}

; Small global controls.
^+F11::SoundSetVolume "-2"
^+F12::SoundSetVolume "+2"

^+Down:: {
  Send("{WheelDown 1}")
  return
}

^+Up:: {
  Send("{WheelUp 1}")
  return
}

; Convert Traditional Chinese clipboard text to Simplified Chinese via OpenCC,
; paste the converted text, then restore the original clipboard shortly after.
^!c::trad_to_simp()

trad_to_simp() {
    ; Preserve the complete original clipboard, including non-text formats.
    ClipSaved := ClipboardAll()
    
    ; The conversion path only works when the clipboard has text.
    if !A_Clipboard {
        MsgBox("Clipboard is empty; no text to convert.", "Conversion", 16)
        return
    }
    
    ; OpenCC works on files here, so use temporary UTF-8 buffers.
    tempInputFile := A_Temp "\trad_input_" A_TickCount ".txt"
    tempOutputFile := A_Temp "\simp_output_" A_TickCount ".txt"
    
    try {
        ; Write the current clipboard text as UTF-8 input.
        FileEncoding("UTF-8")
        FileObj := FileOpen(tempInputFile, "w")
        if !FileObj {
            throw Error("Could not create the temporary input file")
        }
        FileObj.Write(A_Clipboard)
        FileObj.Close()
        
        ; Convert Traditional Chinese to Simplified Chinese with OpenCC.
        openccConfigPath := EnvGet("OPENCC_CONFIG_PATH")
        if !openccConfigPath
            throw Error("OPENCC_CONFIG_PATH is not set; copy .env.example to .env and configure it")
        cmdLine := 'opencc -i "' tempInputFile '" -o "' tempOutputFile '" -c "' openccConfigPath '"'
        RunWait(cmdLine,, "Hide")
        
        ; Read the converted text back into the clipboard.
        FileObj := FileOpen(tempOutputFile, "r")
        if !FileObj {
            throw Error("Could not open the converted output file")
        }
        convertedText := FileObj.Read()
        FileObj.Close()
        
        A_Clipboard := convertedText
        
        ; Paste before restoring the original clipboard.
        Send("^v")
    }
    catch as e {
        MsgBox("Conversion failed: " e.Message, "Error", 16)
    }
    finally {
        ; Clean up the temporary files.
        try FileDelete(tempInputFile)
        try FileDelete(tempOutputFile)
        
        ; Delay restoration so the paste operation can consume converted text.
        savedClip := ClipSaved  ; Create a local copy for the timer function
        SetTimer(() => A_Clipboard := savedClip, -300)
    }
}




; F8::
; stop := 0
; Loop
; {
;     Send, ^+{F4}
;     Sleep 500
;     Send, ^+{F4}
;     Sleep 500
; }until Stop
; return
; 
; F9::Stop := 1    ; Note single line hotkeys do not require a return under them like the F8 hotkey does above.
