%% HW9 #10.1

clear; clc;

%% Properties (_s = steel, _w = wood, _c = combined)

den_w = .001122*.9;    %slug/inch^3
den_s = 7850*1.12287e-6;     %slug/inch^3 (kg/m^3->slug/in^3)

vol_w = 3.5*((pi/4)*1.25^2);    %in^3
vol_s = 10*((pi/4)*1.25^2);     %in^3

mass_w = vol_w*den_w;
mass_s = vol_s*den_s;
mass_c = mass_w+mass_s;

cg_w = [10/2, 0, 0];
cg_s = [10+(1.25/2), 0, 0];

cg_c = (cg_w*mass_w + cg_s*mass_s)/(mass_c);

disp(['Combined center of mass is: [', num2str(cg_c), '] inches along x, y, z axis'])

Izz_w = mass_w*(10^2)/3;    %moment about the end
Izz_s = ((mass_s*(3.5)^2)/12) + mass_s*(cg_s(1)^2);   %moment about center + PAT

Izz_c = Izz_w + Izz_s;

disp(['Combined mass moment of inertia is: ', num2str(Izz_c), ' slug*in^2 about the z axis'])

k = sqrt(Izz_c / mass_c);

disp(['Combined radius of gyration is: ', num2str(k), ' inches along the z axis'])
