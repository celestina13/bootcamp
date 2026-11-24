# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: browse.R
# Uses browser() to pause inside a loop and inspect variables.
# Run interactively from an R session at the project root: source("code/browse.R")

Exponential <- function(N0 = 1, r = 1, generations = 10) {
  #Simulates exponential growth and returns the population size in each generation
  
  N <- rep(NA, generations)    #every generation starts empty (NA)
  
  N[1] <- N0
  for (t in 2:generations) {
    N[t] <- N[t-1] * exp(r)
    browser() #pause each generation to inspect N and t: n runs the next line, c continues, Q quits
  }
  return (N)
}

plot(Exponential(), type="l", main="Exponential growth")
