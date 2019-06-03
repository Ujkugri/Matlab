n=3000;
R = unidrnd(6,n,1);
h=histogram(R);
relH=h.Values(6)/n