{
  description = "Plot prime numbers with Python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      allSystems = [ "x86_64-linux" ];
      forAllSystems = f: lib.genAttrs allSystems (system: f system nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        system: pkgs: {
          plot-primes = pkgs.callPackage ./nix/package.nix { };
          default = self.packages.${system}.plot-primes;
        }
      );
      devShells = forAllSystems (
        _: pkgs: {
          default = pkgs.mkShell {
            name = "plot-primes";
            packages = [
              (pkgs.python3.withPackages (
                python-pkgs: with python-pkgs; [
                  matplotlib
                  numpy
                ]
              ))
              pkgs.entr
            ];
          };
        }
      );
    };
}
