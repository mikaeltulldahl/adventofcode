%% input
clear all
clc
fileID = fopen('advent_of_code_2021_day_16_input.txt');
temp = textscan(fileID, '%s');
input = temp{1}{1};
fclose(fileID);

%% part 1 & part 2
format long g
inBits = hex2bin(input);
idx = 1;
[valueDec, idx, versionSum] = parsePackage(inBits, idx);
versionSum
valueDec


%% helper functions

function outBin = hex2bin(inHex)
outBin = char(zeros(1, length(inHex)*4));
for i = 1:length(inHex)
    outBin(i*4-3:i*4) = dec2bin(hex2dec(inHex(i)), 4);
end
end

function [valueDec, idx, versionSum] = parsePackage(inBits, idx)
[version, typeID, idx] = parseHeader(inBits, idx);
versionSum = version;
if typeID == 4 % literal value
    [valueDec, idx] = parseLiteral(inBits, idx);
else % operator
    [valueDec, idx, versionSumTemp] = parseOperator(inBits, idx, typeID);
    versionSum = versionSum + versionSumTemp;
end
end

function [valueDec, idx] = parseLiteral(inBits, idx)
valueBin = char([]);
done = false;
while ~done 
    done = inBits(idx) == '0';
    idx = idx + 1;
    valueBin = [valueBin, inBits(idx:idx+3)]; %#ok<AGROW>
    idx = idx + 4;
end
valueDec = bin2dec(valueBin);
end

function [valueDec, idx, versionSum] = parseOperator(inBits, idx, typeID)
versionSum = 0;
lengthTypeID = inBits(idx);
idx = idx + 1;
valueDecSubPackets = [];
if lengthTypeID == '0'
    subPacketLength = bin2dec(inBits(idx:idx + 14));
    idx = idx + 15;
    
    stopIdx = idx + subPacketLength;
    %parse sub-packets
    while idx < stopIdx
        [valueDecTemp, idx, versionSumTemp] = parsePackage(inBits, idx);
        versionSum = versionSum + versionSumTemp;
        valueDecSubPackets(end+1) = valueDecTemp; %#ok<AGROW>
    end
else % == '1'
    numberOfPackets = bin2dec(inBits(idx:idx + 10));
    idx = idx + 11;
    %parse sub-packets
    for i = 1:numberOfPackets
        [valueDecTemp, idx, versionSumTemp] = parsePackage(inBits, idx);
        versionSum = versionSum + versionSumTemp;
        valueDecSubPackets(end+1) = valueDecTemp; %#ok<AGROW>
    end
end

switch typeID
    case 0 %sum
        valueDec = sum(valueDecSubPackets);
    case 1 %product
        valueDec = prod(valueDecSubPackets);
    case 2 %minimum
        valueDec = min(valueDecSubPackets);
    case 3 %maximum
        valueDec = max(valueDecSubPackets);
    case 5 %greater than
        valueDec = double(valueDecSubPackets(1) > valueDecSubPackets(2));
    case 6 %less than
        valueDec = double(valueDecSubPackets(1) < valueDecSubPackets(2));
    case 7 %equal to
        valueDec = double(valueDecSubPackets(1) == valueDecSubPackets(2));
end
end

function [version, typeID, idx] = parseHeader(inBits, idx)
version = bin2dec(inBits(idx:idx + 2));
typeID = bin2dec(inBits(idx + 3:idx + 5));
idx = idx + 6;
end
