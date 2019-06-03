%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%% Schallanalyse mit FFT %%%
                  %%% Copyright Gentian Rrafshi %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Schallgenerierung

Fs =4410;                                                                   % Sampling frequency                    
T = 1/Fs;                                                                   % Sampling period       
L = 1000000;                                                                % Length of signal
t = (0:L-1)*T;                                                              % Time vector

%S = sin(2*pi*137*t);
S = sin(2*pi*437*t) + 2*sin(2*pi*329*t) + 0.4*sin(2*pi*220*t)  + 1.25*sin(2*pi*69*t) + 0.2*cos(2*pi*159*t);
X = S + 10*randn(size(t));

hold all

%Plot ohne weiﬂem Rauschen
subplot(1,2,1)
plot(1000*t(1:300),S(1:300))
title('Signal Corrupted without Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('S(t)')

%Plot mit weiﬂem Rauschen
subplot(1,2,2)
plot(1000*t(1:300),X(1:300))
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('X(t)')



%% Frequenzanalyse mit FFT


%Auswertung ohne weiﬂem Rauschen
Y1 = fft(S);
P2 = abs(Y1/L);
P1 = P2(1:L/2+1);
f1 = Fs*(0:(L/2))/L;


%Auswertung mit weiﬂem Rauschen
Y2 = fft(X);                
Q2 = abs(Y2/L);
Q1 = Q2(1:L/2+1);
f2 = Fs*(0:(L/2))/L;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%It's Deco-Time!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Peakanalyse f¸r Textbox
[pks,locs] = findpeaks(Q1,f2,'MinPeakDistance',5,'MinPeakHeight',0.05);    %Einzige Variablen, abh‰ngig von Amplituden
lange=sprintf('%0.0f',length(locs));


set(gcf,'units','normalized','outerposition',[0 0 1 1]);                    %Fullscreen Figure
%Plot ohne weiﬂem Rauschen
subplot(2,2,1)
plot(f1,P1) 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
xlim([0  locs(end)+100])

%Plot mit weiﬂem Rauschen
subplot(2,2,2)
plot(f2,Q1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P2(f)|')
xlim([0  locs(end)+100])


%Textbox
subplot(2,2,[3,4])
locs = {locs};                                                              % Create Cell; Editor Note (Gentian): kein Plan warum, aber nur so funktioniert die Frequenzliste Ø\_(?)_/Ø
text(0.5, 0.5, {['Das Signal besteht aus ', lange,' Frequenzen.'];['Es handelt sich dabei um diese Frequenzen:'];[' '];[sprintf('%0.2f\n',locs{:})]}, ... 
  'VerticalAlignment', 'middle', ... 
  'HorizontalAlignment', 'center',...
  'FontSize',28); 
axis off
