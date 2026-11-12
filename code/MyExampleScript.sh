#!/bin/bash
# Author: Celestina Hall ceh121@ic.ac.uk
# Script: MyExampleScript.sh
# Desc: Greets the user using the USER environment variable
# Arguments: None
# Date: Nov 2026

greeting="Hello"
user_name=$USER
printf '%s %s\n' "$greeting" "$user_name"
