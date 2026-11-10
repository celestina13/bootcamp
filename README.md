# MQB Computing Bootcamp portfolio

Author: Celestina Hall (ceh121@ic.ac.uk)

This repository contains my coursework for the Computing Bootcamp that I have undertaken as part of the Imperial Ecology,
Evolution and Conservation MRes. It includes the assigned UNIX, shell, Python and R practicals from Assignments 1 to 3,
revised after feedback, and the class practice scripts. Supplied input files are in `data/`, and each entry below
says what that script reads and what it may create.

## Requirements

- bash and standard UNIX tools, plus `bc` for question 5 of the FASTA practical (check with `command -v bc`)
- Python 3
- R with ggplot2 (for `pound_hill_analysis.R`)

## Layout

```text
README.md
.gitignore
code/      all scripts
data/      supplied input files (unchanged)
results/   created by the scripts, not tracked
sandbox/   scratch files, not tracked (create with `mkdir -p sandbox` if necessary)
```

Run every command in this README from the project root, the folder that
contains `code/`, `data/` and this file.

## Assignment 1: UNIX and shell scripting

### unixPrac1.txt

Five commands answering the FASTA practical questions, with explanations.
Reads `data/fasta/` and prints to the terminal. Copy each command into the
terminal from the project root.

Checked from the project root: Q1 27, 127 and 78104 lines; Q2 no `>` header
line; Q3 4686137; Q4 21968; Q5 0.969.

### tabtocsv.sh

Converts a tab delimited file to comma delimited. Reads the file provided and
writes `results/<input filename>.csv` (e.g. `results/tab-example.tsv.csv`),
creating `results/` if not present.

Limitation: if a field already contains a comma, it will be split in two.

To run:

```bash
bash code/tabtocsv.sh data/tab-example.tsv
```

Checked from the project root:
- Normal test: the script correctly processed `data/tab-example.tsv` and produced the expected output with the columns `species,count,site`. The original input file remained unchanged.
- Boundary test: an empty field (two tabs in a row) became `pine,,B`, so the empty field was kept. A filename containing a space (`sandbox/my file.tsv`) produced `results/my file.tsv.csv`.
- Invalid input tests: running the script without an argument or with two arguments displayed the usage message and exited with code 2. Missing files and directories produced an error and exited with code 1 without creating any output. If the `results/` directory could not be created, the script produced an error and exited with code 1.
- Rerun test: running the script again produced identical output.

### csvtospace.sh

Converts a comma delimited file to space delimited. Reads the file provided and
writes `results/<input filename>.txt` (e.g. `results/1800.csv.txt`), creating
`results/` if not present.

Limitation: a field containing a space or a comma inside quotes would not be kept as one field.

To run:

```bash
bash code/csvtospace.sh data/temperatures/1800.csv
```

Checked from the project root:
- Normal test: the script processed `data/temperatures/1800.csv` correctly, with 1,825 lines in both the input and output and no commas remaining. The original file was unchanged.
- Boundary test: an empty field became two spaces (`pine  B`), so no field was dropped from the line. A filename containing a space (`sandbox/my file.csv`) was handled correctly.
- Invalid input tests: missing or extra arguments displayed the usage message and exited with code 2. Missing files, folders or an uncreatable `results/` directory produced an error and exited without creating output.
- Rerun test: running the script again produced identical output.

### Changes after Assignment 1 feedback

**unixPrac1.txt**
- Changed the paths from `../data/fasta/` to `data/fasta/` so the commands run from the project root, and restored this Assignment 1 section. All five answers were unchanged when rerun.

**tabtocsv.sh and csvtospace.sh**
- Changed the output from `../results` to `results/`, so both scripts run from the project root.
- Added a check that stops each script with an error if `results/` cannot be created.
- Tested an empty field, a filename with a space, a rerun and invalid inputs, checking the output contents and location as well as the exit status (results above).

## Assignment 2: Silwood tree survey (Python)

### clean_silwood_trees.py

Checks each record in the Silwood tree survey against the rules in
`data/silwood_trees_metadata.md`. Keeps the valid records, reports the rejected
ones with their reasons, and counts the accepted oak records by species. Reads
`data/silwood_trees_raw.csv` and writes three files to `results/`:

- `silwood_trees_clean.csv`: accepted records, sorted by `record_id`
- `silwood_tree_issues.csv`: each rejected row's line number, `record_id` and reasons
- `oak_species_counts.csv`: the number of accepted *Quercus* records for each species

To run:

```bash
python3 code/clean_silwood_trees.py
```

Data flow (`main()` runs these steps in order):

