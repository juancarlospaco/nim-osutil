import os, osproc, ospaths, posix, strutils


when defined linux:
  const
    at_version = staticExec("at -V")
    ionice_version = staticExec("ionice --version")
    xset_version = staticExec("xset -version")

  proc set_display_off*(): tuple[output: TaintedString, exitCode: int] =
    ## Turn Display OFF using Nim, it should Auto-ON when needed,
    ## designed for long running tasks on mobile devices and notebooks.
    return execCmdEx("xset dpms force off")

  proc prctl(a: cint=15, name: cstring, b: cint=0, c: cint=0, d: cint=0): void {.importc, dynlib: "libc.so.6".} =
    return

  proc set_process_name*(name: string): string =
    ## Set this process name from argument string using LibC.prctl().
    prctl(name=cstring(name))

  proc set_process_cpu_limit*(limit: range[5..100] = 5): Process =
    ## Set Process CPUs Limit cap, from 5% to 100% on global percentage, Linux-only.
    return startProcess("cpulimit", "/usr/bin/", openArray[string](["--include-children", "--pid=" & $getpid(), "--limit=" & $limit]))

  proc set_process_ionice*(scheduling_class: range[0..3] = 3): tuple[output: TaintedString, exitCode: int] =
    ## Set Process I/O Limit cap, similar to https://nim-lang.org/docs/posix.html#nice,cint but for I/O (storage disks), Linux-only.
    return execCmdEx("ionice --ignore --class " & $scheduling_class & " --pid " & $getpid())

  proc at*(timespec, job: string): tuple[output: TaintedString, exitCode: int] =
    ## Poor mans AT wrapper for Nim. Works with string or existing file path.
    ##
    ## If it errors with "Cant open /var/run/atd.pid to signal atd. No atd running?",
    ## then execute on the Linux Bash terminal:    systemctl restart atd.service
    let jobs = if job.existsFile: " -f " & quoteShell(job) else: " < " & job
    return execCmdEx("at -v -M " & timespec & jobs)

  proc atq*(): string = execCmdEx("atq").output.strip  ## Lists all AT Jobs with number ID from queue.

  proc atrm*(job: int8): bool = parseBool($execCmdEx("atrm " & $job).exitCode)  ## Removes 1 Job by number ID from job queue.


  if is_main_module:
    # If you dont set the process name, usually its always "nim" or "main".
    echo "Open your system monitor and check the process name of this."
    echo set_process_name("MY_PROCESS_NAME")

    echo ionice_version
    echo set_process_ionice()

    discard set_process_cpu_limit()

    echo at_version
    echo at("midnight", "/bin/free")  # Free at Midnight.
    echo atq()
    # echo atrm(1)


# proc clipboard_copy*(content: string): tuple[output: TaintedString, exitCode: int] =
#   ## Clipboard copy functionality.
#   return execCmdEx(fmt"xclip -selection clipboard -rmlastnl {$content}")

#
# proc clipboard_paste*(): tuple[output: TaintedString, exitCode: int] =
#   ## Clipboard paste functionality.
#   return execCmdEx("xclip -selection clipboard -rmlastnl -out")
