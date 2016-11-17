function [pitch, vbp1, vbp2, vbp3, vbp4, vbp5, g, b, LSFcoef] = codificador(x,fs)
l=length(x);
ntramas=floor((length(x)-180)/180);
r=cell(1,ntramas);

% FILTRADO DE LA SEÑAL EN 5 BANDAS
% x1 = pbajo(6,500,fs,x);
x2 = pbanda(6,500,1000,fs,x);
x3 = pbanda(6,1000,2000,fs,x);
x4 = pbanda(6,2000,3000,fs,x);
x5 = pbanda(6,3000,3999,fs,x);



% DIVIDO LA SEÑAL EN TRAMAS DE 180 MUESTRAS DE FORMA ITERATIVA
% Para cada iteración tengo una trama de 180 muestras, y calculo su
% correlación.
    for i = 1 : ntramas-1
        s = x(i*180+1:i*180+360);
        s2 = x2(i*180+1:i*180+360);
        s3 = x3(i*180+1:i*180+360);
        s4 = x4(i*180+1:i*180+360);
        s5 = x5(i*180+1:i*180+360);
        
        for T = 40 : 160
        c11 = correlacion (s,T, 0, T);
        c12 = correlacion (s, T, 0, 0);
        c13 = correlacion (s, T, T, T);
        r{T} = (c11 / sqrt(c12*c13));
        
        c21 = correlacion (s2,T, 0, T);
        c22 = correlacion (s2, T, 0, 0);
        c23 = correlacion (s2, T, T, T);
        r2{T} = (c21 / sqrt(c22*c23));
        
        
        c31 = correlacion (s3,T, 0, T);
        c32 = correlacion (s3, T, 0, 0);
        c33 = correlacion (s3, T, T, T);
        r3{T} = (c31 / sqrt(c32*c33));
        
        
        c41 = correlacion (s4,T, 0, T);
        c42 = correlacion (s4, T, 0, 0);
        c43 = correlacion (s4, T, T, T);
        r4{T} = (c41 / sqrt(c42*c43));
        
        
        c51 = correlacion (s5,T, 0, T);
        c52 = correlacion (s5, T, 0, 0);
        c53 = correlacion (s5, T, T, T);
        r5{T} = (c51 / sqrt(c52*c53));
        end
        
        max = 0;
        max2 = 0;
        max3 = 0;
        max4 = 0;
        max5 = 0;
        
       for T = 40:160	
            if (r{T} > max)
                max = r{T};
                 tau=T;
            end
       end     
       vbp1(i)=max; % Voice strength de la señal original.
       pitch(i)=tau; %El pitch se calcula para cada trama de la señal original x[n]     
       
       for T = 40:160
            if (r2{T} > max2)
                max2 = r2{T};
            end
       end     
      vbp2(i)=max2;
       
       for T = 40:160
            if (r3{T} > max3)
                max3 = r3{T};
            end
       end     
       vbp3(i)=max3;
        
       for T = 40:160
            if (r4{T} > max4)
                max4 = r4{T};
            end
       end     
       vbp4(i)=max4;
        
       for T = 40:160
            if (r5{T} > max5)
                max5 = r5{T};
            end
       end  
          
       vbp5(i)=max5;
            
    end
   
    
    [ g, b, LSFcoef ] = calcular_lpc_ganancia(x);
end
    
    
   