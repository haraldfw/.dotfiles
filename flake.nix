{
  description = "My first flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

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
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "haraldfw";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        tux = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/tux ];
          specialArgs = {
            host = "tux";
            inherit self inputs username;
          };
        };
      };
      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./modules/home ];
          extraSpecialArgs = {
            inherit inputs username;
          };
        };
      };
    };
}
