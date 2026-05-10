# TinyBoot

TinyBoot is a minimal x86_64 UEFI bootloader for loading Linux `bzImage` kernels from a configurable boot menu.

The project is intended as a low-level systems programming exercise focused on the Linux boot process, UEFI boot services, memory map handling, and kernel handoff. It is deliberately small in scope and is not intended to replace mature bootloaders such as GRUB or systemd-boot.

## Features

- x86_64 UEFI application
- Linux `bzImage` loading
- Linux boot protocol header parsing
- Kernel command line support
- Initrd loading
- UEFI memory map handling
- Serial debug output
- Configurable boot entries
- Minimal text-based boot menu

## Scope

TinyBoot targets QEMU with OVMF as the primary development environment. It expects a FAT-formatted EFI System Partition containing the bootloader, configuration file, Linux kernel image, and optional initrd.

## Non-goals

TinyBoot does not aim to support BIOS boot, Secure Boot, Windows boot, encrypted disks, automatic OS discovery, advanced filesystem drivers, or full graphical boot manager functionality.

## Example Configuration

```ini
timeout = 5
default = arch

[arch]
kernel = /EFI/TINYBOOT/vmlinuz
initrd = /EFI/TINYBOOT/initrd.img
cmdline = console=ttyS0 root=/dev/ram0

[rescue]
kernel = /EFI/TINYBOOT/vmlinuz
initrd = /EFI/TINYBOOT/initrd-rescue.img
cmdline = console=ttyS0 debug
