[x, fs] = audioread('rl014.wav');

[pitch, vbp1, vbp2, vbp3, vbp4, vbp5, g, b, LSFcoef] = codificador(x,fs);
xout = decodificador(pitch, vbp1, vbp2, vbp3, vbp4, vbp5, b, g, LSFcoef);

plot(x)
figure;
E = reshape(xout,180*length(pitch),1);
plot(E)

audiowrite('out.wav',E,fs);