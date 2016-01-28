clear; clc;

r1 = 6;
r2 = 2;
r3 = 7;
r4 = 9;

theta1 = 0;

theta2 = linspace(10, 370, 100);
%theta2 = 30;

theta3Guess = 0;
theta4Guess = 0;

for i = 1:length(theta2)
    [theta3(i), theta4(i), xp(i), yp(i)] = four_bar_func([theta1,theta2(i), theta3Guess, theta4Guess], [r1,r2,r3,r4], [1, 1]);
    if(i>1)
        while(abs(theta3(i) - theta3(i-1)) > 50)
            if(theta3Guess < 360)
                theta3Guess = theta3Guess + 1;
            elseif(theta4Guess < 360)
                theta4Guess = theta4Guess + 1;
            else
                disp('this is not working');
            end
            [theta3(i), theta4(i), xp(i), yp(i)] = four_bar_func([theta1,theta2(i), theta3Guess, theta4Guess], [r1,r2,r3,r4], [1, 1]);
        end
    end
    
    x(:,i) = [0 r2*cos(deg2rad(theta2(i))) r2*cos(deg2rad(theta2(i)))+r3*cos(deg2rad(theta3(i))) r1*cos(deg2rad(theta1))];
    y(:,i) = [0 r2*sin(deg2rad(theta2(i))) r2*sin(deg2rad(theta2(i)))+r3*sin(deg2rad(theta3(i))) r1*sin(deg2rad(theta1))];
end


figure(1); clf;
subplot(1,4,1)
plot(theta2, theta3)
xlabel('theta 2 (degrees)')
ylabel('theta3');
subplot(1,4,2)
plot(theta2, theta4)
xlabel('theta 2 (degrees)')
ylabel('theta4');
subplot(1,4,3)
plot(theta2, xp)
xlabel('theta 2 (degrees)')
ylabel('xp');
subplot(1,4,4)
plot(theta2, yp)
xlabel('theta 2 (degrees)')
ylabel('yp');

figure(2); clf;
plot(xp, yp);
axis equal
grid on
xlabel('xp')
ylabel('yp')

for i = 2:4:98
    figure(i+1); clf;
    plot([x(i-1) x(i)], [y(i-1) y(i)], 'r',[x(i) x(i+1)], [y(i) y(i+1)], 'g',[x(i+1) x(i+2)], [y(i+1) y(i+2)], 'b',[x(i+2) x(i-1)], [y(i+2) y(i-1)], 'y');
    legend('coupling', 'conecting rod', '4', 'ground')
    hold on;
    scatter(x(i-1:i+2),y(i-1:i+2));
    grid on
    axis equal
end

