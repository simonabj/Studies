import sys

for l in sys.stdin:
    X,Y,N = l.split()
    x = int(X)
    y = int(Y)
    n = int(N)
    for i in range(1, n+1):
        if i % x == 0 and i % y == 0:
            print("FizzBuzz")
        elif i % x == 0:
            print("Fizz")
        elif i % y == 0:
            print("Buzz")
        else:
            print(i)
        
