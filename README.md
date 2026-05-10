# TinyBoot

TinyBoot is a minimal x86_64 UEFI bootloader written as a low-level systems programming project. The goal is to understand how a bootloader loads a Linux kernel, prepares the required boot parameters, exits UEFI boot services, and transfers control to the kernel.

The project focuses on a small and maintainable implementation rather than trying to replace full-featured bootloaders such as GRUB or systemd-boot.

## Goals

The main goals of TinyBoot are:

- Run as an x86_64 UEFI application.
- Load a Linux `bzImage` kernel from the EFI System Partition.
- Parse the Linux x86 boot protocol header.
- Prepare the required Linux boot parameters.
- Pass a kernel command line.
- Exit UEFI boot services correctly.
- Transfer control to the Linux kernel.
- Provide a minimal boot selection interface.

## Status

TinyBoot is currently in early development.

The first objective is to produce a minimal UEFI bootloader capable of loading and entering a Linux kernel in QEMU.
