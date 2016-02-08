clear;clc;
r2 = 1.0;

ax = cosd(31)*3.06
ay = -sind(31)*3.06

AP = 3.06;

theta1 = 0;
theta2 = linspace(10,370,50);
%theta2 = 75;
theta3Guess = 0;
theta4Guess = 0;

for i = 1:length(theta2)
    [angles, lengths, points, p] = four_bar_func([0,theta2(i), theta3Guess, theta4Guess],[2.22 r2 2.06 2.33], [ax ay], 1);
    theta3(i) = angles(3);
    theta4(i) = angles(4);
    %disp(i)
    if(i>1)
        while(abs(theta3(i) - theta3(i-1)) > 50)
            if(theta3Guess < 360)
                theta3Guess = theta3Guess + 1;
            elseif(theta4Guess < 360)
                theta4Guess = theta4Guess + 1;
                 theta3Guess = theta3Guess - 2;
            else
                disp('this is not working');
            end
            [angles, lengths, points, p] = four_bar_func([0,theta2(i), theta3Guess, theta4Guess],[2.22 r2 2.06 2.33], [ax ay], 1);
            theta3(i) = angles(3);
            theta4(i) = angles(4);
        end
    end
    Ax(i) = r2*cosd(theta2(i)) + AP*cosd(theta3(1)-31);
    Ay(i) = r2*sind(theta2(i)) + AP*sind(theta3(1)-31);
    
    figure(2);% clf;
    scatter(p(1), p(2))
    hold on
    xlabel('xp')
    ylabel('yp')
end


figure(3); clf;
plot(theta2, theta3)
xlabel('theta2')
ylabel('theta3')

figure(4); clf;
plot(theta2, theta4)
xlabel('theta2')
ylabel('theta4')


