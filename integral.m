
function [L]=integral(I,C,r,n,part)
theta=(2*pi)/n;
rows=size(I,1);
cols=size(I,2);
angle=theta:theta:2*pi;
x=C(1)-r*sin(angle);
y=C(2)+r*cos(angle);
if (any(x>=rows)|any(y>=cols)|any(x<=1)|any(y<=1))
    L=0;
    return
    
end

if (strcmp(part,'pupil')==1)
          s=0;
          for i=1:n
          val=I(round(x(i)),round(y(i)));
          s=s+val;
          end
          
          L=s/n;
      end

if(strcmp(part,'iris')==1)
          s=0;
          for i=1:round((n/8))
          val=I(round(x(i)),round(y(i)));
          s=s+val;
          end
          
          for i=(round(3*n/8))+1:round((5*n/8))
          val=I(round(x(i)),round(y(i)));
          s=s+val;
          end
          
          for i=round((7*n/8))+1:(n)
          val=I(round(x(i)),round(y(i)));
          s=s+val;
          end
          
          L=(2*s)/n;
end