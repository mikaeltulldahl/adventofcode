print("Part 1")
with open("day_1_input.txt") as f:
    calorie_count = 0
    max_calories = 0
    for line in f:
        if line.startswith("\n"):
            calorie_count = 0
        else:
            calorie_count += int(line.strip())
            if calorie_count > max_calories:
                max_calories = calorie_count
print(f"max_calories: {max_calories}")

print("Part 2")
with open("day_1_input.txt") as f:
    calorie_count = [0]
    for line in f:
        if line.startswith("\n"):
            calorie_count.append(0)
        else:
            calorie_count[-1] += int(line.strip())
calorie_count.sort()
print(f"total calories of top 3: {sum(calorie_count[-3:])}")