1. `load_records()` reads `data/silwood_trees_raw.csv` and checks the column names.
2. `process_records()` checks each row with `validate_record()` and splits the rows into clean records and issues.
3. `summarise_oaks()` counts the oaks in the clean records only, so rejected rows are never counted.
4. `write_csv()` writes the clean records, issues and oak counts to the three output files.

Limitations: both of these follow the metadata rules. Misspelt names (e.g.
`Quercuss`) are rejected rather than corrected, so some usable records are lost.
When two rows share a `record_id`, the first valid row is kept and the later one
is rejected, even if the later one is the correct record.

Checked from the project root:
- Normal test: 24 clean records, 12 issues, and oak counts of petraea 4 and robur 4, matching what I worked out by hand from the raw data and the metadata.
- Rerun test: running it twice gave identical files, and the raw survey was unchanged.
- Boundary and invalid input tests: covered by `test_silwood_trees.py` below.

### test_silwood_trees.py

Tests the functions in `clean_silwood_trees.py`, then runs the whole program and
checks its output files. Reads `data/silwood_trees_raw.csv` and writes the three
cleaner outputs to `results/`. Prints "All tests passed" if every check passes;
otherwise it stops with an `AssertionError` at the first failed check.

To run:

```bash
python3 code/test_silwood_trees.py
```

What the tests cover:
- Normal test: a valid record is accepted with every field cleaned correctly, including spaces and capital letters tidied to the metadata spelling.
- Boundary tests: distances of 0.1 and 100 are accepted but 0 and 100.1 are rejected; angles of 0.1 and 89.9 are accepted but 0 and 90 are rejected.
- Invalid input tests: each missing field, names not in the metadata, IDs in the wrong format, disallowed genus/species pairs, text, `nan` and `inf` as numbers, duplicate IDs and a row with several problems listing every reason in order.
- Data flow test: one valid and one invalid oak record go through `process_records()`. The invalid one goes to issues and is not counted by `summarise_oaks()`.
- Output tests: running the program twice gives identical files, the raw survey is unchanged and the written files have the right headers, line counts and contents.

Checked from the project root: prints "All tests passed".

A future improvement would be to run these checks with pytest so all failures are reported at once.

### Changes after Assignment 2 feedback

**test_silwood_trees.py**
- Added a test passing one valid and one invalid oak record through `process_records()` and `summarise_oaks()`. Earlier tests checked each function separately, so nothing showed that a rejected record can't reach the summary. Both records are oaks, so a leak would add a petraea row.
- Added checks on the contents of the clean and issues files. Previously only line counts were checked, so a wrong value would have passed.
- Added a check of every field of a cleaned record, so a wrong value is traced to `validate_record()` rather than found later in the output files.
- Added author and usage information.

**clean_silwood_trees.py**
- Added comments explaining the reasons for less obvious validation and cleaning steps.
- Removed repeated code in `summarise_oaks()` and `process_records()`.
- Added author and usage information.

**README**
- Added the data-flow explanation above, showing how the raw file becomes the three outputs.

After each change I reran the tests and confirmed the three output files were unchanged.

## Assignment 3: Tree heights and Pound Hill (R)

### TreeHeight.R

Calculates the height of every tree in `data/trees.csv` from its distance and
angle, using height = distance × tan(angle in radians). Validates the data first
and stops with a clear error if a check fails. Writes `results/TreeHts.csv` (the
three original columns plus `height_m`).

To run:

```bash
Rscript code/TreeHeight.R
```

It can also be run with `source("code/TreeHeight.R")` from an R session started at the project root.

Checked from the project root:
- Normal test: 120 trees written. Row 1 (*Populus tremula*, 31.666 m, 41.283°) gives 27.8021 m, matching 31.666 × tan(41.283°) worked out separately.
- Invalid input tests: an angle of 90, a distance of 0, an empty file and missing columns each stop with a matching error message and no output file is created.
- Rerun test: running it again produced identical output.

### get_TreeHeight.R

A generalised version of `TreeHeight.R` that takes any CSV with the same columns
as its one command-line argument. Writes `results/<input name>_treeheights.csv`.

To run:

```bash
Rscript code/get_TreeHeight.R data/trees.csv
```

It has to be run with `Rscript`, because `source()` can't pass the file name.

Limitations: two input files with the same name in different folders write to the same output file.

Checked from the project root:
- Normal test: `data/trees.csv` gives heights identical to `results/TreeHts.csv` for every tree.
- Boundary test: a distance of 100 and an angle of 89.9 are accepted.
- Invalid input tests: no file gives "No input file given", two files give "Expected exactly one input file, received 2", a missing file gives "Input file not found", text as a distance gives "Distance and angle must be numeric", and the angle, distance, empty-file and missing-column cases give the same messages as `TreeHeight.R`. No output file is created in any of these cases.
- Rerun test: running it again produced identical output.
- Debugging check: with `browser()` added temporarily, I started R with `R --vanilla --args data/trees.csv`, ran `source("code/get_TreeHeight.R")` and stepped through row 5 (*Betula pendula*): 45.466 × tan(38.349°) = 35.970 m, matching the output. `browser()` was then removed.

