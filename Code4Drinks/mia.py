import sys


def score(s):
    if 1 in s and 2 in s:
        return 99999
    elif len(s) == 1:
        return s.pop()*1000
    else:
        return int(str(max(s))+str(min(s)))


line = next(sys.stdin)
while "0" not in line:

    s1, s2, r1, r2 = (int(l) for l in line.split())

    p1 = score(set([s1,s2])) 
    p2 = score(set([r1,r2]))

    if p1 > p2:
        print("Player 1 wins.")
    elif p1 < p2:
        print("Player 2 wins.")
    else:
        print("Tie.")

    line=next(sys.stdin)

