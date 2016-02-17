function [ shouldBeZero ] = four_bar_func_gen( variable, angles, ux, uy)

wx = variable(1);
wy = variable(2);
zx = variable(3);
zy = variable(4);


%% Variables to Iterate on
% 
% Wlength = variable(1);
% Zlength = variable(2);
% 
% phi = variable(3);
% theta = variable(4);

alpha2 = variable(5);
alpha3 = variable(6);
alpha4 = variable(7);

%% Given Functionality

beta2 = angles(1);
beta3 = angles(2);
beta4 = angles(3);

gamma2 = angles(4);
gamma3 = angles(5);
gamma4 = angles(6);

%% Free Choices


%% Equations to Solve
% x = 1;
% y = 2;
% 
% W = Wlength.*[cosd(theta), sind(theta);...
%             cosd(theta+beta2), sind(theta+beta2);...
%             cosd(theta+beta3), sind(theta+beta3);
%             cosd(theta+beta4), sind(theta+beta4)];
%         
% Z = Zlength.*[cosd(phi), sind(phi);...
%             cosd(phi+alpha2), sind(phi+alpha2);...
%             cosd(phi+alpha3), sind(phi+alpha3);
%             cosd(phi+alpha4), sind(phi+alpha4)];
%         
% U = Ulength.*[cosd(sigma), sind(sigma);...
%             cosd(sigma+gamma2), sind(sigma+gamma2);...
%             cosd(sigma+gamma3), sind(sigma+gamma3);
%             cosd(sigma+gamma4), sind(sigma+gamma4)];

% %x component
% shouldBeZero(1) = W(2,x) - W(1,x) + Z(2,x) - Z(1,x) - U(2,x) + U(1,x);
% shouldBeZero(2) = W(3,x) - W(1,x) + Z(3,x) - Z(1,x) - U(3,x) + U(1,x);
% shouldBeZero(3) = W(4,x) - W(1,x) + Z(4,x) - Z(1,x) - U(4,x) + U(1,x);
% 
% %y component
% shouldBeZero(4) = W(2,y) - W(1,y) + Z(2,y) - Z(1,y) - U(2,y) + U(1,y);
% shouldBeZero(5) = W(3,y) - W(1,y) + Z(3,y) - Z(1,y) - U(3,y) + U(1,y);
% shouldBeZero(6) = W(4,y) - W(1,y) + Z(4,y) - Z(1,y) - U(4,y) + U(1,y);

% shouldBeZero(1) = wx - wx*cos(beta2) + wy*sin(beta2) + zx - zx*cos(alpha2) + zy*sin(alpha2) - ux + ux*cos(gamma2) - uy*sin(gamma2);
% shouldBeZero(2) = wy - wy*cos(beta2) - wx*sin(beta2) + zy - zy*cos(alpha2) - zx*sin(alpha2) - uy + uy*cos(gamma2) + ux*sin(gamma2);
% shouldBeZero(3) = wx - wx*cos(beta3) + wy*sin(beta3) + zx - zx*cos(alpha3) + zy*sin(alpha3) - ux + ux*cos(gamma3) - uy*sin(gamma3);
% shouldBeZero(4) = wy - wy*cos(beta3) - wx*sin(beta3) + zy - zy*cos(alpha3) - zx*sin(alpha3) - uy + uy*cos(gamma3) + ux*sin(gamma3);
% shouldBeZero(5) = wx - wx*cos(beta4) + wy*sin(beta4) + zx - zx*cos(alpha4) + zy*sin(alpha4) - ux + ux*cos(gamma4) - uy*sin(gamma4);
% shouldBeZero(6) = wy - wy*cos(beta4) - wx*sin(beta4) + zy - zy*cos(alpha4) - zx*sin(alpha4) - uy + uy*cos(gamma4) + ux*sin(gamma4);

Ulength = sqrt(ux^2 + uy^2);
Zlength = sqrt(zx^2 + zy^2);
Wlength = sqrt(wx^2 + wy^2);

shouldBeZero(1) = wx - Wlength*cos(beta2) + zx - Zlength*cos(alpha2) - ux + Ulength*cos(gamma2);
shouldBeZero(2) = wy - Wlength*sin(beta2) + zy - Zlength*sin(alpha2) - uy + Ulength*sin(gamma2);
shouldBeZero(3) = wx - Wlength*cos(beta3) + zx - Zlength*cos(alpha3) - ux + Ulength*cos(gamma3);
shouldBeZero(4) = wy - Wlength*sin(beta3) + zy - Zlength*sin(alpha3) - uy + Ulength*sin(gamma3);
shouldBeZero(5) = wx - Wlength*cos(beta4) + zx - Zlength*cos(alpha4) - ux + Ulength*cos(gamma4);
shouldBeZero(6) = wy - Wlength*sin(beta4) + zy - Zlength*sin(alpha4) - uy + Ulength*sin(gamma4);

end

