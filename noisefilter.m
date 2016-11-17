function [e2] = noisefilter(h1,h2,h3,h4,h5, vbp1, vbp2, vbp3, vbp4, vbp5)
stateruido=zeros(32,1);
e2 = zeros(180,length(vbp1));
for t = 1:length(vbp1)
ruido = rand(180,1)*(2*1.732)-1.732;

hn=(1-vbp1(t))*h1+(1-vbp2(t))*h2+(1-vbp3(t))*h3+(1-vbp4(t))*h4+(1-vbp5(t))*h5;
% a =length(hn)
[e2(:,t),stateruido]=filter(hn,1,ruido,stateruido);
% freqz(hn),pause
end

%  a = 1-vbp1;
%  r1 = filter(a,1,ruidofiltrado1);
%  
%   ruidofiltrado2 = filter(h2,1,ruido);
%   b = 1-vbp2;
%   r2 = filter(b,1,ruidofiltrado2);
%   
%    ruidofiltrado3 = filter(h3,1,ruido);
%    c = 1-vbp3;
%    r3 = filter(c,1,ruidofiltrado3);
%    
%     ruidofiltrado4 = filter(h4,1,ruido);
%     d = 1-vbp4;
%     r4 = filter(d,1,ruidofiltrado4);
%     
%      ruidofiltrado5 = filter(h5,1,ruido);
%      e = vbp5;
%      r5 = filter(e,1,ruidofiltrado5);
%      
%      
% A = plus(r1,r2);
% B = plus(r3,r4);
% C = plus(A,r5);
% R = plus(B,C);
%     
%      
end