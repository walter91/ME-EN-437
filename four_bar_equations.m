function [f] = four_bar_equations(unknownAngles, angles, lengths)

theta3 = unknownAngles(1);
theta4 = unknownAngles(2);

theta1 = deg2rad(angles(1));
theta2 = deg2rad(angles(2));

r1 = lengths(1);
r2 = lengths(2);
r3 = lengths(3);
r4 = lengths(4);

f(1) = r2*cos(theta2) + r3*cos(theta3) - r1*cos(theta1) - r4*cos(theta4);
f(2) = r2*sin(theta2) + r3*sin(theta3) - r1*sin(theta1) - r4*sin(theta4);

end