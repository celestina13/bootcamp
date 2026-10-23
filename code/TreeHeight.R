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

#Checks that the tree data meet the assumptions of the height calculation
#Stops the script with a clear error message if any check fails 
check_tree_data <- function(MyData) {

  #Check that the required columns are present
  #setdiff() returns the required names that are NOT in the data
  required <- c("Species", "Distance.m", "Angle.degrees")
  missing_cols <- setdiff(required, names(MyData))
  if (length(missing_cols) > 0) {
    stop(paste("Missing required column(s):", paste(missing_cols)))
  }

  #Check that distance and angle are numeric
  if (!is.numeric(MyData$Distance.m) || !is.numeric(MyData$Angle.degrees)) {
    stop("Distance and angle must be numeric")
  }

  #Check for missing or infinite values
  if (!all(is.finite(MyData$Distance.m)) || !all(is.finite(MyData$Angle.degrees))) {
    stop("Distance and angle must contain valid numbers")
  }

  #Check that distances are between 0 and 100 metres
  if (any(MyData$Distance.m <= 0 | MyData$Distance.m > 100)) {
    stop("Distance must be greater that 0 and at most 100")
  }

  #Check that angles are between 0 and 100 metres
  if (any(MyData$Angle.degrees <= 0 | MyData$Angle.degrees >= 90)) {
    stop("Angle must be between 0 and 90 degrees")
  }

  return (TRUE)
}

#Read the tree data. The path is relative to the project root,
#so there is no setwd() and no absolute path in the script.
#header = TRUE uses the first row as the column names.
MyData <- read.csv("data/trees.csv", header = TRUE)

check_tree_data(MyData)

#Calculate the height of every tree
MyData$height_m <- TreeHeight(MyData$Angle.degrees, MyData$Distance.m)

