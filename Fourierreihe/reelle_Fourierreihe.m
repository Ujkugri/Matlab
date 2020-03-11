% Löschen 
clc 
close all 
% überflüssig 
clear all 
% format long 

% Fourier 
syms x 
fx = log(x+1); 
a = (1/(pi))*int(fx, 0, 2*pi); 
%%

summe1 = 0; 

    for i=1:3
    b = (1/(pi))*int(fx*cos(i*x), 0, 2*pi); % immer i statt n 
    c = (1/(pi))*int(fx*sin(i*x), 0, 2*pi); 
    summe1 = summe1 + b*cos(i*x) + c*sin(i*x); 
    end 
y1 = (a/2)+ summe1; 


%%
% 
% summe2 = 0; 
% 
%     for i=1:9
%     b = (1/(pi))*int(fx*cos(i*x), 0, 2*pi); % immer i statt n 
%     c = (1/(pi))*int(fx*sin(i*x), 0, 2*pi); 
%     summe2 = summe2 + b*cos(i*x) + c*sin(i*x); 
%     end 
% y2 = (a/2)+ summe2; 
%%

summe3 = 0; 

    for i=1:27
    b = (1/(pi))*int(fx*cos(i*x), 0, 2*pi); % immer i statt n 
    c = (1/(pi))*int(fx*sin(i*x), 0, 2*pi); 
    summe3 = summe3 + b*cos(i*x) + c*sin(i*x); 
    end 
y3 = (a/2)+ summe3; 
%%

ax1 = subplot(1,3,1), 
fplot(fx,[0 2*pi],'r','Linewidth',2)
ylim([0 2.5])
grid on 
title('\fontsize{16} f(x)= ln(x+1)')
ax1.FontSize = 14;

ax2 = subplot(1,3,2),
hold on
fplot(y1,[0 2*pi],'Linewidth',2)
fplot(fx,[0 2*pi],'r','Linewidth',2)
ylim([0 2.5])
grid on 
title('\fontsize{16} reelle Fourierreihe (n=3) von f(x)')
ax2.FontSize = 14;
hold off

% ax3 = subplot(1,4,3),
% hold on
% fplot(y2,[0 2*pi])
% fplot(fx,[0 2*pi],'r')
% ylim([0 2.5])
% grid on 
% title('reelle Fourierreihe (n=9) von f(x)')
% ax3.FontSize = 14;
% hold off

ax4 = subplot(1,3,3),

hold on
fplot(y3,[0 2*pi],'Linewidth',2)
fplot(fx,[0 2*pi],'r','Linewidth',2)
ylim([0 2.5])
grid on 
title('\fontsize{16} reelle Fourierreihe (n=27) von f(x)')
ax4.FontSize = 14;
hold off



