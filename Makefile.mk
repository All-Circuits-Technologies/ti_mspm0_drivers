# SPDX-FileCopyrightText: 2022 Pierre-Noël Bouteville <pierre-noel.bouteville@allcircuits.com>
# SPDX-FileCopyrightText: 2024 Pierre-Noel Bouteville <pnb990@gmail.com>
#
# SPDX-License-Identifier: LicenseRef-ALLCircuits-ACT-1.1
# SPDX-License-Identifier: BSD-3-Clause
#
LIB_TI_MSPM0_DRIVERS_DIR:=$(dir $(lastword $(MAKEFILE_LIST)))

CHECK_EXCLUDE_PATH+=$(LIB_TI_MSPM0_DRIVERS_DIR)

