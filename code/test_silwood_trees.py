#!/usr/bin/env python3

"""Checks for the functions in clean_silwood_trees.py."""

import clean_silwood_trees
from clean_silwood_trees import (
    INPUT_PATH,
    RESULTS_DIR,
    main,
    process_records,
    summarise_oaks,
    validate_record,
)


def make_row():
    """Return a new valid survey row that a test can change."""
    return {
        "record_id": "ST001",
        "location": "Silwood Bottom",
        "genus": "Quercus",
        "species": "robur",
        "distance_m": "12.5",
        "angle_degrees": "35",
    }


def read_lines(path):
    """Return the lines of a text file as a list."""
    lines = []
    with open(path, "r") as f:
        for line in f:
            lines.append(line)
    return lines


#Checking that importing the cleaner doesn't run it
assert clean_silwood_trees.__name__ == "clean_silwood_trees"

#A normal valid row should be accepted with no reasons
record, reasons = validate_record(make_row(), 2, set())
assert reasons == [], f"valid row rejected: {reasons}"
assert record["record_id"] == "ST001"

#Extra spaces and odd capitals should be cleaned up to the canonical spelling
row = make_row()
row["record_id"] = " ST001 "
row["location"] = " silwood bottom "
row["genus"] = " quercus "
row["species"] = " ROBUR "
record, reasons = validate_record(row, 2, set())
assert reasons == [], f"cleaning: got {reasons}"
assert record["record_id"] == "ST001"
assert record["location"] == "Silwood Bottom"
assert record["genus"] == "Quercus"
assert record["species"] == "robur"

#Each empty field should give its "missing" reason
for field in ["record_id", "location", "genus", "species",
              "distance_m", "angle_degrees"]:
    row = make_row()
    row[field] = "   "
    record, reasons = validate_record(row, 2, set())
    assert record is None
    assert reasons == [f"missing {field}"], f"missing {field}: got {reasons}"

#Values not in the metadata should be rejected
row = make_row()
row["location"] = "Old Orchard"
assert validate_record(row, 2, set())[1] == ["invalid location"]
row = make_row()
row["genus"] = "Quercuss"
assert validate_record(row, 2, set())[1] == ["invalid genus"]
row = make_row()
row["species"] = "roburr"
assert validate_record(row, 2, set())[1] == ["invalid species"]

#IDs that aren't "ST" plus three digits
for bad_id in ["st001", "ST01", "ST0001", "TREE27", "ST-12", "ST 12"]:
    row = make_row()
    row["record_id"] = bad_id
    reasons = validate_record(row, 2, set())[1]
    assert reasons == ["invalid record_id"], f"{bad_id}: got {reasons}"

#Real genus and real species, but not a pair that's allowed
row = make_row()
row["species"] = "excelsior"
reasons = validate_record(row, 2, set())[1]
assert reasons == ["invalid genus/species combination"], f"got {reasons}"

#No pair reason if one of the names is already invalid
row = make_row()
row["genus"] = "Quercuss"
row["species"] = "excelsior"
assert validate_record(row, 2, set())[1] == ["invalid genus"]

#Text, nan and inf aren't usable numbers, and shouldn't get a range reason
for bad_value in ["forty", "nan", "inf", "-inf"]:
    row = make_row()
    row["distance_m"] = bad_value
    reasons = validate_record(row, 2, set())[1]
    assert reasons == ["invalid distance_m"], f"{bad_value}: got {reasons}"
    row = make_row()
    row["angle_degrees"] = bad_value
    reasons = validate_record(row, 2, set())[1]
    assert reasons == ["invalid angle_degrees"], f"{bad_value}: got {reasons}"

#Distance has to be above 0 and at most 100, so I test either side of both
distance_cases = [("0", ["distance_m out of range"]),
                  ("0.1", []),
                  ("100", []),
                  ("100.1", ["distance_m out of range"]),
                  ("-2", ["distance_m out of range"])]
for case in distance_cases:
    distance = case[0]
    expected = case[1]
    row = make_row()
    row["distance_m"] = distance
    reasons = validate_record(row, 2, set())[1]
    assert reasons == expected, f"distance {distance}: got {reasons}"

#Angle has to be above 0 and below 90, so 90 itself should fail
angle_cases = [("0", ["angle_degrees out of range"]),
               ("0.1", []),
               ("89.9", []),
               ("90", ["angle_degrees out of range"]),
               ("91", ["angle_degrees out of range"])]
