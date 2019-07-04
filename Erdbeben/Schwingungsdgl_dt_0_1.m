%% Aufgabe 2: für dt2=0.1
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('---> Aufgabe 2 wird geloest ...\n');

% Eingangsgroeßen

beta = 0.0;                     % Newmark parameter beta
gamma = 0.0;					% Newmark parameter gamma
dt2 = 0.1;						% Zeitschrittweite

T = 100;    					% Beobachtungszeitraum
t_out = 0.1;    				% Zeitschrittweite
m = 1.0;						% Masse des 1-Massenschwingers
c = 1.0;						% Federkonstante des 1-Massenschwingers
d = 0.25;						% Daempfungskonstante des 1-Massenschwingers
x0 = 1.0;						% Anfangsbedingung x(t)
v0 = 0;							% Anfangsbedingung v(t)
W = sqrt(c/m)*1.5;				% Erregerfrequenz
f = 0.125;						% Krafterregung F0
xg = 0;							% Fusspunkterregung

%%%%%%%%%%%%
% analytische Loesung

W0 = sqrt(c/m);    				% Eigenkreisfrequenz
D = d/(2*m*W0);    				% Lehrsches Daempfungsmaß
Astat = f/(m*W0*W0);			% statische Amplitude
rel = W/W0;						% Frequenzverhaeltnis

if(f==0) 
	Vx = 1.0;
else
	Vx = sqrt(1/(((1-(rel^2))^2)+(4*D^2*rel^2)));	% Vergrößerungsfunktion
end
if(D==0) 
	phi =  0;
else
	phi = atan((2*D*rel)/(1-rel^2));				% Phasenversatz
end
nue = W0*sqrt(abs(D^2-1));

% Ermittlung der Anfangsbeschleunigung

a0p = -W*W*Astat*Vx*cos(phi);	% Anteil aus der particular Lösung

% Addiere Anteil aus der homogenen Lösung getrennt nach Dämpfung */

if(D >= 1.0)					% ueberkritische Daempfung
   c0 = (sqrt((D^2)-1)-D)*W0;
   a0h = c0*c0*x0;
else
   if(abs(nue) > 1e-15) 		% schwache Daempfung
     c0 = (v0+(D*W0*x0))/nue;
     a0h = -(2*D*W0*nue*c0+D*D*W0*W0*x0+nue*nue+x0); 
   else  						% keine Daempfung
     c0 = 0;
     a0h = -D*D*W0*W0*x0; 
   end
end

a0 = a0h+a0p;
 
% Zeitverlauf der Lösung

i=1;
for t=0:t_out:T
	% particular Lösung
	if(f >= 1e-15) 
	xp(i) = Astat*Vx*cos(W*t-phi);
	else
	xp(i) = 0;
	end
	
	% homogene Lösung
	if(D >= 1.0)					% starke Daempfung
		xh(i) = x0*exp(c0*t);
	else 
		if(abs(nue) <= 1e-15) 		% keine Daempfung
			xh(i) = exp(-D*W0*t)*x0;  
		else   						% schwache Daempfung
			xh(i) = exp(-D*W0*t)*(c0*sin(nue*t)+x0*cos(nue*t)); 
		end
	end
	
	% Gesamtlösung
	x(i) = xp(i)+xh(i);
	t_val(i) = t;
	i=i+1;
end

%%%%%%%%%%%%
% Ermittle Lösung der Schwingungdgl. mit impliziten Newmark

phi = 3.14159;
x0_imp = x0;
v0_imp = v0;
a0_imp = a0;
Tout = 0;
amax = 0; 
vmax = 0;
xmax = 0; 
xf = 0;
vf = 0;
af = 0;
ft = 0;
t = 0;
j=1;
if(t_out <= T)
	x_imp(j) = x0_imp;
	t_imp_val(j) = 0;
	j=j+1;
end

