#For debugging practice: fails on purpose with ZeroDivisionError when y reaches 0
def buggyfunc(x):
    y = x
    for i in range(x):
        y = y-1
        z = x/y
    return z

buggyfunc(20)