# MQB Computing Bootcamp portfolio

Author: Celestina Hall (ceh121@ic.ac.uk)

This repository contains my coursework for the Computing Bootcamp that I have undertaken as part of the Imperial Ecology,
Evolution and Conservation MRes. It includes the assigned UNIX, shell, Python and R practicals from Assignments 1 to 3,
revised after feedback, and the class practice scripts. Supplied input files are in `data/`, and each entry below
says what that script reads and what it may create.

## Requirements

- bash and standard UNIX tools, plus `bc` for question 5 of the FASTA practical (check with `command -v bc`)
- Python 3
- R with ggplot2 (for `pound_hill_analysis.R`), reshape2 (for `data_wrang.R`) and dplyr and tidyr (for `data_wrang_tidy.R`)
- ImageMagick for `tiff2_png.sh` (check with `command -v convert`)

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

The practice scripts follow the code in the MQB chapters, with my own headers and
comments. I also added input checks to `CountLines.sh` and `ConcatenateTwoFiles.sh`.
They print to the terminal unless a file is mentioned.

### Shell

**boilerplate.sh**: the basic layout of a shell script. `bash code/boilerplate.sh` prints "This is a shell script!" and exits with 0.

**MyExampleScript.sh**: uses an environment variable. `bash code/MyExampleScript.sh` prints "Hello" followed by your login name.

**variables.sh**: special variables, assigning a variable and reading user input. `bash code/variables.sh 1 "two words"` reports 2 arguments; entering `hello world` then `3 4` gives "New value: <hello world>" and "Their sum is: 7".

**CheckLabel.sh**: accepts exactly one label, oak or pine. `bash code/CheckLabel.sh oak` prints "Selected species: oak" (exit 0). An unknown label such as `maple` gives "Unknown label: maple" (exit 1), and no label gives a usage message (exit 2).

**CountLines.sh**: counts the lines in a file.

`bash code/CountLines.sh data/trees.csv`

Checked:
- Normal test: prints "The file data/trees.csv has 121 lines" (exit 0).
- Invalid input tests: a missing file or a folder gives "is not a readable file" (exit 1); no file or more than one gives a usage message (exit 2).

**ConcatenateTwoFiles.sh**: writes the first file to an output file, then adds the second.

`mkdir -p results && bash code/ConcatenateTwoFiles.sh data/tab-example.tsv data/tab-example.tsv results/merged.tsv`

Checked:
- Normal test: creates `results/merged.tsv` with 6 lines (3 from each copy).
- Invalid input tests: a missing input, a folder or no output named each stop with an error (exit 1).
- Overwrite test: naming an input as the output stops with an error and the input is left unchanged.

**tiff2_png.sh**: converts every `.tif` in the current folder to `.png` with ImageMagick. To test it, make two images in `sandbox/tiffs/` and run it inside that folder:

`mkdir -p sandbox/tiffs && convert -size 10x10 xc:white sandbox/tiffs/a.tif && convert -size 10x10 xc:black sandbox/tiffs/b.tif`

`cd sandbox/tiffs && bash ../../code/tiff2_png.sh`

It prints "Converting a.tif" and "Converting b.tif" and creates `a.png` and `b.png`. In a folder with no `.tif` files, `convert` reports an error, as noted in the script.

### Python

**loops.py**: `for` and `while` loops. `python3 code/loops.py` prints 0 to 4, each item of a mixed list, a running total ending at 1234, then 1 to 100.

**cfexercises1.py**: functions using conditionals and loops, made importable with a `__name__` guard.

`python3 code/cfexercises1.py`

Checked:
- Normal test: prints one example from each function: `foo_1(9) = 3.0`, `foo_2(3, 5) = 5`, `foo_3(3, 1, 2) = [1, 2, 3]` and 120 for each factorial.
- Boundary test: `foo_5(0)` now returns 1, like `foo_4(0)` and `foo_6(0)`, instead of crashing.
- Import test: importing it prints nothing, so the examples only run when the file is run directly.

**cfexercises2.py**: loops and conditionals combined. `python3 code/cfexercises2.py` prints "hello" 4, 4, 14, 5, 8 and 6 times from `hello_1` to `hello_6`.

**MyExampleScript.py**: saving and running a script. `python3 code/MyExampleScript.py` prints "The square of 2 is 4".

**boilerplate.py**: the basic layout of a Python program. `python3 code/boilerplate.py` prints "This is a boilerplate".

**using_name.py**: the value of `__name__`. `python3 code/using_name.py` prints "This module's name is: \_\_main\_\_". When imported, the module's name is `using_name` instead.

**sysargv.py**: command-line arguments. `python3 code/sysargv.py oak 12` prints the script name, "Number of arguments: 2" and "Arguments: ['oak', '12']". With no arguments it reports 0.

**control_flow.py**: small functions using control flow, with doctests. `python3 code/control_flow.py` prints the even/odd, divisor and prime examples, ending "Primes up to 20: [2, 3, 5, 7, 11, 13, 17, 19]". `python3 -m doctest code/control_flow.py` prints nothing, as all 3 doctests pass.

**test_control_flow.py**: tests for `control_flow.py`. `python3 code/test_control_flow.py` prints nothing if every check passes.

