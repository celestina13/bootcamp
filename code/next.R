# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: next.R
# Uses next to skip even numbers in a for loop.
# Run from the project root with: Rscript code/next.R

for (i in 1:10) {
  if ((i %% 2) == 0) #even numbers have no remainder when divided by 2
    next #skip straight to the next number without printing
  print(i)
}
