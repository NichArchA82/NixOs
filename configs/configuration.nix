{ config, pkgs, ... }:

{
  # Set hostname, timezone, and other basic settings
  networking.hostName = "nixos";
  time.timeZone = "America/New_York"

  # Enable services
  services.openssh = {
    enable = true;
    ports = [22 2222];
  };
  services.tailscale.enable = true;

  virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
    ovmf = {
      enable = true;
      packages = [(pkgs.OVMF.override {
        secureBoot = true;
        tpmSupport = true;
        }).fd];
      };
    };
  };

  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
  curl
  git
  libvirt
  qemu
  bridge-utils
  virt-manager
  dnsmasq
  vim
  jq
  file
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # DO NOT REMOVE OR YOU WILL LOSE SSH ACCESS
    "ssh-ed25519 your pub key"
    "ssh-ed25519 your 2nd pub key"
  ];

  # Other configuration settings here...

  system.stateVersion = "24.05";
}
