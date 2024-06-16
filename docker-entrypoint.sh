#!/bin/bash
set -e

cd /Linux_for_Tegra/source/public/kernel/kernel-4.9

# default kernel config
make ARCH=arm64 O=$TEGRA_KERNEL_OUT tegra_defconfig

# custom kernel config
# make ARCH=arm64 O=$TEGRA_KERNEL_OUT menuconfig

# build kernel
make ARCH=arm64 O=$TEGRA_KERNEL_OUT -j`nproc`

tail -f /dev/null
