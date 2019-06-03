% "The Golf ball problem"

% Clearprocess
clc;    % Clear the command window.
clearvars;
close all;  % Close all figures (except those of imtool.)
workspace;  % Make sure the workspace panel is showing.
fontSize = 20;
format compact;

% INPUT DATA
% Specified constants:
k = 0.01;
g = 9.81;
dt = 0.01;
%
% Input the initial condition:
%
prompt = {' Initial angle of launch: ',' Initial speed of launch: '};
titleBar = 'Enter an integer value';
defaultans = {'30','100'};
answer = inputdlg(prompt,titleBar,1,defaultans);

theta = str2double(answer{1});
Vs= str2double(answer{2});

the = theta * pi/180.;
u(1) = Vs * cos(the);
v(1) = Vs * sin(the);
% Launch pad location:
x(1) = 0.;
y(1) = 0.01;

% Compute approximate solution of the trajectory of flight
for n=1:1:6000

u(n+1) = u(n) - dt * (k * sqrt(u(n)^2+v(n)^2) * u(n));
v(n+1) = v(n) - dt * (k * sqrt(u(n)^2+v(n)^2) * v(n) + g);
x(n+1) = x(n) + u(n) * dt;
y(n+1) = y(n) + v(n) * dt;
  
% Determination of when the object hits ground:
if y(n+1) < 0; break; end
slope = (y(n+1) - y(n))/(x(n+1) - x(n));
b = y(n) - slope * x(n);
xhit = - b/slope;
      
end

%the plot
plot(x,y);

%Message about how far the ball went
message = sprintf(' The length of the shot = %5.2f \n', xhit);
msgbox(message);
