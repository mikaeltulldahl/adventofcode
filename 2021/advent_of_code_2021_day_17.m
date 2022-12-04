%% input
clear all
clc
targetArea = [143, 177, -106, -71];%my input
%targetArea = [xMin, xMax, yMin, yMax];
%% part 1
figure(1);
clf;
hold on;
grid on;
xPatch = [targetArea(1) targetArea(2) targetArea(2) targetArea(1)];
yPatch = [targetArea(3) targetArea(3) targetArea(4) targetArea(4)];
p = patch(xPatch, yPatch,'blue');
plot(0,0,'rx');

figure(2);
clf;
hold on;
grid on;
yline(targetArea(3))
yline(targetArea(4))

%first, find valid x-velocity to reach 0 x-velocity at
initVel = [0;0];
maxY = 0;
iteration = 0;
while true
    trajectory = simulate(targetArea, initVel);
    endPosition = trajectory(:,end);
    inside = insideTarget(targetArea, endPosition);
    if inside
        color = 'g';
        %record highest point and then increase y vel
        maxY = max(maxY, max(trajectory(2,:)));
        initVel
        initVel(2) = initVel(2) + 1;
    else
        color = 'r';
        if endPosition(1) < targetArea(1) %undershoot x
            initVel(1) = initVel(1) + 1;
        elseif endPosition(1) > targetArea(2) %overshoot x
            initVel(1) = initVel(1) - 1;
        elseif endPosition(2) < targetArea(3) %below y
            initVel(2) = initVel(2) + 1;
        elseif endPosition(2) > targetArea(4) %above y
            %should not happen
            derp = 1;
        end
    end
    iteration = iteration + 1;
    
    figure(1);
    plot(trajectory(1,:),trajectory(2,:),color);
    plot(endPosition(1),endPosition(2),['x' color]);
    drawnow;
    if (endPosition(1) >= targetArea(1) && endPosition(1) <= targetArea(2)) %within X
        figure(2);
        plot(iteration, trajectory(2,end-1),['o' color]);
        plot(iteration, trajectory(2,end),['x' color]);
        drawnow;
    end
    pause(0.1);
end

%% part 2
xRange = [15:200];
yRange = [-150:120];

success = zeros(length(xRange),length(yRange));

for i = 1:length(xRange)
    for j = 1:length(yRange)
        trajectory = simulate(targetArea, [xRange(i); yRange(j)]);
        success(i,j) = insideTarget(targetArea, trajectory(:,end));
    end
end
figure(3);
clf;
pcolor(xRange, yRange, success');
xlabel('X');
ylabel('Y');
colormap(gray(2))

sum(success, 'all')
%% helper functions

function trajectory = simulate(targetArea, initVel)
%targetArea = [xMin, xMax, yMin, yMax];

% The probe's x position increases by its x velocity.
% The probe's y position increases by its y velocity.
% Due to drag, the probe's x velocity changes by 1 toward the value 0; that is, it decreases by 1 if it is greater than 0, increases by 1 if it is less than 0, or does not change if it is already 0.
% Due to gravity, the probe's y velocity decreases by 1.
position = [0;0];
velocity = initVel;
trajectory = [];
while true
    position = position + velocity;
    trajectory(:,end+1) = position; %#ok<AGROW>
    velocity(1) = velocity(1) - sign(velocity(1));
    velocity(2) = velocity(2) - 1;
    if insideTarget(targetArea, position)
        break;%success
    end 
    if velocity(1) == 0 ...
        && (position(1) < targetArea(1) ...
            || position(1) > targetArea(2))
        break;% will never reach x target
    end
    if position(2) < targetArea(3)
        break;%below target
    end
end
end

function out = insideTarget(targetArea, position)
%targetArea = [xMin, xMax, yMin, yMax];
out = position(1) >= targetArea(1) &&...
    position(1) <= targetArea(2) &&...
    position(2) >= targetArea(3) &&...
    position(2) <= targetArea(4);
end

function plotWorld(trajectory, targetArea)
%targetArea = [xMin, xMax, yMin, yMax];
figure(1);
clf;
hold on;
grid on;
x = [targetArea(1) targetArea(2) targetArea(2) targetArea(1)] + inX;
y = [targetArea(3) targetArea(3) targetArea(4) targetArea(4)] + inY;
patch(y, x,'green');

plot(trajectory(1,:),trajectory(2,:),'rb');
plot(0,0,'rx');


end