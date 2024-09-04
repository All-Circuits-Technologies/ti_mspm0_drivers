# SPDX-FileCopyrightText: 2022 Pierre-Noël Bouteville <pierre-noel.bouteville@allcircuits.com>
#
# SPDX-License-Identifier: LicenseRef-ALLCircuits-ACT-1.1
#

CPU_DRIVERS_DIR:=$(dir $(lastword $(MAKEFILE_LIST)))

INCLUDEPATHS+=$(CPU_DRIVERS_DIR)
INCLUDEPATHS+=$(CPU_DRIVERS_DIR)/ti/CMSIS/Core/Include
INCLUDEPATHS+=$(CPU_DRIVERS_DIR)/ti/CMSIS/DSP/Include

