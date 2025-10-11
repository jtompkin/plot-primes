{
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "plot-primes";
  version = "0.0.1";
  pyproject = true;
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./src
      ./pyproject.toml
    ];
  };
  build-system = [ python3Packages.setuptools ];
  dependencies = with python3Packages; [
    matplotlib
    numpy
  ];
}