for t=0:dt2:T
  mstern = m+dt2*(1.0-1.0)*d+0.5*dt2*dt2*(1.0-2.0*0.5)*c;  

  % erregte Schwingung, Überschreibe ft = 0
  if(t<=T)
    ft = f*cos(W*t+phi);
    % Normierung des Antwortspektrums
    af = c/m;
    vf = c/(m*W0);
    xf = c/(m*W0*W0);
  end

  % Newmark Werte
  fstern = ft-c*(x0_imp+dt2*v0_imp+dt2*dt2*0.5*a0_imp)-d*(v0_imp+dt2*1.0*a0_imp);
  if(abs(mstern)<1e-15)
	break;
  end
  
  % aktuelle Beschleunigung und bezogene Relativbeschleunigung
  a1 = fstern/mstern;
  Spa = (a1+af)/af; 

  % aktuelle Geschwindikeit und bezogene Relativgeschwindigkeit
  v1 = v0_imp+dt2*((1.0-1.0)*a0_imp+1.0*a1);
  Spv = v1/vf;
  
  % aktuelle Position und bezogene Relativposition
  x1 = x0_imp+dt2*v0_imp+0.5*dt2*dt2*((1.0-2.0*0.5)*a0_imp+2.0*0.5*a1);
  Spx = x1/xf ; 		%klassische Vergrößerungsfunktion
  Tout = Tout+dt2;

  % Datenausgabe entsprechend Ausgabeintervall
  if(Tout >= t_out)
	x_imp(j) = x1;
	t_imp_val(j) = t;
    Tout = 0;
	j=j+1;
  end
    
  % Bestimme betragsmäßige maximale Werte der Relativgrößen
  if(abs(Spa) > abs(amax)) 
	amax = abs(Spa); 
  end
  if(abs(Spv) > abs(vmax)) 
	vmax = abs(Spv);
  end
  if(abs(Spx) > abs(xmax)) 
	xmax = abs(Spx); 
  end      

  % Setze alte Werte = Neue Werte  
  a0_imp = a1;
  v0_imp = v1;
  x0_imp = x1;
end

%%%%%%%%%%%%
% Ermittle Lösung der Schwingungdgl. mit explizitem Newmark

x0_exp = x0;
v0_exp = v0;
a0_exp = a0;
Tout = 0;
amax = 0; 
vmax = 0;
xmax = 0; 
xf = 0;
vf = 0;
af = 0;
ft = 0;
t = 0;
j=1;
if(t_out <= T)
	x_exp(j) = x0_exp;
	t_exp_val(j) = 0;
	j=j+1;
end

for t=0:dt2:T
  mstern = m+dt2*(1.0-0)*d+0.5*dt2*dt2*(1.0-2.0*0)*c;  

  % erregte Schwingung, Überschreibe ft = 0
  if(t<=T)
    ft = f*cos(W*t+phi);
    % Normierung des Antwortspektrums
    af = c/m;
    vf = c/(m*W0);
    xf = c/(m*W0*W0);
  end

  % Newmark Werte
  fstern = ft-c*(x0_exp+dt2*v0_exp+dt2*dt2*0*a0_exp)-d*(v0_exp+dt2*0*a0_exp);
  if(abs(mstern)<1e-15)
	break;
  end
  
  % aktuelle Beschleunigung und bezogene Relativbeschleunigung
  a1 = fstern/mstern;
  Spa = (a1+af)/af; 

  % aktuelle Geschwindikeit und bezogene Relativgeschwindigkeit
  v1 = v0_exp+dt2*((1.0-0)*a0_exp+0*a1);
  Spv = v1/vf;
  
  % aktuelle Position und bezogene Relativposition
  x1 = x0_exp+dt2*v0_exp+0.5*dt2*dt2*((1.0-2.0*0)*a0_exp+2.0*0*a1);
  Spx = x1/xf ; 		%klassische Vergrößerungsfunktion
  Tout = Tout+dt2;

  % Datenausgabe entsprechend Ausgabeintervall
  if(Tout >= t_out)
	x_exp(j) = x1;
	t_exp_val(j) = t;
    Tout = 0;
	j=j+1;
  end
    
  % Bestimme betragsmäßige maximale Werte der Relativgrößen
  if(abs(Spa) > abs(amax)) 
	amax = abs(Spa); 
  end
  if(abs(Spv) > abs(vmax)) 
	vmax = abs(Spv);
  end
  if(abs(Spx) > abs(xmax)) 
	xmax = abs(Spx); 
  end      

  % Setze alte Werte = Neue Werte  
  a0_exp = a1;
  v0_exp = v1;
  x0_exp = x1;
