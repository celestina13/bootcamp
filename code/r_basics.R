a <- 4 #store 4 as variable a
a #display it

 a*a #product

 a_squared <- a*a # store a variable

sqrt(a_squared) #square root

#Build a vector
v <- c(0, 1, 2, 3, 4) #store a vector of numbers
v

isvector(v)

mean(v) #mean

var(v) #variance

median(v) #median

sum(v) #sum all elements

prod(v+1) #multiply 

length(v) #how many elements in the vector


##Variable names and Tagging##
wing.width.cm <- 1.2
wing.length.cm <- c(4.7, 5.2, 4.8)

wing.

##Types of parentheses
f(3,4) #call the function f with arguments 3 and 4
a + (b*c) #use parentheses to control order of operations
{expr1;expr2;expr3} #group expressions together
x[4]#access the 4th element of vector x
li[[3]]

li = list(c(1,2,3))
class(li)

##~Variable types
v <- TRUE
v

class(v)

v  <- 3.2
class(v)

v <- 2L

v <- "A string"
class(v)

is.na(b)

b <- 0/0
b

is.nan(b)

b <- 5/0
b

is.nan(b)

is.infinite(b)

is.finite(b)

is.finite(0/0)

##Type Conservations and Special Values

as.integer(3.1)
as.numeric(3L)
as.roman(155)
as.character(155) #same as converting to string
as.logical(0) #0 is false, 1 is true

#R Data Structures
# Vectors = 1D array of elements of the same type
# Matrix = 2D array of elements of the same type
# Array = nD array of elements of the same type
# List = 1D array of elements of different types
# Data Frame = 2D array of elements of different types

#Vectors
a <- 5
is.vector(a)
#TRUE

v1 <- C(0.02, 0.5, 1)
v2 <- c("a", "b", "c")
v3 <- c(TRUE, FALSE, TRUE)

#R vectors can only store data od a single type 
v1 <- c(0.02, TRUE, 1) 
v1
#v1 is coerced to numeric, TRUE is converted to 1

#creating empty vectors
v <- vector("numeric", length = 10) #create a numeric vector of length 10


#From an algorithm to R

heights_cm <- c(8, 12, 10, 15)
above_threshold <- heights_cm > 10
above_threshold
sum(above_threshold) #count how many heights are above threshold


#Matrices and Arrays
#R matrices are 2D arrays of elements of the same type. 
#They can be created using the matrix() function or by converting a vector to a matrix using the dim() function.

mat1 <- matrix(1:25, 5, 5)
mat1

mat1 <- matrix(1:25, byrow = TRUE) 

dim(mat1) #get the dimensions of the matrix

arr1 <- array(1:50, c(5, 5, 2))
arr1[,,1]
print(arr1)



