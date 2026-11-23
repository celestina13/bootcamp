# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: basic_io.R
# A simple R script illustrating file input and output.
# Run from the project root with: Rscript code/basic_io.R

MyData <- read.csv("data/trees.csv", header = TRUE) #import with headers

dir.create("results", showWarnings = FALSE) #create results/ if it does not exist yet

write.csv(MyData, "results/MyData.csv") #write it as a new file

write.table(MyData[1, ], file = "results/MyData.csv", append = TRUE) #append the first row (R warns that it is appending column names, which is expected)

write.csv(MyData, "results/MyData.csv", row.names = TRUE) #write row names

write.table(MyData, "results/MyData.csv", col.names = FALSE) #omit column names
