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
- Linux `bzImage` kernel loading
- Linux boot protocol support
- Linux `boot_params` construction
- kernel command line support
- initrd/initramfs loading
- configurable Linux boot profiles
- multiple boot entries
- default boot profile selection
- boot timeout
- keyboard navigation
- minimal graphical boot selector
- text-based menu fallback during early development
- structured serial logging for development
- clear error reporting

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

The output is generated at:

```text
build/BOOTX64.EFI
```

## Development

TinyBoot is developed incrementally.

The first step is a minimal UEFI application that builds successfully as `BOOTX64.EFI`. From there, the project will grow toward file loading, Linux kernel parsing, boot parameter construction, initrd support, configurable profiles, and the boot selector interface.

## License

License information will be added later.
