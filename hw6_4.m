%hw6 #4, Walter Coe, 2/17/16

clear; clc;

%% Second Half of analysis (crank-slider)
theta2 = 15:1:60;

for i = 1:length(theta2)
    [angles, angularRates, alpha3, lengths, linearRates, points, p] = four_bar_slider([0 theta2(i) 30 90], 1, 0, [50 105 172 27], [0 0], 1);

    V2(i,:) = linearRates(2,:);
    V3(i,:) = linearRates(3,:);

    Ma(i) = (V2(i)/V3(i))*(301/105);
end

%% results

figure(3); clf;
plot(theta2, Ma);
xlabel('Theta2');
ylabel('Mechanical Advantage');

