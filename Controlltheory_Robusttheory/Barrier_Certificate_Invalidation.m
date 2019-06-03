%%
clear all; clc; close all;

%Define variables----------------------------------------------------------
pvar x1 x2 t;
x = [x1;x2];

% Define ODE---------------------------------------------------------------
x1dot = -x1^3 + x2;
x2dot = -x2 - x1 +2;
f = [x1dot;x2dot];

% Define the initial set and unsafe set------------------------------------
% The state set is the entire R^2
% Xini = {x : ginit(x) >= 0}
% Xunsafe = {x : gunsafe(x) >= 0}
ginit = 2 - (x1-1)^2 - (x2-1)^2;
gunsafe = 1 - (x1-2)^2 - (x2+1.5)^2;

% Define decision variable-------------------------------------------------
zB = monomials([t;x],[0;2;3;4]);
B = polydecvar('b',zB,'vec');

% Define the Constraints for B(t,x)----------------------------------------
% Impose: B(x) <= 0 for all x in Xinit
zs0 = monomials([x],[2]);
s0 = polydecvar('c',zs0,'vec');
% The multiplier is SOS
sosconst(1) = s0>=0;
% Impose: B(x) > 0 for all x in Xunsafe
zs1 = monomials([x],[2]);
s1 = polydecvar('c',zs1,'vec');
% The multiplier is SOS
sosconst(2) = s1>=0;
% Impose: B(x) > 0 for all x in Xunsafe
zn1 = monomials([t],[0]);
n1 = polydecvar('c',zn1,'vec');
% The multiplier is SOS
sosconst(2) = n1>=0;

% B-epsilon-s1*gunsafe is SOS
epsilon = 1e-6;
B0 = subs(B,t,0);
B1 = subs(B,t,4);
% -B-s0*ginit is SOS
sosconst(3) = B1-epsilon-s1*gunsafe - B0 - s0*ginit >=0;
sosconst(4) = B1-epsilon-s1*gunsafe>=0;
sosconst(5) = -B0 -s0*ginit>=0;


% Impose: (dB/dx)(x) <= 0 for all x
sosconst(7) = -diff(B,t)- jacobian(B,x)*f -n1*(4*t-t^2)>=0;
% Solve with feasibility problem-------------------------------------------
[info,dopt,sossol] = sosopt(sosconst,[t;x]);

% Getting B(t,x)-----------------------------------------------------------
fprintf('\n----------------Results');
if info.feas
    fprintf('\n SOS Optimization is feasible.\n');
    Bg = subs(B,dopt)
else
    fprintf('\nSOS Optimization is not feasible. \n');    
    return
end

%% Plot for B with various levelsets --------------------------------------
close all
tmp = -3:0.5:4;
lt = length(tmp);
x0 = [tmp(:) repmat(tmp(1),[lt 1]); tmp(:) repmat(tmp(end),[lt 1]); ...
    repmat(tmp(1),[lt 1]) tmp(:); repmat(tmp(end),[lt 1]) tmp(:)];
tfinal = 200;
[xtraj,xconv]=psim(f,x,x0',tfinal);

for i1=1:length(xtraj)
    plot(xtraj{i1,2}(:,1),xtraj{i1,2}(:,2),'b'); hold on;
end
ax = [min(tmp) max(tmp) min(tmp) max(tmp)];

[Ci,hi]=pcontour(ginit,[0],ax,'g');
[Cu,hu]=pcontour(gunsafe,[0],ax,'k');

axis(ax);


