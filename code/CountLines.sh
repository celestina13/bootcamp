#!/bin/bash
# Author: Celestina Hall ceh121@ic.ac.uk
# Script: CountLines.sh
# Desc: Counts the lines in a file
# Arguments: 1 (file to count)
# Date: Nov 2026

#Stop with a usage message unless exactly one file is given
if [[ $# -ne 1 ]]; then
    printf 'Usage: %s <file>\n' "$0" >&2
    exit 2
fi

#Stop with a clear message if the file is missing, unreadable or a folder
if [[ ! -f "$1" || ! -r "$1" ]]; then
    printf 'Error: %s is not a readable file\n' "$1" >&2
    exit 1
fi

#Reading the file as input gives just the number, without the file name
NumLines=`wc -l < "$1"`
echo "The file $1 has $NumLines lines"
echo
