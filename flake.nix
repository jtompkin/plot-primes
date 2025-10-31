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
          plotprimes = pkgs.callPackage ./nix/package.nix { };
        in
        {
          plotprimes = plotprimes.application;
          plotprimes-lib = plotprimes.library;
          default = self.packages.${system}.plotprimes;
        }
      );
      devShells = forAllSystems (
        system: pkgs: {
          default = pkgs.mkShell {
            name = "plot-primes";
            packages = [
              pkgs.ruff
              pkgs.pyright
              pkgs.just
              pkgs.uv
              pkgs.just-lsp
              (pkgs.python3.withPackages (
                python-pkgs: with python-pkgs; [
                  matplotlib
                  build
                  twine
                  self.packages.${system}.plotprimes-lib
                ]
              ))
            ];
          };
        }
      );
    };
}
