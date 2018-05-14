#!/usr/bin/nim c -r


import osproc


proc set_display_off*(): tuple[output: TaintedString, exitCode: int] =
  ## Turn Display OFF using Nim, it should Auto-ON when needed, crossplatform,
  ## designed for long running tasks on mobile devices and notebooks.
  when defined linux:
    return execCmdEx("xset dpms force off")
  elif defined macosx:
    return execCmdEx("""echo 'tell application "Finder" to sleep' | osascript""")


when defined linux:
  proc prctl(a: cint=15, name: cstring, b: cint=0, c: cint=0, d: cint=0): void {.importc, dynlib: "libc.so.6".} =
    return

  proc set_process_name*(name: string): string =
    ## Set this process name from argument string using LibC.prctl().
    prctl(name=cstring(name))


# proc clipboard_copy*(content: string): tuple[output: TaintedString, exitCode: int] =
#   ## Clipboard copy functionality.
#   when defined linux:
#     return execCmdEx("xclip -selection clipboard")
#   elif defined macosx:
#     return execCmdEx("pbcopy")


proc clipboard_paste*(): tuple[output: TaintedString, exitCode: int] =
  ## Clipboard paste functionality.
  when defined linux:
    return execCmdEx("xclip -selection clipboard -o")
  elif defined macosx:
    return execCmdEx("pbpaste")


if is_main_module:
  echo set_display_off()
  echo set_process_name("MY_PROCESS_NAME")
  echo clipboard_paste()
