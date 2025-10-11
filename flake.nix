{
  description = "Making plots with Python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      allSystems = [ "x86_64-linux" ];
      forAllSystems = f: lib.genAttrs allSystems (system: f system nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (
        system: pkgs: {
          default = pkgs.mkShell {
            name = "plotting";
            packages = [
              (pkgs.python3.withPackages (
                python-pkgs: with python-pkgs; [
                  matplotlib
                  pandas
                  numpy
                ]
              ))
            ];
          };
        }
      );
    };
}
