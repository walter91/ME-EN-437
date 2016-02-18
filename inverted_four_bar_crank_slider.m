function [angles, angularRates, lengths, linearRates, points, p] = inverted_four_bar_crank_slider(angles, omega2, lengths, gamma, p, options)
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
theta3 = angles(3);
theta4 = angles(4); %guess

r1 = lengths(1);
r2 = lengths(2);
r3 = lengths(3); %guess
r4 = lengths(4);

guess = [theta4 r3];

[unknowns] = fsolve(@inverted_four_bar_crank_slider_equations, guess, [], angles, lengths, gamma);

angles(4) = unknowns(1);
angles(3) = angles(4) + gamma;
lengths(3) = unknowns(2);

xp = lengths(2)*cosd(angles(2)) - p(2)*cosd(theta3);
yp = lengths(2)*sind(angles(2)) + p(2)*sind(theta3);

x(1:4) = [0 r2*cosd(angles(2)) r1*cosd(angles(1))+r4*cosd(angles(4)) r1*cosd(angles(1))];
y(1:4) = [0 r2*sind(angles(2)) r1*sind(angles(1))+r4*sind(angles(4)) r1*sind(angles(1))];

points = [x' y'];

angularRates(1) = 0;
angularRates(2) = omega2;
angularRates(3) = lengths(2)*angularRates(2)*cosd(angles(2) - angles(3))/(lengths(3)+lengths(4)*cosd(angles(4)-angles(3)));
angularRates(4) = angularRates(3);

linearRates(1,:) = [0, 0];
linearRates(2,:) = [lengths(2)*angularRates(2)*-sind(angles(2)), lengths(2)*angularRates(2)*cosd(angles(2))];
linearRates(3,:) = [lengths(4)*angularRates(4)*-sind(angles(4)), lengths(4)*angularRates(4)*cosd(angles(4))];
linearRates(4,:) = [0, 0];

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