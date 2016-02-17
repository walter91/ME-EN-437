function outvec = fourfunction(unknown, known)

% Given in problem
beta2 = known(1);
beta3 = known(2);
beta4 = known(3);
gamma2 = known(4);
gamma3 = known(5);
gamma4 = known(6);
% Free choices
ux = known(7);
uy = known(8);
% Unknown
wx = unknown(1);
wy = unknown(2);
zx = unknown(3);
zy = unknown(4);
alpha2 = unknown(5);
alpha3 = unknown(6);
alpha4 = unknown(7);

outvec(1) = wx - wx*cos(beta2) + wy*sin(beta2) + zx - zx*cos(alpha2) + zy*sin(alpha2) - ux + ux*cos(gamma2) - uy*sin(gamma2);
outvec(2) = wy - wy*cos(beta2) - wx*sin(beta2) + zy - zy*cos(alpha2) - zx*sin(alpha2) - uy + uy*cos(gamma2) + ux*sin(gamma2);
outvec(3) = wx - wx*cos(beta3) + wy*sin(beta3) + zx - zx*cos(alpha3) + zy*sin(alpha3) - ux + ux*cos(gamma3) - uy*sin(gamma3);
outvec(4) = wy - wy*cos(beta3) - wx*sin(beta3) + zy - zy*cos(alpha3) - zx*sin(alpha3) - uy + uy*cos(gamma3) + ux*sin(gamma3);
outvec(5) = wx - wx*cos(beta4) + wy*sin(beta4) + zx - zx*cos(alpha4) + zy*sin(alpha4) - ux + ux*cos(gamma4) - uy*sin(gamma4);
outvec(6) = wy - wy*cos(beta4) - wx*sin(beta4) + zy - zy*cos(alpha4) - zx*sin(alpha4) - uy + uy*cos(gamma4) + ux*sin(gamma4);