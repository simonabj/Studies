import sys
import itertools

N = int(next(sys.stdin))

tree_start = list(range(1, N+1))
tree_rate = [int(x) for x in next(sys.stdin).split()]

best_time = 10_000_000

for perm in itertools.permutations(tree_start):
    time = max([a+b for a, b in zip(perm, tree_rate)])
    best_time = min(best_time, time)

print(best_time+1)
