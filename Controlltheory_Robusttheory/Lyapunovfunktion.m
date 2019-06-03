%% getting Lyaponuvfunctions
clear all; clc;

%Define variables----------------------------------------------------------
pvar x1 x2  t;
xk = [x1;x2];

% Define ODE---------------------------------------------------------------
x1dot = -x1 - 2*x2^2;
x2dot = -x2 - x1*x2 - 2*x2^3;
f = [x1dot;x2dot];

% The Constraints on V-----------------------------------------------------
% V(t,x) - epsilon is SOS
zV = monomials([t;xk],[2]);
V = polydecvar('c',zV,'vec');

% The Constraints on V-----------------------------------------------------
% V(t,x) - epsilon is SOS
V0 = subs(V,xk,[0;0]);
sosconstr(1) = V - V0 ;

% -Vdot is SOS
sosconstr(2) = -jacobian(V-V0,xk)*f -diff(V-V0,t);


% Solve with feasibility problem-------------------------------------------
[info,dopt,sossol] = sosopt(sosconstr,[t;xk]);

% Getting V(t,x)-----------------------------------------------------------
fprintf('\n----------------Results----------------');
if info.feas
    fprintf('\nSOS Optimization is feasible.\n');
    Vsol = subs(V-V0,dopt)  %#ok<NOPTS>
% Getting V as xtrans*P*x
        fprintf('\nSOS The Decomposition of Vsol is as followed \n');
        [~,x,P] = issos(Vsol)
        fprintf('Eigenvalues of P are:'); 
        disp((eig(P)));
% Getting Vdot
        fprintf('\n SOS The Decomposition of Vdot is as followed \n');
        [~,z,Q] = issos((-jacobian(Vsol,xk)*f))
        fprintf('Eigenvalues of Q are:'); 
        disp((eig(Q)))
else
    fprintf('\n SOS Optimization is not feasible. \n');    
    return
end

%% Plot for V with various levelsets --------------------------------------
close all;
tmp = -10:1:10;
lt = length(tmp);
x0 = [  tmp(:) repmat(tmp(1),[lt 1]); 
        tmp(:) repmat(tmp(end),[lt 1]); ...
        repmat(tmp(1),[lt 1]) tmp(:); 
        repmat(tmp(end),[lt 1]) tmp(:)];
tfinal = 100;
[xtraj,xconv]=psim(f,xk,x0',tfinal);

for i1=1:length(xtraj)
    plot(xtraj{i1,2}(:,1),xtraj{i1,2}(:,2),'b'); hold on;
end
ax = [min(tmp) max(tmp) min(tmp) max(tmp)];
[C,h]=pcontour(Vsol,[1 2.5 5 10 15 20],ax,'r');
clabel(C,h,'FontSize',15,'color','k');
axis(ax);
for i1=1:length(xtraj)
    plot(xtraj{i1,2}(:,1),xtraj{i1,2}(:,2),'b'); hold on;
end
ax = [min(tmp) max(tmp) min(tmp) max(tmp)];
[C,h]=pcontour(Vsol,[1 2.5 5 10 15 20],ax,'r');
clabel(C,h,'FontSize',15,'color','k');
axis(ax);