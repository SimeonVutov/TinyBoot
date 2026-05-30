BUILD := build

CC := gcc
LD := ld
OBJCOPY := objcopy

# Main GNU-EFI include directory.
# Provides headers such as <efi.h>.
EFI_INC := /usr/include/efi

# Architecture-specific GNU-EFI include directory.
# Provides x86_64-specific EFI definitions.
EFI_ARCH_INC := /usr/include/efi/x86_64

# Directory where GNU-EFI libraries, linker script, and startup object are installed.
EFI_LIB := /usr/lib

# EFI startup object.
# This contains low-level entry code before your efi_main() function is called.
EFI_CRT := $(EFI_LIB)/crt0-efi-x86_64.o

# GNU-EFI linker script for x86_64 EFI applications.
# It tells the linker how to arrange the binary sections.
EFI_LDS := $(EFI_LIB)/elf_x86_64_efi.lds

CFLAGS := \
	-I$(EFI_INC) \
	-I$(EFI_ARCH_INC) \
	-DEFI_FUNCTION_WRAPPER \
	-ffreestanding \
	-fshort-wchar \
	-fno-stack-protector \
	-fpic \
	-mno-red-zone \
	-O2 \
	-Wall \
	-Wextra \
	-Werror

LDFLAGS := \
	-nostdlib \
	-znocombreloc \
	-T $(EFI_LDS) \
	-shared \
	-Bsymbolic \
	-L$(EFI_LIB)

.PHONY: all clean compdb

all: $(BUILD)/BOOTX64.EFI

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/main.o: src/main.c | $(BUILD)
	$(CC) $(CFLAGS) -c src/main.c -o $(BUILD)/main.o

$(BUILD)/tinyboot.so: $(BUILD)/main.o
	$(LD) $(LDFLAGS) $(EFI_CRT) $(BUILD)/main.o -o $(BUILD)/tinyboot.so -lefi -lgnuefi

$(BUILD)/BOOTX64.EFI: $(BUILD)/tinyboot.so
	$(OBJCOPY) \
		-j .text \
		-j .sdata \
		-j .data \
		-j .dynamic \
		-j .dynsym \
		-j .rel \
		-j .rela \
		-j .rel.* \
		-j .rela.* \
		-j .reloc \
		--output-target=efi-app-x86_64 \
		$(BUILD)/tinyboot.so \
		$(BUILD)/BOOTX64.EFI

compdb:
	$(MAKE) clean
	mkdir -p $(BUILD)
	bear --output $(BUILD)/compile_commands.json -- $(MAKE) all
	ln -sf $(BUILD)/compile_commands.json compile_commands.json

clean:
	rm -rf $(BUILD)


