#!/bin/bash
# Author: Celestina Hall ceh121@ic.ac.uk
# Script: tabtocsv.sh
# Desc: substitute the tabs in a file with commas and save the output as results/<input-filename>.csv
# Arguments: 1 (tab delimited file)
# Date: Oct 2026

#Stop unless exactly one argument was given
if [[ $# -ne 1 ]]; then
    printf 'Usage: %s <tab-delimited file>\n' "$0" >&2
    exit 2
fi

#Stop unless the argument is a file that can be read
if [[ -f "$1" && -r "$1" ]]; then
    echo "Creating a comma delimited version of $1 ..."
else
    printf 'Error: %s is not a readable file\n' "$1" >&2
    exit 1
fi

#Run from the project root: output goes in results/, named after the input file
#Folder created if it does not exist and any existing file is overwritten
output_file="results/$(basename "$1").csv"

#Stop if the results/ folder cannot be created
if ! mkdir -p results; then
    printf 'Error: could not create results/\n' >&2
    exit 1
fi

#Convert tabs to commas and save to output file
#Removed -s from tr so empty fields are not removed, to prevent data loss/corruption
tr "\t" "," < "$1" > "$output_file"

#Check if the conversion was successful, if failed report error
if [[ $? -ne 0 ]]; then
    printf 'Error: could not convert %s\n' "$1" >&2
    exit 1
fi

#Prints a message indicating where the output was saved
echo "Done! Saved to $output_file"
