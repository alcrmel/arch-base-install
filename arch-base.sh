#!/bin/bash

# Editing the keyboard type to use
printf "[Start] Setting up the timezone and auto timesync : /etc/locale.gen"
sed -i '177s/.//' /etc/locale.gen
locale-gen
timedatectl set-ntp true
printf "[Done] Setting up the timezone and auto timesync : /etc/locale.gen"

# Editing the local timezone
printf "[Start] Setting the localtime : /etc/localtime"
ln -sf /usr/share/zoneinfo/Asia/Hong_Kong
hwclock --systohc
printf "[Done] Setting the localtime : /etc/localtime"

# Setting the keyboard layout and language
printf "[Start] Setting the keyboard layout and language : /etc/locale.conf"
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
printf "[Done] Setting the keyboard layout and language : /etc/locale.conf"

# Editing the host file
echo "[Start] Editing the host file : /etc/hostname"
echo "arch" >> /etc/hostname
echo "[Start] Editing the host file : /etc/hosts"
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo "[Done] Editing the host file : /etc/hosts"

# Changing password of root
# Change the password in root:password
printf "[Start] Changing password of root : chpasswd"
echo root:password | chpasswd
printf "[Done] Changing password of root : chpasswd"

# Downloading packages
# optionals:
#    wpa_supplicant - for wireless connection
#    avahi -  It allows programs to publish and discover services and hosts running on a local network with no specific configuration. For example you can plug into a network and instantly find printers to print to, files to look at and people to talk to
#    gvfs-smb - Filesystem explorer for smb
#    nfs-utils - Network file system utilities
# # You can remove the tlp package if you are installing on a desktop or vm
printf "[Start] Downloading required packages : pacman -S --noconfirm"
pacman -S --noconfirm grub networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pulseaudio bash-completion openssh rsync reflector acpi acpi_call virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font
printf "[Done] Downloading required packages : pacman -S --noconfirm"

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings


#installing Grub bootloader
grub-install --target=i386-pc /dev/sdX # replace sdx with your disk name, not the partition
grub-mkconfig -o /boot/grub/grub.cfg

# Enable the system applications
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
# systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

# Change the password in arch_gen:password
useradd -m arch_gen
echo arch_gen:password | chpasswd
usermod -aG libvirt arch_gen

echo "arch_gen ALL=(ALL) ALL" >> /etc/sudoers.d/arch_gen


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
