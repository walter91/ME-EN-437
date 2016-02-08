%functiongeneration.m - solves a 3-point function synthesis problem 

clear
%Given:
beta2 = 5*pi/180;
beta3 = 10*pi/180;
gamma2 = 10*beta2;
gamma3 = 10*beta3;

%Choices:
alpha2 = -15*pi/180;
alpha3 = 20*pi/180;
U = 1*exp(j*0*pi/180);

mat1 = [(exp(j*beta2)-1), (exp(j*alpha2)-1);...
    (exp(j*beta3)-1), (exp(j*alpha3)-1)];

rhs = [U*(exp(j*gamma2)-1); U*(exp(j*gamma3)-1)];


solution1 = mat1\rhs;

W = solution1(1);
Z = solution1(2);

S = 0;

%construct a vector of precision points
pp = [W+Z;...
    W*exp(1i*beta2)+Z*exp(1i*alpha2);...
    W*exp(1i*beta3)+Z*exp(1i*alpha3)];

%Run the mechanism simulator, and extract the angles (position analysis)
angles = Four_Bar([W Z U S],pp,'play','thetas','radians');

%Get the angles as changes in theta2 and theta4, put in the range of -pi to
%pi, and then convert to degrees.
deltatheta2 = angles(:,2) - angle(W);
deltatheta4 = angles(:,4) - angle(U);
deltatheta2 = atan2(sin(deltatheta2),cos(deltatheta2));
deltatheta4 = atan2(sin(deltatheta4),cos(deltatheta4));
deltatheta2 = deltatheta2*180/pi;
deltatheta4 = deltatheta4*180/pi;

%Plot the changes in theta4 vs. the changes in theta2
figure(1)
clf
plot(deltatheta2,deltatheta4)
hold on
plot([0:.1:10],[0:.1:10]*10,'r')
