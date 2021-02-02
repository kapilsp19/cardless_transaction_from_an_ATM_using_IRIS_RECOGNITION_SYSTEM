
function [cp]=eye_find(im,rmin,rmax,x,y,option)
rows=size(im,1);
cols=size(im,2);
sigma=0.5;
R=rmin:rmax;
maxrad=zeros(rows,cols);
maxb=zeros(rows,cols);
for i=(x-5):(x+5)
for j=(y-5):(y+5)
        [b,r,blur]=Itegralderrential(im,[i,j],rmin,rmax,0.5,600,option);
        maxrad(i,j)=r;
        maxb(i,j)=b;
    end
end
B=max(max(maxb));
[X,Y]=find(maxb==B);
radius=maxrad(X,Y);
cp=[X,Y,radius];



        