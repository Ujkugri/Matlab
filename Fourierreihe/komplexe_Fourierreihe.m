% Löschen 
clc 
close all 
% überflüssig 
clear all 
% format long 

% Fourier 
syms x 
fx = log(x+1); 

%%

n1 = 3; 
summe1 = 0; 

    for j=(-n1):n1
    c = (1/(2*pi))*int(fx*exp( (-1i)*j*x), 0, 2*pi); % immer j statt n 
    summe1 = summe1 + c*exp(1i*j*x);
    end 
    y1 = summe1; 

% %%
% 
% n2 = 9; 
% summe2 = 0; 
% 
%     for j=(-n2):n2
%     c = (1/(2*pi))*int(fx*exp( (-1i)*j*x), 0, 2*pi); % immer j statt n 
%     summe2 = summe2 + c*exp(1i*j*x);
%     end 
%     y2 = summe2; 
% 
%%

n3 = 27; 
summe3 = 0; 

    for j=(-n3):n3
    c = (1/(2*pi))*int(fx*exp( (-1i)*j*x), 0, 2*pi); % immer j statt n 
    summe3 = summe3 + c*exp(1i*j*x);
    end 
    y3 = summe3; 

%%

ax1 = subplot(1,3,1), 
fplot(fx,[0 2*pi],'r','Linewidth',3)
ylim([0 2.5])
grid on 
title('\fontsize{22} f(x)= ln(x+1)')
ax1.FontSize = 14;

ax2 = subplot(1,3,2),
hold on
fplot(y1,[0 2*pi],'Linewidth',3)
fplot(fx,[0 2*pi],'r','Linewidth',3)
ylim([0 2.5])
grid on 
title('\fontsize{22} komplexe Fourierreihe (n=3) von f(x)')
ax2.FontSize = 14;
hold off

% ax3 = subplot(1,4,3),
% hold on
% fplot(y2,[0 2*pi])
% fplot(fx,[0 2*pi],'r')
% ylim([0 2.5])
% grid on 
% title('komplexe Fourierreihe (n=9) von f(x)')
% ax3.FontSize = 14;
% hold off

ax4 = subplot(1,3,3),

hold on
fplot(y3,[0 2*pi],'Linewidth',3)
fplot(fx,[0 2*pi],'r','Linewidth',3)
ylim([0 2.5])
grid on 
title('\fontsize{22} komplexe Fourierreihe (n=27) von f(x)')
ax4.FontSize = 14;
hold off


