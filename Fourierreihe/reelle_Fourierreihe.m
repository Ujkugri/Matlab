% Löschen 
clc 
close all 
% überflüssig 
% clear all 
% format long 

% Fourier 
syms x 
fx = (x^2)*6; 
n = 9; 
summe = 0; 

a = (1/(pi))*int(fx, 0, 2*pi); 

for k=1:3:n
    for i=1:n
    b = (1/(pi))*int(fx*cos(i*x), 0, 2*pi); % immer i statt n 
    c = (1/(pi))*int(fx*sin(i*x), 0, 2*pi); 
    summe = summe + b*cos(i*x) + c*sin(i*x); 
    end 
y = (a/2)+ summe; 

hold all
fplot(y,[0 2*pi])
fplot(fx,[0 2*pi])
end
