import sys

name1 = next(sys.stdin)
name2 = next(sys.stdin)

print("".join(sorted(list(name1)+list(name2))))

