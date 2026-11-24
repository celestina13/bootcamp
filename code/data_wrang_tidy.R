# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: data_wrang_tidy.R
# The same Pound Hill wrangling as data_wrang.R, rewritten step by step with dplyr and tidyr.
# Run from the project root with: Rscript code/data_wrang_tidy.R

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

#Reshape from wide to long form with tidyr: the four design columns stay as they are,
#and every species column becomes a Species name and its Count
library(tidyr)

MyWrangledData <- TempData |>
  pivot_longer(
    cols = -c(Cultivation, Block, Plot, Quadrat),
    names_to = "Species",
    values_to = "Count"
  )

#Make the four design columns factors and the counts whole numbers in one step
library(dplyr)

MyWrangledData <- MyWrangledData |>
  mutate(
    across(c(Cultivation, Block, Plot, Quadrat), as.factor),
    Count = as.integer(Count)
  )

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

#Save the long table to results/ under its own name, so it can be compared with data_wrang.R's output
dir.create("results", showWarnings = FALSE)
write.csv(MyWrangledData, "results/pound_hill_long_tidy.csv", row.names = FALSE)

