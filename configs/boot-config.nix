{  
  # Set up GRUB as the bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
  #boot.loader.grub.devices = [ "/dev/nvme0n1" ];
}