{
  description = "My first flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    # hypr-contrib = {
    #   url = "github:hyprwm/contrib";
    #   inputs.nixpkgs.follows = "hyprland/nixpkgs";
    # };

    # hyprpicker = {
    #   url = "github:hyprwm/hyprpicker";
    #   inputs.nixpkgs.follows = "hyprland/nixpkgs";
    # };

    # hyprlock = {
    #   url = "github:hyprwm/hyprlock";
    #   inputs = {
    #     hyprgraphics.follows = "hyprland/hyprgraphics";
    #     hyprlang.follows = "hyprland/hyprlang";
    #     hyprutils.follows = "hyprland/hyprutils";
    #     nixpkgs.follows = "hyprland/nixpkgs";
    #     systems.follows = "hyprland/systems";
    #   };
    # };

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs = {
    #     hyprland = {
    #       follows = "hyprland";
    #     };
    #   };
    # };

    # nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-vscode-extensions,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "haraldfw";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nix-vscode-extensions.overlays.default
        ];
        config.permittedInsecurePackages = [
          "electron-36.9.5"
        ];
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        tux = lib.nixosSystem {
          inherit system;
          modules = [ ./systems/tux ];
          specialArgs = {
            host = "tux";
            inherit self inputs username;
          };
        };
        tuxollini = lib.nixosSystem {
          inherit system;
          modules = [ ./systems/tuxollini ];
          specialArgs = {
            host = "tuxollini";
            inherit self inputs username;
          };
        };
      };
      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home ];
          extraSpecialArgs = {
            inherit inputs username;
          };
        };
      };
    };
}
