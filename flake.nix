# flake.nix
{
  description = "flake-based NixOS configuration for Maricruz laptop";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      # this line assume that you also have nixpkgs as an input
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-ld, home-manager, ... }: {
    nixosConfigurations = {
      maricruz = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./old-config.nix
          nix-ld.nixosModules.nix-ld
          #          home-manager.nixosModules.home-manager
          #          {
          #            home-manager.useGlobalPkgs = true;
          #            home-manager.useUserPackages = true;
          # home-manager.users.jdoe = import ./home.nix;
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
          #          }
        ];
      };
    };
  };
}
