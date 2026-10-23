# This script analyses how mean plant species richness per quadrat varies
# among the March, May and October cultivation treatments at Pound Hill

# Richness = the number of species with a count above 0 in a quadrat
# Plots are the treatment replicates, so quadrat richness is averaged
# within each plot before treatments are compared

# How to run:
# Run from the project root (bootcamp/):
#   Rscript code/pound_hill_analysis.R

# Input:  data/pound_hill_data.csv and data/pound_hill_meta_data.csv (kept unchanged)
# Output: results/pound_hill_plot_richness.csv (one row per plot)
#         results/pound_hill_plot_richness.pdf (plot values by treatment)
# Needs the ggplot2 package for the figure

#Clear the workspace so the script only uses objects it creates
rm(list = ls())

data_file <- "data/pound_hill_data.csv"
meta_file <- "data/pound_hill_meta_data.csv"

#Check the data files are there
if (!file.exists(data_file) || !file.exists(meta_file)) {
  stop("Input files not found. Run this script from the project root")
}

#Read the species count data
#There is no header row
MyData <- as.matrix(read.csv(data_file, header = FALSE, colClasses = "character"))

#Read the metadata
MyMetaData <- read.csv(meta_file, header = TRUE, sep = ";", strip.white = TRUE)

#Inspect the data and metadata
dim(MyData)
str(MyData)
MyData[1:6, 1:6]
str(MyMetaData)
MyMetaData