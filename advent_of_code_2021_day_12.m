%% input

clear all
clc
fileID = fopen('advent_of_code_2021_day_12_input.txt');
input = textscan(fileID, '%s%s', 'Delimiter', '-');
fclose(fileID);

T = length(input{1,1});
nodes = unique([input{1,1}; input{1,2}])
N = length(nodes);
transitions = zeros(T, 2);


for i = 1:T
    transitions(i,1) = find(strcmp(input{1,1}{i}, nodes));
    transitions(i,2) = find(strcmp(input{1,2}{i}, nodes));
end

transitions = [transitions; transitions(:,2),transitions(:,1)];%%add opposite direction transitions


startIdx = find(strcmp('start', nodes))
endIdx = find(strcmp('end', nodes))
transitions(transitions(:,2) == startIdx,:) = []; %remove transitions to start
transitions(transitions(:,1) == endIdx,:) = []; %remove transitions from end
transitions

isBig = false(N,1);
for i = 1:N
    isBig(i) = all(isstrprop(nodes{i},'upper'));
end
isBig

%% part 1
paths = findPath(startIdx, [], transitions, endIdx, isBig, true);
length(paths)
% for i = 1:length(paths)
%    disp(nodes(paths{i})')
% end

%% part 2
paths = findPath(startIdx, [], transitions, endIdx, isBig, false);
length(paths)
% for i = 1:length(paths)
%    disp(nodes(paths{i})')
% end

%% helper function
function paths = findPath(currentNode, currentPath, transitions, endIdx, isBig, visitedTwice)
SRC = 1;
DST = 2;

if ~visitedTwice && ~isBig(currentNode) && any(currentPath==currentNode)
    visitedTwice = true;
    for node = currentPath
        if ~isBig(node)
            transitions(transitions(:,DST) == node,:) = []; %remove transitions to node
        end
    end
end
if visitedTwice && ~isBig(currentNode)
    transitions(transitions(:,DST) == currentNode,:) = []; %remove transitions to currentNode
end
currentPath = [currentPath, currentNode];
paths = {};
transitionsAvailable = transitions(transitions(:,SRC) == currentNode, :); %only consider transitions from this node
for i = 1: size(transitionsAvailable, 1)
    transition = transitionsAvailable(i,:);
    if transition(DST) == endIdx
        childPaths = [currentPath, transition(DST)];
        paths = [paths; childPaths]; %#ok<AGROW>
    else
        childPaths = findPath(transition(DST), currentPath, transitions, endIdx, isBig, visitedTwice);
        if ~isempty(childPaths)
            paths = [paths; childPaths]; %#ok<AGROW>
        end
    end
end
end