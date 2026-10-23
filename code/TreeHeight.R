# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 

# height = distance * tan(radians)

# Arguments
# degrees: The angle of elevation of tree
# distance: The distance from base of tree

# How to run:
# Run from the project root (bootcamp/) so the relative paths work:
#   Rscript code/TreeHeight.R
# or, in R started at the project root:
#   source("code/TreeHeight.R")

# Input:  data/trees.csv
# Output: results/TreeHts.csv

TreeHeight <- function(degrees, distance) {
  radians <- degrees * pi / 180      #tan() in R needs radians, not degrees
  height <- distance * tan(radians)  #height = distance * tan(angle)
  return (height)                    
}

# Read the tree data. The path is relative to the project root,
# so there is no setwd() and no absolute path in the script.
# header = TRUE uses the first row as the column names.
MyData <- read.csv("data/trees.csv", header = TRUE)



