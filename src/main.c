// Copyright 2026 Simeon Vutov
//
// Licensed under the Apache License, Version 2.0.
// See the LICENSE file in the project root for details.

#include <efi.h>
#include <efilib.h>

EFI_STATUS
EFIAPI
efi_main(EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *system_table)
{
    InitializeLib(image_handle, system_table);

    Print(L"TinyBoot started\r\n");

    return EFI_SUCCESS;
}