`TreeHeight.R` and `get_TreeHeight.R` each keep their own copy of `TreeHeight()`
and `check_tree_data()`, so each script runs on its own, as the practical sets
them up as separate scripts.

### run_get_TreeHeight.sh

Runs `get_TreeHeight.R` on `data/trees.csv`, creating `results/trees_treeheights.csv`,
and stops if the R script fails.

To run:

```bash
bash code/run_get_TreeHeight.sh
```

Checked from the project root: prints "Done: results/trees_treeheights.csv created", and the output matches running `get_TreeHeight.R` directly.

### pound_hill_analysis.R

Compares mean species richness and abundance per quadrat across the March, May
and October cultivation treatments at Pound Hill. Following the metadata, blank
counts are treated as zeros, and quadrats are averaged within each plot first,
because plots are the treatment replicates.

Reads `data/pound_hill_data.csv` and `data/pound_hill_meta_data.csv`, and writes
`results/pound_hill_plot_richness.csv` and `.pdf` (mean richness for each plot)
and `results/pound_hill_plot_abundance.csv` and `.pdf` (mean richness and
abundance for each plot).

To run:

```bash
Rscript code/pound_hill_analysis.R
```

The grey bar on each figure is the median of the four plot means per treatment,
because the median is more robust than the mean to a single extreme plot (e.g.
October block c).

Checked from the project root:
- Treatment names: the exported tables use `march`, `may` and `october`, remaining the same as the input.
- Traced example: plot 3 (March, block a) has quadrat richness values of 7, 5, 8, 7, 6 and 5, giving a mean of 6.333, matching the exported value.
- Median bar: the treatment medians of the plot means are March 7.45, May 9.80 and October 6.90 (the means would be 7.81, 9.65 and 7.61), and the March bar on the figure sits at 7.45.
- Figures: reopened both PDFs. The month labels, caption and values are correct.
- Rerun test: running it again produced identical tables.

### Changes after Assignment 3 feedback

Across all three R scripts, I corrected comments that were wrong or repeated the code, fixed indentation and typos, and added author information to each header.

**TreeHeight.R**
- Corrected the angle-check comment, which described distances, as the feedback asked.
- Missing column names are now listed separately in the error message, instead of running together when more than one is missing.

**get_TreeHeight.R**
- Fixed the indentation of the validation blocks so they are easier to follow, as the feedback asked.

**Both tree-height scripts**
- An empty input file now gives "Input file has no tree records", instead of a misleading message about numbers.

**pound_hill_analysis.R**
- The exported tables now keep the lowercase treatment names from the input. The `factor()` labels had been renaming the data values, so capital month names are now applied only to the figure axis labels.
- Added a caption to both figures saying the grey bar is the median of the plot means, as it could be read as a mean.

After each change I reran the scripts and checked the outputs and messages above.

## In-class practice scripts

These print to the terminal unless a file is mentioned.

### Shell

**variables.sh**

**MyExampleScript.sh**: `bash code/MyExampleScript.sh`

**boilerplate.sh**: `bash code/boilerplate.sh`

**CheckLabel.sh**

**CountLines.sh**: `bash code/CountLines.sh data/trees.csv`

**ConcatenateTwoFiles.sh**

**tiff2_png.sh**

### Python

**loops.py**: `python3 code/loops.py`

**cfexercises1.py**: `python3 code/cfexercises1.py`

**cfexercises2.py**: `python3 code/cfexercises2.py`

**MyExampleScript.py**: `python3 code/MyExampleScript.py`

**boilerplate.py**: `python3 code/boilerplate.py`

**using_name.py**

**sysargv.py**

**control_flow.py**: `python3 code/control_flow.py`

**test_control_flow.py**

**observations_practice.py**

**test_observations_practice.py**

**debugme.py**

### R

**basic_io.R**: Reads `data/trees.csv` and writes `results/MyData.csv`.
`Rscript code/basic_io.R`

**boilerplate.R**: `Rscript code/boilerplate.R`

**control_flow.R**: `Rscript code/control_flow.R`

**r_conditionals.R**

**break.R**

**next.R**

**try.R**

**browse.R**: interactive
**observations_practice.R**

**data_wrang.R**

**data_wrang_tidy.R**

## Use of AI

TODO

