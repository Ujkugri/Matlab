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

%for k=(-n):3:n
    for j=(-n):n
    c = (1/(2*pi))*int(fx*exp( (-1i)*j*x), 0, 2*pi); % immer j statt n 
    summe = summe + c*exp(1i*j*x);
    end 
y = summe; 

hold all
fplot(y,[0 2*pi])
fplot(fx,[0 2*pi])
%end
