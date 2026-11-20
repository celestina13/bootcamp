#!/usr/bin/env python3

"""Checks for the functions in observations_practice.py.

Author: Celestina Hall (ceh121@ic.ac.uk)
Script: test_observations_practice.py
Run from the project root: python3 code/test_observations_practice.py
Prints nothing if every check passes.
"""

from observations_practice import load_observations, parse_count

#Normal case: ordinary count text becomes an integer
assert parse_count("2") == 2

#Boundary case: zero is a valid known count
assert parse_count("0") == 0

#Special valid case: blank text represents a missing count
assert parse_count("") is None

#Failure cases: each invalid value must raise ValueError
for bad_count in ["-1", "many", 2]:
    try:
        parse_count(bad_count)
    except ValueError:
        pass
    else:
        raise AssertionError(f"Invalid count accepted: {bad_count!r}")
