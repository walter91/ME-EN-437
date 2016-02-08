function [f] = inverted_four_bar_crank_slider_equations(unknown, angles, lengths, gamma)

r1 = lengths(1);
r2 = lengths(2);
r3 = lengths(3);
r4 = lengths(4);

theta1 = angles(1);
theta2 = angles(2);

theta4 = unknown(1);
theta3 = theta4 + gamma;

r3 = unknown(2);

f(1) = r2*cosd(theta2) - r3*cosd(theta3) - r1*cosd(theta1) - r4*cosd(theta4);
f(2) = r2*sind(theta2) - r3*sind(theta3) - r1*sind(theta1) - r4*sind(theta4);

end