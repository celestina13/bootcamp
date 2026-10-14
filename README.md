# Bootcamp Assignment 2

Author: Celestina Hall (ceh121@ic.ac.uk)

Coursework for the MQB computing bootcamp. Tree survey practical. Python program taht checks tree survey records, keeps the valid ones, reports the rejected ones, and counts oak species.

## Project layout 
```text
README.md
.gitignore
code/
   clean_silwood_trees.py #cleaning program
   test_silwood_trees.py #tests
data/
   silwood_trees_raw.csv #original survey, never edited
   silwood_trees_metadata.md
results/ #created by the program, not tracked by Git
sandbox/
```
## Input

- `data/silwood_trees_raw.csv`, one row per tree record.

## Output

- `results/silwood_trees_clean.csv`: accepted records, sorted by `record_id`.
- `results/silwood_tree_issues.csv`: each rejected row's line number, `record_id`, and the reasons it was rejected.
- `results/oak_species_counts.csv`: the number of accepted *Quercus* records

## Plan

```text
INPUT: survey rows from data/silwood_trees_raw.csv

process_records(rows) -> accepted records, issue rows
    for each row, in file order (line 2 onwards):
        validate_record(row, line number, accepted IDs so far)
        if it returns a cleaned record:
            keep it and remember its record_id
        otherwise:
            record the line number, record_id and reasons joined by "; "
    sort the kept records by record_id

validate_record(row, line number, accepted IDs) -> cleaned record or None, reasons
    clean the text fields and check every field against the metadata rules
    if the record_id was already accepted, add the duplicate reason
    if there are no reasons, return the cleaned record
    otherwise return None and every reason, in the metadata's order

summarise_oaks(accepted records) -> species counts
    count the accepted records whose genus is Quercus, by species
    sort by species (no oaks gives a header with no rows)

OUTPUT: clean records, issue report, oak species counts
```

## Running the program

From the project root:

```bash
python3 code/clean_silwood_trees.py   #creates the three files in results/
python3 code/test_silwood_trees.py    #no output means all tests passed  
```

