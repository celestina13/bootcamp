# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: observations_practice.R
# Summarises the bootcamp observation counts for each site in R.
# Run from the project root with: Rscript code/observations_practice.R

#Every column is read as text first, so the counts can be checked before they are converted,
#and blank counts are read as NA (missing)
observations <- read.csv(
  "data/bootcamp_observations.csv",
  colClasses = "character", na.strings = "", check.names = FALSE
)
str(observations)
print(observations)
