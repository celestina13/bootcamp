#!/usr/bin/env python3

"""Small functions practising conditionals and loops."""


def foo_1(x):
    """Return the square root of x."""
    return x ** 0.5


def foo_2(x, y):
    """Return the larger of x and y."""
    if x > y:
        return x
    return y


def foo_3(x, y, z):
    """Return x, y and z as a list sorted from smallest to largest."""
    if x > y:
        x, y = y, x
    if x > z:
        x, z = z, x
    if y > z:
        y, z = z, y
    return [x, y, z]


def foo_4(x):
    """Return the factorial of x, using a for loop."""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result


def foo_5(x):
    """Return the factorial of x, using recursion."""
    if x == 1:
        return 1
    return x * foo_5(x - 1)


def foo_6(x):
    """Return the factorial of x, using a while loop instead of an if statement."""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto
