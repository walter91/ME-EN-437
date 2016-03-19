%% HW 7 #3
clear; clc;

%% Given

angles = [0 45 160 0];
omega2 = rad2deg(24);
alpha2 = rad2deg(30);
lengths = [3 10 4 6];
gamma = 45;
p = [0 0];
options = [1 0];


%% Calculation

    [angles, angularRates, alpha3, alpha4, lengths, linearRates,b_dot, b_ddot, points, p] = inverted_four_bar_crank_slider(angles, omega2, alpha2, lengths, gamma, p, options);
    
    disp(['Alpha4 = ' num2str(alpha4) ' rad/sec^2']);
    disp(['Ab34 = ' num2str(b_ddot) ' cm/sec^2']);
    disp(['Magnitude of coriolis term is ' num2str(abs(2*b_dot*angularRates(3)*exp(1i*angles(3)))) ' cm/sec^2']);
    




