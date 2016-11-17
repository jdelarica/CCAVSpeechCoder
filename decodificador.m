function [s] = decodificador(pitch, vbp1, vbp2, vbp3, vbp4, vbp5, b, g, ~)

[h1,h2,h3,h4,h5] = filtros();
eperio = excitacion(pitch,vbp1);
e1 = excitationfilter(h1,h2,h3,h4,h5, vbp1, vbp2, vbp3, vbp4, vbp5, eperio);
e2 = noisefilter(h1,h2,h3,h4,h5, vbp1, vbp2, vbp3, vbp4, vbp5);

state=zeros(10,1);
s = zeros(180,64);
    k=e1+e2;
 for i=1:length(pitch)
%   Se filtra la señal con los nuevos coef lpc
    [sn,state] = filter(1,b(i,:),k(:,i),state);
%   La nueva señal se multiplica por la ganancia
    s(:,i)=g(i,:)*sn;
 end
end