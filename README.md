# my-ahk-config

Personal AutoHotkey v2 configuration for Windows.

## Files

- `custom.ahk` - main AutoHotkey script.
- `build/custom.exe` - compiled local artifact, ignored by git.

## Build

Compile the script with AutoHotkey's Ahk2Exe:

```powershell
$compiler = Join-Path $env:ProgramFiles "AutoHotkey\Compiler\Ahk2Exe.exe"
$runtime = Join-Path $env:ProgramFiles "AutoHotkey\v2\AutoHotkey64.exe"
& $compiler /in ".\custom.ahk" /out ".\build\custom.exe" /base $runtime
```

## Startup Setup

Create a Windows Startup shortcut under:

`$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup`

Point it at `build\custom.exe` in your local clone.

## Local Configuration

Copy `.env.example` to `.env`, then set `OPENCC_CONFIG_PATH` to the OpenCC
`t2s.json` file on your machine. `.env` is intentionally ignored by Git.

The script checks for `.env` beside `custom.ahk` and one directory above the
compiled executable, so the same file works for both source and `build` runs.

## Requirements

- AutoHotkey v2
- OpenCC command line tool, only for `Ctrl + Alt + C` Traditional-to-Simplified clipboard conversion

## Features

### Text Expansions

| Trigger | Output |
| --- | --- |
| `imp_bs4` | `from bs4 import BeautifulSoup` |
| `imp_sess` | `from requests_html import HTMLSession` |
| `imp_plt` | `import matplotlib.pyplot as plt` |

### Clipboard Slots

| Hotkey | Action |
| --- | --- |
| `Ctrl + Numpad1` | Copy to slot 1 |
| `Ctrl + Numpad4` | Paste from slot 1 |
| `Ctrl + Numpad2` | Copy to slot 2 |
| `Ctrl + Numpad5` | Paste from slot 2 |
| `Ctrl + Numpad3` | Copy to slot 3 |
| `Ctrl + Numpad6` | Paste from slot 3 |

### Debug Helper

| Hotkey | Action |
| --- | --- |
| `Ctrl + Alt + F` | Copy the active window `ahk_class` to the clipboard |

### CapsLock Emacs-style Bindings

CapsLock is forced off and used as a modifier.

| Hotkey | Action |
| --- | --- |
| `CapsLock + a` | Move to beginning of line |
| `CapsLock + e` | Move to end of line |
| `CapsLock + p` | Previous line |
| `CapsLock + n` | Next line |
| `CapsLock + f` | Forward character |
| `CapsLock + b` | Backward character |
| `CapsLock + d` | Delete |
| `CapsLock + h` | Backspace |
| `CapsLock + w` | Intended backward word delete, currently sends Backspace |
| `CapsLock + k` | Kill to end of line |
| `CapsLock + [` | Escape |
| `CapsLock + Space` | Windows key |

### CapsLock Ctrl-style Bindings

| Hotkey | Sends |
| --- | --- |
| `CapsLock + c` | `Ctrl + C` |
| `CapsLock + s` | `Ctrl + S` |
| `CapsLock + v` | `Ctrl + V` |
| `CapsLock + z` | `Ctrl + Z` |
| `CapsLock + x` | `Ctrl + X` |
| `CapsLock + t` | `Ctrl + T` |
| `CapsLock + j` | `Ctrl + J` |
| `CapsLock + r` | `Ctrl + R` |
| `CapsLock + y` | `Ctrl + Y` |
| `CapsLock + l` | `Ctrl + L` |
| `CapsLock + o` | `Ctrl + O` |
| `CapsLock + i` | `Ctrl + I` |
| `CapsLock + Tab` | `Ctrl + Tab` |

### Disabled Target Apps

Some CapsLock Emacs-style behavior is bypassed for these window classes:

- `MEADOW`
- `cygwin/x X rl-xterm-XTerm-0`
- `MozillaUIWindowClass`
- `VMwareUnityHostWndClass`
- `Vim`
- `Qt5QWindowIcon`
- `CASCADIA_HOSTING_WINDOW_CLASS`

### Audio and Scroll

| Hotkey | Action |
| --- | --- |
| `Ctrl + Shift + F11` | Volume down by 2 |
| `Ctrl + Shift + F12` | Volume up by 2 |
| `Ctrl + Shift + Down` | Wheel down 1 tick |
| `Ctrl + Shift + Up` | Wheel up 1 tick |

### Traditional-to-Simplified Clipboard Conversion

| Hotkey | Action |
| --- | --- |
| `Ctrl + Alt + C` | Convert clipboard text from Traditional Chinese to Simplified Chinese, paste it, then restore the original clipboard |

## Notes For Later Cleanup

- `CapsLock + w` probably should send `Ctrl + Backspace`; the current v2 function only sends Backspace.
- `is_pre_spc` and `is_pre_x` look like unfinished Emacs prefix or mark-mode state.
- `Cut(clipboardID)` exists but has no hotkey binding.
