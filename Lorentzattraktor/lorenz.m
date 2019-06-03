function dx=lorenz(t,x)
% Parameters
sigma=10; 
r=28; 
b=8/3;
%Right hand sides
dx1=sigma*(x(2)-x(1));
dx2=r*x(1)-x(2)-x(1)*x(3);
dx3=x(1)*x(2)-b*x(3);

%Put togther the RHS vector
dx=[dx1;dx2;dx3];