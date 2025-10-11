#!/usr/bin/env python3

import argparse
from typing import Generator


from matplotlib import pyplot as plt
import numpy as np


def is_prime(x: int) -> bool:
    for divisor in range(2, int(x**0.5) + 1):
        if x % divisor == 0:
            return False
    return True


def get_primes(n: int) -> Generator[int]:
    count = 0
    i = 2
    while count < n:
        if is_prime(i):
            count += 1
            yield i
        i += 1


def plot_primes(n: int, colormap: str) -> None:
    fig, ax = plt.subplots(subplot_kw={"projection": "polar"})
    ax.scatter(list(get_primes(n)), np.arange(n), s=0.7, c=np.arange(n), cmap=colormap)

    ax.grid(False)
    ax.set_axis_off()

    fig.set_facecolor("black")
    fig.set_size_inches(11, 6)

    plt.show()


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(
        prog="plot", description="Plot primes in polar coordinate system"
    )
    parser.add_argument("-n", type=int, default=100)
    parser.add_argument("-c", type=str, default="twilight")
    args = parser.parse_args(argv)
    plot_primes(args.n, args.c)


if __name__ == "__main__":
    main()
