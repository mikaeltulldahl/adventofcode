class Monkey:
    def __init__(self, items: list, op, test_div:int) -> None:
        self.items = items
        self.op = op
        self.test_div = test_div
        self.next = [None, None]
        self.inspect_count = 0
        
    def inspect(self, common_denominator, part):
        for item in self.items:
            self.inspect_count += 1
            new_item = self.op(item)
            if part == 2:
                new_item = new_item % common_denominator
            if part == 1:
                new_item = new_item//3
            if new_item % self.test_div == 0:
                receiver = self.next[0]
            else:
                receiver = self.next[1]
            receiver.items.append(new_item)
        self.items = []


def get_input_example():
    monkey0 = Monkey([79, 98], lambda old: old * 19, 23)
    monkey1 = Monkey([54, 65, 75, 74], lambda old: old + 6, 19)
    monkey2 = Monkey([79, 60, 97], lambda old: old * old, 13)
    monkey3 = Monkey([74], lambda old: old + 3, 17)

    monkey0.next = [monkey2, monkey3]
    monkey1.next = [monkey2, monkey0]
    monkey2.next = [monkey1, monkey3]
    monkey3.next = [monkey0, monkey1]

    monkeys = [monkey0, monkey1, monkey2, monkey3]
    return monkeys


def get_input():
    monkey0 = Monkey([63, 84, 80, 83, 84, 53, 88, 72], lambda old: old * 11, 13)
    monkey1 = Monkey([67, 56, 92, 88, 84], lambda old: old + 4, 11)
    monkey2 = Monkey([52], lambda old: old * old, 2)
    monkey3 = Monkey([59, 53, 60, 92, 69, 72], lambda old: old + 2, 5)
    monkey4 = Monkey([61, 52, 55, 61], lambda old: old + 3, 7)
    monkey5 = Monkey([79, 53], lambda old: old + 1, 3)
    monkey6 = Monkey([59, 86, 67, 95, 92, 77, 91], lambda old: old + 5, 19)
    monkey7 = Monkey([58, 83, 89], lambda old: old * 19, 17)
    
    monkey0.next = [monkey4, monkey7]
    monkey1.next = [monkey5, monkey3]
    monkey2.next = [monkey3, monkey1]
    monkey3.next = [monkey5, monkey6]
    monkey4.next = [monkey7, monkey2]
    monkey5.next = [monkey0, monkey6]
    monkey6.next = [monkey4, monkey0]
    monkey7.next = [monkey2, monkey1]


    monkeys = [monkey0, monkey1, monkey2, monkey3, monkey4, monkey5, monkey6, monkey7]
    return monkeys

def get_monkey_business(rounds, part):
    monkeys = get_input()
    common_denominator = 1
    for monkey in monkeys:
        common_denominator *=monkey.test_div

    for round in range(rounds):
        for monkey in monkeys:
            monkey.inspect(common_denominator, part)

    print("items:")
    for monkey in monkeys:
            print(monkey.items)
    activity = [x.inspect_count for x in monkeys]

    print(f"activity: {activity}")
    activity.sort(reverse=True)
    monkey_business = activity[0] * activity[1]
    return monkey_business

print(f"Part 1, monkey_business: {get_monkey_business(20, 1)}\n\n")
print(f"Part 2, monkey_business: {get_monkey_business(10000, 2)}")