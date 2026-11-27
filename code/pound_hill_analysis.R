# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: pound_hill_analysis.R

# This script analyses how mean plant species richness and total abundance per quadrat vary
# among the March, May and October cultivation treatments at Pound Hill

# Richness = the number of species with a count above 0 in a quadrat
# Abundance = the total number of plants (sum of all species counts) in a quadrat
# Plots are the treatment replicates, so quadrat richness is averaged
# within each plot before treatments are compared

# How to run:
# Run from the project root (bootcamp/):
#   Rscript code/pound_hill_analysis.R

# Input:  data/pound_hill_data.csv and data/pound_hill_meta_data.csv (kept unchanged)
# Output: results/pound_hill_plot_richness.csv and .pdf
#         results/pound_hill_plot_abundance.csv and .pdf

# Needs the ggplot2 package for the figure

#Clear the workspace so the script only uses objects it creates
rm(list = ls())

#Load ggplot2 for the figure
library(ggplot2)

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
#The lowercase identifiers are kept so the exported tables match the input;
#capitalised month names are only used as labels on the figures
MyWrangledData$Cultivation <- factor(MyWrangledData$Cultivation,
                                     levels = c("march", "may", "october"))
month_labels <- c(march = "March", may = "May", october = "October")

#Give each quadrat a unique ID from its cultivation, block, plot and quadrat
MyWrangledData$QuadratID <- paste(MyWrangledData$Cultivation, MyWrangledData$Block,
                                  MyWrangledData$Plot, MyWrangledData$Quadrat, sep = "_")

#Check that all counts are numbers of 0 or more
if (!is.numeric(MyWrangledData$Count) || any(is.na(MyWrangledData$Count)) ||
    any(MyWrangledData$Count < 0)) {
  stop("Counts must be numbers of 0 or more")
}

#Check every quadrat belongs to March, May or October
if (any(is.na(MyWrangledData$Cultivation))) {
  stop("Unexpected cultivation treatment label")
}

#Count the number of species, quadrats and plots
n_species <- length(unique(MyWrangledData$Species))
n_quadrats <- length(unique(MyWrangledData$QuadratID))
n_plots <- length(unique(MyWrangledData$Plot))
print(paste("Species:", n_species, " Quadrats:", n_quadrats, " Plots:", n_plots))
head(MyWrangledData)

#Calculate species richness in each quadrat (species with a count above 0)
MyWrangledData$Present <- MyWrangledData$Count > 0
QuadratRichness <- aggregate(Present ~ Cultivation + Block + Plot + Quadrat,
                             data = MyWrangledData, FUN = sum)
names(QuadratRichness)[names(QuadratRichness) == "Present"] <- "Richness"

#Show how many quadrats were sampled in each plot
table(factor(QuadratRichness$Plot, levels = 1:12))

#Calculate mean richness for each plot
#Plots have different numbers of quadrats, so averaging within plots first
#stops plots with more quadrats having more influence
PlotRichness <- aggregate(Richness ~ Cultivation + Block + Plot,
                          data = QuadratRichness, FUN = mean)
names(PlotRichness)[names(PlotRichness) == "Richness"] <- "MeanRichness"

#Sort by treatment and plot number
PlotRichness <- PlotRichness[order(PlotRichness$Cultivation,
                                   as.numeric(PlotRichness$Plot)), ]
rownames(PlotRichness) <- NULL

#Check each of the 12 plots appears exactly once
if (nrow(PlotRichness) != 12 || any(duplicated(PlotRichness$Plot))) {
  stop("Plot table should have each of the 12 plots exactly once")
}
PlotRichness

#Create the results folder if it doesn't exist yet
dir.create("results", showWarnings = FALSE)

#Save the plot mean richness table
write.csv(PlotRichness, "results/pound_hill_plot_richness.csv", row.names = FALSE)

#Plots one plot-level measure by treatment and saves it as a PDF, so both figures share one layout
plot_by_treatment <- function(data, y, y_label, file) {
  #Each point is one plot's mean.
  #The grey bar is the median of the four plot means in each treatment.
  fig <- ggplot(data, aes(x = Cultivation, y = .data[[y]])) +
    stat_summary(fun = median, geom = "crossbar", width = 0.4, colour = "grey50") +
    geom_point(aes(shape = Block), size = 3, position = position_dodge(width = 0.3)) +
    scale_x_discrete(labels = month_labels) +
    ylim(0, NA) +
    labs(x = "Month of cultivation treatment",
         y = y_label,
         shape = "Block",
         caption = "Points: plot means. Grey bar: treatment median of the plot means.") +
    theme_classic()
  ggsave(file, fig, width = 6, height = 4.5)
}

#Plot and save mean richness for each plot by treatment
plot_by_treatment(PlotRichness, "MeanRichness", "Mean species richness per quadrat",
                  "results/pound_hill_plot_richness.pdf")

#Calculate total abundance in each quadrat (sum of all species counts)
QuadratAbundance <- aggregate(Count ~ Cultivation + Block + Plot + Quadrat,
                              data = MyWrangledData, FUN = sum)
names(QuadratAbundance)[names(QuadratAbundance) == "Count"] <- "Abundance"

#Calculate mean abundance for each plot
PlotAbundance <- aggregate(Abundance ~ Cultivation + Block + Plot,
                           data = QuadratAbundance, FUN = mean)
names(PlotAbundance)[names(PlotAbundance) == "Abundance"] <- "MeanAbundance"

#Put richness and abundance side by side for each plot
PlotSummary <- merge(PlotRichness, PlotAbundance)
PlotSummary <- PlotSummary[order(PlotSummary$Cultivation,
                                 as.numeric(PlotSummary$Plot)), ]
rownames(PlotSummary) <- NULL
PlotSummary

#Compare the treatment medians for richness and abundance
aggregate(cbind(MeanRichness, MeanAbundance) ~ Cultivation,
          data = PlotSummary, FUN = median)

#Save the plot-level richness and abundance table
write.csv(PlotSummary, "results/pound_hill_plot_abundance.csv", row.names = FALSE)

#Plot and save mean abundance for each plot by treatment
plot_by_treatment(PlotSummary, "MeanAbundance", "Mean number of plants per quadrat",
                  "results/pound_hill_plot_abundance.pdf")

#Interpretation

#May has the highest typical richness, although there is quite a lot of variation
#between plots in each treatment. The ranges also overlap, and there are only four
#plots per treatment. Therefore, we cannot say for sure that cultivation timing caused
#the differences, as other factors, such as soil type, slope or previous land use,
#may also have affected the results.

#Abundance shows a different pattern to richness. October has the most plants
#but the fewest species. This suggests a few species dominate the October plots,
#so a plot can have lots of plants but low diversity.
#This may be because some species, such as clonal grasses, recover quickly
#and outcompete others for light and space.