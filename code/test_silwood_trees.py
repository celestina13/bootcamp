#!/usr/bin/env python3

"""Checks for the functions in clean_silwood_trees.py."""

import clean_silwood_trees
from clean_silwood_trees import validate_record


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

#Values not in the metadata should be rejected, not corrected
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

print("All tests passed")