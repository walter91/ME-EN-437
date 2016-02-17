%hw5 #2

clear; clc; clf;

lengths = [3 10 6 8];
angles = [0 45 0 0];

p = [10*cosd(80) 10*sind(80)];
options = [1 0]

[angles lengths points p] = four_bar_func(angles, lengths, p, options);






