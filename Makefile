.ONESHELL:

nix/plotprimes.py: plotprimes.py
	tail -n+2 plotprimes.py >tmp
	cat - tmp <<EOF >nix/plotprimes.py
		#!/usr/bin/env nix-shell
		#! nix-shell -i python3 --pure
		#! nix-shell -p 'python3.withPackages (pp: with pp; [matplotlib numpy])'
		#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/0b4defa2584313f3b781240b29d61f6f9f7e0df3.tar.gz
		# This is a reproducible script that does not require any dependencies to be 
		# installed. You must have Nix installed to run it as is.
		EOF
	chmod 755 nix/plotprimes.py
	${RM} tmp
