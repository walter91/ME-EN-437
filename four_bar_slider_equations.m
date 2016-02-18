function [f] = four_bar_slider_equations(unknowns, angles, lengths)

theta3 = unknowns(1);
r1 = unknowns(2);

theta1 = angles(1);
theta2 = angles(2);
theta4 = angles(4);

r2 = lengths(2);
r3 = lengths(3);
r4 = lengths(4);

f(1) = r2*cosd(theta2) + r3*cosd(theta3) - r1;
f(2) = r2*sind(theta2) + r3*sind(theta3) - r4;

end