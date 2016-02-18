%% HW 6 #1, Walter Coe, 2-17-16
 clear; clc;
 
%% Table P6-1 row c, pg. 328

lengths = [3 10 6 8];
omega2 = rad2deg(-15);
p = [10*cosd(80) 10*sind(80)];

%% Solve
[angles, angularRates, lengths, linearRates, points, p, vp] = four_bar_func([0 90 0 0],omega2,lengths,p,[1 0])

omega3_ = angularRates(3);
omega4_ = angularRates(4);
vpx = vp(1);
vpy = vp(2);

%% Measure across theta2 range
theta2 = 0:1:90;

for i=1:length(theta2)

    [angles, angularRates, lengths, linearRates, points, p, vp] = four_bar_func([0 theta2(i) 0 0],omega2,lengths,p,[0 0]);

    omega3(i) = angularRates(3);
    omega4(i) = angularRates(4);
    Vpx(i) = vp(1);
    Vpy(i) = vp(2);
    V2(i) = linearRates(2);

end

%% Report

disp(['omega3 is: ', num2str(omega3_), ' degrees per second']);
disp(['omega4 is: ', num2str(omega4_), ' degrees per second']);
disp(['Vpx is: ', num2str(vp(1)), ' cm per second']);
disp(['Vpy is: ', num2str(vp(2)), ' cm per second']);

figure(2); clf;
plot(theta2, omega3, theta2, omega4);
legend('Omega3', 'Omega4');
xlabel('theta2')
ylabel('angular rates in deg/sec')

figure(3); clf;
plot(theta2, Vpx, theta2, Vpy);
legend('Vpx', 'Vpy');
xlabel('theta2')
ylabel('linear rates in cm/sec')
% 
% figure(4); clf;
% plot(theta2, V2);
% legend('V2');
% xlabel('theta2')
% ylabel('linear rates in deg/sec')