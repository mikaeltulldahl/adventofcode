%% input

clear all
clc
fileID = fopen('advent_of_code_2021_day_10_input.txt');
temp = textscan(fileID, '%s');
fclose(fileID);
input = temp{1};
N = length(input);

%% part 1
points = 0;
for i = 1:N
    [corrupted, incomplete, invalidChar, ~] = validateExp(input{i});
    if corrupted
        switch invalidChar
            case ')'
                points = points + 3;
            case ']'
                points = points + 57;
            case '}'
                points = points + 1197;
            case '>'
                points = points + 25137;
            otherwise
        end
    end
end
points

%% part 2
format long g
points2 = [];
for i = 1:N
    [corrupted, incomplete, ~, completionString] = validateExp(input{i});
    if incomplete
        tempPoints = 0;
        for j = 1:length(completionString)
            tempPoints = 5*tempPoints;
            switch completionString(j)
                case ')'
                    tempPoints = tempPoints + 1;
                case ']'
                    tempPoints = tempPoints + 2;
                case '}'
                    tempPoints = tempPoints + 3;
                case '>'
                    tempPoints = tempPoints + 4;
                otherwise
            end
        end
        points2(end+1) = tempPoints; %#ok<SAGROW>
    end
end
median(points2)

%% helper functions

function [corrupted, incomplete, invalidChar, completionString] = validateExp(in)
corrupted = false;
incomplete = false;
completionString = [];
invalidChar = '';
%if is opening bracket
% followed by opening bracket -> parse inside
stack = char(zeros(size(in)));
stackLength = 0;
for i = 1:length(in)
    [isOpening, closingBracket] = isOpeningBracket(in(i));
    if isOpening
        stackLength = stackLength + 1;
        stack(stackLength) = closingBracket;
    else % is closing
        if stackLength == 0 || stack(stackLength) ~= in(i)
            corrupted = true;
            invalidChar = in(i);
            break;
        else % matching last pushed bracket
            stackLength = stackLength - 1; % pop stack
        end
    end
end
if ~corrupted && stackLength ~= 0
    completionString = flip(stack(1:stackLength));
    incomplete = true;
end
end

function [corrupted, incomplete, idx] = validateExpRecursive(in, idx)
corrupted = false;
incomplete = false;
%if is opening bracket
% followed by opening bracket -> parse inside
[isOpening, closingBracket] = isOpeningBracket(in(idx));
if ~isOpening || idx == length(in)
    incomplete = true;
else % we are opening and there are more chars, thus possible to close and complete
    [isOpening, ~] = isOpeningBracket(in(idx + 1));
    if isOpening
        [corrupted, incomplete, idx] = validateExpRecursive(in, idx + 1);
    end
        
end

end

function [out, closingBracket] = isOpeningBracket(in)
switch in
    case '['
        closingBracket = ']';
        out = true;
    case '('
        closingBracket = ')';
        out = true;
    case '{'
        closingBracket = '}';
        out = true;
    case '<'
        closingBracket = '>';
        out = true;
    otherwise
        closingBracket = '';
        out = false;
end
end