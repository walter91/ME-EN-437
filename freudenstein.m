function outvec = freudenstein(thetas,theta2, r1, r2, r3, r4)

theta3 = thetas(1);
theta4 = thetas(2);

outvec(1) = r2*cos(theta2) + r3*cos(theta3) - r4*cos(theta4) - r1*cos(0);
outvec(2) = r2*sin(theta2) + r3*sin(theta3) - r4*sin(theta4) - r1*sin(0);
