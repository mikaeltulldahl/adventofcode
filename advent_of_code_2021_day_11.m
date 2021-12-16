%%input
clc
clear all
temp = num2str([
5665114554
4882665427
6185582113
7762852744
7255621841
8842753123
8225372176
7212865827
7758751157
1828544563]);

state = zeros(10, 10);
rows = size(state,1);
cols = size(state,2);
for row = 1:rows
    for col = 1:cols
        state(row,col) = str2double(temp(row,col));
    end
end
originalState = state;

%% part 1
state = originalState;
total = 0;
for i = 1:100
    state = flashOctopus(state);
    total = total + sum(state==0, 'all');
end
total

%% part 2
state = originalState;
idx = 1;
while true
    state = flashOctopus(state);
    if all(state == 0,'all')
        break;
    else
        idx = idx + 1;
    end
end
idx

%% helper funtions

function state = flashOctopus(state)
rows = size(state,1);
cols = size(state,2);
state = state + ones(rows,cols);
while true
    newFlashes = state > 9;
    [flashedRows, flashedCols] = find(newFlashes);
    if isempty(flashedRows)
        break;
    else
        patternRows = [0, 1, 1,  1,  0,  -1, -1, -1];
        patternCols = [1, 1, 0, -1  -1,  -1,  0,  1];
        for j = 1:length(flashedRows)
            for k = 1:length(patternRows)
                row = flashedRows(j) + patternRows(k);
                col = flashedCols(j) + patternCols(k);
                if row > 0 && row <= rows && col > 0 && col <= cols && state(row,col) > 0
                    state(row,col) = state(row,col) + 1;
                end
            end
        end
        state(newFlashes) = 0;
    end
end
end