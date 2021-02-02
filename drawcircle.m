
function [O]=drawcircle(I,C,r,n)
if nargin==3
    n=600;
end
theta=(2*pi)/n;
rows=size(I,1);
cols=size(I,2);
angle=theta:theta:2*pi;

x=C(1)-r*sin(angle);
y=C(2)+r*cos(angle);
if any(x>=rows)|any(y>=cols)|any(x<=1)|any(y<=1)
    O=I;
    return
end
for i=1:n
I(round(x(i)),round(y(i)))=1;
end
O=I;
