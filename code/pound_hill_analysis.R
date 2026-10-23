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

#Check the metadata says blank counts are observed absences (zeros)
blank_rule <- MyMetaData$Description[MyMetaData$FieldName == "BlankSpeciesCount"]
print(blank_rule)
if (!grepl("zero", blank_rule)) {
  stop("Metadata does not say blanks are zeros")
}

#Check the first four rows are Cultivation, Block, Plot and Quadrat
design_cols <- c("Cultivation", "Block", "Plot", "Quadrat")
if (!identical(MyData[1:4, 1], design_cols)) {
  stop("First four rows are not Cultivation, Block, Plot and Quadrat")
}

#Turn the data round so each quadrat is a row and each species is a column
MyData <- t(MyData)
TempData <- as.data.frame(MyData[-1, ], stringsAsFactors = FALSE)
colnames(TempData) <- MyData[1, ]
rownames(TempData) <- NULL

#Replace blank species counts with zeros
species <- setdiff(colnames(TempData), design_cols)
counts <- as.matrix(TempData[, species])
print(paste("Blank counts converted to 0:", sum(counts == "")))
counts[counts == ""] <- "0"

#Reshape to long form, with one row for each species in each quadrat
MyWrangledData <- data.frame(
  TempData[rep(seq_len(nrow(TempData)), times = length(species)), design_cols],
  Species = rep(species, each = nrow(TempData)),
  Count = as.numeric(as.vector(counts)),
  stringsAsFactors = FALSE
)
rownames(MyWrangledData) <- NULL

#Put the treatments in month order: March, May, October
MyWrangledData$Cultivation <- factor(MyWrangledData$Cultivation,
                                     levels = c("march", "may", "october"),
                                     labels = c("March", "May", "October"))
                                     