clear; clc;

%% Constraints

alpha2 = 120;
p21 = 4.03;
delta2 = -29.75;
theta = 90;
sigma = 90;
phi = -90;


%% Free Choices

Z = 3;
beta2 = -90;
gamma2 = -80;

%% Vecter Setup and Solution

A = cosd(beta2) - 1;
B = sind(beta2);
C = cosd(alpha2) - 1;
D = sind(alpha2);
E = p21*cosd(delta2);
F = p21*sind(delta2);

Z1x = 0;
Z1y = Z;


W1x = (A*(-C*Z1x + D*Z1y + E) + B*(-C*Z1y - D*Z1x + F))/(-2*A);
W1y = (A*(-C*Z1y + D*Z1x + F) + B*(C*Z1x - D*Z1y + E))/(-2*A);


A = cosd(gamma2)-1;
B = sind(gamma2);
C = cosd(alpha2) - 1;
D = sind(alpha2);
E = p21*cosd(delta2);
F = p21*sind(delta2);

S1x = 0;
S1y = 2.5;

U1x = (A*(-C*S1x + D*S1y + E) + B*(-C*S1y - D*S1x + F))/(-2*A);
U1y = (A*(-C*S1y + D*S1x + F) + B*(C*S1x - D*S1y + E))/(-2*A);


W = sqrt(W1x^2 + W1y^2);
U = sqrt(U1x^2 + U1y^2);
G = U + Z - W;
%G = sqrt((W1x + Z1x - U1x)^2 + (W1y + Z1y - U1y)^2);

G
W
Z
U