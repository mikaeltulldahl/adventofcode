%% input
clear all;
clc
initFish = [1,2,5,1,1,4,1,5,5,5,3,4,1,2,2,5,3,5,1,3,4,1,5,2,5,1,4,1,2,2,1,5,1,1,1,2,4,3,4,2,2,4,5,4,1,2,3,5,3,4,1,1,2,2,1,3,3,2,3,2,1,2,2,3,1,1,2,5,1,2,1,1,3,1,1,5,5,4,1,1,5,1,4,3,5,1,3,3,1,1,5,2,1,2,4,4,5,5,4,4,5,4,3,5,5,1,3,5,2,4,1,1,2,2,2,4,1,2,1,5,1,3,1,1,1,2,1,2,2,1,3,3,5,3,4,2,1,5,2,1,4,1,1,5,1,1,5,4,4,1,4,2,3,5,2,5,5,2,2,4,4,1,1,1,4,4,1,3,5,4,2,5,5,4,4,2,2,3,2,1,3,4,1,5,1,4,5,2,4,5,1,3,4,1,4,3,3,1,1,3,2,1,5,5,3,1,1,2,4,5,3,1,1,1,2,5,2,4,5,1,3,2,4,5,5,1,2,3,4,4,1,4,1,1,3,3,5,1,2,5,1,2,5,4,1,1,3,2,1,1,1,3,5,1,3,2,4,3,5,4,1,1,5,3,4,2,3,1,1,4,2,1,2,2,1,1,4,3,1,1,3,5,2,1,3,2,1,1,1,2,1,1,5,1,1,2,5,1,1,4];
% initFish = [3,4,3,1,2];
%% part 1
fish = initFish;
for i = 1:80
    newFish = [];
    for j = 1:length(fish)
        if fish(j) == 0
            fish(j) = 6;
            newFish(end+1) = 8; %#ok<SAGROW>
        else
            fish(j) = fish(j) - 1;
        end
    end
    fish = [fish newFish]; %#ok<AGROW>
%     disp(fish);
end
length(fish)

%% part 2
format long g
fishAge = zeros(1,9);
for i = 1:length(fishAge)
    fishAge(i) = sum(initFish == (i - 1));
end
% fishAge
for i = 1:256
    fishAge(9 + 1) = fishAge(0 + 1); %% newborn
    fishAge(7 + 1) = fishAge(7 + 1) + fishAge(0 + 1); %reset moms
    fishAge(0 + 1) = []; % shift age to younger
%     disp(fishAge)
end
sum(fishAge)