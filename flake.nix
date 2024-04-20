# flake.nix
{
  description = "flake-based NixOS configuration";
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
        modules = [ ./maricruz.nix nix-ld.nixosModules.nix-ld ];
      };
      reno = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./reno.nix nix-ld.nixosModules.nix-ld ];
      };
      euler = nixpkgs.lib.nixosSystem {
        system = "i686-linux";
        modules = [ ./euler.nix ];
      };
      tray = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./tray.nix nix-ld.nixosModules.nix-ld ];
      };
      thales = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./thales.nix nix-ld.nixosModules.nix-ld ];
      };
    };
  };
}
