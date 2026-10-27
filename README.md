# MQB Computing Bootcamp portfolio

Author: Celestina Hall (ceh121@ic.ac.uk)

This repository contains my coursework for the Computing Bootcamp that I have undertaken as part of the Imperial Ecology,
Evolution and Conservation MRes. It includes the assigned UNIX, shell, Python and R practicals from Assignments 1 to 3,
revised after feedback, and the class practice scripts. Supplied input files are in `data/`, and each entry below
says what that script reads and what it may create.

## Requirements

- bash and standard UNIX tools, plus `bc` for question 5 of the FASTA practical (check with `command -v bc`)
- Python 3
- R with ggplot2

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
- Normal test: The script correctly processed `data/tab-example.tsv` and produced the expected output with the columns `species,count,site`. The original input file remained unchanged.
- Boundary test: An empty field (two tabs in a row) became `pine,,B`, so the empty field was kept. A filename containing a space (`sandbox/my file.tsv`) produced `results/my file.tsv.csv`.
- Invalid input tests: Running the script without an argument or with two arguments displayed the usage message and exited with code 2. Missing files and directories produced an error and exited with code 1 without creating any output. If the `results/` directory could not be created, the script produced an error and exited with code 1.
- Rerun test: Running the script again produced identical output.

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
- Normal test: The script processed `data/temperatures/1800.csv` correctly, with 1,825 lines in both the input and output and no commas remaining. The original file was unchanged.
- Boundary test: An empty field became two spaces (`pine  B`), so no field was dropped from the line. A filename containing a space (`sandbox/my file.csv`) was handled correctly.
- Invalid input tests: Missing or extra arguments displayed the usage message and exited with code 2. Missing files, folders or an uncreatable `results/` directory produced an error and exited without creating output.
- Rerun test: Running the script again produced identical output.

### Changes after Assignment 1 feedback

**unixPrac1.txt.** Changed the paths from `../data/fasta/` to `data/fasta/` so
the commands run from the project root, as the feedback asked, and restored this
Assignment 1 section. All five answers were unchanged when rerun from the root.

**tabtocsv.sh and csvtospace.sh.** Both scripts assumed they were run from
`code/` and wrote to `../results`. They now write to `results/` from the project
root. After the feedback I also added a check that stops each script with an
error if `results/` cannot be created. I tested an empty field, a filename with a
space, a rerun and invalid inputs, checking the output contents and location as
well as the exit status (results above).

## Assignment 2: Silwood tree survey (Python)

### clean_silwood_trees.py

Reads `data/silwood_trees_raw.csv` and writes
`results/silwood_trees_clean.csv`, `results/silwood_tree_issues.csv` and
`results/oak_species_counts.csv`.

```bash
python3 code/clean_silwood_trees.py
```

### test_silwood_trees.py

Reads `data/silwood_trees_raw.csv` and writes the
three cleaner outputs to `results/`.

```bash
python3 code/test_silwood_trees.py
```

### Changes after Assignment 2 feedback

TO DO

## Assignment 3: Tree heights and Pound Hill (R)

### TreeHeight.R

Reads `data/trees.csv` and writes `results/TreeHts.csv`.

```bash
Rscript code/TreeHeight.R
```

Checked:
- Normal:
- Invalid:

### get_TreeHeight.R

Reads the CSV you give it and writes
`results/<input name>_treeheights.csv`.

```bash
Rscript code/get_TreeHeight.R data/trees.csv
```

Checked:
- Normal:
- Invalid:

### run_get_TreeHeight.sh

Runs `get_TreeHeight.R` on `data/trees.csv`, creating
`results/trees_treeheights.csv`.

```bash
bash code/run_get_TreeHeight.sh
```

### pound_hill_analysis.R

Reads `data/pound_hill_data.csv` and
`data/pound_hill_meta_data.csv` and writes
`results/pound_hill_plot_richness.csv`, `results/pound_hill_plot_richness.pdf`,
`results/pound_hill_plot_abundance.csv` and `results/pound_hill_plot_abundance.pdf`.

```bash
Rscript code/pound_hill_analysis.R
```

### Changes after Assignment 3 feedback

TO DO

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

