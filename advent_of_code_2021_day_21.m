%% input
clear all
clc
startingPosition = [7, 3];

%% part 1
score = [0, 0];
position = startingPosition;
diceState = 0;
diceRolls = 0;
nextPlayer = 1;
maxScore = 1000;
while true
    [diceState, diceSum, diceRolls] = rollDiceDeterministic(diceState, diceRolls);
    position(nextPlayer) = mod(position(nextPlayer) + diceSum - 1, 10) + 1;
    score(nextPlayer) = score(nextPlayer) + position(nextPlayer);
    if all(score < maxScore)
        nextPlayer = mod(nextPlayer, 2) + 1;
    else
        break;
    end    
end
diceRolls * min(score)
%% part 2
% positionAndScore2variantMemoized = memoize(@positionAndScore2variant);
% positionAndScore2variantMemoized.CacheSize = 15000;
tic
universes = containers.Map;
universes(positionAndScore2variant(startingPosition(1), 0, startingPosition(2), 0, 1)) = 1;
wins = [0, 0];
keySet = keys(universes);
while ~isempty(keySet)
    universes.Count
    for i = 1:length(keySet)
        [position1, score1, position2, score2, currentPlayer] = variant2positionAndScore(keySet{i});
        count = universes(keySet{i});
        remove(universes,keySet{i});
        if currentPlayer == 1
            position = position1;
            score = score1;
        else %== 2
            position = position2;
            score = score2;
        end
        [position, score] = playRound(position, score);
        
        %remove duplicate variants
        [position,ia,ic] = unique(position);
        score = score(ia);
        positionCount = accumarray(ic,1).';
        
        nextPlayer = mod(currentPlayer, 2) + 1;
        for j = 1:length(position)
            if score(j) >= 21
                wins(currentPlayer) = wins(currentPlayer) + positionCount(j)*count;
            else
                if currentPlayer == 1
                    variant = positionAndScore2variant(position(j), score(j), position2, score2, nextPlayer);
                else %==2
                    variant = positionAndScore2variant(position1, score1, position(j), score(j), nextPlayer);
                end
                
                % add variant to map
                if isKey(universes,variant)
                    universes(variant) = universes(variant) + positionCount(j)*count;
                else
                    universes(variant) = positionCount(j)*count;
                end
            end
        end
    end
    keySet = keys(universes);
end
max(wins)
toc
function [position, score] = playRound(position, score)
for roll = 1:3
    position = [position + 1, position + 2, position + 3];
end
position = mod(position - 1, 10) + 1;
score = score + position;
end

function str = positionAndScore2variant(position1, score1, position2, score2, currentPlayer)
str = sprintf('%u %u %u %u %u', position1, score1, position2, score2, currentPlayer);
end

function [position1, score1, position2, score2, currentPlayer] = variant2positionAndScore(str)
temp = str2num(str); %#ok<ST2NM>
position1 = temp(1);
score1 = temp(2);
position2 = temp(3);
score2 = temp(4);
currentPlayer = temp(5);
end

function [state, diceSum, rolls] = rollDiceDeterministic(state, rolls)
diceSum = 0;
for i = 1:3
    state = mod(state, 100) + 1;
    diceSum = diceSum + state;
end
rolls = rolls + 3;
end