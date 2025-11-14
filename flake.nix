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
          default = self.packages.${system}.plotprimes-lib;
        }
      );
      apps = forAllSystems (
        system: pkgs: {
          plotprimes = {
            type = "app";
            program = lib.getExe self.packages.${system}.plotprimes;
            meta.description = "Run plotprimes, a tool that plots primes in a polar coordinate system";
          };
          default = self.apps.${system}.plotprimes;
        }
      );
      devShells = forAllSystems (
        system: pkgs:
        let
          customPython = pkgs.python3.withPackages (
            python-pkgs: with python-pkgs; [
              self.packages.${system}.plotprimes-lib
              build
              matplotlib
              twine
            ]
          );
          just-lsp =
            {
              rustPlatform,
              fetchFromGitHub,
              nix-update-script,
            }:
            rustPlatform.buildRustPackage (finalAttrs: {
              pname = "just-lsp";
              version = "0.2.8";
              src = fetchFromGitHub {
                owner = "terror";
                repo = "just-lsp";
                rev = finalAttrs.version;
                hash = "sha256-QwpChzZ+zC4MoVp6kNqbNF6+p4Rsd0KJfVuKPyxnnZU=";
              };
              cargoHash = "sha256-j/qLLyt9Sl1cXfNkKsyEYL/MQbxRMhni6uGmRVI+Xd8=";
              passthru.updateScript = nix-update-script { };
              meta.mainProgram = "just-lsp";
            });
        in
        {
          default = pkgs.mkShell {
            PYTHON_CMD = lib.getExe customPython;
            name = "plot-primes";
            packages = [
              pkgs.just
              (pkgs.callPackage just-lsp { })
              pkgs.pyright
              pkgs.ruff
              pkgs.uv
              customPython
            ];
          };
        }
      );
    };
}
