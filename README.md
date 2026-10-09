#Bootcamp Assignment 1

Celestina Hall (ceh121@ic.ac.uk), October 2026

UNIX and shell scripting coursework: the FASTA practical, an improved
tabtocsv.sh, and a new csvtospace.sh.

Code is in code/, supplied input files are in data/ (unchanged), and
generated outputs go to results/ (not committed).

Requirements: Linux with bash and standard UNIX tools. Q5 of the FASTA practical uses bc for decimal division (check it is installed with `command -v bc`).

All commands and scripts use relative paths, so run them from code/.

#FASTA practical

code/unixPrac1.txt holds five one line commands, numbered #1 to #5,
each with a short explanation.

To run: `cd code`, then copy each command into the terminal.

To test, compare with the expected output on the supplied files:

1. Line counts: 27, 127 and 78104 (total 78258)
2. Sequence lines only, no > header
3. Sequence length: 4686137
4. ATGC matches: 21968
5. AT/GC ratio: 0.969 (printed to 20 decimal places)

Q5 uses grep bracket expressions ('[AT]', '[GC]') to match either base. See `man grep`, "Character Classes and Bracket Expressions".

#tabtocsv.sh

Converts a tab-delimited file to comma-delimited. The input is left
unchanged and the output is saved as ../results/<input-filename>.csv.
The results/ folder is created if it does not exist, and a rerun
replaces the earlier output.

To run:

    bash tabtocsv.sh ../data/tab-example.tsv

This creates results/tab-example.tsv.csv.

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

#csvtospace.sh

Converts a comma-separated file to space-separated. The input is left
unchanged and the output is saved as ../results/<input-filename>.txt.
The results/ folder is created if it does not exist, and a rerun
replaces the earlier output.

To run:

    bash csvtospace.sh ../data/temperatures/1800.csv

This creates results/1800.csv.txt. The same works for 1801.csv,
1802.csv and 1803.csv.

To test:

- No argument, or more than one: prints a usage message, status 2
- A file that does not exist: prints an error, status 1
- A valid file: prints "Done!", status 0
- Two commas in a row (an empty field) come out as two spaces
- A path containing spaces works
- Running twice gives the same output, with no duplicated rows

Limitations: this is a simple comma substitution, not a CSV parser.

- A comma inside a quoted field is treated as a separator
- A field containing a space cannot be told apart from two fields
- The supplied temperature files contain no quoted commas
