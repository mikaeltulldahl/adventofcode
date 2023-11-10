import numpy as np


def simulate(lines, n_knots):
    knots = [np.array([0, 0]) for x in range(n_knots)]
    history = set()
    for line in lines:
        direction, distance = line.split(" ")
        distance = int(distance)
        for _ in range(distance):
            match direction:
                case "D":
                    knots[0][0] += 1
                case "U":
                    knots[0][0] -= 1
                case "R":
                    knots[0][1] += 1
                case "L":
                    knots[0][1] -= 1
                case _:
                    exit(1)

            for i in range(n_knots-1):
                diff = knots[i] - knots[i+1]
                if any(diff == 0):
                    diff = np.clip(diff, -1, 1)
                    knots[i+1] = knots[i] - diff
                elif all(np.abs(diff) == [1, 1]):
                    pass
                else:
                    diff = np.clip(diff, -1, 1)
                    knots[i+1] = knots[i+1] + diff
            history.add(tuple(knots[-1]))
    return len(history)


with open("day_9_input.txt") as f:
    lines = f.read().splitlines()
print(f"Part 1: tail history: {simulate(lines, 2)}")
print(f"Part 2: tail history: {simulate(lines, 10)}")

