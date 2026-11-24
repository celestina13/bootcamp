# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: r_conditionals.R
# Functions that use conditionals to describe a number.
# Run from the project root with: Rscript code/r_conditionals.R

#Says whether a whole number is even or odd
is.even <- function(n) {
  if (n %% 2 == 0) {
    return(paste(n,'is even!'))
  } else {
  return(paste(n,'is odd!'))
  }
}

is.even(6)

#A power of 2 has a whole-number log2, so dividing that by 1 leaves no remainder
is.power2 <- function(n) {
  if (log2(n) %% 1==0) {
    return(paste(n, 'is a power of 2!'))
  } else {
  return(paste(n,'is not a power of 2!'))
    }
}

is.power2(4)

#Says whether a number is zero, one, prime or composite
#Note: for n = 2, 2:(n-1) counts down to 2:1, so 2 is wrongly reported as composite
is.prime <- function(n) {
  if (n==0) {
    return(paste(n,'is a zero!'))
  } else if (n==1) {
    return(paste(n,'is just a unit!'))
  }
    
  ints <- 2:(n-1)
  
  if (all(n%%ints!=0)) {
    return(paste(n,'is a prime!'))
  } else {
  return(paste(n,'is a composite!'))
    }
}

is.prime(3)
