% motionsynthesis3pt.m from Dr. Jensen
%this utilizes linear equations.

clear;
% Problem givens
alpha2=(5)*pi/180;   %Angle from pos. 1 -> 2
alpha3=(-2.3)*pi/180;   %Angle from pos. 2 -> 3
p=[(-.75) - (1i*.3);111.3+1i*-151.8];   %vectors from pnt. 1 -> 2 and 1 -> 3

%Free Choices
beta2= 60*pi/180;   %initial guess for left hand leg angle from pos. 1 -> 2
beta3= 130*pi/180;  %initial guess for left hand leg angle from pos. 1 -> 3
gamma2= -5*pi/180;  %initial guess for right hand leg angle from pos. 1 -> 2
gamma3= -40*pi/180; %initial guess for right hand leg angle from pos. 1 -> 3

%Now, we'll solve for r2, r5, r4, and r6, and their angles
a1=[exp(1i*beta2)-1,exp(1i*alpha2)-1;exp(1i*beta3)-1,exp(1i*alpha3)-1];
Solutionwz =a1\p;
a2=[exp(1i*gamma2)-1,exp(1i*alpha2)-1;exp(1i*gamma3)-1,exp(1i*alpha3)-1];
Solutionus =a2\p;

W = Solutionwz(1);
Z = Solutionwz(2);
U = Solutionus(1);
S = Solutionus(2);


pp = [W+Z; W+Z+p(1); W+Z+p(2)];

Four_Bar([W Z U S],pp,'play');
