function [angles, angularRates, alpha3, lengths, linearRates, d_ddot, points, p] = four_bar_slider(angles, omega2, alpha2, lengths, p, options)
%[angles, angularRates, lengths, linearRates, points, p] = four_bar_slider(angles, omega2, lengths, p, options)
%will solve for an unknown angle (3)
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

angles(3) = unknowns(1);
lengths(1) = unknowns(2);

p(1) = lengths(2)*cosd(angles(2)) + p(1)*cosd(angles(3));
p(2) = lengths(2)*sind(angles(2)) + p(2)*sind(angles(3));

x = [0 lengths(2)*cosd(angles(2)) lengths(2)*cosd(angles(2))+lengths(3)*cosd(angles(3)) lengths(1)*cosd(angles(1))];
y = [0 lengths(2)*sind(angles(2)) lengths(2)*sind(angles(2))+lengths(3)*sind(angles(3)) lengths(1)*sind(angles(1))];

points = [x' y'];


% checkLengths(1) = sqrt(((x(4))- (x(1)))^2 + ((y(4)) - (y(1)))^2);
% checkLengths(2) = sqrt(((x(1))- (x(2)))^2 + ((y(1)) - (y(2)))^2);
% checkLengths(3) = sqrt(((x(2))- (x(3)))^2 + ((y(2)) - (y(3)))^2);
% checkLengths(4) = sqrt(((x(3))- (x(4)))^2 + ((y(3)) - (y(4)))^2);
% 
% disp(checkLengths);


angularRates(1) = 0;
angularRates(2) = omega2;
angularRates(3) = lengths(2)*cosd(angles(2))*angularRates(2)/(lengths(3)*cosd(angles(3)));
angularRates(4) = 0;

linearRates(1,:) = [0, 0];
linearRates(2,:) = [lengths(2)*angularRates(2)*-sind(angles(2)), lengths(2)*angularRates(2)*cosd(angles(2))];
linearRates(3,:) = [-lengths(2)*angularRates(2)*sind(angles(2))+lengths(3)*angularRates(3)*sind(angles(3)), 0];
linearRates(4,:) = linearRates(3,:);


alpha3 = (lengths(2)*alpha2*cosd(angles(2))-lengths(2)*(angularRates(2)^2)*sind(angles(2))+lengths(3)*(angularRates(3)^2)*sind(angles(3)))/(lengths(3)*cosd(angles(3)));
d_ddot = -lengths(2)*alpha2*sind(angles(2))-lengths(2)*(angularRates(2)^2)*cosd(angles(2))+lengths(3)*alpha3*sind(angles(3))+lengths(3)*(angularRates(3)^2)*cosd(angles(3));










if(options(1) == 1) %would you like to plot?
    figure(2); clf;
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