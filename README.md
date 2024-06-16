# jetson-nano-kernel-rebuild

## This is a manual for rebuilding the Linux kernel for the Jetson Nano 2GB.

#### The host OS is Fedora 40, but it is built using the Ubuntu 18.04 Docker image.
#### The latest 7.x cross compiler is used.
#### Overwrite the SD card that has the jetson nano image on it.

```bash
# Before
$ cat /proc/version
Linux version 4.9.337-tegra (buildbrain@mobile-u64-5434-d8000) (gcc version 7.3.1 20180425 [linaro-7.3-2018.05 revision d29120a424ecfbc167ef90065c0eeb7f91977701] (Linaro GCC 7.3-2018.05) ) #1 SMP PREEMPT Thu Jun 8 21:19:14 PDT 2023

# After
$ cat /proc/version
Linux version 4.9.337-tegra-customX (tegra@1891474155dd) (gcc version 7.5.0 (Linaro GCC 7.5-2019.12) ) #1 SMP PREEMPT Mon Jun 17 10:42:29 UTC 2024
```

### 1.Download and extract the kernel
```bash
wget https://developer.nvidia.com/embedded/l4t/r32_release_v7.4/sources/t210/public_sources.tbz2
tar -xjf public_sources.tbz2
rm -f public_sources.tbz2
cd Linux_for_Tegra/source/public
tar -xjf kernel_src.tbz2
```

### 2.Creating a compilation container
```bash
$ docker build . -t hexaforce/jetson-kernel-rebuilder
```

### 3.1 Check the [MOUNTPOINTS] for the media card reader
```bash
$ lsblk /dev/sdb
NAME MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdb    8:16   1 29.5G  0 disk /run/media/{xxxx-USB-xxxx}
```

### 3.2 Build on the compilation container
```bash
$ docker run --privileged --rm -it \
-v $(pwd)/Linux_for_Tegra:/Linux_for_Tegra \
-e LOCALVERSION=-tegra-customX \
-v /run/media/{xxxx-USB-xxxx}:/usb \
hexaforce/jetson-kernel-rebuilder
```

### 4.1 Check the [CONTAINER ID] of build container
```bash
$ docker ps
CONTAINER ID   IMAGE                             COMMAND
{xxxx-ID-xxxx} hexaforce/jetson-kernel-rebuilder "bash /docker-entryp…"
```

### 4.2 Enter the container
```bash
$ docker exec -it {xxxx-ID-xxxx} bash
```

### 5.1 Overwrite the image and dtb on the SD card
```bash
sudo cp $TEGRA_KERNEL_OUT/arch/arm64/boot/Image /usb/boot/Image
sudo cp -r $TEGRA_KERNEL_OUT/arch/arm64/boot/dts/* /usb/boot/dtb
```

### 5.2 Install the kernel module on the SD card
```bash
sudo make ARCH=arm64 O=$TEGRA_KERNEL_OUT modules_install INSTALL_MOD_PATH=/usb
```

## Appendix

### custom kernel setting
```bash
make ARCH=arm64 O=$TEGRA_KERNEL_OUT menuconfig
```
### name change
```bash
export LOCALVERSION=-tegra-customYZ
```

### rebuild kernel
```bash
make ARCH=arm64 O=$TEGRA_KERNEL_OUT -j`nproc`
```
