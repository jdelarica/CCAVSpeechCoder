function [e1] = excitationfilter(h1,h2,h3,h4,h5, vbp1, vbp2, vbp3, vbp4, vbp5,eperio)
state=zeros(32,1);
e1 = zeros(180,length(vbp1));
for t = 1:length(vbp1)
% ruido = rand(180,1)*(2*1.732)-1.732;

he=(vbp1(t))*h1+(vbp2(t))*h2+(vbp3(t))*h3+(vbp4(t))*h4+(vbp5(t))*h5;
% a =length(hn)
[e1(:,t),state]=filter(he,1,eperio(:,t),state);
% freqz(he),pause
end


end