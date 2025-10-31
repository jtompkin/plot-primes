alias t := test
alias b := build
alias u := upload

nixpkgsRev := "0b4defa2584313f3b781240b29d61f6f9f7e0df3"
nixScriptFile := "nix/plotprimes.py"
nixShebang := '''
    #!/usr/bin/env nix-shell
    #! nix-shell -i python3 --pure
    #! nix-shell -p 'python3.withPackages (pp: [pp.matplotlib])'
''' + '#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/' + nixpkgsRev + ".tar.gz\n" + '''
    # This is a reproducible interpreted script that only requires Nix to run.
    # See: https://nix.dev/tutorials/first-steps/reproducible-scripts.html'''

test:
    PYTHONPATH=src python tests/test_plotprimes.py -v

make-nix-script:
    printf "%s\n" "{{ nixShebang }}" >{{ nixScriptFile }}
    tail -n+2 src/plotprimes/plotprimes.py >>{{ nixScriptFile }}
    chmod +x {{ nixScriptFile }}

build: test make-nix-script
    python -m build --installer uv

upload token repo="pypi": build
    python -m twine upload -u __token__ -p '{{ token }}' -r '{{ repo }}' dist/*
