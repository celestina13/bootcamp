# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: observations_practice.R
# Summarises the bootcamp observation counts for each site in R.
# Run from the project root with: Rscript code/observations_practice.R

#Reads an observations file and checks every value before converting the counts
read_observations <- function(path) {
  #Every column is read as text first, so the counts can be checked before they are converted,
  #and blank counts are read as NA (missing)
  observations <- read.csv(
    path,
    colClasses = "character", na.strings = "", check.names = FALSE
  )

  #The columns must be exactly site, date and count, in that order
  if (!identical(names(observations), c("site", "date", "count"))) {
    stop(paste0(path, ": expected the columns site,date,count but found ",
                paste(names(observations), collapse = ",")), call. = FALSE)
  }

  #Line numbers in the messages start at 2, because line 1 of the CSV is the header
  csv_lines <- seq_len(nrow(observations)) + 1

  #Every row needs a site and a date
  for (column in c("site", "date")) {
    blank <- is.na(observations[[column]]) | observations[[column]] == ""
    if (any(blank)) {
      stop(paste0(path, ": CSV line ", csv_lines[blank][1], ", column '", column,
                  "' is empty"), call. = FALSE)
    }
  }

  #A count must be missing or a whole number of 0 or more, written without signs or leading zeros
  counts <- observations$count
  bad <- !is.na(counts) & !grepl("^(0|[1-9][0-9]*)$", counts)
  if (any(bad)) {
    stop(paste0(path, ": CSV line ", csv_lines[bad][1], ", column 'count': found '",
                counts[bad][1], "'; expected an empty field or a non-negative integer"),
         call. = FALSE)
  }

  observations$count <- as.integer(counts)
  return(observations)
}

observations <- read_observations("data/bootcamp_observations.csv")
str(observations)
print(observations)

#The invalid file must be rejected; try() catches the error so the rest of the script still runs
invalid_result <- try(read_observations("data/bootcamp_observations_invalid.csv"), silent = TRUE)
stopifnot(inherits(invalid_result, "try-error"))
cat("Invalid file rejected:", conditionMessage(attr(invalid_result, "condition")), "\n")
