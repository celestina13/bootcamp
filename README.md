# Bootcamp Assignments

Author: Celestina Hall (ceh121@ic.ac.uk)

# Assignment 1

UNIX and shell scripting coursework: the FASTA practical, an improved
tabtocsv.sh, and a new csvtospace.sh.
Coursework for the MQB computing bootcamp. UNIX and shell scripting chapters.

Code is in code/, supplied input files are in data/ (unchanged), and
generated outputs go to results/ (not committed).

## Structure

Requirements: Linux with bash and standard UNIX tools. Q5 of the FASTA practical uses bc for decimal division (check it is installed with `command -v bc`).

```text
README.md
.gitignore
code/  unixPrac1.txt, tabtocsv.sh, csvtospace.sh
data/fasta/  3 required files present
data/temperatures/  4 required files present
data/tab-example.tsv
results/  no files tracked; generated on run
sandbox/  no files tracked; optional
```

All commands and scripts use relative paths, so run them from code/.

## Requirements

#FASTA practical
Bash on a UNIX-like system. Run everything from the code directory.

code/unixPrac1.txt holds five one line commands, numbered #1 to #5,
each with a short explanation.
Command #5 of the FASTA practical needs `bc`, which may not be
installed on every machine. Check with `command -v bc`. On Ubuntu you can 
install with `sudo apt install bc`.

To run: `cd code`, then copy each command into the terminal.

## FASTA practical

To test, compare with the expected output on the supplied files:
code/unixPrac1.txt holds five one-line commands, numbered #1 to #5,
each with a short explanation. To run, copy each command into the
terminal.

Expected output:

1. Line counts: 27, 127 and 78104 (total 78258)
2. Sequence lines only, no > header
2. Sequence lines only, without the > header line
3. Sequence length: 4686137
4. ATGC matches: 21968
5. AT/GC ratio: 0.969 (printed to 20 decimal places)
5. AT/GC ratio: 0.969 (bc -l prints it to 20 decimal places)

Q5 uses grep bracket expressions ('[AT]', '[GC]') to match either base. See `man grep`, "Character Classes and Bracket Expressions".
Source for `[AT]` and `[GC]` in #5: `man grep`.



## Shell scripts

### tabtocsv.sh

Converts a tab-delimited file to comma-delimited. The input is left
unchanged and the output is saved as ../results/<input-filename>.csv.
The results/ folder is created if it does not exist, and a rerun
replaces the earlier output.
Both scripts leave the input unchanged and save the output in
../results/.

To run:

    bash tabtocsv.sh ../data/tab-example.tsv
Converts a tab-delimited file to comma-delimited, saved as
'../results/<input-filename>.csv'.

This creates results/tab-example.tsv.csv.
    bash tabtocsv.sh <tab-delimited file>

To test:

- No argument, or more than one: prints a usage message, status 2
- A file that does not exist: prints an error, status 1
- A valid file: prints "Done!", status 0
- Two tabs in a row (an empty field) come out as two commas
- A path containing spaces works
- Running twice gives the same output, with no duplicated rows

Check the status after any run with `echo "$?"`.

Limitation: this is a simple tab-to-comma substitution. A field that
itself contains a comma would be wrongly split in the output.
    bash tabtocsv.sh                          # no file = usage message
    bash tabtocsv.sh ../data/missing.tsv      # file not found = error message
    printf 'oak\t\t12\n' > "../sandbox/tab test.txt"   # make a test file
    bash tabtocsv.sh "../sandbox/tab test.txt"  #run the script
    cat "../results/tab test.txt.csv"         # shows oak,,12

### csvtospace.sh
Limitation: a field containing a comma could be wrongly split into two

Converts a comma-separated file to space-separated. The input is left
unchanged and the output is saved as ../results/<input-filename>.txt.
The results/ folder is created if it does not exist, and a rerun
replaces the earlier output.

To run:

    bash csvtospace.sh ../data/temperatures/1800.csv

