# expdev
Docker container for Exploit Development and Binary Analysis.

Based on Ubuntu 22.04 LTS (Jammy Jellyfish).

## Features & Included Tools 🔻

### Exploit Development & Debugging
- **GDB + pwndbg** (enhanced GDB for exploit developers)
- **pwntools** (CTF framework and exploit development library)
- **ropper** (ROP gadget finder)
- **patchelf** (utility for modifying ELF executables)
- **pwninit** (automate starting pwn CTF challenges)
- **capstone** & **unicorn** (disassembly and emulation engines)
- **strace** & **ltrace** (system and library call tracing)
- **nasm** & **binutils** (assembler and binary utilities)
- **file** (file type identification)

### Languages & Environment
- **Python 2 & 3** (with `pip`, `setuptools`, and header files)
- **build-essential** (GCC, G++, Make)
- **socat** & **netcat** (networking utilities)
- **fish shell** (preconfigured aliases for ASLR check, ls formatting)
- **tmux** (preconfigured dotfile)
- **vim** (configured `.vimrc`)

## Build

With the `Dockerfile` in the current working directory, run:
```sh
docker build -t expdev .
```

## Run

Run interactively with your current working directory mounted to `/app`:
```sh
docker run --rm -it --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v "$PWD":/app expdev
```

> **Note:** `--cap-add=SYS_PTRACE --security-opt seccomp=unconfined` is recommended so GDB and debugging tools can attach to processes inside the container without restriction.
