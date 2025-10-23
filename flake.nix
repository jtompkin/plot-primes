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
          plotprimes = pkgs.callPackage ./nix/package.nix { };
          default = self.packages.${system}.plotprimes;
        }
      );
      devShells = forAllSystems (
        _: pkgs: {
          default = pkgs.mkShell {
            name = "plot-primes";
            packages = [
              pkgs.uv
              pkgs.entr
              (pkgs.python3.withPackages (
                python-pkgs: with python-pkgs; [
                  matplotlib
                  build
                ]
              ))
            ];
          };
        }
      );
    };
}
