import re


class Dir:
    def __init__(self, name, parent):
        self.content = {}
        self.name = name
        self.parent = parent
        self.size = 0


class File:
    def __init__(self, size, name):
        self.size = size
        self.name = name


root = Dir("", None)
current_dir = root
with open("day_7_input.txt") as f:
    while True:
        line = f.readline()
        if not line:
            break
        line = line.strip("\n")
        #print(line)
        if line == "$ ls":
            continue
        elif line.startswith("$ cd "):
            new_paths = line[5:].split("/")
            for new_path in new_paths:
                if not new_path:
                    continue
                #print(f"cd to {new_path}")
                if new_path == "..":
                    current_dir = current_dir.parent
                else:
                    current_dir = current_dir.content[new_path]
        elif line.startswith("dir "):  # new dir
            new_dir = Dir(line[4:], current_dir)
            current_dir.content[new_dir.name] = new_dir
        else:  # new file
            size_str, file_name = re.split(" ", line)
            new_file = File(int(size_str), file_name)
            current_dir.content[new_file.name] = new_file


def update_dir_size(dir):
    global total_size
    dir_list.append(dir)
    dir.size = 0
    for item in dir.content.values():
        if isinstance(item, Dir):
            update_dir_size(item)
        dir.size += item.size
    #print(f"dir: {dir.name}, with size: {dir.size}")
    if dir.size <= 100000:
        total_size+=dir.size

total_size = 0
dir_list = []
update_dir_size(root)
print(f"Part 1, total size: {total_size}")

disk_space = 70000000
needed_space = 30000000
used_space = root.size
min_space_to_delete = used_space + needed_space - disk_space
best_candidate = root.size
for dir in dir_list:
    if best_candidate > dir.size >= min_space_to_delete:
        best_candidate = dir.size
print(f"Part 2, best candidate: {best_candidate}")