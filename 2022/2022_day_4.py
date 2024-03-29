fully_contains = 0
partially_contains = 0
with open("day_4_input.txt") as f:
    for line in f:
        (first_str, second_str) = line.strip().split(",")
        first_range = [int(x) for x in first_str.split("-")]
        second_range = [int(x) for x in second_str.split("-")]

        if first_range[0] >= second_range[0] and first_range[1] <= second_range[1]:
            fully_contains += 1
        elif second_range[0] >= first_range[0] and second_range[1] <= first_range[1]:
            fully_contains += 1

        if second_range[0] <= first_range[0] <= second_range[1]:
            partially_contains += 1
        elif first_range[0] <= second_range[0] <= first_range[1]:
            partially_contains += 1
print(f"Part 1 fully_contains: {fully_contains}")
print(f"\nPart 2 partially_contains: {partially_contains}")