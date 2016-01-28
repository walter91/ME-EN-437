function [theta3, r1, xp, yp] = four_bar_slider(angles, lengths, p, options)
%[A3 L1 Xp Yp] = four_bar_slider(ANGLES, LENGTHS, P) will solve for an unknown angle (3)
%and an unknown length (1) for a four bar mechanism and plot the mechanism
%following standard convention. Xp and Yp are the x and y
%locations of the point P which is on fixed to the link 2.
%
%   ANGLES is an array of four angles provided in degrees [a1 a2 a3 a4].
%   Angle 3 is provided as am initial guess.
%   LENGTHS is an array of four lengths [L1 L2 L3 L4]. Length 1 is provided
%   as an initial guess.
%   P is an array of two distances (along and away from) length 2 [px py]

theta1 = angles(1);
theta2 = angles(2);
theta3 = angles(3); %guess
theta4 = angles(4);

r1 = lengths(1);    %guess
r2 = lengths(2);
r3 = lengths(3);
r4 = lengths(4);

guess = [theta3 r1];

[unknowns] = fsolve(@four_bar_slider_equations, guess, [], angles, lengths);

theta3 = rad2deg(unknowns(1));
r1 = unknowns(2);

xp = lengths(2)*cos(deg2rad(angles(2))) + p(1)*cos(theta3);
yp = lengths(2)*sin(deg2rad(angles(2))) + p(2)*sin(theta3);

theta3_deg = rad2deg(theta3);
theta4_deg = rad2deg(theta4);

for i=1:4
    x(:,i) = [0 r2*cos(deg2rad(theta2)) r2*cos(deg2rad(theta2))+r3*cos(deg2rad(theta3)) r1*cos(deg2rad(theta1))];
    y(:,i) = [0 r2*sin(deg2rad(theta2)) r2*sin(deg2rad(theta2))+r3*sin(deg2rad(theta3)) r1*sin(deg2rad(theta1))];
end

checkLengths(1) = sqrt(((x(4))- (x(1)))^2 + ((y(4)) - (y(1)))^2);
checkLengths(2) = sqrt(((x(1))- (x(2)))^2 + ((y(1)) - (y(2)))^2);
checkLengths(3) = sqrt(((x(2))- (x(3)))^2 + ((y(2)) - (y(3)))^2);
checkLengths(4) = sqrt(((x(3))- (x(4)))^2 + ((y(3)) - (y(4)))^2);

disp(checkLengths);

if(options(1) == 1) %would you like to plot?
    figure(1); clf;
    plot([x(1) x(2)], [y(1) y(2)], 'r',[x(2) x(3)], [y(2) y(3)], 'g',...
        [x(3) x(4)], [y(3) y(4)], 'b',[x(4) x(1)], [y(4) y(1)], 'y')
    hold on
    %plot([x(2) xp], [y(2) yp], 'k', [x(3) xp], [y(3) yp], 'k');
    legend('coupling', 'conecting rod', 'offset', 'distance', 'location', 'best')
    hold on;
    scatter(x(1:4),y(1:4));
    hold on;
    %scatter(xp,yp);
    grid on
    axis equal
end

end