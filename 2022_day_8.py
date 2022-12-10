import numpy as np

with open("day_8_input.txt") as f:
    lines = f.read().splitlines()
    rows = len(lines)
    cols = len(lines[0])
trees = np.zeros((rows, cols), int)
idx = 0
for line in lines:
    trees[idx,:] = np.array(list(line))
    idx += 1

visible = np.zeros_like(trees)


for i in range(rows):
    max_height = -1
    for j in range(cols):
        visible[i,j] = visible[i,j] or trees[i,j] > max_height
        max_height = max(max_height, trees[i,j])

    max_height = -1
    for j in reversed(range(cols, )):
        visible[i,j] = visible[i,j] or trees[i,j] > max_height
        max_height = max(max_height, trees[i,j])

for i in range(cols):
    max_height = -1
    for j in range(rows):
        visible[j,i] = visible[j,i] or trees[j,i] > max_height
        max_height = max(max_height, trees[j,i])

    max_height = -1
    for j in reversed(range(cols, )):
        visible[j,i] = visible[j,i] or trees[j,i] > max_height
        max_height = max(max_height, trees[j,i])

print(f"Part 1, visible sum: {np.sum(visible)}")

scenic_score = np.ones_like(trees)
height_list = [0,0,0,0]
for i in range(1, rows-1):
    for j in range(1, cols-1):
        height_list[0] = trees[i-1::-1, j]
        height_list[1] = trees[i, j-1::-1]
        height_list[2] = trees[i + 1:, j]
        height_list[3] = trees[i, j+1:]
        for direction in height_list:
            idx = 0
            for element in direction:
                idx += 1
                if element >= trees[i, j]:
                    break
            scenic_score[i, j] *= idx

print(f"Part 2, max scenic score: {np.max(scenic_score)}")
