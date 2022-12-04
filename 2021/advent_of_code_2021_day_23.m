%%input
clc
clear all

E = 0; %empty
A = 1;
B = 2;
C = 3;
D = 4;
W = 5;

CORIDOR_ROW = 1;
ROOM_ROWS = 2:3;
ROOM_A_COL = 3;
ROOM_B_COL = 5;
ROOM_C_COL = 7;
ROOM_D_COL = 9;

state = char(zeros(3,11));
state(ROOM_ROWS,ROOM_A_COL) = [B;A];
state(ROOM_ROWS,ROOM_A_COL) = [B;A];
state(ROOM_ROWS,ROOM_A_COL) = [B;A];
state(ROOM_ROWS,ROOM_A_COL) = [B;A];

CORR_1 = 1;
CORR_2 = 2;
CORR_4 = 4; 
CORR_6 = 6;
CORR_8 = 8;
CORR_10 = 10;
CORR_11 = 11;
ROOM_A1 = 12;
ROOM_A2 = 13;
ROOM_B1 = 14;
ROOM_B2 = 15;
ROOM_C1 = 16;
ROOM_C2 = 17;
ROOM_D1 = 18;
ROOM_D2 = 19;

function [cost, valid] = solver(map, unfinishedGuest, readyRooms)
%unfinishedGuest = [row, col, type]
%readyRooms = [a ready, b ready, c ready, d ready]
%if finished, return 0 cost
% for each unfinished amphipod
% if room is ready & path to final room available -> go to room
% if possible to move to cooridor
    %for each possible location
    % go to location, then run solver
    %add self cost with lowest child cost
    
%if no children exists, return invalid solution
end