for case in angle_cases:
    angle = case[0]
    expected = case[1]
    row = make_row()
    row["angle_degrees"] = angle
    reasons = validate_record(row, 2, set())[1]
    assert reasons == expected, f"angle {angle}: got {reasons}"

#An ID that's already been accepted should be rejected as a duplicate
row = make_row()
assert validate_record(row, 3, set(["ST001"]))[1] == ["duplicate record_id"]

#A row with lots of problems should list all of them, in the metadata's order
row = {
    "record_id": "ST036",
    "location": "Unknown Site",
    "genus": "",
    "species": "",
    "distance_m": "not-a-number",
    "angle_degrees": "",
}
reasons = validate_record(row, 2, set())[1]
assert reasons == ["invalid location", "missing genus", "missing species",
                   "invalid distance_m", "missing angle_degrees"], (
    f"several problems: got {reasons}")

#Checking process_records: line numbers, duplicates, sorting and the reasons
first = make_row()
first["record_id"] = "ST002"
duplicate = make_row()
duplicate["record_id"] = "ST002"
second = make_row()
second["record_id"] = "ST001"
bad = make_row()
bad["record_id"] = ""
bad["location"] = "Old Orchard"
clean, issues = process_records([first, duplicate, second, bad])
assert len(clean) == 2
assert clean[0]["record_id"] == "ST001", "clean records not sorted"
assert clean[1]["record_id"] == "ST002"
assert issues == [
    {"source_row": "3", "record_id": "ST002",
     "reasons": "duplicate record_id"},
    {"source_row": "5", "record_id": "",
     "reasons": "missing record_id; invalid location"},
], f"issues: got {issues}"

#A bad row shouldn't block a later good row with the same ID
invalid_first = make_row()
invalid_first["distance_m"] = "forty"
valid_later = make_row()
clean, issues = process_records([invalid_first, valid_later])
assert len(clean) == 1, "invalid row reserved its identifier"
assert issues[0]["source_row"] == "2"

#An empty survey should give nothing back, without crashing
assert process_records([]) == ([], [])

#Only exact Quercus records should be counted, split by species
robur = make_row()
petraea = make_row()
petraea["species"] = "petraea"
ash = make_row()
ash["genus"] = "Fraxinus"
ash["species"] = "excelsior"
summary = summarise_oaks([robur, petraea, robur, ash])
assert summary == [{"species": "petraea", "count": "1"},
                   {"species": "robur", "count": "2"}], f"got {summary}"

#A near match like Quercuss isn't an oak
near_match = make_row()
near_match["genus"] = "Quercuss"
assert summarise_oaks([near_match]) == []

#It also gets rejected before it reaches the summary
clean, issues = process_records([near_match])
assert summarise_oaks(clean) == []

#No oaks should give an empty summary
assert summarise_oaks([ash]) == []
assert summarise_oaks([]) == []

#Data flow check: one valid and one invalid oak record go through
#process_records(), then the cleaned list goes to summarise_oaks().
#The invalid record would add a petraea row if it reached the summary.
valid_oak = make_row()
valid_oak["record_id"] = "ST010"
invalid_oak = make_row()
invalid_oak["record_id"] = "ST011"
invalid_oak["species"] = "petraea"
invalid_oak["angle_degrees"] = "95"
clean, issues = process_records([valid_oak, invalid_oak])
assert len(clean) == 1, f"expected one clean record, got {clean}"
assert clean[0]["record_id"] == "ST010", f"got {clean}"
assert issues == [{"source_row": "3", "record_id": "ST011",
                   "reasons": "angle_degrees out of range"}], f"got {issues}"
assert summarise_oaks(clean) == [{"species": "robur", "count": "1"}], (
    "invalid record reached the oak summary")

#Running the program twice should give the same files, and the raw survey
#shouldn't change
raw_before = read_lines(INPUT_PATH)
output_names = ["silwood_trees_clean.csv",
                "silwood_tree_issues.csv",
                "oak_species_counts.csv"]
main()
first_run = []
for name in output_names:
    first_run.append(read_lines(RESULTS_DIR / name))
main()
second_run = []
for name in output_names:
    second_run.append(read_lines(RESULTS_DIR / name))
assert first_run == second_run, "second run gave different outputs"
assert read_lines(INPUT_PATH) == raw_before, "raw survey was changed"

#Checking the outputs match what I worked out by hand
assert len(first_run[0]) == 25, "expected a header and 24 clean records"
assert len(first_run[1]) == 13, "expected a header and 12 issues"
assert first_run[2] == ["species,count\n", "petraea,4\n", "robur,4\n"]

print("All tests passed")
