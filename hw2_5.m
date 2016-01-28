clear; clc;

r1 = 5;
r2 = 5;
r3 = 3;
r4 = 3;

theta1 = 0;

%theta2 = linspace(30, 50, 2);
theta2 = 74.18999;

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

figure(i+1); clf;
plot([x(1) x(2)], [y(1) y(2)], 'r',[x(2) x(3)], [y(2) y(3)], 'g',[x(3) x(4)], [y(3) y(4)], 'b',[x(4) x(1)], [y(4) y(1)], 'y');
legend('coupling', 'conecting rod', '4', 'ground')
hold on;
grid on
axis equal
scatter(x,y);


