{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    fstar.url   = "github:fstarlang/fstar";
  };
  
  outputs = { self, nixpkgs, fstar }: rec {

    nixosModules =
      let
        system = "x86_64-linux";
      in rec {
        fstar-overlay = {
          nixpkgs.overlays = [(self: super:
            {
              fstar = fstar.packages.${system}.fstar;
              z3-fstar = fstar.packages.${system}.z3;
            }
          )];
          system.stateVersion = "22.11";
        };
        container = ./backend/container.nix;
        default = {
          imports = [fstar-overlay container];
        };
      }; 
    
    nixosConfigurations.container = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        nixosModules.fstar-overlay
        nixosModules.container
      ];
    };

  };
}
