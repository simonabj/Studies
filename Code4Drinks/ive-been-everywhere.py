import sys

cases = int(next(sys.stdin))

for case in range(cases):
    N = int(next(sys.stdin))
    cities = set()
    for i in range(N):
        cities.add(next(sys.stdin))
    print(len(cities))
