% fourbarcomplex.m - solves the Freudenstein equations using nonlinear
% solution

r1 = 6;
r2 = 2;
r3 = 7;
r4 = 9;

theta2 = 30*pi/180;

theta3 = 0*pi/180;
theta4 = 10*pi/180;

thetas = [theta3 theta4];
options = optimset('Display','iter');
solution = fsolve(@freudenstein,thetas,options,theta2,r1,r2,r3,r4);

theta3 = solution(1)*180/pi
theta4 = solution(2)*180/pi