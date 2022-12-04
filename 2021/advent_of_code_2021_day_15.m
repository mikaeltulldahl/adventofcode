%%input
clc
clear all

fileID = fopen('advent_of_code_2021_day_15_input.txt');
input = textscan(fileID, '%s');
fclose(fileID);

temp = cell2mat(input{1});
rows = size(temp,1);
cols = size(temp,2);
riskMap = zeros(rows, cols);

for row = 1:rows
    for col = 1:cols
        riskMap(row,col) = str2double(temp(row,col));
    end
end
originalState = riskMap;

%% part 1
bestRisk1 = bestPath(riskMap, [1,1], [rows,cols])

%% part 2
riskMap2 = riskMap;
riskMap2 = [riskMap2; riskMap2 + 1; riskMap2 + 2; riskMap2 + 3; riskMap2 + 4];
riskMap2 = [riskMap2, riskMap2 + 1, riskMap2 + 2, riskMap2 + 3, riskMap2 + 4];
riskMap2 = mod(riskMap2 - 1,9) + 1;

bestRisk2 = bestPath(riskMap2, [1,1], [5*rows,5*cols])

%% helper functions 
function totalCost = bestPath(riskLevel, start, finish)
% standard dijkstra
rows = size(riskLevel,1);
cols = size(riskLevel,2);
UNVISITED = inf;
costMatrix = inf(rows, cols);
costMatrix(start(1),start(2)) = 0;
toVisit = [start(1);start(2); 0; 0];%row; col; cost
% figure(1)
% clf;
% im = image(costMatrix(1:10,1:10));

neighbors = [1, 0, -1,  0;
             0, 1,  0, -1];
while costMatrix(finish(1),finish(2)) == UNVISITED
    useless = [];
    done = false;
    while ~done
        current = toVisit(1:2,1);
        currentCost = toVisit(3,1);
        toVisit(:,1) = [];
        if costMatrix(current(1),current(2)) < currentCost % there has been a better path found, and current is not usefull
            useless(:,end+1) = current; % this never happens
        else
            done = true;
        end
    end
    for i = 1:size(neighbors,2)
        temp = current + neighbors(:,i);
        if all(temp > 0) && temp(1) <= rows && temp(2) <= cols %valid coord
            cost = currentCost + riskLevel(temp(1),temp(2));
            if cost < costMatrix(temp(1),temp(2))
                toVisit(:,end+1) = [temp; cost; costMatrix(temp(1),temp(2)) == UNVISITED]; %#ok<AGROW>
                costMatrix(temp(1),temp(2)) = cost;
            end
        end
    end
    [~,I] = sort(toVisit(3,:));
    toVisit = toVisit(:,I);% sort toVisit based on lowest cost
    
    
    %plotting
    im = image(costMatrix(1:15,1:15));
%     im.CData = costMatrix(1:10,1:10);
    for i = 1:size(toVisit,2)
        plotSquare(toVisit(1,i), toVisit(2,i), toVisit(3,i), 0.3);
        if toVisit(4,i)%was unvisited
            plotSquare(toVisit(1,i), toVisit(2,i), 'green', 0.1);
        end
    end
    for i = 1:size(useless,2)
        plotSquare(useless(1,i), useless(2,i), 'cyan', 0.15);
    end
    plotSquare(current(1), current(2), 'red', 0.15);
%     colorbar
    caxis([0 50])
    drawnow
    pause(0.5);
end
totalCost = costMatrix(finish(1),finish(2));
figure(1)
heatmap(costMatrix);
drawnow;
end

function plotSquare(inX, inY, color, size)
x = [-size size size -size] + inX;
y = [-size -size size size] + inY;
p = patch(y, x,color);
p.CDataMapping = 'direct';
end