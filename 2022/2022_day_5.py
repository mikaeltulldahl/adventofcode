import re


def read_input():
    with open("day_5_input.txt") as f:
        lines = f.readlines()
    # Parse original crates positions
    idx = 0
    while not lines[idx].startswith(" 1"):
        idx += 1
    nCrates = len(lines[idx]) // 4
    moves_start = idx + 2
    crates = [[] for x in range(nCrates)]
    for i in range(idx - 1, -1, -1):
        line = lines[i]
        for j in range(nCrates):
            if line[j * 4:].startswith("["):
                item = line[j * 4 + 1]
                crates[j].append(item)

    # Parse moves
    moves = []
    for line in lines[moves_start:]:
        moves.append([int(s) for s in re.findall(r'\d+', line)])
    return (crates, moves)


# Part 1
(crates, moves) = read_input()
for move in moves:
    (nCrates, source, dest) = move
    for j in range(nCrates):
        item = crates[source - 1].pop()
        crates[dest - 1].append(item)
print(f"Part 1 answer: {''.join([x[-1] for x in crates])}")

# Part 2
(crates, moves) = read_input()
for move in moves:
    (nCrates, source, dest) = move
    items = crates[source - 1][-nCrates:]
    crates[source - 1] = crates[source - 1][:-nCrates]
    crates[dest - 1].extend(items)
print(f"Part 2 answer: {''.join([x[-1] for x in crates])}")
