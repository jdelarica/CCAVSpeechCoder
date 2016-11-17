function [ g, b, LSFcoef ] = calcular_lpc_ganancia(x)

% x señal t el numero de tramas
% [x, fs] = audioread('rl014.wav');

ntramas=floor((length(x)-180)/180);

a=zeros(ntramas,11);

b=zeros(ntramas,11);

LSFcoef=zeros(ntramas,10);

g=zeros(ntramas,1);

for i=1:ntramas 
    
    s = x(i*180-100:i*180+99).*hamming(200); %ventana de hamming de 200 muestras centrada entre dos tramas
    a(i,:) = lpc(s,10); 
    %[a(i,:),sigma] =lpc(s,10) ;
   %[H,freq]=freqz(sigma,a(i,:),512,8000);
   b(i,1)=1;
 for in=2:11
     
   b(i,in)=(((0.994)^(in-1))*a(i,in));%expansion
 
 end
   %hacer lsf de las b(y pasarlo al decoder) y la inversa(lo hara el decoder

   LSFcoef(i,:)=poly2lsf(b(i,:));
   %poly2lsf convierte la predicion plynomial especificada por b en una linea espectral de frecuencias lsf.
   %normaliza la prediccion polinomial por b(1)
       
  %inversa que se hace en el decoder
   %b2(i,:)=lsf2poly(LSFcoef(i,:));
   
        
s1=x(i*180-150:i*180+149);
   e=filter(b(i,:),1,s1); %filtramos y nos da los coef
 %subplot(2,1,1), plot(s1)
 %subplot(2,1,2), plot(e)
 %pause
 %imprime la señal (añadir en la memoria)
 
 
re = e(90:289);

g(i) = (re' * re)/200; %en columna
 
end 
