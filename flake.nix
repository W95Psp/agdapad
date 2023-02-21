{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    fstar.url   = "github:fstarlang/fstar";
  };
  
  outputs = { self, nixpkgs, fstar }: {

    nixosConfigurations.container = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        {
          nixpkgs.overlays = [(self: super:
            {
              fstar = fstar.packages.${system}.fstar;
              z3-fstar = fstar.packages.${system}.z3;
            }
          )];
          system.stateVersion = "22.11";
        }
        ./backend/container.nix
      ];
    };

  };
}
