#!/bin/bash
#Author: Celestina Hall
#Script: run_get_TreeHeight.sh
#Desc: Tests get_TreeHeight.R on trees.csv
#Run from the project root: bash code/run_get_TreeHeight.sh
#Arguments: none
#Date: Oct 2026

#Uses Rscript because source() can't pass the file name
#Stops if the R script fails
Rscript code/get_TreeHeight.R data/trees.csv || exit 1

echo "Done: results/trees_treeheights.csv created"