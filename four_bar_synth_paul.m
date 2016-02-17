
clear; clc; clf; close all;

theta = 63*pi/180;
w = 2*exp(1i*theta);
abs(w)
rad2deg(atan2(imag(w),real(w)))

phi = 45*pi/180;
z = 3*exp(1i*phi);
abs(z)
rad2deg(atan2(imag(z),real(z)))

sigma = 0*pi/180;
u = 1*exp(1i*sigma);
abs(u)
rad2deg(atan2(imag(u),real(u)))

% Given in problem
known(1) = 4*pi/180;     % beta2
known(2) = 8*pi/180;     % beta3
known(3) = 10*pi/180;    % beta4
known(4) = 16*pi/180;    % gamma2
known(5) = 64*pi/180;    % gamma3
known(6) = 100*pi/180;   % gamma4
% Free choices
known(7) = real(u);      % ux
known(8) = imag(u);      % uy
% Unknown
unknown(1) = real(w);    % wx
unknown(2) = imag(w);    % wy
unknown(3) = real(z);    % zx
unknown(4) = imag(z);    % zy
unknown(5) = 10*pi/180;  % alpha2
unknown(6) = 5*pi/180;   % alpha3
unknown(7) = 30*pi/180;  % alpha4

solution = fsolve(@fourfunction, unknown,[],known);
check = fourfunction(solution,known)

Wlength = sqrt(solution(1)^2 + solution(2)^2)
theta = rad2deg(atan2(solution(2), solution(1)))
Zlength = sqrt(solution(3)^2 + solution(4)^2)
phi = rad2deg(atan2(solution(4), solution(3)))


