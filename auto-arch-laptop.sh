#!/bin/bash

###
### mount the root fs in /mnt
### mount the boot fs in /mnt/boot
###

# Install Arch Linux
pacstrap /mnt base-devel openssh sudo alsa-utils xorg-server xorg-xinit xorg-server-utils xorg-server-devel mesa ttf-dejavu cinnamon terminator firefox  

# Some configrations 
genfstab -U -p /mnt > /mnt/etc/fstab
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
sed -i "s/#en_US.UTF/en_US.UTF/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
arch-chroot /mnt hwclock --systohc --utc
arch-chroot /mnt useradd -m -g users -G wheel -s /bin/bash bdereims
echo "root:arch" | chpasswd -R /mnt
echo "bdereims:arch" | chpasswd -R /mnt
arch-chroot /mnt systemctl enable sshd
echo "exec cinnamon-session" > /mnt/root/.xinitrc
echo "exec cinnamon-session" > /mnt/bdereims/.xinitrc
echo "arch" > /mnt/etc/hostname

# Activate DHCP
cat << EOF > /mnt/etc/systemd/network/dhcp.network
[Match]
Name=en*
[Network]
DHCP=ipv4
EOF
arch-chroot /mnt systemctl enable systemd-networkd
rm -fr /mnt/etc/resolv.conf
arch-chroot /mnt systemctl enable systemd-resolved
mkdir -p /mnt/run/systemd/resolve
touch /mnt/run/systemd/resolve/resolv.conf
arch-chroot /mnt ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
rm /mnt/run/systemd/resolve/resolv.conf

