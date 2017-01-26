#!/bin/bash

cd /mnt/root
mkdir src
cd src
wget https://aur.archlinux.org/packages/br/broadcom-wl/broadcom-wl.tar.gz
tar xf broadcom-wl.tar.gz
cd broadcom-wl/
makepkg -s

#pacman -U /tmp/usb/broadcom-wl-6.30.223.248-4-x86_64.pkg.tar.xz
