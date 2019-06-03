tic

%Calculate all Equilibriumpoints for a ode x'=F(x)

%differential equation system
syms x1 x2
F = [( 1 + (x1/3 - 1)*exp(-x2*27)) - 5, ( 1 + (x1/3 - 1)*exp(-x2*39)) - 6];


%Solver
sol=solve(F);
xsol=[sol.x1, sol.x2];
disp(xsol);


%Provide evidence for correctness
for i=1:length(xsol)
subs(F,[x1 x2],[xsol(i) xsol(i+length(xsol))])
end

toc

