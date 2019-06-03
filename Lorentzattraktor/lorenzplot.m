
% To solve the Lorenz equations. It uses the file lorenz.m
clear all % Clear all variables
clc; % Clear command


x0 = [2 -5.5 7]; % initial values in a vector
t0 = [0 20];

subplot(2,4,1)
[t, x] = ode45(@lorenz, t0, x0);
plot(t,x)
plot(t,x(:,2),'g') 
hold on

[t, x] = ode23(@lorenz, t0, x0);
plot(t,x(:,2),'r') 
xlabel('Zeit t')
ylabel('Auslenkung x(t)')
hold off

subplot(2,4,2)
plot(x(:,1), x(:,2))
xlabel('x(t)')
ylabel('y(t)')

subplot(2,4,5)
plot(x(:,1), x(:,3))
xlabel('x(t)')
ylabel('Auslenkung x(t)')

subplot(2,4,6)
plot(x(:,2), x(:,3))
xlabel('y(t)')
ylabel('z(t)')

subplot(2,4,[3 4 7 8]);
plot3(x(:,1),x(:,2),x(:,3),'-')
xlabel('x(t)');
ylabel('y(t)');
zlabel('z(t)');
title('3D phase portrait of Lorenz Attractor');
