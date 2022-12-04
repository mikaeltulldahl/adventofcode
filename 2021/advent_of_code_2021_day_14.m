%% input

clear all
clc
fileID = fopen('advent_of_code_2021_day_14_input.txt');
startStr = textscan(fileID, '%s', 1);
rules = textscan(fileID, '%c%c -> %c');
fclose(fileID);

%% part 1
polymer = startStr{1}{1};
diff = helper(polymer, rules, 10);

%% part 2
format long g
polymer = startStr{1}{1};
uniqueChars = sort(unique([polymer, rules{3}']));
K = length(uniqueChars);
uniquePairs = char([]); % every combination possible
for i = 1:K
    for j = 1:K
        uniquePairs(end+1,:) = [uniqueChars(i) uniqueChars(j)];
    end
end
N = size(uniquePairs,1);

%convert polymer to polymerChars
polymerChars = zeros(K,1);%count occurances of each unique char
for i = 1:K
    polymerChars(i) = sum(polymer == uniqueChars(i));
end
%convert polymer to polymerPairs
polymerPairs = zeros(N,1);%count how many occurances of each unique pair exist in polymer
for i = 1:length(polymer)-1
   pair = polymer(i:i+1);
   idx = pair2uniquePairIdx(pair, uniquePairs);
   polymerPairs(idx) = polymerPairs(idx) + 1;
end

%convert rules
%first col is if rule exist or not
%second col is idx for 1st new pair being created
%third col is idx for 2nd new pair being created
%fourth col is idx for new char being created
rulePairs = zeros(N,4);
for j = 1:length(rules{1})
   inRulePair = [rules{1}(j), rules{2}(j)];
   outRulePair1 = [rules{1}(j), rules{3}(j)];
   outRulePair2 = [rules{3}(j), rules{2}(j)];
   idx = pair2uniquePairIdx(inRulePair, uniquePairs);
   rulePairs(idx,1) = 1;
   rulePairs(idx,2) = pair2uniquePairIdx(outRulePair1, uniquePairs);
   rulePairs(idx,3) = pair2uniquePairIdx(outRulePair2, uniquePairs);
   rulePairs(idx,4) = find(uniqueChars == rules{3}(j));
end

%simulate
for i = 1:40
    deltaPairs = zeros(N,1);
    deltaChars = zeros(K,1);
    for j = 1:N
        currentCnt = polymerPairs(j);
        if rulePairs(j,1)%rule exist
            deltaPairs(j) = deltaPairs(j) - polymerPairs(j);%all pairs will go away
            deltaPairs(rulePairs(j,2)) = deltaPairs(rulePairs(j,2)) + polymerPairs(j);
            deltaPairs(rulePairs(j,3)) = deltaPairs(rulePairs(j,3)) + polymerPairs(j);
            deltaChars(rulePairs(j,4)) = deltaChars(rulePairs(j,4)) + polymerPairs(j);
        end
    end
    polymerPairs = polymerPairs + deltaPairs;
    polymerChars = polymerChars + deltaChars;
end
a = min(polymerChars)
b = max(polymerChars)
diff = b - a

%% helper functions

function idx = pair2uniquePairIdx(pair, uniquePairs)
N = size(uniquePairs,1);
idx = -1;
for j = 1:N
    if strcmp(pair, uniquePairs(j,:))
        idx = j;
        break;
    end
end
end

function diff = helper(polymer, rules, loops)
rulesCnt = length(rules{1});
for i = 1:loops
    idx = 1;
    while idx < length(polymer)
        insertChar = '';
        for j = 1:rulesCnt
            inRule = [rules{1}(j), rules{2}(j)];
            if strcmp(inRule, polymer(idx:idx + 1))
                insertChar = rules{3}(j);
                break;
            end
        end
        if isempty(insertChar)
            idx = idx + 1;
        else
            polymer = [polymer(1:idx) insertChar polymer(idx + 1:end)];
            idx = idx + 2;
        end
    end
    %     disp(polymer)
end

uniqueChars = unique(polymer);
uniqueCharsCnt = zeros(size(uniqueChars));
for j = 1:length(uniqueChars)
    uniqueCharsCnt(j) = sum(polymer == uniqueChars(j));
end
a = min(uniqueCharsCnt)
b = max(uniqueCharsCnt)
diff = b - a
end