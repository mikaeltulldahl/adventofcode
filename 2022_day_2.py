print("Part 1")
code_map = {"A": 0, "B": 1, "C": 2, "X": 0, "Y": 1, "Z": 2}
score_total = 0
with open("day_2_input.txt") as f:
    for line in f:
        # print(line.strip())
        (a, b) = line.split()
        opponent_choice = code_map[a]
        my_choice = code_map[b]
        outcome = (my_choice - opponent_choice) % 3
        # print(f"outcome: {outcome}")
        # print(f"my_choice: {my_choice}")
        match outcome:
            case 0:  # tie
                score = 3 + my_choice + 1
            case 1:  # win
                score = 6 + my_choice + 1
            case 2:  # lose
                score = 0 + my_choice + 1
        # print(f"score: {score}\n")
        score_total += score
print(f"score_total: {score_total}")

print("\n\nPart 2")
code_map = {"A": 0, "B": 1, "C": 2, "X": -1, "Y": 0, "Z": 1}
score_total = 0
with open("day_2_input.txt") as f:
    for line in f:
        # print(line.strip())
        (a, b) = line.split()
        opponent_choice = code_map[a]
        outcome = code_map[b]
        my_choice = (opponent_choice + outcome) % 3
        # print(f"outcome: {outcome}")
        # print(f"opponent_choice: {opponent_choice}")
        # print(f"my_choice: {my_choice}")
        match outcome:
            case 0:  # tie
                score = 3 + my_choice + 1
            case 1:  # win
                score = 6 + my_choice + 1
            case -1:  # lose
                score = 0 + my_choice + 1
        # print(f"score: {score}\n")
        score_total += score
print(f"score_total: {score_total}")
