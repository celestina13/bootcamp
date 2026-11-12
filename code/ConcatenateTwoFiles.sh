#!/bin/bash
# Author: Celestina Hall ceh121@ic.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: Writes the first file to an output file, then adds the second file
# Arguments: 3 (first input file, second input file, output file)
# Date: Nov 2026

#Overwrite the output with the first file, then append the second
cat "$1" > "$3"
cat "$2" >> "$3"
echo "Merged File is"
cat "$3"
