# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: break.R
# Uses break to stop a while loop once a condition is met.
# Run from the project root with: Rscript code/break.R

i <- 0 #start counting from 0
    while (i < Inf) { #Inf gives the loop no fixed end, so only break can stop it
        if (i == 10) {
            break #stop the loop once i reaches 10
        } else {
            cat("i equals " , i , " \n")
            i <- i + 1 #move on to the next number
    }
}
