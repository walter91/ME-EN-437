%% HW 6 #3, Walter Coe, 2-17-16
 clear; clc;
 
 %% Setup
 
 r1x = 7.5;
 r1y = 5;
 r2 = 2;
 r3 = 6;
 r4 = 6;
 r5 = 6;
 
 r1 = sqrt(r1x^2 + r1y^2);
 theta1 = rad2deg(atan2(r1y, r1x));
 
 theta2 = 45;
 %unkown: theta3, theta4, theta5
 
 omega1 = 0;
 omega2 = rad2deg(100*2*pi/60);
 %unkown: omega3, omega4, omega5
 
 %% First four bar linkage
 
 [angles, angularRates, lengths, linearRates, points, p, vp] = four_bar_func([theta1 theta2 -45 -45], omega2, [r1 r2 r3 r4], [0 0], [1 0])
 
 theta3Solved = angles(3);
 theta4Solved = angles(4);
 
 Va = linearRates(2,:);
 Vb = linearRates(3,:);
 
 omega3Solved = angularRates(3);
 omega4Solved = angularRates(4);
 
 point3 = points(3,:);
 
 %% Crank Slider Analysis
 
 %[angles, angularRates, lengths, linearRates, points, p] = four_bar_slider([0 (90-theta4Solved) 30 90], omega4Solved, [9 r4 r5 0], [0 0], 1)
 
%  theta5Solved = 180-rad2deg(asin((r1x-point3(1))/(r5)));
%  omega5Solved = -(r4*cosd(90-theta4Solved)*omega4Solved/(r5*cosd(theta5Solved)));
%  
%  Vc = -r4*omega4Solved*sind(90-theta4Solved)+r5*omega5Solved*sind(theta5Solved);
 Vc = 2*Vb(1); %by symmetry...
 
 %% Report
 
 disp(['Va is: '  num2str(sqrt(Va(1)^2 + Va(2)^2))  ' cm/sec']);
 disp(['Vb is: '  num2str(sqrt(Vb(1)^2 + Vb(2)^2))  ' cm/sec']);
 disp(['Vc is: '  num2str(Vc)  ' cm/sec']);
 
 
 