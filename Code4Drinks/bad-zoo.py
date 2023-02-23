import sys

listnum = 1
while True:
    num_animals = int(next(sys.stdin))
    if num_animals == 0:
        break
    print(f"List {listnum}:")
    listnum += 1
    animals = {}
    for i in range(num_animals):
        line = str(next(sys.stdin))
        animal = line.split()[-1]
        c = animals.get(str(animal).lower(), 0)
        animals[str(animal).lower()] = c+1

    for key, value in sorted(animals.items()):
        print(f"{key} | {value}")
