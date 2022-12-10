from __future__ import annotations
import re


class Dir:
    dir_list = []

    def __init__(self, name, parent: Dir = None):
        Dir.dir_list.append(self)
        self.content = {}
        self.name = name
        self.parent = parent
        self.size = 0

    def add_item(self, item):
        self.content[item.name] = item
        self._update_size(item.size)

    def _update_size(self, delta_size):
        self.size += delta_size
        if self.parent:
            self.parent._update_size(delta_size)


class File:
    def __init__(self, size, name):
        self.size = size
        self.name = name


root = Dir("")
current_dir = root
with open("day_7_input.txt") as f:
    while True:
        line = f.readline()
        if not line:
            break
        line = line.strip("\n")
        if line == "$ ls":
            continue
        elif line.startswith("$ cd "):
            new_paths = line[5:].split("/")
            for new_path in new_paths:
                if not new_path:
                    continue
                if new_path == "..":
                    current_dir = current_dir.parent
                else:
                    current_dir = current_dir.content[new_path]
        elif line.startswith("dir "):  # new dir
            current_dir.add_item(Dir(line[4:], current_dir))
        else:  # new file
            size_str, file_name = re.split(" ", line)
            current_dir.add_item(File(int(size_str), file_name))

total_size = 0
for dir in Dir.dir_list:
    if dir.size <= 100000:
        total_size += dir.size
print(f"Part 1, total size: {total_size}")

disk_space = 70000000
needed_space = 30000000
used_space = root.size
min_space_to_delete = used_space + needed_space - disk_space
best_candidate = root.size
for dir in Dir.dir_list:
    if best_candidate > dir.size >= min_space_to_delete:
        best_candidate = dir.size
print(f"Part 2, best candidate: {best_candidate}")
