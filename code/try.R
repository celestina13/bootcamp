# Author: Celestina Hall (ceh121@ic.ac.uk)
# Script: try.R
# Uses try() to catch errors so a repeated simulation keeps running.
# Run from the project root with: Rscript code/try.R

doit <- function(x) {
    temp_x <- sample(x, replace = TRUE)
    if(length(unique(temp_x)) > 30) {#the mean is only worked out if the sample has over 30 unique values
         print(paste("Mean of this sample was:", as.character(mean(temp_x))))
        } 
    else {
        stop("Couldn't calculate mean: too few unique values!")
        }
    }

set.seed(1345) #fix the random numbers so every run gives the same result

popn <- rnorm(50)

hist(popn) #saved as Rplots.pdf when run with Rscript

#try() catches each error, so all 15 runs happen and the failures are stored instead of stopping the script
result <- lapply(1:15, function(i) try(doit(popn), FALSE))

class(result)

result

#The same 15 runs again, using a loop instead of lapply
result <- vector("list", 15) #an empty list with one slot for each run
for(i in 1:15) {
    result[[i]] <- try(doit(popn), FALSE)
    }
