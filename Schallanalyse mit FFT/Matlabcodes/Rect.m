%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%% Schallanalyse mit FFT %%%
                  %%% Copyright Gentian Rrafshi %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fs = 1e9;
L = 10000;             % Length of signal
t = 0:1/Fs:(10*2e-6);
pulsewidth = 1e-6;
pulseperiods = [0:10]*4e-6;

S = pulstran(t,pulseperiods,@rectpuls,pulsewidth);
X = S + 0.02*randn(size(t));

hold on

%Plot ohne weiﬂem Rauschen
subplot(1,2,1)
plot(t,S)
title('Signal Corrupted without Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('S(t)')

%Plot mit weiﬂem Rauschen
subplot(1,2,2)
plot(t,X)
title('Signal Corrupted without Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('X(t)')


%%
%Plot ohne weiﬂem Rauschen
subplot(1,2,1)
Y = fft(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')


%Plot mit weiﬂem Rauschen
subplot(1,2,2)
Q = fft(X);
P2 = abs(Q/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P2(f)|')


