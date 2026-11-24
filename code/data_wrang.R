# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: data_wrang.R
# Reshapes the Pound Hill species counts from wide to long form.
# Run from the project root with: Rscript code/data_wrang.R

#Load the data, without a header, as the first rows hold the sampling design
MyData <- as.matrix(read.csv("data/pound_hill_data.csv", header = FALSE))

#The metadata has a header row and is separated by semicolons
MyMetaData <- read.csv("data/pound_hill_meta_data.csv", header = TRUE, sep = ";")

#Look at the data
head(MyData)
dim(MyData)
str(MyData)
head(MyMetaData)

#Flip the matrix so each quadrat is a row and each species is a column
MyData <- t(MyData) 
head(MyData)
dim(MyData)

#The metadata says blanks are observed absences, so they become 0 rather than NA
MyData[MyData == ""] <- 0

#Turn the matrix into a data frame, using the first row as the column names

TempData <- as.data.frame(MyData[-1, ], stringsAsFactors = FALSE)
colnames(TempData) <- MyData[1, ]
rownames(TempData) <- NULL

#Reshape from wide to long form with reshape2 (data_wrang_tidy.R does the same with tidyr)
library(reshape2)

MyWrangledData <- melt(
  TempData,
  id = c("Cultivation", "Block", "Plot", "Quadrat"),
  variable.name = "Species",
  value.name = "Count"
)

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

#Save the long table to results/, leaving the raw data unchanged
dir.create("results", showWarnings = FALSE)
write.csv(MyWrangledData, "results/pound_hill_long.csv", row.names = FALSE)

