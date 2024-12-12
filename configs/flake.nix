{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

  outputs = { self, nixpkgs, disko, nixos-facter-modules, ... }:
    let
      # Define the system configuration
      systemConfig = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./boot-config.nix
        ];
      };
    in
    {
      # Expose the NixOS configuration
      nixosConfigurations.nixos = systemConfig;
    };
}
