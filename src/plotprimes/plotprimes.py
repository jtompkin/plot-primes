#!/usr/bin/env python3
import argparse
from math import log

from matplotlib import pyplot as plt
import numpy as np


def get_upper_limit(n: int) -> int:
    if n < 6:
        return 15
    return int(n * (log(n) + log(log(n)))) + 1


def get_primes(n: int) -> list[int]:
    limit = get_upper_limit(n)
    is_prime = np.ones(limit)
    is_prime[:2] = 0
    for i in range(2, int(limit**0.5) + 1):
        if is_prime[i]:
            is_prime[i * i : limit + 1 : i] = 0
    return [i for i, b in enumerate(is_prime) if b]


def plot_primes(n: int, colormap: str) -> None:
    fig, ax = plt.subplots(subplot_kw={"projection": "polar"})
    ax.scatter(get_primes(n)[:n], np.arange(n), s=0.5, c=np.arange(n), cmap=colormap)
    ax.set_axis_off()

    fig.set_facecolor("black")
    fig.set_size_inches(11, 6)

    plt.show()


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(
        description="Plot prime numbers in a polar coordinate system"
    )
    parser.add_argument(
        "-n",
        "--number",
        type=int,
        metavar="int",
        default=1000,
        help="number of primes to plot (default 1000)",
    )
    parser.add_argument(
        "-c",
        "--colormap",
        type=str,
        metavar="str",
        default="twilight",
        help='name of colormap to use for plot (default "twilight")',
    )
    args = parser.parse_args(argv)
    plot_primes(args.number, args.colormap)


if __name__ == "__main__":
    main()
