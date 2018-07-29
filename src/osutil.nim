import osproc, posix


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
    ## Set Process Name.
    prctl(name=cstring(name))

  proc set_process_cpu_limit*(limit: range[5..100] = 5): Process =
    ## Set Process CPUs Limit cap, from 5% to 100% on global percentage, Linux-only.
    return startProcess("cpulimit", "/usr/bin/", openArray[string](["--include-children", "--pid=" & $getpid(), "--limit=" & $limit]))


  if is_main_module:
    # If you dont set the process name, usually its always "nim" or "main".
    echo "Open your system monitor and check the process name of this."
    echo set_process_name("MY_PROCESS_NAME")
    discard set_process_cpu_limit()
    # sleep 99999


# if is_main_module:
#   echo set_display_off()
