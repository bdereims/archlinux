#!/bin/bash

# Partitioning Disk
echo -e "o\nn\n\n\n\n+260M\nt\nb\na\nn\n\n\n\n\nw\n" | fdisk /dev/sda

# Fromat partitions
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 -F /dev/sda2

# Mount partitions
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Install Arch Linux
pacstrap /mnt base grub-bios openssh sudo alsa-utils xorg-server xorg-xinit xorg-server-utils ttf-dejavu cinnamon terminator firefox

# Some configrations 
genfstab -U -p /mnt > /mnt/etc/fstab
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
sed -i "s/#en_US.UTF/en_US.UTF/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "root:arch" | chpasswd -R /mnt
arch-chroot /mnt grub-install --target=i386-pc --recheck /dev/sda
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt systemctl enable sshd
echo "exec cinnamon-session" > /mnt/root/.xinitrc
echo "archlinux" > /mnt/etc/hostname

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

