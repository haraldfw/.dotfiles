{
  description = "Global flake for my PCs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-vscode-extensions,
      hyprdynamicmonitors,
      nix-darwin,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [
            "electron-36.9.5"
          ];
        };
      pkgsFor = system: mkPkgs system;

      hosts = {
        tux = {
          system = "x86_64-linux";
          username = "haraldfw";
        };
        tuxollini = {
          system = "x86_64-linux";
          username = "haraldfw";
        };
        nixbook = {
          system = "aarch64-darwin";
          username = "harald.wilhelmsen";
        };
      };
    in
    {
      nixosConfigurations = {
        tux = lib.nixosSystem {
          system = hosts.tux.system;
          modules = [ ./systems/tux ];
          specialArgs = {
            host = "tux";
            username = hosts.tux.username;
            inherit self inputs;
          };
        };
        tuxollini = lib.nixosSystem {
          system = hosts.tuxollini.system;
          modules = [
            ./systems/tuxollini
          ];
          specialArgs = {
            host = "tuxollini";
            username = hosts.tuxollini.username;
            inherit self inputs;
          };
        };
      };

      darwinConfigurations = {
        nixbook = nix-darwin.lib.darwinSystem {
          system = hosts.nixbook.system;
          modules = [
            ./systems/nixbook
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit inputs;
                username = hosts.nixbook.username;
                system = hosts.nixbook.system;
              };
              home-manager.backupFileExtension = "pre-home-manager";
              home-manager.users.${hosts.nixbook.username} = import ./home/mac.nix;
            }
          ];
          specialArgs = {
            host = "nixbook";
            username = hosts.nixbook.username;
            inherit self inputs;
          };
        };
      };

      homeConfigurations = {
        "${hosts.tux.username}@tux" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor hosts.tux.system;
          modules = [
            hyprdynamicmonitors.homeManagerModules.default
            ./home/linux.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
            system = hosts.tux.system;
            username = hosts.tux.username;
          };
        };
        "${hosts.tuxollini.username}@tuxollini" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor hosts.tuxollini.system;
          modules = [
            hyprdynamicmonitors.homeManagerModules.default
            ./home/linux.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
            system = hosts.tuxollini.system;
            username = hosts.tuxollini.username;
          };
        };

        "${hosts.nixbook.username}@nixbook" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor hosts.nixbook.system;
          modules = [
            ./home/mac.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
            system = hosts.nixbook.system;
            username = hosts.nixbook.username;
          };
        };
      };
    };
}
