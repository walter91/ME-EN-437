%% HW 6 #2, Walter Coe, 2-17-16
 clear; clc;
 
%% Table P6-3 row c, pg. 330


angles = [0 45 45 00];
lengths = [3 10 5 6];
gamma = 45;

options = 1;

[theta4, r3, xp, yp] = inverted_four_bar_crank_slider(angles, lengths, gamma, [0 0], options)