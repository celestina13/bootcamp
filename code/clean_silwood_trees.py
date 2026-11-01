#!/usr/bin/env python3
"""Validate and clean the synthetic Silwood tree survey."""

from __future__ import annotations

import csv
import math
from pathlib import Path
from typing import Iterable


PROJECT_ROOT = Path(__file__).resolve().parents[1]
INPUT_PATH = PROJECT_ROOT / "data" / "silwood_trees_raw.csv"
RESULTS_DIR = PROJECT_ROOT / "results"

INPUT_FIELDS = [
    "record_id",
    "location",
    "genus",
    "species",
    "distance_m",
    "angle_degrees",
]
ISSUE_FIELDS = ["source_row", "record_id", "reasons"]
OAK_COUNT_FIELDS = ["species", "count"]


def load_records(path: Path = INPUT_PATH) -> list[dict[str, str]]:
    """Read the survey and check its column names."""
    with path.open(newline="", encoding="utf-8") as source:
        reader = csv.DictReader(source)
        #Raise an error if the column names don't match the expected ones, so an
        #unexpected or altered file is reported instead of being cleaned incorrectly
        if reader.fieldnames != INPUT_FIELDS:
            raise ValueError(
                f"Expected columns {INPUT_FIELDS}, found {reader.fieldnames}"
            )
        return list(reader)


def validate_record(
    row: dict[str, str],
    source_row: int,
    accepted_ids: set[str],
) -> tuple[dict[str, str] | None, list[str]]:
    """Clean one record, or return the reasons it cannot be used."""
    #Permitted values from the metadata. Each dictionary maps the lowercase
    #spelling to the canonical spelling, so matching ignores letter case.
    location_names = {"silwood bottom": "Silwood Bottom",
                      "nash's field": "Nash's Field",
                      "manor house": "Manor House",
                      "reactor wood": "Reactor Wood"}
    genus_names = {"quercus": "Quercus", "acer": "Acer", "betula": "Betula",
                   "fagus": "Fagus", "fraxinus": "Fraxinus"}
    species_names = {"robur": "robur", "petraea": "petraea",
                     "pseudoplatanus": "pseudoplatanus", "pendula": "pendula",
                     "sylvatica": "sylvatica", "excelsior": "excelsior"}
    taxon_pairs = [("Quercus", "robur"), ("Quercus", "petraea"),
                   ("Acer", "pseudoplatanus"), ("Betula", "pendula"),
                   ("Fagus", "sylvatica"), ("Fraxinus", "excelsior")]

    #The checks run in the metadata's order, so the reasons are collected
    #in that order. source_row is not needed here; process_records uses it.
    reasons = []
    cleaned = {}

    #record_id: "ST" followed by exactly three digits, not already accepted.
    record_id = row["record_id"].strip()
    if record_id == "":
        reasons.append("missing record_id")
    else:
        digit_count = 0
        #Checked against 0-9 directly, because str.isdigit() also accepts
        #characters like "²" that aren't valid in an ID
        for character in record_id[2:]:
            if character in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
                digit_count += 1
        id_is_valid = (len(record_id) == 5
                       and record_id.startswith("ST")
                       and digit_count == 3)
        if not id_is_valid:
            reasons.append("invalid record_id")
        elif record_id in accepted_ids:
            reasons.append("duplicate record_id")
        else:
            cleaned["record_id"] = record_id

    #Text fields: missing, recognised (stored in canonical form) or invalid.
    for field in ["location", "genus", "species"]:
        if field == "location":
            names = location_names
        elif field == "genus":
            names = genus_names
        else:
            names = species_names
        value = row[field].strip()
        if value == "":
            reasons.append(f"missing {field}")
        elif value.lower() in names:
            cleaned[field] = names[value.lower()]
        else:
            reasons.append(f"invalid {field}")

    #Only judge the pair when both names are individually recognised.
    if "genus" in cleaned and "species" in cleaned:
        pair = (cleaned["genus"], cleaned["species"])
        pair_is_permitted = pair in taxon_pairs
        if not pair_is_permitted:
            reasons.append("invalid genus/species combination")

    #Numeric fields: missing, not a usable number, out of range, or valid.
    #The range is only checked once the value is a usable number.
    for field in ["distance_m", "angle_degrees"]:
        value = row[field].strip()
        if value == "":
            reasons.append(f"missing {field}")
        else:
            try:
                number = float(value)
            except ValueError:
                reasons.append(f"invalid {field}")
            else:
                if field == "distance_m":
                    in_range = number > 0 and number <= 100
                else:
                    in_range = number > 0 and number < 90
                #float() accepts "nan" and "inf", but they are not usable.
                if not math.isfinite(number):
                    reasons.append(f"invalid {field}")
                elif in_range:
                    #Stored from the float so every number has the same format,
                    #e.g. "35" and "35.00" both become "35.0"
                    cleaned[field] = str(number)
                else:
                    reasons.append(f"{field} out of range")

    if len(reasons) > 0:
        return None, reasons
    #The fields were added in the input column order.
    return cleaned, []


def process_records(
    rows: Iterable[dict[str, str]],
) -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    """Sort records into accepted rows and issue reports."""
    accepted_ids = set()
    records_by_id = {}
    issues = []

    #source_row is the line number in the input CSV, the header is line 1
    source_row = 1
    for row in rows:
        source_row += 1
        clean_record, reasons = validate_record(row, source_row, accepted_ids)
        if clean_record is None:
            #Join the reasons with "; ", keeping the metadata's order.
            reasons_text = reasons[0]
            for reason in reasons[1:]:
                reasons_text = reasons_text + "; " + reason
            issues.append({
                "source_row": str(source_row),
                "record_id": row["record_id"].strip(),
                "reasons": reasons_text,
            })
        else:
            #Only accepted records have their ID added here. A rejected row's ID
            #is not added, so a later valid row with that ID isn't marked as a duplicate
            accepted_ids.add(clean_record["record_id"])
            records_by_id[clean_record["record_id"]] = clean_record

    #Accepted records are written sorted by record_id (issues stay in
    #source-row order because they were added in that order).
    clean_records = []
    for record_id in sorted(accepted_ids):
        clean_records.append(records_by_id[record_id])

    return clean_records, issues


def summarise_oaks(clean_records: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    """Count accepted oak records by species."""
    oak_counts = {}
    oak_species = set()

    #A record is an oak when its canonical genus is exactly "Quercus"
    for record in clean_records:
        if record["genus"] == "Quercus":
            species = record["species"]
            oak_species.add(species)
            if species in oak_counts:
                oak_counts[species] += 1
            else:
                oak_counts[species] = 1

    #One row per oak species, sorted by species. No oaks gives an empty list
    summary = []
    for species in sorted(oak_species):
        summary.append({"species": species, "count": str(oak_counts[species])})

    return summary


def write_csv(
    path: Path,
    fieldnames: list[str],
    rows: Iterable[dict[str, str]],
) -> None:
    """Write rows to a CSV file, replacing an older copy."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as destination:
        writer = csv.DictWriter(destination, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    """Clean the survey and write the three result files."""
    clean_records, issues = process_records(load_records())
    oak_counts = summarise_oaks(clean_records)

    write_csv(
        RESULTS_DIR / "silwood_trees_clean.csv",
        INPUT_FIELDS,
        clean_records,
    )
    write_csv(
        RESULTS_DIR / "silwood_tree_issues.csv",
        ISSUE_FIELDS,
        issues,
    )
    write_csv(
        RESULTS_DIR / "oak_species_counts.csv",
        OAK_COUNT_FIELDS,
        oak_counts,
    )


if __name__ == "__main__":
    main()
