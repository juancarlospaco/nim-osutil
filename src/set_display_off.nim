#!/usr/bin/nim c -r


import osproc


proc set_display_off*(): tuple[output: TaintedString, exitCode: int] =
  ## Turn Display OFF using Nim, it should Auto-ON when needed, crossplatform,
  ## designed for long running tasks on mobile devices and notebooks.
  when defined linux:
    return execCmdEx("xset dpms force off")
  elif defined macosx:
    return execCmdEx("""echo 'tell application "Finder" to sleep' | osascript""")


if is_main_module:
  echo set_display_off()
