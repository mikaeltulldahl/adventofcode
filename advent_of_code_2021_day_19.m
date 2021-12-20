%%input
clc
clear all

fileID = fopen('advent_of_code_2021_day_19_input.txt');
beacons = {};
scannerId = [];
idx = 1;
while true
    scannerTemp = textscan(fileID, '--- scanner %d ---', 1);
    if isempty(scannerTemp{1})
        break;
    end
    scannerId(idx) = cell2mat(scannerTemp); %#ok<SAGROW>
    beacons{idx}= double(cell2mat(textscan(fileID, '%d,%d,%d')))'; %#ok<SAGROW>
    idx = idx + 1;
end
fclose(fileID);

%% part 1
R = allOrientations();
S = length(scannerId);
aligned = false(S,1);
aligned(1) = true;
validBeacons = beacons{1};
validScanners = [0;0;0];
while ~all(aligned)
    for i = 2:S %for each scanner after scanner 0
        if aligned(i)
            continue;
        end
        for m = 1:size(R,3)% for all 24 orientations
            if aligned(i)
                break;
            end
            rotBeacons = R(:,:,m) * beacons{i};
            for j = 1:(size(validBeacons,2)-11) %for each beacon in scanner 0
                %we can skip the last 11 beacons because if we haven't got
                %a match after n-12 nodes, there will not be 12 nodes left
                %to match anyway
                if aligned(i)
                    break;
                end
                for k = 1:(size(rotBeacons,2)-11) % each beacon in scanner i
                    deltaPos = rotBeacons(:,k) - validBeacons(:,j);
                    rotTransBeacons = rotBeacons - deltaPos;
                    %check matching beacons
                    mergeBeacons = [validBeacons, rotTransBeacons];
                    mergeBeacons2 = unique(mergeBeacons', 'rows','stable')';
                    if (size(mergeBeacons,2) - size(mergeBeacons2,2)) >= 12 % at least 12 overlaping beacons -> match!
                        validBeacons = mergeBeacons2;
                        validScanners(:,end+1) = -deltaPos; %#ok<SAGROW>
                        aligned(i) = true;
                        break;
                    end
                end
            end
        end
    end
end
size(validBeacons,2)

%% part 2
manhattanDistance = zeros(S,S);
for i = 1:S
    for j = 1:S
        manhattanDistance(i,j) = sum(abs(validScanners(:,i) - validScanners(:,j)));
    end
end
max(manhattanDistance,[],'all')

%% helper funtions
function R = allOrientations()
R = zeros(3,3,64);
idx = 1;
for i = 1:4
    for j = 1:4
        for k = 1:4
            R(:,:,idx) = xrot((i-1)*pi/2)*yrot((j-1)*pi/2)*zrot((k-1)*pi/2);
            idx = idx + 1;
        end
    end
end
R = round(R);% remove round-off errors from rotations

%remove duplicate orientations
a = reshape(R,3,[],1);
b = reshape(a(:),3*3,[])';
c = unique(b,'rows','stable')';
R = reshape(c,3,3,[]);
end

function mat = xrot(ag) 
cosa = cos(ag);
sina = sin(ag);
mat = [1,    0,     0;
       0, cosa, -sina; 
       0, sina,  cosa];
end

function mat = yrot(ag) 
cosa = cos(ag);
sina = sin(ag);
mat = [cosa,    0, sina;
          0,    1,    0; 
      -sina,    0, cosa];
end

function mat = zrot(ag) 
cosa = cos(ag);
sina = sin(ag);
mat = [cosa, -sina,    0;
       sina,  cosa,    0;
          0,     0,    1];
end