function [angles, lengths, points, p] = four_bar_func(angles, lengths, p, options)
%[angles, lengths, points, p] = four_bar_func(angles, lengths, p, options)
%will solve for two unknown angles of a four bar mechanism and plot the mechanism following standard convention.
%The unknown angles are 3 and 4 as denoted below. Xp and Yp are the x and y
%locations of the point P which is on fixed to the link 2.
%   ANGLES is an array of four angles provided in degrees [a1 a2 a3 a4].
%   Angles 3 and 4 are provided as guesses.
%   LENGTHS is an array of four lengths [L1 L2 L3 L4]
%   P is an array of two distances (along and away from) length 2 [a b]

theta1 = angles(1);
theta2 = angles(2);
theta3 = angles(3); %guess
theta4 = angles(4); %guess

r1 = lengths(1);
r2 = lengths(2);
r3 = lengths(3);
r4 = lengths(4);

guess = [theta3 theta4];

optionsFsolve = optimset('Display', 'off');

[unknowns] = fsolve(@four_bar_equations, guess, optionsFsolve, angles, lengths);

theta3 = unknowns(1);
theta4 = unknowns(2);

angles(3) = theta3;
angles(4) = theta4;

pAngle = atand(p(1)/p(2));
pLength = sqrt(p(1)^2 + p(2)^2);

xp = lengths(2)*cosd(angles(2)) + p(1)*cosd(angles(3)) + p(2)*cosd(angles(3) + 90);
yp = lengths(2)*sind(angles(2)) + p(1)*sind(angles(3)) + p(2)*sind(angles(3) + 90);

%p = [xp yp];

x = [0 r2*cosd(angles(2)) r2*cosd(angles(2))+r3*cosd(angles(3)) r1*cosd(angles(1))];
y = [0 r2*sind(angles(2)) r2*sind(angles(2))+r3*sind(angles(3)) r1*sind(angles(1))];

points = [x' y'];

if(options(1) == 1) %would you like to plot?
    figure(1); clf;
    plot([x(1) x(2)], [y(1) y(2)], 'r',[x(2) x(3)], [y(2) y(3)], 'g',...
        [x(3) x(4)], [y(3) y(4)], 'b',[x(4) x(1)], [y(4) y(1)], 'y',...
        [x(2) xp], [y(2) yp], 'k', [x(3) xp], [y(3) yp], 'k');
    legend('coupling', 'conecting rod', '4', 'ground', 'location', 'best')
    hold on;
    scatter(x(1:4),y(1:4));
    hold on;
    scatter(xp,yp);
    grid on
    axis equal
    hold on
end

if(options(2) == 1) %would you like to plot the path of the coupler link...?
    
    anglesTemp = angles;
    lengthsTemp = lengths;
    guessTemp = [anglesTemp(3) anglesTemp(4)];
    
    fullRound = linspace(15,375,100);
    
    for i=1:length(fullRound)
        [unknownsTemp] = fsolve(@four_bar_equations, guessTemp, optionsFsolve, [anglesTemp(1) fullRound(i) anglesTemp(3) anglesTemp(4)], lengthsTemp);
        theta3Temp(i) = unknownsTemp(1);
        theta4Temp(i) = unknownsTemp(2);
        xpTemp(i) = lengths(2)*cosd(fullRound(i)) + p(1)*cosd(theta3Temp(i)) + p(2)*cosd(theta3Temp(i) - sign(pAngle)*90);
        ypTemp(i) = lengths(2)*sind(fullRound(i)) + p(1)*sind(theta3Temp(i)) + p(2)*sind(theta3Temp(i) - sign(pAngle)*90);
%         if((i~=1) && (sqrt((xpTemp(i) - xpTemp(i-1))^2 + (ypTemp(i) - ypTemp(i-1))^2)>=(.1*mean(lengths))))
%             guessTemp(1) = guessTemp(1) + 1;
%             [unknownsTemp] = fsolve(@four_bar_equations, guessTemp, [], anglesTemp, lengthsTemp);
%             theta3Temp(i) = unknownsTemp(1);
%             theta4Temp(i) = unknownsTemp(2);
%             if( guessTemp(1) > 180 && (sqrt((xpTemp(i) - xpTemp(i-1))^2 + (ypTemp(i) - ypTemp(i-1))^2)>=(.1*mean(lengths))) )
%                  guessTemp(2) = guessTemp(2) - 2;
%                 [unknownsTemp] = fsolve(@four_bar_equations, guessTemp, [], anglesTemp, lengthsTemp);
%                 theta3Temp(i) = unknownsTemp(1);
%                 theta4Temp(i) = unknownsTemp(2);
%                 end
%         end
        xpTemp(i) = lengths(2)*cosd(fullRound(i)) + p(1)*cosd(theta3Temp(i)) + p(2)*cosd(theta3Temp(i) + 90);
        ypTemp(i) = lengths(2)*sind(fullRound(i)) + p(1)*sind(theta3Temp(i)) + p(2)*sind(theta3Temp(i) + 90);
    end
    
    figure(1);
    hold on;
    plot(xpTemp, ypTemp);
end

end