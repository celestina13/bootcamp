#!/usr/bin/env python3

"""Checks for the functions in observations_practice.py.

Author: Celestina Hall (ceh121@ic.ac.uk)
Script: test_observations_practice.py
Run from the project root: python3 code/test_observations_practice.py
Prints nothing if every check passes.
"""

from observations_practice import load_observations, parse_count, summarise_site

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

#Normal case: known counts for one site are added up, ignoring other sites
unique_rows = [
    {"site": "A", "date": "2026-10-01", "count": "2"},
    {"site": "A", "date": "2026-10-02", "count": "3"},
    {"site": "B", "date": "2026-10-01", "count": "9"},
]
assert summarise_site(unique_rows, "A") == (5, 0)

#Boundary cases: blanks are missing, zero is known, and no rows gives no total
missing_rows = [
    {"site": "C", "date": "2026-10-01", "count": ""},
    {"site": "C", "date": "2026-10-02", "count": ""},
]
zero_rows = [{"site": "D", "date": "2026-10-01", "count": "0"}]
assert summarise_site(missing_rows, "C") == (None, 2)
assert summarise_site(zero_rows, "D") == (0, 0)
assert summarise_site([], "A") == (None, 0)
assert summarise_site(unique_rows, "Z") == (None, 0)

#Duplicates: a repeated non-zero count and a repeated blank are each counted once
assert summarise_site(unique_rows + [unique_rows[0]], "A") == (5, 0)
assert summarise_site(missing_rows + [missing_rows[0]], "C") == (None, 2)
