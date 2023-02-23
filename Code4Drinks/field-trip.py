import sys

n = int(next(sys.stdin))

class_sections = [int(s) for s in next(sys.stdin).split()]

i = 1
j = n-1

while j >= 2:
    for i in range(0, j):
        class_1 = sum(class_sections[:i])
        class_2 = sum(class_sections[i:j])
        class_3 = sum(class_sections[j:])
        # print(f"{class_1} {class_2} {class_3}")

        if class_1 == class_2 == class_3:
            print(f"{i} {j}")
            quit()
    j -= 1

print(-1)
