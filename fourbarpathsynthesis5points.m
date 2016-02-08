% fourbarsynthesis.m - solves a path generation problem with 5 precision
% points
clear;
knowns(1) = 1.2;%p12x
knowns(2) = 3.2;%p13x
knowns(3) = 4.8;%p14x
knowns(4) = 6;%p15x
knowns(5) = 0;%p12y
knowns(6) = 0;%p13y
knowns(7) = 0;%p14y
knowns(8) = 0;%p15y

unknowns(1) = 1;%wx
unknowns(2) = -2;%wy
unknowns(3) = -.5;%zx
unknowns(4) = -.25;%zy
unknowns(5) = -2;%ux
unknowns(6) = 2.5;%uy
unknowns(7) = -1;%sx
unknowns(8) = 0.5;%sy
unknowns(9) = pi/10;%b2
unknowns(10) = pi/5;%b3
unknowns(11) = 3*pi/10;%b4
unknowns(12) = 2.1*pi/5;%b5
unknowns(13) = pi/8;%a2
unknowns(14) = pi/4;%a3
unknowns(15) = 3*pi/8;%a4
unknowns(16) = pi/2;%a5
unknowns(17) = -pi/8;%g2
unknowns(18) = -pi/4;%g3
unknowns(19) = -3*pi/8;%g4
unknowns(20) = -pi/2;%g5


solution = fsolve(@psynthesis,unknowns,[],knowns);
output = psynthesis(solution,knowns) %This just checks to make sure all of the
%equations are 0 at the solution found by fsolve.

W = solution(1) + 1i*solution(2);
Z = solution(3) + 1i*solution(4);
U = solution(5) + 1i*solution(6);
S = solution(7) + 1i*solution(8);


pp = [W+Z; ...
    W+Z+knowns(1)+1i*knowns(5);...
    W+Z+knowns(2)+1i*knowns(6);...
    W+Z+knowns(3)+1i*knowns(7);...
    W+Z+knowns(4)+1i*knowns(8)];

Four_Bar([W Z U S],pp,'play');