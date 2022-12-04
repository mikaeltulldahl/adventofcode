%%input
clc
clear all

fileID = fopen('advent_of_code_2021_day_25_input.txt');
temp = textscan(fileID, '%s');
fclose(fileID);

input = cell2mat(temp{1,1});
rows = size(input,1);
cols = size(input,2);
east = '>';
south = 'v';
space = '.';
%% part 1
cucumbers = input;
steps = 0;
while true
    startCucumbers = cucumbers;
    %move east
    cucumbersOut = cucumbers;
    eastCucumbers = cucumbers == east;
    [eastRows, eastCols] = find(eastCucumbers);
    for i = 1:length(eastRows)
        nextCol = mod(eastCols(i),cols) + 1;
        if cucumbers(eastRows(i), nextCol) == space
            %move east
            cucumbersOut(eastRows(i), eastCols(i)) = space;
            cucumbersOut(eastRows(i), nextCol) = east;
        end
    end
    cucumbers = cucumbersOut;
   
    %move south
    southCucumbers = cucumbers == south;
   [southRows, southCols] = find(southCucumbers);
    for i = 1:length(southRows)
        nextRow = mod(southRows(i),rows) + 1;
        if cucumbers(nextRow, southCols(i)) == space
            %move south
            cucumbersOut(southRows(i), southCols(i)) = space;
            cucumbersOut(nextRow, southCols(i)) = south;
        end
    end
    cucumbers = cucumbersOut;
    steps = steps + 1;
    if all(cucumbers == startCucumbers, 'all')
        break;
    end
end
steps
