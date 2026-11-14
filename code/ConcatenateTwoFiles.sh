#!/bin/bash
# Author: Celestina Hall ceh121@ic.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: Writes the first file to an output file, then adds the second file
# Arguments: 3 (first input file, second input file, output file)
# Date: Nov 2026

#Stop unless both input files exist and the output file is named
if [[ ! -r "$1" || ! -r "$2" || -z "$3" ]]; then
    printf 'Usage: %s <first file> <second file> <output file>\n' "$0" >&2
    printf 'Both input files must exist and be readable\n' >&2
    exit 1
fi

#Stop if either input is a folder, as cat would fail but the script would still finish
if [[ ! -f "$1" || ! -f "$2" ]]; then
    printf 'Error: both inputs must be files, not folders\n' >&2
    exit 1
fi

#Overwrite the output with the first file, then append the second
cat "$1" > "$3"
cat "$2" >> "$3"
echo "Merged File is"
cat "$3"
