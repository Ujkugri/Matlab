tic

%General Setup
clear all;
clc;

 A = [ 0 1; -2 0];
 B= [ 1 ; 1];
 C= [2 2]

 sys = ss(A,B,C,0);
 
 poles=eig(A)
 
 % Pole-Plot
 
 t=0:0.01:2;
 u=zeros(size(t));
 x0 = [0.01 0];
 
 [y,t,x]=lsim(sys,u,t,x0);
 plot(t,y)
 
 toc
 
 %% Controllability & Observability
 
 ctrb(sys);
 rkctrb=rank(ctrb(sys))

 obsv(sys);
 rkobsv=rank(obsv(sys))
 
 %% Pole-Placement Controllability
 
 cp1 = -2000+50i;
 cp2 = -2000-50i;
 
 F=place(A,B,[cp1,cp2]);
 sys_cl =ss(A-B*F,B,C,0);
 
  
 t=0:0.01:0.02;
 x0 = [0.1 0];
 [y,t,~]=lsim(sys,zeros(size(t)),t,x0);
 plot(t,y)
 lsim(sys_cl,zeros(size(t)),t,x0);
 
 %% Pole-Placement Observability
 
 op1 = -2+0.5i;
 op2 = -2-0.5i;
 
 L=place(A',C',[op1,op2])';
 sysl = ss(A-L*C,B,C,0);

 t=0:0.01:0.02;
 x0 = [0.1 0];
 [y,t,~]=lsim(sys,zeros(size(t)),t,x0);
 plot(t,y)
 lsim(sysl,zeros(size(t)),t,x0);
%%
 
 At=[ A-B*F B*F; zeros(size(A)) A-L*C];
 Bt=[ B ; zeros(size(B))];
 Ct=[ C zeros(size(C))];
 
 sysobsv =ss(At,Bt,Ct,0);
 
 t=0:0.01:0.05;
 x0 = [0.01 0];
 [y,t,~]=lsim(sysobsv,zeros(size(t)),t,[x0 x0]);
 lsim(sysobsv,zeros(size(t)),t,[x0,x0]);
 
 %% Observer
 
 t=0:0.01:0.02;
 x0 = [0.01 0];
 [y,t,x]=lsim(sysobsv,zeros(size(t)),t,[x0 x0]);
 
 n=2;
 e=x(:,n+1:end);
 x=x(:,1:n);
 x_est =x-e;
 
 %Plot
 
 h=x(:,1); h_dot=x(:,2);
 h_est=x_est(:,1); h_dot_est=x(:,2);

plot(t,h,'-r',t,h_est,':r',t,h_dot,'-b',t,h_dot_est,':b')
