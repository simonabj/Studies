import sys

e = int(next(sys.stdin))
f = int(next(sys.stdin))
c = int(next(sys.stdin))

bottles = e+f

drinks = 0
while bottles >= c:
    # Do trade
    sodas = bottles // c
    # He then has this many bottles left
    bottles %= c    
    # He drinks the sodas
    drinks += sodas
    # Now he has this many bottles, and continue trade
    bottles += sodas

print(drinks)
