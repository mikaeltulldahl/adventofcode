%% input

clear all
clc
fileID = fopen('advent_of_code_2021_day_9_input.txt');
temp = textscan(fileID, '%s');
fclose(fileID);

height = zeros(length(temp{1}), length(temp{1}{1}));
rows = size(height,1);
cols = size(height,2);
for row = 1:rows
    for col = 1:cols
        height(row,col) = str2double(temp{1}{row}(col));
    end
end

%% part 1

hDeltaRows = diff(height, 1, 1);
hDeltaCols = diff(height, 1, 2);
cond1 = [hDeltaCols ones(rows,1)] > 0;
cond2 = [-ones(rows,1) hDeltaCols] < 0;
cond3 = [hDeltaRows; ones(1, cols)] > 0;
cond4 = [-ones(1, cols); hDeltaRows] < 0;

pits = cond1 & cond2 & cond3 & cond4;
sum(pits .* (height + 1),'all')

%% part 2
[pitRow,pitCol] = find(pits);
pitN = length(pitRow);
basinSize = zeros(pitN,1);
global basin
for i = 1:pitN
    basin = zeros(rows, cols);
    floodfill(pitRow(i), pitCol(i), rows, cols, height);
    basinSize(i) = sum(basin,'all');
end

basinSize = sort(basinSize, 'descend');
basinSize(1)*basinSize(2)*basinSize(3) %#ok<NOPTS>

%% helper functions
function floodfill(row, col, rows, cols, height)
global basin
if row < 1 || row > rows || col < 1 || col > cols 
    return %invalid coord
end
if basin(row, col) == 1
    return % already visited
end
if height(row, col) == 9
    return % not in basin
else
    basin(row, col) = 1; % add to basin, and fill neighbors if valid
    floodfill(row + 1, col, rows, cols, height);
    floodfill(row - 1, col, rows, cols, height);
    floodfill(row, col + 1, rows, cols, height);
    floodfill(row, col - 1, rows, cols, height);
end
end
