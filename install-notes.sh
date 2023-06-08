
exit 1 # Don't run this, it's a "script" for syntax highlighting

# Internets!
iwctl station wlan0 connect "Network Name"


# Install!

# Ensure EFI
#ls /sys/firmware/efi/efivars

fdisk /dev/sda
#### GPT partition possible!
# Ended up using MBR/DOS disk + installing GRUB
# 2gb FAT boot
# remaining BTRFS root

mkfs.fat -F 32 /dev/sda1
mkfs.btrfs -f /dev/sda2


mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

pacstrap -K /mnt base linux linux-firmware python base-devel git vim sudo lm_sensors

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

# In the new OS!

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

vim /etc/locale.gen

locale-gen

vim /etc/locale.conf
# LANG=en_US.UTF-8

echo 'azure-liminal' > /etc/hostname

mkinitcpio -P

# Set root PW
passwd

# Install Bootloader
bootctl install
systemctl enable systemd-boot-update.service

cat > /boot/loader/loader.conf <<EOF
#console-mode keep
console-mode max
timeout 6
default arch.conf
EOF

cat > /boot/loader/entries/arch.conf <<EOF
title Azure Liminal
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=TODO-run-blkid rootfstype=btrfs add_efi_memmap mitigations=off pti=off intel_pstate=passive
EOF


pacman -Sy intel-ucode

# Misc packages
pacman -Sy zsh vim sudo python iwd dhcpcd
systemctl enable iwd.service
systemctl enable dhcpcd.service

yay -Sy openssh nginx-mainline
sudo systemctl enable sshd.service
sudo systemctl enable nginx.service

# Create a 'jeffrey' account
useradd -m -G wheel,video,disk -s /usr/bin/bash jeffrey

# Install yay
(
  su jeffrey
  cd /opt
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
)


cat > /etc/systemd/network/eno1.network <<EOF
[Match]
Name=eno1

[Network]
Address=169.254.100.3/16
EOF