Converts a comma-delimited file to space-delimited, saved as
'../results/<input-filename>.txt'.

This creates results/1800.csv.txt. The same works for 1801.csv,
1802.csv and 1803.csv.
    for f in ../data/temperatures/*.csv; do bash csvtospace.sh "$f"; done

To test:

- No argument, or more than one: prints a usage message, status 2
- A file that does not exist: prints an error, status 1
- A valid file: prints "Done!", status 0
- Two commas in a row (an empty field) come out as two spaces
- A path containing spaces works
- Running twice gives the same output, with no duplicated rows

Limitations: this is a simple comma substitution, not a CSV parser.
    bash csvtospace.sh                        # no file = usage message
    bash csvtospace.sh ../data/missing.csv    # file not found = error message
    printf 'oak,,12\n' > "../sandbox/csv test.csv"   #make a test file
    bash csvtospace.sh "../sandbox/csv test.csv"     #run the script on test file

cat "../results/csv test.csv.txt"  #shows oak  12 (empty field kept as two spaces)

- A comma inside a quoted field is treated as a separator
- A field containing a space cannot be told apart from two fields
- The supplied temperature files contain no quoted commas
Limitations: a comma inside quotes is turned into a space, and a space
inside a field will split it in two.



# Assignment 2

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
- `results/oak_species_counts.csv`: the number of accepted *Quercus* records for each species

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

## A useful test

- **Test:** an angle of `89.9` is accepted but `90` is rejected.
- **Reason:** the metadata says angles must be less than 90.
- **Fault it would reveal:** writing `<=` instead of `<` in the angle check, which would wrongly accept 90.

## Limitations

- Misspelt names (e.g. `Quercuss`) are rejected rather than corrected, as the metadata requires, so some usable records are lost.
- When two rows share a `record_id`, the first valid one is kept and the later one rejected, even if the later one is the correct record.
- The permitted locations and taxa are written into `validate_record`, so a new site or species means editing the code.
- For an invalid `record_id` (e.g. `TREE27`), the issues file keeps the ID as written. The metadata doesn't say clearly whether an invalid ID counts as "present".



# Assignment 3

## Tree heights practical

Calculates tree heights using `height = distance * tan(angle in radians)`.
Run everything from the project root (`bootcamp/`).

### TreeHeight.R

Reads `data/trees.csv`, checks the data, calculates the height of every tree and saves the results.

```bash
Rscript code/TreeHeight.R
```

- Input: `data/trees.csv`
- Output: `results/TreeHts.csv`
- Checked row 1 (*Populus tremula*): 31.67 * tan(41.28°) = 27.80 m, matching the output

### get_TreeHeight.R

Does the same calculation, but for any CSV file with the same three columns, given on the command line.

```bash
Rscript code/get_TreeHeight.R data/trees.csv
```

- Output: `results/<input name>_treeheights.csv`
- Limitation: two inputs with the same file name write to the same output file
- browser() check on row 5 (*Betula pendula*): 45.47 * tan(38.35°) = 35.97 m, matching the script

### run_get_TreeHeight.sh

Tests `get_TreeHeight.R` by running it on `data/trees.csv`, and stops if the R script fails.

```bash
bash code/run_get_TreeHeight.sh
```


## Pound Hill species richness

Analyses how mean plant species richness per quadrat varies among the
March, May and October cultivation treatments at Pound Hill.

```bash
Rscript code/pound_hill_analysis.R
```

- Inputs: `data/pound_hill_data.csv` and `data/pound_hill_meta_data.csv` (kept unchanged)
- Needs the ggplot2 package
- Outputs: `results/pound_hill_plot_richness.csv` and `.pdf` (mean richness for each plot),
  and `results/pound_hill_plot_abundance.csv` and `.pdf` (mean richness and abundance for each plot)
- Checked: running the script twice from the project root gave the same table (12 plots) and figure both times
- The interpretation is in comments at the end of the script


