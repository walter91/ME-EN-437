clear; clc;

angles = [0 45 0 0]

xL = 7.5;
yL = 5;

lengths = [sqrt(xL^2 + yL^2) 2 6 6 6]

guess = [angles(3) angles(4)]

[unknowns] = fsolve(@hw4_6_equations, guess, [], angles, lengths);

angles(3) = unknowns(1);
angles(4) = unknowns(2)

angles(5) = acos((xL - lengths(2)*cosd(angles(2)) - lengths(3)*cosd(angles(3)))/lengths(5))

y(1) = 0;
y(2) = 0 + length(2)*sind(angles(2));
y(3) = y(2) + length(3)*sind(length(3));
y(4) = yL;
y(5) = length(2)*sind(angles(2)) + length(3)*sind(angles(3)) + length(5)*sind(angles(5))


x(1) = 0;
x(2) = 0 + length(2)*cosd(angles(2));
x(3) = x(2) + length(3)*cosd(length(3));
x(4) = xL;
x(5) = length(2)*cosd(angles(2)) + length(3)*cosd(angles(3)) + length(5)*cosd(angles(5))

figure(1); clf;
 plot([x(1) x(2)], [y(1) y(2)], 'r',[x(2) x(3)], [y(2) y(3)], 'g',...
        [x(3) x(4)], [y(3) y(4)], 'b',...
        [x(3) x(5)], [y(3) y(5)], 'k');
    legend('coupling', 'conecting rod', '4', 'ground', 'location', 'best')
    hold on;
    axis equal
    grid on
scatter(x,y)

