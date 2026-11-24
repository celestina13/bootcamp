#Control flow tools

#if statements
a <- TRUE
if (a) {
  print("a is TRUE")
} else {
  print("a is FALSE")
}

#running code on a single line
z <- runif(1) #generate a uniformly distributed random number
if (z <= 0.5) {print("Less than a half")}

#for loops
for (i in 1:10) {
  j <- i * i
  print(paste(i," squared is", j))
}
#1:10 generates a sequence
#j is a temporary variable that stores the value of the number in that iteration of the loop

#loop over a vector of strings
for(species in c('Heliodoxa rubinoides', 'Boissonneaua jardini', 'Sula nebouxii')) {
  print(paste('The species is', species))
}

#loop for a preexisting vector
v1 <- c("a","bc", "def")
for (i in v1) {
  print(i)
}

#while loops
#perform an operation till some condition is met, use a while loop

i <- 0
while (i < 10) {
  i <- i+1
  print(i^2)
}


