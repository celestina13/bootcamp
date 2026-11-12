#!/bin/bash
# Author: Celestina Hall ceh121@ic.ac.uk
# Script: tiff2_png.sh
# Desc: Converts every .tif in the current folder to .png with ImageMagick
# Arguments: None (run inside a folder of copied .tif files)
# Date: Nov 2026

#Run in a folder of .tif files, otherwise convert gets "*.tif" and fails
for filename in *.tif
do
    echo "Converting $filename"
    #Swap .tif for .png in the new file name
    convert "$filename" "$(basename "$filename" .tif).png"
done
