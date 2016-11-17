function [ xfiltrada ] = pbajo( N, f1, fs, x )
d = designfilt('lowpassiir','FilterOrder',N,'PassbandFrequency',f1,'PassbandRipple',0.2,'SampleRate',fs);
xfiltrada = filter(d,x);
% fvtool(d)
end