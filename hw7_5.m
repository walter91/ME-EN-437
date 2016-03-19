clear; clc;

% Using Inkscape I measured the angle of motion, which is perpendicular to
% the follower arm. I found that angle to be -144 degrees, which equates to
% a motion of 126 degrees. The angle of force, which is perpendicular to
% the shared tangent is 120 degrees. That results in a pressuere angle
% (phi) of 6 degrees.

angM = 360-144-90;

angF = 120;

disp(['Pressure angle is ' num2str(angM - angF) ' degrees']);