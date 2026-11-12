#!/bin/bash
# Author: Celestina Hall ceh121@ic.ac.uk
# Script: CheckLabel.sh
# Desc: Accepts exactly one label, oak or pine
# Arguments: 1 (oak or pine)
# Date: Oct 2026

#Exit 2 for wrong usage and 1 for an unrecognised label, so the two can be told apart
if [[ $# -ne 1 ]]; then
    printf 'Usage: %s oak|pine\n' "$0" >&2
    exit 2
fi

if [[ "$1" != "oak" && "$1" != "pine" ]]; then
    printf 'Unknown label: %s\n' "$1" >&2
    exit 1
fi

printf 'Selected species: %s\n' "$1"