**debugme.py**: a script that fails on purpose, used for debugging practice. `python3 code/debugme.py` stops with `ZeroDivisionError: division by zero` (exit 1), as noted in the script.

**observations_practice.py**: summarises the counts in `data/bootcamp_observations.csv` for each site. Blank counts are missing, zero is a known count, exact duplicate records are counted once and invalid input raises `ValueError`.

`python3 code/observations_practice.py`

Checked:
- Normal test: prints "Site A: known total 2, missing counts 1" and "Site B: known total 0, missing counts 0".
- Boundary, duplicate and invalid input tests: covered by `test_observations_practice.py` below.

**test_observations_practice.py**: tests for `observations_practice.py`, using the three `data/bootcamp_observations` files.

`python3 code/test_observations_practice.py`

Checked (prints nothing when every check passes):
- Normal tests: count text becomes an integer, and known counts for one site are added up.
- Boundary tests: zero is a known count, all-blank counts give no total, and an empty list or absent site gives `(None, 0)`.
- Duplicate tests: a repeated count and a repeated blank are each counted once.
- Invalid input tests: negative or non-numeric counts, missing or extra fields, blank values and bad arguments raise `ValueError`, including an invalid row for a different site.
- File checks: A `(2, 1)`, B `(0, 0)`, C `(None, 2)`, D `(0, 0)` and Z `(None, 0)`, and the input rows are unchanged.

### R

**basic_io.R**: reading and writing files. Reads `data/trees.csv` and writes `results/MyData.csv`, creating `results/` if needed.

`Rscript code/basic_io.R`

Checked:
- Normal test: creates `results/MyData.csv` from a fresh clone, where `results/` does not exist yet.
- R warns "appending column names to file", which is expected.

**boilerplate.R**: the basic layout of an R function. `Rscript code/boilerplate.R` prints the type of each argument, e.g. "Argument 1 is a numeric", and returns both arguments as a vector.

**control_flow.R**: `if` statements and `for` and `while` loops. `Rscript code/control_flow.R` prints "a is TRUE", the squares of 1 to 10, three bird species and the items of a vector. "Less than a half" only appears when the random number is 0.5 or less.

**r_conditionals.R**: functions using conditionals. `Rscript code/r_conditionals.R` prints "6 is even!", "4 is a power of 2!" and "3 is a prime!". The MQB version of `is.prime()` wrongly reports 2 as composite, as noted in the script.

**break.R**: stopping a loop with `break`. `Rscript code/break.R` prints "i equals 0" to "i equals 9", then stops.

**next.R**: skipping loop iterations with `next`. `Rscript code/next.R` prints the odd numbers 1, 3, 5, 7 and 9.

**try.R**: catching errors with `try()`. `Rscript code/try.R` runs the sampling function 15 times, printing a mean for some runs and a caught error for others, and finishes without stopping. Its histogram is saved as `Rplots.pdf`, which is ignored by git.

**browse.R**: pausing a function with `browser()`. It is interactive, so start R at the project root and run `source("code/browse.R")`. It pauses at `Browse[1]>` in each generation of the loop. Typing `N` at the first pause showed `1.000000 2.718282` followed by NAs, and `t` showed 2. `c` continued to the next generation, where `N` had a third value (7.389056), and `Q` quit.

**data_wrang.R**: reshaping the Pound Hill data from wide to long form with reshape2. Reads `data/pound_hill_data.csv` and `data/pound_hill_meta_data.csv`. `Rscript code/data_wrang.R` writes `results/pound_hill_long.csv`, with 2,419 rows and the columns Cultivation, Block, Plot, Quadrat, Species and Count.

**data_wrang_tidy.R**: the same reshaping with dplyr and tidyr instead of reshape2, from the same two input files.

`Rscript code/data_wrang_tidy.R`

Checked:
- Normal test: writes `results/pound_hill_long_tidy.csv` with 2,419 rows and the same columns as `data_wrang.R`.
- Comparison: once both tables are sorted the same way, every value matches `data_wrang.R`'s output. Only the row order differs, as `pivot_longer()` lists the species within each quadrat while `melt()` lists the quadrats within each species.

**observations_practice.R**: checks and summarises the observation files in R, with the same rules as the Python version. Reads `data/bootcamp_observations.csv`, `data/bootcamp_observations_boundary.csv` and `data/bootcamp_observations_invalid.csv`.

`Rscript code/observations_practice.R`

Checked:
- Normal tests: A gives `(2, 1)` and B gives `(0, 0)`, where each pair is (known total, missing count).
- Boundary tests: C, whose counts are all missing, gives `(NA, 2)` rather than 0, and D's repeated zero gives `(0, 0)`.
- Invalid input tests: the invalid file stops with "CSV line 2, column 'count': found '-1'; expected an empty field or a non-negative integer". A count of `many` names CSV line 3 in the same way.
- The four results are checked with `stopifnot()`, so a wrong value stops the script.
- Figure: `results/observations_known_totals.pdf` shows each site's known total, labels site C as "NA: no known counts" and labels the zeros, so a missing total is not shown as 0. Rerunning replaces it.

## Use of AI

TODO

