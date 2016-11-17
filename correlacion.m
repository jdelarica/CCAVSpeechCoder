% clear all;
function [ c ] = correlacion( s, T, m, n)
% s : Señal
% T : Tau
% k : variable sumatorio
% m,n : variables correlacion c(m,n)
% T=40;
% m=0;
% n=0;

% SUMATORIO DE LA CORRELACIÓN
% ct(m,n)
c=0;
k1=180+(-floor(T/2)-80);
k2=180+(-floor(T/2)+79);
    for k = k1 : k2
          z = s(k+m)*s(k+n);
            c=c+sum(z);

    end

end

