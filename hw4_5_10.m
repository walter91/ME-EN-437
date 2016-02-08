clear; clc;

%% Constraints

alpha2 = deg2rad(145.5 - 210);
alpha3 = deg2rad(110.2 - 210);
p21 = -1.236 + 1i*2.138;
p31 = -2.5 + 1i*2.931;

%% Free Choices

beta2 = deg2rad(30);
beta3 = deg2rad(60);
gamma2 = deg2rad(-10);
gamma3 = deg2rad(25);

%% Vecter Setup and Solution

A1 = [exp(1i*beta2)-1, exp(1i*alpha2)-1;...
    exp(1i*beta3)-1, exp(1i*alpha3)-1];

A2 = [exp(1i*gamma2)-1, exp(1i*alpha2)-1;...
    exp(1i*gamma3)-1, exp(1i*alpha3)-1];

B = [p21; p31];

WZ = A1\B;
W = WZ(1);
Z = WZ(2);

US = A2\B;
U = US(1);
S = US(2);

%% Other Plotting Necesities

V = Z-S;
G = W+V-U;

ang1 = atan2(imag(G),real(G));
theta = atan2(imag(W),real(W));
%sigma = atan2(imag(U),real(U));

%% Display Solution

disp(['Link 1 has length ' num2str(abs(G))]);
disp(['Link 2 has length ' num2str(abs(W))]);
disp(['Link 3 has length ' num2str(abs(V))]);
disp(['Link 4 has length ' num2str(abs(U))]);

stuff = four_bar_func([rad2deg(ang1) rad2deg(theta) 10 10], [abs(G) abs(W) abs(V) abs(U)], [-.28 1], [1 1]);

%% Animate

pp = [W+Z; W+Z+p21; W+Z+p31];

Four_Bar([W Z U S],pp,'play');




