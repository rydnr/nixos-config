# flake.nix
{
  description = "flake-based NixOS configuration";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/25.11";
      #url = "github:NixOS/nixpkgs/3969161bed913e109cd4148a8d93d91a1fb932ca";
      #url = "github:NixOS/nixpkgs/nixos-unstable";
      #url = "github:NixOS/nixpkgs/24.05";
      #url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.11";
    };
    #    nix-ld = {
    #      url = "github:Mic92/nix-ld";
    # this line assume that you also have nixpkgs as an input
    #      inputs.nixpkgs.follows = "nixpkgs";
    #    };
    nixos-kubernetes = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rydnr/nixos-kubernetes/test-291";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
  };

  outputs = { nixpkgs,
    #      nix-ld,
    home-manager, nixos-kubernetes, sops-nix, ... }:
    let
      hostSettings = {
        archvile = {
          system = "x86_64-linux";
          hostName = "archvile";
          allowUnfree = true;
          checkMeta = true;
          cudaSupport = true;
          warnUndeclaredOptions = true;
          gtk = {
            fontName = "Fira Sans";
            iconTheme = "Papirus";
            iconThemePackageName = "papirus-icon-theme";
            cursorTheme = "quintom-cursor-theme";
            cursorThemePackageName = "quintom-cursor-theme";
            dpi = 144;
            tmuxPrefix = "C-v";
          };
        };
        maricruz = {
          system = "x86_64-linux";
          hostName = "maricruz";
          allowUnfree = true;
          checkMeta = true;
          cudaSupport = true;
          warnUndeclaredOptions = true;
          gtk = {
            fontName = "Noto Sans";
            iconTheme = "Adwaita";
            iconThemePackageName = "adwaita-icon-theme";
            cursorTheme = "Vanilla-DMZ";
            cursorThemePackageName = "vanilla-dmz";
            dpi = 96;
            tmuxPrefix = "C-a";
          };
        };
        euler = {
          system = "i686-linux";
          hostName = "euler";
          gtk = {
            fontName = "Noto Sans";
            iconTheme = "Adwaita";
            iconThemePackageName = "adwaita-icon-theme";
            cursorTheme = "Vanilla-DMZ";
            cursorThemePackageName = "vanilla-dmz";
            dpi = 96;
            tmuxPrefix = "C-e";
          };
        };
        reno = {
          system = "x86_64-linux";
          hostName = "reno";
          gtk = {
            fontName = "Cantarell";
            iconTheme = "Numix";
            iconThemePackageName = "gnome.numix-icon-theme";
            cursorTheme = "Bibata-Modern-Amber";
            cursorThemePackageName = "bibata-cursors-translucent";
            dpi = 120;
            tmuxPrefix = "C-r";
          };
        };
      };
    in {
      nixosConfigurations = {
        archvile = nixpkgs.lib.nixosSystem rec {
          system = hostSettings.archvile.system or "x86_64-linux";
          modules = [
            ./archvile.nix
            sops-nix.nixosModules.sops
            # nix-ld.nixosModules.nix-ld
            {
              nixpkgs.config = {
                allowUnfree = hostSettings.archvile.allowUnfree or false;
                warnUndeclaredOptions = true;
              };
            }
          ];
        };

        maricruz = nixpkgs.lib.nixosSystem rec {
          system = hostSettings.maricruz.system or "x86_64-linux";
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
            {
              nixpkgs.config = {
                allowUnfree = hostSettings.maricruz.allowUnfree or false;
                warnUndeclaredOptions = true;
              };
            }
          ];
        };

        reno = nixpkgs.lib.nixosSystem {
          system = hostSettings.reno.system or "x86_64-linux";
          modules = [
            ./reno.nix
            #            nix-ld.nixosModules.nix-ld
            {
              nixpkgs.config = {
                allowUnfree = hostSettings.reno.allowUnfree or false;
                warnUndeclaredOptions = true;
              };
            }
          ];
        };
        euler = nixpkgs.lib.nixosSystem {
          system = hostSettings.euler.system or "i686-linux";
          modules = [
            ./euler.nix
            {
              nixpkgs.config = {
                allowUnfree = hostSettings.euler.allowUnfree or false;
                warnUndeclaredOptions = true;
              };
            }
          ];
        };
        tray = nixpkgs.lib.nixosSystem {
          system = hostSettings.tray.system or "x86_64-linux";
          modules = [
            ./tray.nix
            #            nix-ld.nixosModules.nix-ld
            {
              nixpkgs.config = {
                allowUnfree = hostSettings.tray.allowUnfree or false;
                warnUndeclaredOptions = true;
              };
            }
          ];
        };
        # thales = pkgs.lib.nixosSystem {
        #   system = hostSettings.thales.system or "x86_64-linux";
        #   modules = [
        #     ./thales.nix
        #            nix-ld.nixosModules.nix-ld
        #      {
        #        nixpkgs.config = {
        #          allowUnfree = hostSettings.thales.allowUnfree or false;
        #          warnUndeclaredOptions = true;
        #        };
        #      }
        #   ];
        # };
      };
      homeConfigurations = builtins.mapAttrs (hostName: settings:
        home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgs { system = settings.system; };
          extraSpecialArgs = { inherit (settings) hostName gtk; };
          modules = [ ./home-manager/chous.nix ];
        }) hostSettings;
    };

}
