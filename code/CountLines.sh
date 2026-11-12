#!/bin/bash
# Author: Celestina Hall ceh121@ic.ac.uk
# Script: CountLines.sh
# Desc: Counts the lines in a file
# Arguments: 1 (file to count)
# Date: Nov 2026

#Reading the file as input gives just the number, without the file name
NumLines=`wc -l < "$1"`
echo "The file $1 has $NumLines lines"
echo
