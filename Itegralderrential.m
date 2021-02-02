 

function [b,r,blur]=Itegralderrential(I,C,rmin,rmax,sigma,n,part)
R=rmin:rmax;
count=size(R,2);
for k=1:count
[L(k)]=integral(I,C,R(k),n,part);
if L(k)==0
     L(k)=[];
    break;
end
end
D=diff(L);
D=[0 D];

if strcmp(sigma,'inf')==1
f=ones(1,7)/7;
else
f=fspecial('gaussian',[1,5],sigma);
end
blur=convn(D,f,'same');
blur=abs(blur);
[b,i]=max(blur);
r=R(i);
b=blur(i);

end