%% HW7 #2

%% Given

angles = [0, -30, 0, 0];
omega2 = rad2deg(-15);
alpha2 = rad2deg(-10);

r2 = 3;
r3 = 8;
e = 2;

lengths = [5, r2, r3, e];

p = [0, 0];

options = [1, 0]

%% Calculation

[angles, angularRates, alpha3, lengths, linearRates, d_ddot, points, p] = four_bar_slider(angles, omega2, alpha2, lengths, p, options);

disp(['alpha 3 = ' num2str(alpha3) ' deg/sec' ]);
disp(['Ab = ' num2str(d_ddot) ' cm/sec']);
