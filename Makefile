.ONESHELL:

plot-primes.py: src/plotprimes/__init__.py
	tail -n+2 src/plotprimes/__init__.py >tmp
	cat - tmp <<EOF >plot-primes.py
		#!/usr/bin/env nix-shell
		#! nix-shell -i python3 --pure
		#! nix-shell -p 'python3.withPackages (pp: with pp; [matplotlib numpy])'
		#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/0b4defa2584313f3b781240b29d61f6f9f7e0df3.tar.gz
		EOF
	chmod 755 plot-primes.py
	${RM} tmp
