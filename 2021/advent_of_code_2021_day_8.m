%% input
clear all
clc
fileID = fopen('advent_of_code_2021_day_8_input.txt');
input = textscan(fileID, '%s %s %s %s %s %s %s %s %s %s | %s %s %s %s');
fclose(fileID);

N = length(input{1});
%% part 1

% 0 -> 6
% 1 -> 2
% 2 -> 5
% 3 -> 5
% 4 -> 4
% 5 -> 5
% 6 -> 6
% 7 -> 3
% 8 -> 7
% 9 -> 6

% 1 -> 2
% 7 -> 3
% 4 -> 4
% 2 -> 5
% 3 -> 5
% 5 -> 5
% 0 -> 6
% 6 -> 6
% 9 -> 6
% 8 -> 7

cnt = 0;
for i = 1:N
    for j = 11:14
        tempLength = length(input{j}{i});
        if tempLength ~= 5 && tempLength ~= 6
            cnt = cnt + 1;
        end
    end
end
cnt

%% part 2
%   0:      1:      2:      3:      4:
%  aaaa    ....    aaaa    aaaa    ....
% b    c  .    c  .    c  .    c  b    c
% b    c  .    c  .    c  .    c  b    c
%  ....    ....    dddd    dddd    dddd
% e    f  .    f  e    .  .    f  .    f
% e    f  .    f  e    .  .    f  .    f
%  gggg    ....    gggg    gggg    ....
% 
%   5:      6:      7:      8:      9:
%  aaaa    aaaa    aaaa    aaaa    aaaa
% b    .  b    .  .    c  b    c  b    c
% b    .  b    .  .    c  b    c  b    c
%  dddd    dddd    ....    dddd    dddd
% .    f  e    f  .    f  e    f  .    f
% .    f  e    f  .    f  e    f  .    f
%  gggg    gggg    ....    gggg    gggg

%     a  b  c  d  e  f  g
% 0 = 1, 1, 1, 0, 1, 1, 1
% 1 = 0, 0, 1, 0, 0, 1, 0
% 2 = 1, 0, 1, 1, 1, 0, 1
% 3 = 1, 0, 1, 1, 0, 1, 0
% 4 = 0, 1, 1, 1, 0, 1, 0
% 5 = 1, 1, 0, 1, 0, 1, 1
% 6 = 1, 1, 0, 1, 1, 1, 1
% 7 = 1, 0, 1, 0, 0, 1, 0
% 8 = 1, 1, 1, 1, 1, 1, 1
% 9 = 1, 1, 1, 1, 0, 1, 1

% segment occurances
% a : 0, 2, 3, 5, 6, 7, 8, 9
% b : 0, 4, 5, 6, 8, 9
% c : 0, 1, 2, 3, 4, 7, 8, 9
% d : 2, 3, 4, 5, 6, 8, 9
% e : 0, 2, 6, 8
% f : 0, 1, 3, 4, 5, 6, 7, 8, 9
% g : 0, 2, 3, 5, 6, 8, 9

% deduction: 
% find b, e, f from number of occurances
% find c in number 1, only one with 2 seg
% find a in number 7, only one with 3 seg
% find d in number 4, only one with 4 seg
% remaining: g

outputValues = zeros(N,1);
for i = 1:N
    M = char(zeros(1,7)); %map from scrambled to unscrabled chars
    %find count of a-g on this row
    count = zeros(7,1);
    lengths = zeros(10,1);
    for j = 1:10
        tempStr = input{j}{i};
        lengths(j) = length(tempStr);
        for k = 1:length(tempStr)
            charIdx = char2num(tempStr(k));
            count(charIdx) = count(charIdx) + 1;
        end
    end
    M(count == 6) = 'b';
    M(count == 4) = 'e';
    M(count == 9) = 'f';
    oneStr = input{lengths == 2}{i};
    sevenStr = input{lengths == 3}{i};
    fourStr = input{lengths == 4}{i};
    
    keySet = num2char(find(M~=0));
    M(char2num(oneStr(~ismember(oneStr,keySet)))) = 'c';
    keySet = num2char(find(M~=0));
    M(char2num(sevenStr(~ismember(sevenStr,keySet)))) = 'a';
    keySet = num2char(find(M~=0));
    M(char2num(fourStr(~ismember(fourStr,keySet)))) = 'd';
    
    M(M==0) = 'g';
    
    for j = 11:14
        tempStr = input{j}{i};
        unscrambledStr = M(char2num(tempStr));
        digit = seg2digit(unscrambledStr);
        outputValues(i) = outputValues(i) + digit*10^(14-j);
    end
end
answer = sum(outputValues)


function out = char2num(in)
%maps a -> 1, b -> 2 etc
out = 1 + double(cast(in,'int8') - cast('a','int8'));
end

function out = num2char(in)
out = cast(cast(in - 1, 'int8') + cast('a','int8'),'char');
end

function digit = seg2digit(inSeg)
%   0:      1:      2:      3:      4:
%  aaaa    ....    aaaa    aaaa    ....
% b    c  .    c  .    c  .    c  b    c
% b    c  .    c  .    c  .    c  b    c
%  ....    ....    dddd    dddd    dddd
% e    f  .    f  e    .  .    f  .    f
% e    f  .    f  e    .  .    f  .    f
%  gggg    ....    gggg    gggg    ....
% 
%   5:      6:      7:      8:      9:
%  aaaa    aaaa    aaaa    aaaa    aaaa
% b    .  b    .  .    c  b    c  b    c
% b    .  b    .  .    c  b    c  b    c
%  dddd    dddd    ....    dddd    dddd
% .    f  e    f  .    f  e    f  .    f
% .    f  e    f  .    f  e    f  .    f
%  gggg    gggg    ....    gggg    gggg
%          0         1     2        3        4       5        6         7      8          9
segList = {'abcefg', 'cf', 'acdeg', 'acdfg', 'bcdf', 'abdfg', 'abdefg', 'acf', 'abcdefg', 'abcdfg'};
for i = 1:length(segList)
    if isempty(setxor(segList{i}, inSeg))
        digit = i-1;
        break;
    end
end
end