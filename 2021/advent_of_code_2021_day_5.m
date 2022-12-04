%% input
clear all
clc
fileID = fopen('advent_of_code_2021_day_5_input.txt');
temp = textscan(fileID, '%u,%u -> %u,%u');

x1 = double(temp{1}) + 1;
y1 = double(temp{2}) + 1;
x2 = double(temp{3}) + 1;
y2 = double(temp{4}) + 1;

fclose(fileID);

xMax = max([x1;x2]);
yMax = max([y1;y2]);

%% part 1
field = zeros(xMax, yMax);
for i = 1:length(x1)
    xRange = min(x1(i), x2(i)) : max(x1(i), x2(i));
    yRange = min(y1(i), y2(i)) : max(y1(i), y2(i));
    if x1(i)== x2(i) || y1(i) == y2(i)  %only parse row and col-shaped lines
        field(xRange, yRange) = field(xRange, yRange) + 1;
    end
end

 sum(field > 1,'all')
 
 %% part 2
field = zeros(xMax, yMax);
for i = 1:length(x1)
    if x1(i) <= x2(i)
        xRange = x1(i) : x2(i);
    else
        xRange = x1(i) :-1: x2(i);
    end
    if y1(i) <= y2(i)
        yRange = y1(i) : y2(i);
    else
        yRange = y1(i) :-1: y2(i);
    end
    if y1(i) == y2(i)
        for x = xRange
            field(x, y1(i)) = field(x, y1(i)) + 1;
        end
    elseif x1(i)== x2(i)
        for y = yRange
            field(x1(i), y) = field(x1(i), y) + 1;
        end
    else %diagonal line
        for j = 1:length(xRange)
            x = xRange(j);
            y = yRange(j);
            field(x, y) = field(x, y) + 1;
        end
    end
end

 sum(field > 1,'all')