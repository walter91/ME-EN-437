clear; clc;

angles = [0 30 50 110 (60-2.5*30)];
lengths = [6 5 7 8 4];

theta1 = angles(1);
theta2 = angles(2);
theta3 = angles(3);
theta4 = angles(4);
theta5 = angles(5);

r1 = lengths(1);
r2 = lengths(2);
r3 = lengths(3);
r4 = lengths(4);
r5 = lengths(5);

guesses = [theta3 theta4];

[newAngles] = fsolve(@five_bar_geared_equations, guesses, [], angles, lengths)

theta3 = newAngles(:,1);
theta4 = newAngles(:,2);

x = [0 r2*cosd(theta2) r2*cosd(theta2)+r3*cosd(theta3(1)) r1*cosd(theta1)+r5*cosd(theta5) r1*cosd(theta1)];
y = [0 r2*sind(theta2) r2*sind(theta2)+r3*sind(theta3(1)) r1*sind(theta1)+r5*sind(theta5) r1*sind(theta1)];

lengthMeasured(1) = sqrt( abs(x(1)-x(5))^2 - abs(y(1) - y(5))^2);
lengthMeasured(2) = sqrt( abs(x(2)-x(1))^2 - abs(y(2) - y(1))^2);
lengthMeasured(3) = sqrt( abs(x(3)-x(2))^2 - abs(y(3) - y(2))^2);
lengthMeasured(4) = sqrt( abs(x(4)-x(3))^2 - abs(y(4) - y(3))^2);
lengthMeasured(5) = sqrt( abs(x(5)-x(4))^2 - abs(y(5) - y(4))^2);

rad2 = 4.25;

figure(1); clf;
plot([x(1) x(2)], [y(1) y(2)], 'r',[x(2) x(3)], [y(2) y(3)], 'g',...
        [x(3) x(4)], [y(3) y(4)], 'b',[x(4) x(5)], [y(4) y(5)], 'y', ...
        [x(5) x(1)],[y(5) y(1)],'k')
    hold on
scatter(x,y)
hold on
circle(x(1), y(1), rad2)
hold on
circle(x(5), y(5), rad2/2.5)
axis equal
grid on

disp(lengthMeasured)

r1*cosd(theta1) + r5*cosd(theta5) + r4*cosd(theta4) - r3*cosd(theta3) - r2*cosd(theta2)
r1*sind(theta1) + r5*sind(theta5) + r4*sind(theta4) - r3*sind(theta3) - r2*sind(theta2)

