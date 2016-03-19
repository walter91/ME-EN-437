%camrise.m
%Illustrates the surface for several cam programs
%Does rise-fall-dwell, with the same angular motion for rise and fall

beta = 90*pi/180;%anlge of rise
bc = 1;%base circle radius
st = 0.5;%total rise distance

theta = [0:beta/100:beta];
phi = theta + beta;
psi = [phi(end):(2*pi - phi(end))/100:2*pi];

%constant velocity
rcv = bc + (st)*(theta)/beta;
rcv2 = fliplr(rcv);

%simple harmonic
rsh = bc + st/2*(1-cos(pi*theta/beta));
rsh2 = fliplr(rsh);

%cycloidal
rcy = bc + st*(theta/beta - 1/(2*pi)*sin(2*pi*theta/beta));
rcy2 = fliplr(rcy);

%modified trapezoidal
x = theta/beta;
b = 0.25;
c = 0.5;
d = 0.25;
Ca = 4.8881;
rmt = zeros(size(theta));

zone = find(x<=b/2)
rmt(zone) = st*Ca*(b*x(zone)/pi - (b/pi)^2*sin(pi*x(zone)/b));
zone = find((x>=b/2) & (x<=(1-d)/2))
rmt(zone) = st*Ca*(x(zone).^2/2 + b*(1/pi - 1/2)*x(zone) + b^2*(1/8 - 1/pi^2));
zone = find((x>=(1-d)/2) & (x<=(1+d)/2))
rmt(zone) = st*Ca*((b/pi + c/2)*x(zone) + (d/pi)^2 + b^2*(1/8 - 1/(pi^2)) - (1-d)^2/8 - ...
    (d/pi)^2*cos(pi/d*(x(zone) - (1-d)/2)));
zone = find((x>=(1+d)/2) & (x<=1-b/2))
rmt(zone) = st*Ca*(-(x(zone).^2)/2 + (b/pi + 1 - b/2)*x(zone) + (2*d^2 - b^2)*(1/pi^2 - 1/8) - 1/4);
zone = find(x>=1-b/2)
rmt(zone) = st*Ca*(b/pi*x(zone) + 2*(d^2 - b^2)/pi^2 + ((1-b)^2 - d^2)/4 - ...
    (b/pi)^2*sin(pi*(x(zone) - 1)/b));

rmt = rmt + bc;
rmt2 = fliplr(rmt);

%plot the results
figure(1)
clf
plot(rcv.*cos(theta),rcv.*sin(theta),'b')
hold on
plot(rsh.*cos(theta),rsh.*sin(theta),'r')
plot(rcy.*cos(theta),rcy.*sin(theta),'g')
plot(rmt.*cos(theta),rmt.*sin(theta),'k')
plot(rcv2.*cos(phi),rcv2.*sin(phi),'b')
plot(rsh2.*cos(phi),rsh2.*sin(phi),'r')
plot(rcy2.*cos(phi),rcy2.*sin(phi),'g')
plot(rmt2.*cos(phi),rmt2.*sin(phi),'k')

plot(bc*cos(psi),bc*sin(psi),'b')
axis equal
xlabel('x coordinate of cam surface')
ylabel('y coordinate of cam surface')
legend('Constant Velocity','Simple Harmonic','Cycloidal','Modified Trapezoidal','Location','SouthEast')

figure(2)
clf
plot(theta,rcv,'b')
hold on
plot(theta,rsh,'r')
plot(theta,rcy,'g')
plot(theta,rmt,'k')
xlabel('theta (rad)')
ylabel('radius of cam surface')
legend('Constant Velocity','Simple Harmonic','Cycloidal','Modified Trapezoidal','Location', 'NorthWest')
