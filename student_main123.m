[filename,filepath]=uigetfile('.*','Load files');  % used to browse the file from the system

path=[filepath filename];

eye=imread(path);

rmin=20;
rmax=60;

%Image enhancement and adjustment 
eye=rgb2gray(eye);
eye=imresize(eye,[183,275]);

eye=imadjust(eye);

I=eye;

%[ci,cp,out] = thresh(eye,20,100);


scale=0.8;

rmin=rmin*scale;
rmax=rmax*scale;

I=im2double(I);

pimage=I;

I=imresize(I,scale);
I=imcomplement(imfill(imcomplement(I),'holes'));

rows=size(I,1);
cols=size(I,2);
[X,Y]=find(I<0.5);

s=size(X,1);
for k=1:s 
    if (X(k)>rmin)&(Y(k)>rmin)&(X(k)<=(rows-rmin))&(Y(k)<(cols-rmin))
            A=I((X(k)-1):(X(k)+1),(Y(k)-1):(Y(k)+1));
            M=min(min(A));
            
           if I(X(k),Y(k))~=M
              X(k)=NaN;
              Y(k)=NaN;
           end
    end
end
v=find(isnan(X));
X(v)=[];
Y(v)=[];

index=find((X<=rmin)|(Y<=rmin)|(X>(rows-rmin))|(Y>(cols-rmin)));
X(index)=[];
Y(index)=[];  
 

N=size(X,1);

maxb=zeros(rows,cols);
maxrad=zeros(rows,cols);

for j=1:N
    %[b,r,blur]=partiald(I,[X(j),Y(j)],rmin,rmax,'inf',600,'iris');
    %[b,r,blur]=partiald(I,[X(j),Y(j)],rmin,rmax,0.3,600,'iris');
    C=[X(j),Y(j)];
    n=600;
    part='iris';
    R=rmin:rmax;
    count=size(R,2);
    for k=1:count
    [L(k)]=lineint(I,C,R(k),n,part);
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
    maxb(X(j),Y(j))=b;
    maxrad(X(j),Y(j))=r;
end
[x,y]=find(maxb==max(max(maxb)));
ci=search(I,rmin,rmax,x,y,'iris');

ci=ci/scale;

cp=search(I,round(0.39*r),round(0.8*r),ci(1)*scale,ci(2)*scale,'pupil');
cp=cp/scale;

out=drawcircle(pimage,[ci(1),ci(2)],ci(3),600);
out=drawcircle(out,[cp(1),cp(2)],cp(3),600);

imshow(out);
