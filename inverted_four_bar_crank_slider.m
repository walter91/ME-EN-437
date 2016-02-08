function [theta4, r3, xp, yp] = inverted_four_bar_crank_slider(angles, lengths, gamma, p, options)
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

theta4 = unknowns(1);
angles(4) = theta4;
angles(3) = theta4 + 45;
theta3 = angles(3);
r3 = unknowns(2);
lengths(3) = r3;

xp = lengths(2)*cosd(angles(2)) - p(2)*cosd(theta3);
yp = lengths(2)*sind(angles(2)) + p(2)*sind(theta3);

x(1:4) = [0 r2*cosd(theta2) r1*cosd(theta1)+r4*cosd(theta4) r1*cosd(theta1)];
y(1:4) = [0 r2*sind(theta2) r1*sind(theta1)+r4*sind(theta4) r1*sind(theta1)];



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