function [angles, angularVelocity, angularAcceleration, lengths, linearVelocity, linearAcceleration, points, p, vp, ap] = four_bar_func(angles, omega2, alpha2, lengths, p, options)
%[angles, angularVelocity, angularAcceleration, lengths, linearVelocity, linearAcceleration, points, p, vp, ap] = four_bar_func(angles, omega2, alpha2, lengths, p, options)
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

% mu = options(3);
% 
% r7x = lengths(2)*cosd(angles(2)) - lengths(1);
% r7y = lengths(2)*sind(angles(2));
% 
% theta7 = rad2deg(atan2(r7y, r7x));
% 
% r7 = sqrt(r7x^2 + r7y^2);
% 
% psi = rad2deg(acos((lengths(4)^2 + r7^2 - lengths(3)^2)/(2*lengths(4)*r7)));
% 
% theta4_p = theta7 + mu*psi;
% 
% angles(4) = rad2deg(atan2(sind(theta4_p), cosd(theta4_p)));
% 
% r3x = lengths(1) + lengths(4)*cosd(angles(4)) - lengths(2)*cosd(angles(2));
% r3y = lengths(4)*sind(angles(4)) - lengths(2)*sind(angles(2));
% 
% r3 == sqrt(r3x^2 + r3y^2)
% 
% r2*cosd(theta2) + r3*cosd(theta3) - r1*cosd(theta1) - r4*cosd(theta4);
% r2*sind(theta2) + r3*sind(theta3) - r1*sind(theta1) - r4*sind(theta4);

%angles(3) = atan2(r3y, r3x);

%%
guess = [theta3 theta4];

optionsFsolve = optimset('Display', 'off');

[unknowns] = fsolve(@four_bar_equations, guess, optionsFsolve, angles, lengths);

theta3 = unknowns(1);
theta4 = unknowns(2);

angles(3) = theta3;
angles(4) = theta4;

%%

pLength = sqrt(p(1)^2 + p(2)^2);
% pAngle = rad2deg(atan2(p(1)*sind(angles(3)) + p(2)*sind(angles(3) + 90),p(1)*cosd(angles(3)) + p(2)*cosd(angles(3) + 90)));
%pAngle

xp = lengths(2)*cosd(angles(2)) + p(1)*cosd(angles(3)) - p(2)*sind(angles(3));
yp = lengths(2)*sind(angles(2)) + p(1)*sind(angles(3)) + p(2)*cosd(angles(3));

p = [xp yp];

x = [0 r2*cosd(angles(2)) r2*cosd(angles(2))+r3*cosd(angles(3)) r1*cosd(angles(1))];
y = [0 r2*sind(angles(2)) r2*sind(angles(2))+r3*sind(angles(3)) r1*sind(angles(1))];

points = [x' y'];

pAngle = rad2deg(atan2(yp - y(2),xp - x(2)));

%% Velocity calculations

angularVelocity(1) = 0;
angularVelocity(2) = omega2;
angularVelocity(3) = (lengths(2)*angularVelocity(2)/lengths(3))*(sind(angles(4)) - sind(angles(2))/(sind(angles(3) - angles(4))));
angularVelocity(4) = (lengths(2)*angularVelocity(2)/lengths(4))*(sind(angles(2)) - sind(angles(3))/(sind(angles(4) - angles(3))));

linearVelocity(1,:) = [0, 0];
linearVelocity(2,:) = [lengths(2)*angularVelocity(2)*-sind(angles(2)), lengths(2)*angularVelocity(2)*cosd(angles(2))];
linearVelocity(3,:) = [lengths(4)*angularVelocity(4)*-sind(angles(4)), lengths(4)*angularVelocity(4)*cosd(angles(4))];
linearVelocity(4,:) = [0, 0];


% pLength = sqrt(p(1)^2 + p(2)^2);
% pAngle = rad2deg(atan2(p(1)*sind(angles(3)) + p(2)*sind(angles(3) + 90),p(1)*cosd(angles(3)) + p(2)*cosd(angles(3) + 90)));

vp = [linearVelocity(2,1) + (pLength*angularVelocity(3)*-sind(pAngle)),...
    linearVelocity(2,2) + (pLength*angularVelocity(3)*cosd(pAngle))];

%% Acceleration Calculation

angularAcceleration(1) = 0;
angularAcceleration(2) = alpha2;

A = lengths(4)*sind(angles(4));
B = lengths(3)*sind(angles(3));
C = lengths(2)*angularAcceleration(2)*sind(angles(2)) + lengths(2)*(angularVelocity(2)^2)*cosd(angles(2))...
        + lengths(3)*(angularVelocity(3)^2)*cosd(angles(3)) - lengths(4)*(angularVelocity(4)^2)*cosd(angles(4));
D = lengths(4)*cosd(angles(4));
E = lengths(3)*cosd(angles(3));
F = lengths(2)*angularAcceleration(2)*cosd(angles(2)) - lengths(2)*(angularVelocity(2)^2)*sind(angles(2))...
        - lengths(3)*(angularVelocity(3)^2)*sind(angles(3)) - lengths(4)*(angularVelocity(4)^2)*sind(angles(4));

angularAcceleration(3) = (C*D-A*F)/(A*E-B*D);
angularAcceleration(4) = (C*E-B*F)/(A*E-B*D);

linearAcceleration(1, :) = [0, 0];
linearAcceleration(2, :) = [-lengths(2)*angularAcceleration(2)*sind(angles(2)) - lengths(2)*(angularVelocity(2)^2)*cosd(angles(2))...
                                lengths(2)*angularAcceleration(2)*cosd(angles(2)) - lengths(2)*(angularVelocity(2)^2)*sind(angles(2))];
linearAcceleration(3, :) = [-lengths(3)*angularAcceleration(3)*sind(angles(3)) - lengths(3)*(angularVelocity(3)^2)*cosd(angles(3))...
                                lengths(3)*angularAcceleration(3)*cosd(angles(3)) - lengths(3)*(angularVelocity(3)^2)*sind(angles(3))];
linearAcceleration(4, :) = [0, 0];

ap = [linearAcceleration(2,1) + (-pLength*angularAcceleration(3)*sind(angles(3)) - pLength*(angularVelocity(3)^2)*cosd(angles(3)));...
        linearAcceleration(2,2) + (pLength*angularAcceleration(3)*cosd(angles(3)) - pLength*(angularVelocity(3)^2)*sind(angles(3)))];
%% Plotting based on options

if(options(1) == 1) %would you like to plot?
    figure(1); clf;
    plot([x(1) x(2)], [y(1) y(2)], 'r',[x(2) x(3)], [y(2) y(3)], 'g',...
        [x(3) x(4)], [y(3) y(4)], 'b',[x(4) x(1)], [y(4) y(1)], 'y')
    hold on;
    if(p(1) ~= 0 && p(2) ~= 0)
        plot([x(2) xp], [y(2) yp], 'k', [x(3) xp], [y(3) yp], 'k');
    end
    legend('coupling', 'conecting rod', '4', 'ground', 'location', 'best')
    hold on;
    scatter(x(1:4),y(1:4));
    hold on;
    if(p(1) ~= 0 && p(2) ~= 0)
        scatter(xp,yp);
    end
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