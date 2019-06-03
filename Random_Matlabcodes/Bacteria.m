h=0.25;
r=0.8;
a=0;
b=10;
m=(b-a)/h;
N=zeros(1,m);
N0=1000;

N(1)=N0+r*h*N0;
for i=2:m
    N(i)= N(i-1) + r * h * N(i-1);
end

t =  a+h : h : b;
Nex= N0 * exp(r*t);
disp([t' N' Nex'])
plot (a,N0)
hold on
plot(t,N), xlabel('Hours'), ylabel('Bacteria')
plot(t, Nex) 
hold off