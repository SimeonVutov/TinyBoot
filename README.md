# TinyBoot

TinyBoot is a lightweight x86_64 UEFI bootloader for Linux systems.

It is designed for machines that do not need a large general-purpose boot manager for every possible operating system and boot scenario. Instead, TinyBoot focuses on one clear use case: selecting and launching configurable Linux boot profiles from a small custom boot interface.

The project is also a low-level systems programming project. It is intended to explore UEFI, Linux kernel loading, initrd loading, boot parameters, memory maps, and kernel handoff through a small and understandable codebase.

## Overview

TinyBoot is loaded by UEFI firmware as:

```text
EFI/BOOT/BOOTX64.EFI
```

Once started, TinyBoot is intended to load a Linux boot profile from configuration, allow the user to select the desired profile, and launch the selected Linux kernel.

A boot profile describes one Linux boot configuration. For example, a system may provide separate profiles for:

- normal boot
- LTS kernel boot
- fallback initramfs boot
- rescue mode
- debug mode
- serial console boot

This makes TinyBoot useful as a small Linux-focused boot selector rather than a full boot manager.

## Features

TinyBoot aims to support:

- x86_64 UEFI boot
- low-level serial logging using `outb`/`inb`
- Linux `bzImage` kernel loading
- Linux boot protocol support
- Linux `boot_params` construction
- kernel command line support
- initrd/initramfs loading and placement
- UEFI memory map handling
- `ExitBootServices` handoff
- kernel entry transition using small assembly code
- clear error reporting
- basic framebuffer drawing
- configurable Linux boot profiles
- multiple boot entries
- default boot profile selection
- boot timeout
- keyboard navigation
- text-based boot menu during early development
- minimal graphical boot selector later

## Non-Goals

TinyBoot is intentionally limited in scope.

It is not intended to support:

- legacy BIOS boot as the main boot path
- Windows boot
- Secure Boot in the initial versions
- GRUB-style scripting
- automatic operating system discovery
- complex graphical themes
- encrypted disk unlocking
- network boot
- full filesystem support for many filesystems
- replacing all functionality of GRUB or systemd-boot

A small legacy BIOS bootsector may be added later as an experiment, but the main project is focused on modern x86_64 UEFI Linux booting.

## Boot Profiles

TinyBoot is built around boot profiles.

Each profile defines the information required to boot one Linux configuration:

```text
label
kernel
initrd
cmdline
```

The same kernel can be reused with different command lines, which allows profiles such as normal boot, rescue boot, debug boot, or serial console boot without duplicating the kernel image.

Different kernels can also be configured, such as a mainline kernel, an LTS kernel, or a fallback kernel.

## Example Configuration

TinyBoot reads boot profiles from a configuration file on the EFI System Partition.

Example path:

```text
/EFI/TINYBOOT/tinyboot.cfg
```

Example configuration:

```ini
default = arch
timeout = 5

[arch]
label = Arch Linux
kernel = /EFI/TINYBOOT/vmlinuz-linux
initrd = /EFI/TINYBOOT/initramfs-linux.img
cmdline = root=UUID=00000000-0000-0000-0000-000000000000 rw quiet

[lts]
label = Arch Linux LTS
kernel = /EFI/TINYBOOT/vmlinuz-linux-lts
initrd = /EFI/TINYBOOT/initramfs-linux-lts.img
cmdline = root=UUID=00000000-0000-0000-0000-000000000000 rw quiet

[fallback]
label = Fallback Initramfs
kernel = /EFI/TINYBOOT/vmlinuz-linux
initrd = /EFI/TINYBOOT/initramfs-linux-fallback.img
cmdline = root=UUID=00000000-0000-0000-0000-000000000000 rw

[rescue]
label = Rescue Mode
kernel = /EFI/TINYBOOT/vmlinuz-linux
initrd = /EFI/TINYBOOT/initramfs-linux-fallback.img
cmdline = root=UUID=00000000-0000-0000-0000-000000000000 rw single

[debug]
label = Debug Boot
kernel = /EFI/TINYBOOT/vmlinuz-linux
initrd = /EFI/TINYBOOT/initramfs-linux.img
cmdline = root=UUID=00000000-0000-0000-0000-000000000000 rw loglevel=7 earlyprintk=serial
```

## Boot Selector

TinyBoot is intended to provide a minimal graphical selector for choosing between configured boot profiles.

The selector should stay small and focused. It is not intended to become a full graphical boot environment. Its purpose is to show the available Linux boot profiles, highlight the selected entry, handle keyboard navigation, and boot the selected profile.

During early development, a simple text-based menu may be used before the graphical selector is implemented.

## Build

TinyBoot currently uses GNU Make and GNU-EFI.

Build the UEFI application with:

```sh
make
```

The build produces:

```text
build/BOOTX64.EFI
```

The build also copies the EFI binary to the test EFI System Partition layout:

```text
esp/EFI/BOOT/BOOTX64.EFI
```

This is the path expected by UEFI removable media boot.

## Generate compile_commands.json

For editor and language server support, generate `compile_commands.json` with:

```sh
make compdb
```

This requires `bear`.

## Test with QEMU

TinyBoot can be tested using QEMU and OVMF.

Create a local OVMF variable store:

```sh
mkdir -p run
cp /usr/share/edk2/x64/OVMF_VARS.4m.fd run/OVMF_VARS.4m.fd
```

Run QEMU:

```sh
qemu-system-x86_64 \
  -machine q35 \
  -m 512M \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,file=run/OVMF_VARS.4m.fd \
  -drive format=raw,media=disk,file=fat:rw:esp \
  -serial stdio
```

The `esp/` directory is exposed to QEMU as a FAT disk. UEFI should find and load:

```text
esp/EFI/BOOT/BOOTX64.EFI
```

The `run/` directory is used for local QEMU/OVMF runtime state and should not be committed.

## Development Roadmap

Planned milestone direction:

```text
v0.1.0  Minimal UEFI Binary
v0.2.0  Low-Level Serial Logging
v0.3.0  Bootloader Runtime Foundation
v0.4.0  EFI File Loading
v0.5.0  Linux Image Loading
v0.6.0  Initrd and Command Line Placement
v0.7.0  Linux boot_params Construction
v0.8.0  UEFI Memory Map and ExitBootServices
v0.9.0  Kernel Entry Transition
v1.0.0  Minimal Linux Boot
v1.1.0  Single Config File Boot
v1.2.0  Multiple Boot Profiles
v1.3.0  Text Boot Menu
v2.0.0  Minimal Graphical Boot Selector
```

The early goal is not to build a menu. The early goal is to prove the bootloader can control the low-level Linux boot path.

## License

TinyBoot is licensed under the Apache License 2.0.

See [LICENSE](LICENSE) and [NOTICE](NOTICE) for details.
