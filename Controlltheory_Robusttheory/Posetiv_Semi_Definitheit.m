%% sosproof
clearvars; clc;

%Define a polynomial with its variables------------------------------------
pvar x1 x2;
f =2*x1^4*x2^2+2*x1^2*x2^4+4*x1^2*x2 +2;

%Check if f is
%SOS-----------------------------------------------------------------------
[feas,x,P] = issos(f);

% if feasible display x,P such that xtrans*P*x =f--------------------------
fprintf('\n----------------Results----------------')
if feas              
    fprintf('\n The given Polynomial is SOS.\n');
    [~,x,P] = issos(f);
    error = f - x'*P*x;
        fprintf('Eigenvalues of P are:'); 
                disp(P); 
        disp((eig(P)));       
% if not feasible say it---------------------------------------------------
else
    fprintf('\n  The given Polynomial is not SOS.\n');
    [feas,~,~] = issos(f);
end