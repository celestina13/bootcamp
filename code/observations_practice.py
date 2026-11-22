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
    """Return (known_total, missing_count) for one site.

    known_total is None when the site has no known counts. Exact duplicate
    records are only counted once. Raises ValueError for invalid input.
    """
    #Bad arguments are reported straight away
    if not isinstance(rows, list):
        raise ValueError("rows must be a list of row dictionaries")
    if not isinstance(site, str) or site == "":
        raise ValueError(f"site must be non-empty text, got {site!r}")
    known_total = 0
    missing_count = 0
    has_known_count = False
    seen_records = set()
    for row in rows:
        #Every row is checked, including rows for other sites, so bad data is never skipped
        if not isinstance(row, dict):
            raise ValueError(f"each row must be a dictionary, got {row!r}")
        if set(row) != {"site", "date", "count"}:
            raise ValueError(f"row must have exactly site, date and count, got {row!r}")
        if not all(isinstance(value, str) for value in row.values()):
            raise ValueError(f"row values must all be text, got {row!r}")
        if row["site"] == "" or row["date"] == "":
            raise ValueError(f"site and date cannot be blank, got {row!r}")
        count = parse_count(row["count"])
        #A record repeating the same site, date and count is skipped after its first copy
        record = (row["site"], row["date"], row["count"])
        if record in seen_records:
            continue
        seen_records.add(record)
        #Only rows for the requested site are counted
        if row["site"] == site:
            #Checking for None, not a false value, keeps an observed zero as a known count
            if count is None:
                missing_count += 1
            else:
                known_total += count
                has_known_count = True
    #With no known counts the total is unavailable, not zero
    if not has_known_count:
        return (None, missing_count)
    return (known_total, missing_count)


if __name__ == "__main__":
    rows = load_observations("data/bootcamp_observations.csv")
    #One labelled summary for each site, in alphabetical order
    for site in sorted({row["site"] for row in rows}):
        known_total, missing_count = summarise_site(rows, site)
        print(f"Site {site}: known total {known_total}, missing counts {missing_count}")
