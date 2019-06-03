%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%% Schallanalyse mit FFT %%%
                  %%% Copyright Gentian Rrafshi %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   
%% Audiofilebearbeitung
[x,fs] = audioread('C:\Users\Gentian\Dropbox\Uni\Physik\Schallanalyse mit FFT\Noten\g.mp3');                                                   
music=x(0.1e4:end);                                                        % x:komplette Audiodatei; music:der zu bearbeitende Teil
NFFT = 2^nextpow2(length(music));                                          % Signallänge fft
t = (0:1/fs:(length(music)-1)/fs);                                         % Zeit fft

plot(t,music)
xlabel('Time (seconds)')
ylabel('Amplitude')
xlim([0 t(end)])

%% Frequenzanalyse mit FFT

%Auswertung 
Y = fft(music,NFFT);
P1alt= abs(Y(1:NFFT/2+1));
f = fs/2*linspace(0,1,NFFT/2+1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%It's Deco-Time!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Peakanalyse samt Normierung
[pks,~] = findpeaks(P1alt,f);                              
P1=P1alt/(max(pks));
[pks,locs] = findpeaks(P1,f,'MinPeakDistance',5,'MinPeakHeight',0.2);      %Variable MinPeakHeight     


%Plot
subplot(2,1,1)
set(gcf,'units','normalized','outerposition',[0 0 1 1]);                   %Fullscreen Figure
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('Amplitude')
xlim([0 locs(1)+1000]);                                                     %Variable locs(1)+500


%Note aus Notenliste rauslesen
Notenliste = importdata('C:\Users\Gentian\Dropbox\Uni\Physik\Schallanalyse mit FFT\Noten\Notenliste.txt');
[~, Zeile]=min(abs( Notenliste.data(:)-locs(1)));


%Textbox
subplot(2,1,2)
text(0.5, 0.5, {['Die Grundfrequenz beträgt ', sprintf('%0.2f',locs(1)),' Hz.'];'Es handelt sich also dabei um die Musiknote:'; ' ' ;char(Notenliste.textdata(Zeile+1))}, ... 
  'VerticalAlignment', 'middle', ... 
  'HorizontalAlignment', 'center',...
  'FontSize',28); 
axis off

