MyFunction <-  function(Arg1, Arg2) {
  #Prints the type of each argument and returns both arguments together as a vector
  print(paste("Argument", as.character(Arg1), "is a", class(Arg1)))
  print(paste("Argument", as.character(Arg2), "is a", class(Arg2)))
  
  return (c(Arg1, Arg2)) 
}

MyFunction(1,2)
MyFunction("riki", "tiki")

