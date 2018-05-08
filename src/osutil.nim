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
    prctl(name=cstring(name))


  if is_main_module:
    # If you dont set the process name, usually its always "nim" or "main".
    echo "Open your system monitor and check the process name of this."
    echo set_process_name("MY_PROCESS_NAME")
    # sleep 99999


if is_main_module:
  echo set_display_off()
