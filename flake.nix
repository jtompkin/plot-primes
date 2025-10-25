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
        system: pkgs:
        let
          plotprimesCombined = pkgs.callPackage ./nix/package.nix { };
        in
        {
          plotprimes = plotprimesCombined.application;
          plotprimes-lib = plotprimesCombined.library;
          default = self.packages.${system}.plotprimes;
        }
      );
      devShells = forAllSystems (
        system: pkgs: {
          default = pkgs.mkShell {
            name = "plot-primes";
            packages = [
              pkgs.ruff
              (pkgs.python3.withPackages (
                python-pkgs: with python-pkgs; [
                  matplotlib
                  build
                  self.packages.${system}.plotprimes-lib
                ]
              ))
            ];
          };
        }
      );
    };
}
