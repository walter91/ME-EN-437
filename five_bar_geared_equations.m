function [f] = five_bar_geared_equations(unknownAngles, angles, lengths)

theta3 = unknownAngles(1);
theta4 = unknownAngles(2);

theta1 = angles(1);
theta2 = angles(2);
theta5 = 60 - 2.5*theta2;

r1 = lengths(1);
r2 = lengths(2);
r3 = lengths(3);
r4 = lengths(4);
r5 = lengths(5);

f(1) = r1*cosd(theta1) + r5*cosd(theta5) + r4*cosd(theta4) - r3*cosd(theta3) - r2*cosd(theta2);
f(2) = r1*sind(theta1) + r5*sind(theta5) + r4*sind(theta4) - r3*sind(theta3) - r2*sind(theta2);

disp(f(1))
disp(f(2))

end