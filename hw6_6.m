%% HW6 #6, Walter Coe, 2/17/16
clear; clc;

[angles, angularRates, lengths, linearRates, points, p] = four_bar_slider([0 110 5 90], 1, [.5 .75 .375 .5], [0 0], 1);

Vout = angularRates(2)*1.25;
Vin = linearRates(4);

% Fin*Vin = Fout*Vout
% MA = Fout/Fin = Vin/Vout

MA = Vin/Vout;

disp(['Mecanical Advantage is: ', num2str(MA)]);