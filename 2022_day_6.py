import numpy as np

with open("day_6_input.txt") as f:
    input = next(f)
#input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
part_1_done =False
for i in range(4, len(input)):
    tmp = list(input[i-4:i])
    if not part_1_done and (len(np.unique(tmp)) == 4):
        print(f"Part 1 answer: {i}")
        part_1_done = True

    if i >= 14:
        tmp2 = list(input[i - 14:i])
        if (len(np.unique(tmp2)) == 14):
            print(f"Part 2 answer: {i}")
            break