end

%%%%%%%%%%%%
% Ermittle Lösung der Schwingungdgl. mit Newmark Verfahren

x0_newmark = x0;
v0_newmark = v0;
a0_newmark = a0;Tout = 0;
amax = 0; 
vmax = 0;
xmax = 0; 
xf = 0;
vf = 0;
af = 0;
ft = 0;
t = 0;
j=1;
if(t_out <= T)
	x_newmark(j) = x0_newmark;
	t_newmark_val(j) = 0;
	j=j+1;
end

for t=0:dt2:T
  mstern = m+dt2*(1.0-gamma)*d+0.5*dt2*dt2*(1.0-2.0*beta)*c;  

  % erregte Schwingung, Überschreibe ft = 0
  if(t<=T)
    ft = f*cos(W*t+phi);
    % Normierung des Antwortspektrums
    af = c/m;
    vf = c/(m*W0);
    xf = c/(m*W0*W0);
  end

  % Newmark Werte
  fstern = ft-c*(x0_newmark+dt2*v0_newmark+dt2*dt2*beta*a0_newmark)-d*(v0_newmark+dt2*gamma*a0_newmark);
  if(abs(mstern)<1e-15)
	break;
  end
  
  % aktuelle Beschleunigung und bezogene Relativbeschleunigung
  a1 = fstern/mstern;
  Spa = (a1+af)/af;

  % aktuelle Geschwindikeit und bezogene Relativgeschwindigkeit
  v1 = v0_newmark+dt2*((1.0-gamma)*a0_newmark+gamma*a1);
  Spv = v1/vf;
  
  % aktuelle Position und bezogene Relativposition
  x1 = x0_newmark+dt2*v0_newmark+0.5*dt2*dt2*((1.0-2.0*beta)*a0_newmark+2.0*beta*a1);
  Spx = x1/xf ; 		%klassische Vergrößerungsfunktion
  Tout = Tout+dt2;

  % Datenausgabe entsprechend Ausgabeintervall
  if(Tout >= t_out)
	x_newmark(j) = x1;
	t_newmark_val(j) = t;
    Tout = 0;
	j=j+1;
  end
    
  % Bestimme betragsmäßige maximale Werte der Relativgrößen
  if(abs(Spa) > abs(amax)) 
	amax = abs(Spa);
  end
  if(abs(Spv) > abs(vmax)) 
	vmax = abs(Spv);
  end
  if(abs(Spx) > abs(xmax)) 
	xmax = abs(Spx); 
  end      

  % Setze alte Werte = Neue Werte  
  a0_newmark = a1;
  v0_newmark = v1;
  x0_newmark = x1;
end
  
%%%%%%%%%%%%

% Visualisierung

figure(1)
plot(t_val,x,t_imp_val,x_imp,t_exp_val,x_exp,t_newmark_val,x_newmark);
legend('analytisch','implizit','explizit',sprintf('newmark b = %1.2f, g=%1.2f', beta, gamma));
title(sprintf('Einfluss der Newmark Parameter beta (b) und gamma (g) fuer dt = %f', dt2)); 		% title of plot
xlabel('Zeit t') 										% x-axis label
ylabel('Auslenkung') 									% y-axis label
xlim([0 50]);									% y-axis label
ylim([-1.5 1.5]);
grid on
hold off

% Ende Aufgabe 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%