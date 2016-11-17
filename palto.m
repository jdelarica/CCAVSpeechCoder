function [ xfiltrada ] = palto( N, f1,f2, fs, x )
d = designfilt('highpassiir','FilterOrder',N, 'PassbandFrequency',f1,'PassbandRipple',f2, 'SampleRate',fs);
     
end