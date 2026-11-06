# This function calculates heights of trees given distance of each tree
# from its base and angle to its top, using  the trigonometric formula

# height = distance * tan(radians)

# Arguments
# degrees: The angle of elevation of tree
# distance: The distance from base of tree

# How to run:
# Run from the project root (bootcamp/) and give the input file:
#   Rscript code/get_TreeHeight.R data/trees.csv
# source() can't pass the file name, so use Rscript

# Input:  any CSV with the same columns as data/trees.csv
# Output: results/<input name>_treeheights.csv
# Two inputs with the same file name will write to the same output file

TreeHeight <- function(degrees, distance) {
  radians <- degrees * pi / 180      #tan() in R needs radians, not degrees
  height <- distance * tan(radians)
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
    #collapse joins the missing column names into one message, separated by commas
    stop(paste("Missing required column(s):", paste(missing_cols, collapse = ", ")))
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
    stop("Distance must be greater than 0 and at most 100")
  }

  #Check that angles are between 0 and 90 degrees
  if (any(MyData$Angle.degrees <= 0 | MyData$Angle.degrees >= 90)) {
    stop("Angle must be between 0 and 90 degrees")
  }

  return (invisible(TRUE))
}

#Get the input file name from the command line
args <- commandArgs(trailingOnly = TRUE)
usage <- "Usage: Rscript code/get_TreeHeight.R data/<file>.csv"

#Check exactly one file was given
if (length(args) == 0) {
  stop(paste("No input file given.", usage))
} else if (length(args) > 1) {
  stop(paste("Expected exactly one input file, received ", length(args), ". ", usage, sep = ""))
}

input_file <- args[1]

#Check the file exists and can be read
if (!file.exists(input_file)) {
  stop(paste("Input file not found:", input_file))
}
if (file.access(input_file, 4) != 0) {
  stop(paste("Input file is not readable:", input_file))
}

#Read the tree data from the file given
MyData <- read.csv(input_file, header = TRUE)

check_tree_data(MyData)

#TreeHeight() works on whole columns at once, so every tree is done without a loop
MyData$height_m <- TreeHeight(MyData$Angle.degrees, MyData$Distance.m)

#Make the output name from the input name, e.g. data/trees.csv -> trees
file_name <- tools::file_path_sans_ext(basename(input_file))
output_file <- paste("results/", file_name, "_treeheights.csv", sep = "")

#Create the results folder if it doesn't exist yet
#showWarnings = FALSE stops a warning when the folder already exists
dir.create("results", showWarnings = FALSE)

#Save the three original columns and the new height_m column
write.csv(MyData, output_file, row.names = FALSE)

print(paste("Tree heights written to", output_file))

