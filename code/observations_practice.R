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

#Removes exact duplicate rows, then gives each site's known total and number of missing counts
summarise_observations <- function(data) {
  #A repeated row is the same observation recorded twice, so only its first copy is kept
  data <- data[!duplicated(data), ]

  sites <- sort(unique(data$site))
  total_known <- integer(length(sites))
  missing_count <- integer(length(sites))
  for (i in seq_along(sites)) {
    counts <- data$count[data$site == sites[i]]
    missing_count[i] <- sum(is.na(counts))
    #With no known counts the total is NA, because sum(na.rm = TRUE) would wrongly give 0
    if (all(is.na(counts))) {
      total_known[i] <- NA
    } else {
      total_known[i] <- sum(counts, na.rm = TRUE)
    }
  }
  return(data.frame(site = sites, total_known = total_known, missing_count = missing_count))
}

observations <- read_observations("data/bootcamp_observations.csv")
str(observations)
print(observations)

#The invalid file must be rejected; try() catches the error so the rest of the script still runs
invalid_result <- try(read_observations("data/bootcamp_observations_invalid.csv"), silent = TRUE)
stopifnot(inherits(invalid_result, "try-error"))
cat("Invalid file rejected:", conditionMessage(attr(invalid_result, "condition")), "\n")

summary_ordinary <- summarise_observations(observations)
print(summary_ordinary)

boundary <- read_observations("data/bootcamp_observations_boundary.csv")
summary_boundary <- summarise_observations(boundary)
print(summary_boundary)

#Returns (total_known, missing_count) for one site, so the results can be checked
site_result <- function(summary, site) {
  row <- summary[summary$site == site, ]
  return(c(row$total_known, row$missing_count))
}

#Expected results: A (2, 1), B (0, 0), C (NA, 2) and D (0, 0)
stopifnot(
  identical(site_result(summary_ordinary, "A"), c(2L, 1L)),
  identical(site_result(summary_ordinary, "B"), c(0L, 0L)),
  identical(site_result(summary_boundary, "C"), c(NA, 2L)),
  identical(site_result(summary_boundary, "D"), c(0L, 0L))
)
