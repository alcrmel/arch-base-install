#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
#echo "KEYMAP=de_CH-latin1" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | chpasswd


#----------------- Packages To Be Installed ------------------------------------------
# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm
# Most of this are commented out for references. You can create your own general packages.

# pacman -Syu grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call tlp virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings


#---- System defaults -----------------------------------------------------------------
# Download the specific headers for your linux package

pacman -Syu grub efibootmgr base-devel linux-zen-headers

#---- Network packages ----------------------------------------------------------------
# 
# Don't install wpa_supplicant if you install iwd or wireless_tools
# Don't install netctl if you install network manager
# Don't install net-tools if you install iproute2
# You can install cups to access the printers
pacman -Syu  networkmanager network-manager-applet dialog dhclient dnsmasq dnsutils ethtool iwd ndisc6 iproute2 avahi nss-mdns ntfs-3g wireless-regdb bluez bluez-utils firewalld


#----- Audio Packages -----------------------------------------------------------------
pacman -Syu alsa-firmware alsa-plugins alsa-utils paprefs pavucontrol pulseaudio pulseaudio-alsa pulseaudio-jack pulseaudio-bluetooth


#---- Package management --------------------------------------------------------------
pacman -Syu reflector flatpak

#---- Xor Packages --------------------------------------------------------------------
pacman -Syu libwnck3 xf86-input-libinput xf86-video-fbdev xf86-video-vesa xorg-server xorg-xinit xorg-xinput xorg-xkill xorg-xrandr xorg-xprop

#---- Hardware Packages ---------------------------------------------------------------
pacman -Syu mtools dosfstools hdparm sof-firmware

#---- Power Management ----------------------------------------------------------------
pacman -Syu tlp acpi

#---- Desktop integration -------------------------------------------------------------
pacman -Syu mlocate xdg-user-dirs xdg-utils freetype2

#---- Filesystem Tools and App --------------------------------------------------------
pacman -Syu nfs-utils nilfs-utils ntp smartmontools unrar unzip xz

#---- Others --------------------------------------------------------------------------
pacman -Syu bash-completion


# --------------------------------------------------------------------------------------

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable firewalld

useradd -m general
echo general:password | chpasswd

echo "general ALL=(ALL) ALL" >> /etc/sudoers.d/general

echo "[main]" >> /etc/NetworkManager/conf.d/dns.conf
echo "dns=dnsmasq" >> /etc/NetworkManager/conf.d/dns.conf

echo "listen-address=::1" >> /etc/NetworkManager/dnsmasq.d/ipv6-listen.conf

echo "conf-file=/usr/share/dnsmasq/trust-anchors.conf" >> /etc/NetworkManager/dnsmasq.d/dnssec.conf
echo "dnssec" >> /etc/NetworkManager/dnsmasq.d/dnssec.conf

echo "[main]" >> /etc/NetworkManager/conf.d/dhcp-client.conf
echo "dhcp=dhclient" >> /etc/NetworkManager/conf.d/dhcp-client.conf


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
