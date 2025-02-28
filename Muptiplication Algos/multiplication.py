import timeit, random, gc
from typing import Callable
import statistics  # For calculating standard deviation


def naive_multiplication(x: int, y: int) -> int:
    """
    Naive Multiplication Algorithm for two integers.
    :param x: First number
    :param y: Second number
    :return: Product of x and y
    """
    # we will use the naive approach which is bit by bit multiplication
    # thus we convert them to strings to iterate over them
    x, y, result = str(x), str(y), 0
    # we want the longer number to be the first one, becuase it will reduce the number of iterations
    if len(x) < len(y):
        x, y = y, x
    # we iterate over the digits of the second number
    n, m = len(x), len(y)

    for i in range(m - 1, -1, -1):
        carry, temp = 0, 0
        for j in range(n - 1, -1, -1):
            digit_x = int(x[j])
            digit_y = int(y[i])
            prod = digit_x * digit_y + carry
            carry = prod // 10
            temp += (prod % 10) * (10 ** (n - 1 - j))
        temp += carry * (10 ** (n))
        result += temp * (10 ** (m - 1 - i))
    return result

def karatsuba(x, y):
    """
    Implements the Karatsuba algorithm for integer multiplication.

    Args:
        x: The first integer.
        y: The second integer.

    Returns:
        The product of x and y.
    """

    x = str(x)  # Convert to strings for easier digit manipulation
    y = str(y)

    if len(x) < len(y): # Make sure x is the longer number
        x, y = y, x

    n = len(x)
    if n < 2 or len(y) < 2:  # Base case, we only need to multiply single-digit numbers
        return int(x) * int(y)

    n_half = n // 2  # Split length

    # Pad smaller number with zeros if needed for equal split
    y = y.zfill(n)

    a = int(x[:n_half])
    b = int(x[n_half:])
    c = int(y[:n_half])
    d = int(y[n_half:])

    ac = karatsuba(a, c)
    bd = karatsuba(b, d)
    ad_plus_bc = karatsuba(a + b, c + d) - ac - bd  # Crucial step

    return ac * (10**(2* (n-n_half))) + ad_plus_bc * (10**(n-n_half)) + bd




def bechmark(func: Callable, x: int = 114514114514, y: int = 114514114514, n: int = 100000) -> float:
    """
    Benchmark the function func with the given inputs x and y
    :param func: The function to benchmark
    :param x: First number
    :param y: Second number
    :param n: Number of iterations
    :return: Average time taken by the function to execute
    """
    print(f"Benchmarking {func.__name__} with {n} iterations")
    gc.collect()
    time = timeit.timeit(lambda: func(x, y), number=n)
    return time

    
bechmark(naive_multiplication)
