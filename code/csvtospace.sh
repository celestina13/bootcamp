#!/bin/bash
# Author: Celestina Hall ceh121@ic.ac.uk
# Script: csvtospace.sh
# Desc: substitute the commas in a file with spaces and save the output as results/<input-filename>.txt
# Arguments: 1 (comma delimited file)
# Date: Oct 2026
# Note: simple comma substitution only, see README.md for limitations

#Stop unless exactly one argument was given
if [[ $# -ne 1 ]]; then
    printf 'Usage: %s <comma-delimited file>\n' "$0" >&2
    exit 2
fi

#Stop unless the argument is a file that can be read
if [[ -f "$1" && -r "$1" ]]; then
    echo "Creating a space delimited version of $1 ..."
else
    printf 'Error: %s is not a readable file\n' "$1" >&2
    exit 1
fi

#Run from the project root, output goes in results/, named after the input file
#Folder created if it does not exist; any existing file is overwritten
output_file="results/$(basename "$1").txt"
mkdir -p results

#Convert commas to spaces and save to output file
tr "," " " < "$1" > "$output_file"

#Check if the conversion was successful, if failed report error
if [[ $? -ne 0 ]]; then
    printf 'Error: could not convert %s\n' "$1" >&2
    exit 1
fi

#Prints a message indicating where the output was saved
echo "Done! Saved to $output_file"
