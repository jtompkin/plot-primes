{
  lib,
  python3Packages,
}:
let
  recipe = {
    pname = "plotprimes";
    version = "0.0.1";
    pyproject = true;
    src = lib.fileset.toSource {
      root = ../.;
      fileset = lib.fileset.unions [
        ../pyproject.toml
        ../tests
        ../src
      ];
    };
    build-system = [ python3Packages.setuptools ];
    nativeCheckInputs = [ python3Packages.pytestCheckHook ];
    dependencies = with python3Packages; [
      matplotlib
    ];
  };
in
{
  application = python3Packages.buildPythonApplication recipe;
  library = python3Packages.buildPythonPackage (recipe // { pname = "plotprimes-lib"; });
}
