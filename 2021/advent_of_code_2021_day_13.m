%% input

clear all
clc
fileID = fopen('advent_of_code_2021_day_13_input.txt');
temp = textscan(fileID, '%u,%u');
folds = textscan(fileID, 'fold along %s%u','Delimiter', '=');

fclose(fileID);

inputCol = double(temp{1,1}) + 1;
inputRow = double(temp{1,2}) + 1;
rows = 1 + 2*double(folds{2}(2));%max(inputRow);
cols = 1 + 2*double(folds{2}(1));%max(inputCol);
input = false(rows,cols);
for i = 1:length(inputCol)
   input(inputRow(i), inputCol(i)) = true; 
end
% disp(input)

%% part 1
foldLine = double(folds{2}(1));
part1Result = input;
if folds{1}{1} == 'y'
    remainPart = part1Result(1:foldLine,:);
    foldPart = part1Result(foldLine + 2:end,:);
    part1Result = remainPart | flip(foldPart,1);
else % == 'x'
    remainPart = part1Result(:,1:foldLine);
    foldPart = part1Result(:,foldLine + 2:end);
    part1Result = remainPart | flip(foldPart,2);
end
% disp(part1Result)
sum(part1Result,'all')

%% part 2
part2Result = input;
for i = 1:length(folds{2})
    foldLine = double(folds{2}(i));
    if folds{1}{i} == 'y'
        remainPart = part2Result(1:foldLine,:);
        foldPart = part2Result(foldLine + 2:end,:);
        part2Result = remainPart | flip(foldPart,1);
    else % == 'x'
        remainPart = part2Result(:,1:foldLine);
        foldPart = part2Result(:,foldLine + 2:end);
        part2Result = remainPart | flip(foldPart,2);
    end
end
disp(char(double(part2Result)))
% spells out HZKHFEJZ
