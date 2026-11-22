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

#Checks against the supplied data files
rows = load_observations("data/bootcamp_observations.csv")
assert summarise_site(rows, "A") == (2, 1)
assert summarise_site(rows, "B") == (0, 0)

boundary_rows = load_observations("data/bootcamp_observations_boundary.csv")
assert summarise_site(boundary_rows, "C") == (None, 2)
assert summarise_site(boundary_rows, "D") == (0, 0)
assert summarise_site(rows, "Z") == (None, 0)


def expect_summary_error(rows, site="A"):
    """Check that summarise_site raises ValueError for these arguments."""
    try:
        summarise_site(rows, site)
    except ValueError:
        pass
    else:
        raise AssertionError("Expected ValueError, but the call succeeded")


#Failure cases: each invalid row or argument must raise ValueError
invalid_rows = load_observations("data/bootcamp_observations_invalid.csv")
for invalid_row in invalid_rows:
    expect_summary_error([invalid_row])

expect_summary_error([{"site": "A", "count": "2"}])
expect_summary_error([{"site": "A", "date": "2026-10-01", "count": "2", "extra": "x"}])
expect_summary_error([{"site": "", "date": "2026-10-01", "count": "2"}])
expect_summary_error([{"site": "A", "date": "", "count": "2"}])
expect_summary_error([{"site": "A", "date": "2026-10-01", "count": 2}])
expect_summary_error(["not a row dictionary"])
expect_summary_error(None)
expect_summary_error(rows, "")
expect_summary_error(rows, 2)

#An invalid row for another site still raises an error when A is requested
expect_summary_error([unique_rows[0], invalid_rows[1]], "A")

#The input rows are not changed
original_rows = [row.copy() for row in rows]
summarise_site(rows, "A")
assert rows == original_rows
