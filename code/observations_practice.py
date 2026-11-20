#!/usr/bin/env python3

"""Summarise the bootcamp observation counts for each site.

Author: Celestina Hall (ceh121@ic.ac.uk)
Script: observations_practice.py
Run from the project root: python3 code/observations_practice.py
Input: data/bootcamp_observations.csv
"""

import csv


def load_observations(path):
    """Return the rows of a CSV file as a list of dictionaries."""
    with open(path, newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream))


def parse_count(count_text):
    """Return a count as an integer, or None if it is blank.

    Raises ValueError if the count is not text or not a whole number of 0 or more.
    """
    #Only text is accepted, so a number passed in by mistake is reported, not converted
    if not isinstance(count_text, str):
        raise ValueError(f"count must be text, got {count_text!r}")
    #A blank count is missing, which is different from an observed zero
    if count_text == "":
        return None
    #int() raises ValueError itself for text that is not a whole number
    count = int(count_text)
    if count < 0:
        raise ValueError(f"count cannot be negative, got {count_text!r}")
    return count



def summarise_site(rows, site):
    """Return (known_total, missing_count) for one site."""
    known_total = 0
    #Only rows for the requested site are added to the total
    for row in rows:
        if row["site"] == site:
            known_total += parse_count(row["count"])
    return (known_total, 0)


if __name__ == "__main__":
    rows = load_observations("data/bootcamp_observations.csv")
    #Print a normal row and one with a blank count, to see how each is read
    print(rows[0])
    print(rows[2])
