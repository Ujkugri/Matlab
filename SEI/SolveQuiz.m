%%  Cleaning
clearvars
clc
%%  Define position of start, obstacles and letters
%   The '+1' is added since matlab starts counting at 1 and not 0 like in
%   other programming languages (for example python)
start = [0 2]+1;

obst = [];
obst(1,:) = [0 0]+1;
obst(2,:) = [0 4]+1;
obst(3,:) = [4 0]+1;
obst(4,:) = [5 0]+1;
obst(5,:) = [6 2]+1;
obst(6,:) = [6 6]+1;

letters = [];
letters.L = [0 3]+1;
letters.A = [4 4]+1;
letters.I = [2 0]+1;
letters.O = [1 0]+1;
letters.S = [2 1]+1;

%%  Create object
a = SEI_quizsolver(start,obst,letters);
%%  Start solving algorithm
moveIter(a,start(1),start(2));
%%  Display solution
fprintf('Solution: %s\n',a.letter_bin)