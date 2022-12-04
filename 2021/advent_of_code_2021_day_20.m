%%input
clc
clear all

fileID = fopen('advent_of_code_2021_day_20_input.txt');
% image enhancement algorithm = IEA
temp= textscan(fileID, '%s',1);
IEA = temp{1}{1};
IEA(IEA == '#') = '1';
IEA(IEA == '.') = '0';

temp2 = textscan(fileID, '%s');
inputImage = cell2mat(temp2{1});
inputImage(inputImage == '#') = '1';
inputImage(inputImage == '.') = '0';
fclose(fileID);

%% part 1
img = inputImage;
boarder = '0';
img = padImage(img, boarder, 1);
for n = 1:2
    [img, boarder] = enhanceImage(img, boarder, IEA);
end
sum(img == '1','all')

%% part 2
img = inputImage;
boarder = '0';
img = padImage(img, boarder, 1);
for n = 1:50
    [img, boarder] = enhanceImage(img, boarder, IEA);
end
sum(img == '1','all')


%% helper funtions
function [outImg, boarderOut] = enhanceImage(img, boarder, IEA)
img = padImage(img, boarder, 1);
[rows, cols] = size(img);
boarderOut = IEA(bin2dec(repmat(boarder, 1, 9)) + 1);
outImg = repmat(boarderOut, rows, cols);
for i = 2:(rows - 1)
    for j = 2:(cols - 1)
        binaryStr = [img(i-1,(j-1):(j+1)),...
                     img(  i,(j-1):(j+1)),...
                     img(i+1,(j-1):(j+1))];
        idx = bin2dec(binaryStr);
        outImg(i,j) = IEA(idx + 1);
    end
end
end

function out = padImage(in, padChar, padSize)
[rows, cols] = size(in);
out = [repmat(padChar, padSize, cols + 2*padSize);
       repmat(padChar, rows, padSize), in, repmat(padChar, rows, padSize);
       repmat(padChar, padSize, cols + 2*padSize)];
end


