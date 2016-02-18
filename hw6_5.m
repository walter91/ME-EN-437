%% HW6 #5, Walter Coe, 2/17/16
clear; clc;

[angles, angularRates, lengths, linearRates, points, p, vp] = four_bar_func([0 49 40 110], 1, [2.4 .8 1.23 1.55], [0 0 ], [1 0]);


Vin = angularRates(2)*4.26;
Vout = angularRates(4)*1;

% Fin*Vin = Fout*Vout
% MA = Fout/Fin = Vin/Vout

MA = Vin/Vout;

disp(['Mecanical Advantage is: ', num2str(MA)]);