# plot-primes

It plots primes in a polar coordinate system. Looks real nice for wallpapers and such.

## Run it

### Directly

Download [`plotprimes.py`](https://github.com/jtompkin/plot-primes/blob/main/plotprimes.py) and run it with Python. This script requires [`numpy`](https://pypi.org/project/numpy/) and [`matplotlib`](https://pypi.org/project/matplotlib/).

### Nix

The flake exposes `plot-primes` as the default package:

```bash
nix run 'github:jtompkin/plotprimes' -- -n 10000
```

If you're feeling spicy, you can download the [`nix/plotprimes.py`](https://github.com/jtompkin/plot-primes/blob/main/nix/plotprimes.py) script and run it directly. This is a reproducible interpreted script&mdash;all you need is Nix, it will run in an environment with all dependencies satisfied automagically.

## Use it

### Flags

- `-n`: `int` Number of primes to plot. Be careful, this script uses the ultra-inefficient trial division method of finding primes. (default 1000)
- `-c`: `str` [Matplotlib colormap](https://matplotlib.org/stable/users/explain/colors/colormaps.html) name. (default "twilight")

## Build it

Requires Python and [`build`](https://pypi.org/project/build/).

```bash
git clone https://github.com/jtompkin/plot-primes
cd plot-primes
python -m build
```
