class Cpu:
    def __init__(self) -> None:
        self.cycle = 0
        self.x = 1
        self.sum = 0
        self.canvas = ["."]*6*40
    
    def step(self, post_change:int):
        horizontal = self.cycle % 40
        if self.x <= horizontal + 1 and self.x >= horizontal - 1:
            self.canvas[self.cycle] = "#"
        self.cycle +=1
        if self.time_to_sample():
            self.sum += self.cycle * self.x

        self.x += post_change
    
    def time_to_sample(self):
        return ((self.cycle - 20) % 40) == 0


cpu = Cpu()
with open("day_10_input.txt") as f:
    for line in f:
        if line.startswith("addx"):
            _, count = line.split(" ")
            cpu.step(0)
            cpu.step(int(count))
        elif line.startswith("noop"):
            cpu.step(0)
print(f"Part 1, cpu.sum: {cpu.sum}")
print(f"Part 2, cpu.canvas: {''.join(cpu.canvas[0:39])}")
print(f"                    {''.join(cpu.canvas[40:79])}")
print(f"                    {''.join(cpu.canvas[80:119])}")
print(f"                    {''.join(cpu.canvas[120:159])}")
print(f"                    {''.join(cpu.canvas[160:199])}")
print(f"                    {''.join(cpu.canvas[200:239])}")
    