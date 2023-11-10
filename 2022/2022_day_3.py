def letter_2_num(letter):
    if ord(letter) >= ord("a"):
        return ord(letter) - ord("a") + 1
    else:
        return ord(letter) - ord("A") + 27


print("Part 1")
priority_sum = 0
with open("day_3_input.txt") as f:
    for line in f:
        line = line.strip()
        part1 = line[:int(len(line) / 2)]
        part2 = line[int(len(line) / 2):]
        overlap = set(part1).intersection(set(part2)).pop()
        priority_sum += letter_2_num(overlap)
print(f"priority_sum: {priority_sum}")

print("\n\nPart 2")
priority_sum = 0
with open("day_3_input.txt") as f:
    while True:
        try:
            first = next(f).strip()
            second = next(f).strip()
            third = next(f).strip()
        except:
            break
        overlap = set(first).intersection(set(second), set(third)).pop()
        priority_sum += letter_2_num(overlap)
print(f"priority_sum: {priority_sum}")
