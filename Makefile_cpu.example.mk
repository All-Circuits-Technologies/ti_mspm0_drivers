# SPDX-FileCopyrightText: 2024 Pierre-Noel Bouteville <pnb990@gmail.com>
# SPDX-FileCopyrightText: 2022 Pierre-Noël Bouteville <pierre-noel.bouteville@allcircuits.com>
#
# SPDX-License-Identifier: LicenseRef-ALLCircuits-ACT-1.1
# SPDX-License-Identifier: BSD-3-Clause
#
####################################################################
# CPU Makefile
####################################################################

ARCH_COMPILER=gcc

PKG_ARCH        = ARCH_M0
FAMILLY         = mspm0g
DEVICE          = $(FAMILLY)350
DEVICE_SUFFIX_X = x
DEVICE_SUFFIX   = 7

FAMILLY_UPPER:=$(shell echo $(FAMILLY) | tr '[:lower:]' '[:upper:]')
DEVICE_UPPER:=$(shell echo $(DEVICE) | tr '[:lower:]' '[:upper:]')
DEVICE_IC:=$(DEVICE_UPPER)$(DEVICE_SUFFIX)
DEVICE_IC_X:=$(DEVICE_UPPER)$(DEVICE_SUFFIX_X)

DEVICE_IC_LOWER:=$(shell echo $(DEVICE_IC) | tr '[:upper:]' '[:lower:]')

ifeq ($(USE_LINUX),1)
TOOLCHAIN_STM32_DIR?=/usr
else
TOOLCHAIN_STM32_DIR?=C:/Program Files (x86)/GNU Arm Embedded Toolchain/10 2021.10
endif
TOOLCHAIN_DIR:=$(shell cd "$(TOOLCHAIN_STM32_DIR)" && pwd)
TOOLCHAIN_BIN_DIR:=$(TOOLCHAIN_DIR)/bin
TOOLCHAIN_LIB_DIR:=$(TOOLCHAIN_DIR)/lib

CC      = $(TOOLCHAIN_BIN_DIR)/arm-none-eabi-gcc
LD      = $(TOOLCHAIN_BIN_DIR)/arm-none-eabi-ld
AS      = $(TOOLCHAIN_BIN_DIR)/arm-none-eabi-gcc
AR      = $(TOOLCHAIN_BIN_DIR)/arm-none-eabi-ar
SZ      = $(TOOLCHAIN_BIN_DIR)/arm-none-eabi-size
OBJCOPY = $(TOOLCHAIN_BIN_DIR)/arm-none-eabi-objcopy
OBJDUMP = $(TOOLCHAIN_BIN_DIR)/arm-none-eabi-objdump
CP      = cp
GREP    = grep

####################################################################
# CPU Library use
####################################################################

INCLUDEPATHS+=$(CPU_DIR)

include $(PKG_FMT_DIR)/Makefile_pkg.mk
include $(CPU_DIR)/src/Makefile_src.mk
include $(CPU_DIR)/Drivers/Makefile.mk

####################################################################
# Flags Definitions                                            	   #
####################################################################

CPU_CFLAGS += -mcpu=cortex-m0plus
CPU_CFLAGS += -mtune=cortex-m0plus
CPU_CFLAGS += -mthumb
#CPU_CFLAGS += -mfpu=fpv4-sp-d16	# FPU
CPU_CFLAGS += -mfloat-abi=soft 	# float-abi
#CPU_CFLAGS += -DARM_MATH_CM0 	# ARM_MATH_CM4

# ASM files.
ASFLAGS += $(CPU_CFLAGS)
ASFLAGS += -Ttext 0x0
# Specify explicitly the language for the following input files (rather than
# letting the compiler choose a default based on the file name suffix).
# This option applies to all following input files until the next -x option.
ASFLAGS += -x assembler-with-cpp

# C Arch specific flags.
CFLAGS += $(CPU_CFLAGS)
CFLAGS += -ffunction-sections   # to remove unused code
CFLAGS += -nostartfiles
CFLAGS += -fdata-sections       # to remove unused data
CFLAGS += -ftabstop=4           # tab size for error reporting
CFLAGS += -fomit-frame-pointer
CFLAGS += -D__STDC_FORMAT_MACROS
CFLAGS += -mlittle-endian
CFLAGS += -g
CFLAGS += -DBYTE_ORDER=LITTLE_ENDIAN
CFLAGS += -D$(FAMILLY_UPPER)=1
CFLAGS += -D$(DEVICE_IC)=1
CFLAGS += -D$(DEVICE_IC_X)=1
CFLAGS += -D__$(DEVICE_IC)__=1


# Linker Flags.
LDFLAGS += $(CPU_CFLAGS)
LDFLAGS += -Xlinker
LDFLAGS += -Map=$(PROJECT_MAP)
LDFLAGS += -T$(LINKER_SECTION)
LDFLAGS += -Wl,--gc-sections # to remove unused code and data compiled with right options
#LDFLAGS += -Wl,-t # show library used on linking
LDFLAGS += -mlittle-endian

# To use newlib-nano
CFLAGS  += --specs=nano.specs
LDFLAGS += --specs=nano.specs

# No sys : non-semihosting/retarget
CFLAGS  += --specs=nosys.specs
LDFLAGS += --specs=nosys.specs
