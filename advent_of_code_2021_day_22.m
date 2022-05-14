%%input
clc
clear all

fileID = fopen('advent_of_code_2021_day_22_input.txt');
temp= textscan(fileID, '%s x=%d%d,y=%d%d,z=%d%d', 'Delimiter',{' ','.'});
fclose(fileID);
%example input:
%on x=-28..16,y=-48..0,z=-7..44
onOff = strcmp('on', temp{1,1});
xMin = temp{1,2};
xMax = temp{1,3};
yMin = temp{1,4};
yMax = temp{1,5};
zMin = temp{1,6};
zMax = temp{1,7};
input = int64([cell2mat(temp(1,2:7)), int32(onOff)]);
N = length(xMin);
%% part 
tic
cube1 = false(101,101,101);
for i = 1:N
    [xMin2, xMinOutside] = coord2idx(xMin(i));
    [xMax2, xMaxOutside] = coord2idx(xMax(i));
    [yMin2, yMinOutside] = coord2idx(yMin(i));
    [yMax2, yMaxOutside] = coord2idx(yMax(i));
    [zMin2, zMinOutside] = coord2idx(zMin(i));
    [zMax2, zMaxOutside] = coord2idx(zMax(i));
    if (xMinOutside && xMaxOutside)...
        || (yMinOutside && yMaxOutside)...
        || (zMinOutside && zMaxOutside)
        %do nothing
    else
        cube1(xMin2:xMax2,yMin2:yMax2,zMin2:zMax2) = onOff(i);
    end
end
sum(cube1,'all')
toc

%% part 2
format long g
cube2 = [];%[xMin, xMax, yMin, yMax, zMin, zMax, value]
tic
for i = 1:N
    i
    newCube = input(i,:);
    deltaCubes = [];
    for j = 1:size(cube2,1) %check overlap with every cube2
        [overlapRangeX, isOverlappingX] = findOverlap(newCube(1:2), cube2(j, 1:2));
        [overlapRangeY, isOverlappingY] = findOverlap(newCube(3:4), cube2(j, 3:4));
        [overlapRangeZ, isOverlappingZ] = findOverlap(newCube(5:6), cube2(j, 5:6));
        if isOverlappingX && isOverlappingY && isOverlappingZ
            % existing 1, new 1 -> overlap -1
            % existing 1, new 0 -> overlap -1
            % existing -1, new 1 -> overlap 1
            % existing -1, new 0 -> overlap 1
            overlapValue = -cube2(j,7);
            deltaCubes(end+1,:) = [overlapRangeX, overlapRangeY, overlapRangeZ, overlapValue]; %#ok<SAGROW>
        end
    end
    cube2 = [cube2; deltaCubes]; %#ok<AGROW>
    if newCube(7)
        cube2 = [cube2; newCube]; %#ok<AGROW>
    end
%     sum2 = totalVolume2(cube2)
end
toc
sum2 = totalVolume2(cube2)

%%helper functions
function sum2 = totalVolume2(cube2)
sum2 = 0;
for i = 1:size(cube2,1)
    cubeVolume = (cube2(i,2)- cube2(i,1) + 1)*... %xRange
                (cube2(i,4)- cube2(i,3) + 1)*... %yRange
                (cube2(i,6)- cube2(i,5) + 1); %zRange
    sum2 = sum2 + cubeVolume * cube2(i,7);
end
end

function [overlapRange, isOverlapping] = findOverlap(inRange1, inRange2)
if inRange1(2) < inRange2(1)... % 1 below 2
        || inRange1(1) > inRange2(2) % 2 below 1
    isOverlapping = false;
    overlapRange = [];
else
    isOverlapping = true;
    temp = sort([inRange1, inRange2]);
    overlapRange = temp(2:3);
end
end

function [out, outside] = coord2idx(in)
if in < -50
    out = -50 + 51;
    outside = true;
elseif in > 50
    out = 50 + 51;
    outside = true;
else
    out = in + 51;
    outside = false;
end
end