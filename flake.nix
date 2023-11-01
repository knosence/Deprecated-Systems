# Entry point of my configuration
# ├ ─ └
#  flake.nix *             
#   ├─ ./hosts
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#


{
  description = "My Systems flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";

      user = "knosence";
      
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.knosence = {
                imports = [./home.nix];
              };
            }
          ];
        };
      };
    };

}
