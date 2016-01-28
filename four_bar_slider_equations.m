function [f] = four_bar_slider_equations(unknowns, angles, lengths)

theta3 = unknowns(1);
r1 = unknowns(2);

theta1 = deg2rad(angles(1));
theta2 = deg2rad(angles(2));
theta4 = deg2rad(angles(4));

r2 = lengths(2);
r3 = lengths(3);
r4 = lengths(4);

f(1) = r2*cos(theta2) + r3*cos(theta3) - r1*cos(theta1) - r4*cos(theta4);
f(2) = r2*sin(theta2) + r3*sin(theta3) - r1*sin(theta1) - r4*sin(theta4);

end