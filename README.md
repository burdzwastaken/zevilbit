# ZEvilBit - RFC 3514 Kernel Module

Linux kernel module written in Zig with a C FFI layer that implements [RFC 3514](https://www.rfc-editor.org/rfc/rfc3514)

> **Warning**: This is a silly kernel module for learning more about Zig/FFI. May the evil be with you!

## Usage

### Prerequisites

- Zig compiler
- Linux kernel headers (you may need to change KDIR in the Makefile depending on your distro)
- Build tools (gcc/make)
- Privileges (sudo!) for loading/unloading/logs

### Commands

build:
```bash
make
```

load: 
```bash
sudo make load
```

unload:
```bash
sudo make unload
```

logs:
```bash
sudo make logs
```

clean:
```bash
make clean
```
