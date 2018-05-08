# nim-os-utils

Set the current Process name in Nim, shows up on system monitor with custom name.
Turn Display Off using Nim, 1 proc, turns off monitor, designed for long running tasks on mobile devices to save battery.

![screenshot](temp.png)


# Use

```nim
>>> import set_process_name
>>> echo set_process_name("MyAwesomeNimApp")
>> import set_display_off
>>> echo set_display_off()
(output: "", exitCode: 0)
```


# Install

```
nimble install osutils
```


# Requisites

- [Nim](https://nim-lang.org)


# Documentation

<details>
    <summary><b>set_process_name()</b></summary>

**Description:**
Set the current Process name in Nim, shows up on system monitor with custom name.

If you dont set the process name it will show up as `"nim"` or `"main"` or
the filename of the main executable.

For SysAdmins and DevOps is important to quickly identify a particular process on
the system monitor, that can be a GUI or a command like `htop` or `glances`.

Giving a proper name to your processes makes your software feel more professional.

Uses a low level call to `libc.so`. **Only available on Linux.**

**Arguments:**
- `name` A Name for your Process, `string` type, required.

**Returns:** None.

</details>


<details>
    <summary><b>set_display_off()</b></summary>

**Description:**
Turn Display Off using Nim, crossplatform, 1 proc, turns off monitor,
designed for long running tasks on mobile devices.

**Arguments:** None.

**Returns:** `tuple[output: TaintedString, exitCode: int]`.

</details>
