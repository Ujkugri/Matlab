function konsensoptshort()
N = 100;
konsens = rand(N,1)*10;         %rand gibt Zahl zwischen 0 bis 1 aus 
M=mean(konsens);
T = 400;                        %Wie lange läuft mein System
h = 0.1;                        %Schrittweite Zeit
H = T/h;                        %Schrittweite Einschrittverfahren

x = NaN(N,H+1);
x(:,1) = konsens;

figure(1); clf; hold all
subplot(1,4,1);                 %Die Bewertung (0-10) von jeder Person xi
stem(konsens,'linestyle','none','marker','pentagram') 
xlabel('Agent i')
ylabel('Opinion x_i(0)')

for nPhi=1:3                    %Einschrittverfahren h=0.1
   for k=1:H
     x(:,k+1) = x(:,k) + (h/10)*rhs(x(:,k),nPhi);
   end
   
   t = [0:h:T];
   subplot(1,4,nPhi+1)
   
   for ii=1:N     
       hold all;
       plot(t,x(ii,:))
       title({['Opinion dynamic'];['with influence function \phi_' num2str(nPhi) '(|x_i - x_j|)']})
       xL = get(gca,'XLim');
       ax=line(xL,[M M],'Color','r','LineStyle','-.','LineWidth',1);
   end
   xlabel('Time t')
   ylabel('Opinion x(t)')
   ylim([0 10])
end
end

function ret=phi(x,nPhi)            %Die verschiedenen Einflussfunktionen 
   if(nPhi==1)
      ret = 0.01*[x>=0 & x<=1/sqrt(2)] + [x>1/sqrt(2) & x<=1];       
   elseif(nPhi==2)
      ret = 0.01*[x>=0 & x<=1.5/(sqrt(2))] + [x>1.5/(sqrt(2)) & x<=1.5];
   elseif(nPhi==3)
       ret = 0.01*[x>=0 & x<=2/(sqrt(2))] + [x>2/(sqrt(2)) & x<=2];
   else
     error('Stop being stupid, stupid!');
   end
end

function dx = rhs(x,nPhi)            %Die rechte Seite meines Systems
    alpha = 1;
    N = size(x,1);
    dx = zeros(N,1);

    for ii=1:N
        for jj=1:N
            if(ii~=jj)
                d = x(jj,1)-x(ii,1);
                    tmp=0;
                    for gg=1:N
                        tmp = tmp + phi(abs(x(ii,1)-x(gg,1)),nPhi);
                    end 
            a = (1/tmp)*phi(abs(d),nPhi);
            dx(ii,1) = dx(ii,1) + alpha*a*d;
            end
        end
    end
end