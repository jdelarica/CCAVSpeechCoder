function [eperio] = excitacion(pitch,vbp1)
   
%generacion ruido
% ruido = rand(180)*(2*1732)-1732;

%generacion excitacion
%LO QUE FALTA ES:
   %conseguir 180 muestras, si es posible con memoria de donde empieza la
   %delta
   %for seria una manera para iterar y conseguirlo
   %TJ=T*(1+0,2*(2*rand(1)-1)); se usa en casos determinados(se usa si bvpc1<0,5, poner en el
   %main
% ntramas=64;
   eperio = zeros(180,length(pitch));
   
   for i = 1:length(pitch)
       exc = [];
   while(length(exc)<180)
   
   T=pitch(i);
   if(vbp1(i) < 0.5)
       TJ = round(T*(1+0.2*(2*rand(1)-1)));
       ep=zeros(TJ,1);
       ep(10)=sqrt(TJ);     
   else   
           %al final hacemos que la excitacion sea un pulso con valor uno
        ep = zeros(pitch(i),1);
        ep(10)=sqrt(T);
       
   end
   exc = [exc;ep];
   end
   eperio(:,i) = exc(1:180);
   end
end
 



