%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% INTELLIGENTE DATENANALYSE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hier die Messwerte eintragen Bsp für t=0 ist x=0; t=20ms ist x=1 etc
Signal=[0  10 -1 8 -1 2];

% der Zeitabstand dt (Hier 20ms)
dt=20*1e-3;

%Fourieranalyse
n=length(Signal);  %dimension vom Raum ist n

%Eigentliche Fouriertrafo
Signal_FFT = fft(Signal,n);
f=(0:floor(n/2))/(n*dt); 

% Ploten der Werte 
plot(f,abs(Signal_FFT(1:length(f))),'-.');