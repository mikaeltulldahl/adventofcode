%% input
clear all
clc
fileID = fopen('advent_of_code_2021_day_3_input.txt');
temp = textscan(fileID, '%s ');
input = cell2mat(temp{1});
rows = size(input,1); % number of input lines
cols = size(input,2); %number of bits

fclose(fileID);
%% Part 1
gamma = '';
epsilon = '';

for col = 1:cols
    [mostCommon, leastCommon] = mostLeastCommonBit(input, col);
    gamma = [gamma, mostCommon]; %#ok<AGROW>
    epsilon = [epsilon, leastCommon]; %#ok<AGROW>
end

gammaDec = bin2dec(gamma)
epsilonDec = bin2dec(epsilon)
out = gammaDec * epsilonDec
%% Part 2
% find oxygen
inputCopy = input;
for col = 1:cols
    [mostCommon, ~] = mostLeastCommonBit(inputCopy, col, '1');
    matchIdx = inputCopy(:,col) == mostCommon;
    inputCopy = inputCopy(matchIdx,:);
    if size(inputCopy,1) == 1
        break;
    end
end

oxygenDec = bin2dec(inputCopy)

% find carbon
inputCopy = input;
for col = 1:cols
    [~, leastCommon] = mostLeastCommonBit(inputCopy, col, '0');
    matchIdx = inputCopy(:,col) == leastCommon;
    inputCopy = inputCopy(matchIdx,:);
    if size(inputCopy,1) == 1
        break;
    end
end
carbonDec = bin2dec(inputCopy)

oxygenDec * carbonDec

%% helper functions
function [mostCommon, leastCommon] = mostLeastCommonBit(input, col, default)
rows = size(input,1); % number of input lines
oneCount = 0;
for row = 1:rows
    if input(row,col) == '1'
        oneCount = oneCount + 1;
    end
end
zeroCount = rows - oneCount;
if oneCount == zeroCount
    mostCommon = default;
    leastCommon = default;
elseif oneCount > zeroCount
    mostCommon = '1';
    leastCommon = '0';
else
    mostCommon = '0';
    leastCommon = '1';
end
end