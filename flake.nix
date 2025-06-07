# flake.nix
{
  description = "flake-based NixOS configuration";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/25.05";
      #url = "github:NixOS/nixpkgs/3969161bed913e109cd4148a8d93d91a1fb932ca";
      #url = "github:NixOS/nixpkgs/nixos-unstable";
      #url = "github:NixOS/nixpkgs/24.05";
      #url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    nix-ld = {
#      url = "github:Mic92/nix-ld";
      # this line assume that you also have nixpkgs as an input
#      inputs.nixpkgs.follows = "nixpkgs";
#    };
    nixos-kubernetes = {
      url = "github:rydnr/nixos-kubernetes/test-291";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
#      nix-ld,
      home-manager,
      nixos-kubernetes,
      ...
    }:
    let
      system = "x86_64-linux";
      hostConfig = {
        archvile = {
          #system = "x86_64-linux";
          allowUnfree = true;
          checkMeta = true;
          cudaSupport = true;
          warnUndeclaredOptions = true;
        };
        maricruz = {
          #system = "x86_64-linux";
          allowUnfree = true;
          checkMeta = true;
          cudaSupport = true;
          warnUndeclaredOptions = true;
        };
        euler = {
          #system = "i686-linux";
        };
      };
      #hostname = builtins.getEnv "HOSTNAME";
      pkgs = import nixpkgs {
        inherit nixpkgs system;
#        system = "x86_64-linux";
        config = {
#          allowUnfree = (hostConfig.${hostname}).allowUnfree or #false;
          allowUnfree = true;
          warnUndeclaredOptions = true;
        };
      };
    in
    {
      nixosConfigurations = {
        archvile = nixpkgs.lib.nixosSystem rec {
          # inherit pkgs;
          system = "x86_64-linux";
          #system = hostConfig.system or "x86_64-linux";
          modules = [
            ./archvile.nix
#            nix-ld.nixosModules.nix-ld
          ];
        };

        maricruz = nixpkgs.lib.nixosSystem rec {
          # inherit pkgs;
          system = "x86_64-linux";
          #system = hostConfig.system or "x86_64-linux";
          modules = [
            ./maricruz.nix
#            nix-ld.nixosModules.nix-ld
            nixos-kubernetes.nixosModules.${system}.raw-kubernetes-ca
            nixos-kubernetes.nixosModules.${system}.raw-kube-apiserver
            nixos-kubernetes.nixosModules.${system}.raw-kube-controller-manager
            nixos-kubernetes.nixosModules.${system}.raw-kube-proxy-certificate
            nixos-kubernetes.nixosModules.${system}.raw-kube-proxy
            nixos-kubernetes.nixosModules.${system}.raw-kube-scheduler
            nixos-kubernetes.nixosModules.${system}.raw-kubelet-certificate
            nixos-kubernetes.nixosModules.${system}.raw-kubelet
          ];
        };

        reno = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          #system = hostConfig.system or "x86_64-linux";
          modules = [
            ./reno.nix
#            nix-ld.nixosModules.nix-ld
          ];
        };
        euler = nixpkgs.lib.nixosSystem {
          system = "i686-linux";
          #system = hostConfig.system or "x86_64-linux";
          modules = [ ./euler.nix ];
        };
        tray = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          #system = hostConfig.system or "x86_64-linux";
          modules = [
            ./tray.nix
#            nix-ld.nixosModules.nix-ld
          ];
        };
        # thales = pkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   #system = hostConfig.system or "x86_64-linux";
        #   modules = [
        #     ./thales.nix
#            nix-ld.nixosModules.nix-ld
        #   ];
        # };
      };
      homeConfigurations = {
        archvile = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/chous.nix ];
        };
        maricruz = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/chous.nix ];
        };
      };
    };
}
