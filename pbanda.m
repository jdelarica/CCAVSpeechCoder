function [ xfiltrada ] = pbanda( N, f1, f2, fs, x )
% N: Orden del filtro
% f1: Frecuencia de corte 1
% f2: Frecuencia de corte 2
% fs: Frecuencia de muestreo
d = designfilt('bandpassiir', 'FilterOrder',N,'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2,'SampleRate',fs);
xfiltrada = filter(d,x);

%% PARA HACER PLOT DEL FILTRO BUTTERWORTH
% N=6;
% f1=500;
% f2 = 1000;
% fs = 8000;
% [B,A] = butter((N/2),[f1 f2]/(fs/2));
% fvtool(B,A,'Fs',fs)
% figure;
% zplane(B,A)
end

