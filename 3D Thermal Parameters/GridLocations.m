function [Mat,Q] = GridLocations(NR,NC,NL,xlayout,ylayout,dx,dy,bmat,meshdensity)
%% Device location within grid 
% mat=[1 2 3 2 2 2 4 4 4 4 5]';
% QQ=zeros(20,1);
count=1;                                                                    % counting variable for assorted use
count2=1;
pointerx=zeros(1,NC);                                                       % loactions in the x-dir where grid lines exist
pointery=zeros(1,NR);                                                       % loactions in the y-dir where grid lines exist
pointerx(1,1)=min(xlayout(:));                                                 % first pointer location is equal to the min value of base layer
pointery(1,1)=min(ylayout(:));
[lx,~]=size(xlayout);
f=zeros(lx,4);
tol=10*eps;                                                                 % defines tolerance for floating point comparison, required because comparing zero and the difference between 0.024-0.024000001 are not equal under normal matlab conditions
xdim=xlayout(:,1:4);
xmin=min(xdim(:));
ymin=min(ylayout(:));
for i=1:NC
            pointerx(1,i+1)=xmin+sum(dx(1,1:i));                    % finds pointer locations that will be considered based on the grid spacing 
end
for i=1:NR
        pointery(1,i+1)=ymin+sum(dy(1,1:i));
end
col=1;
col2=1;
[lx,~]=size(xdim);
for ii=1:lx
for i=1:length(pointerx)
    if(abs(pointerx(1,i)-xdim(ii,col)) < tol)==1 
        f(ii,col2)=i;
        col2=2;
        col=3;
    end
end
col=1;
col2=1;
end
col=1;
col2=3;
[ly,~]=size(ylayout);
for ii=1:ly
for i=1:length(pointery)
    if(abs(pointery(1,i)-ylayout(ii,col)) < tol)==1 
        f(ii,col2)=i;
        col2=4;
        col=3;
    end
end
col=1;
col2=3;
end
Mat=zeros(NR,NC,NL);
Q=Mat;
f(:,5:7)=xlayout(:,5:7);
% f(:,7)=mat;
f(:,[2 4])=f(:,[2 4])-1;
[lf,~]=size(f);
for i=1:lf
   Mat(f(i,1):f(i,2),f(i,3):f(i,4),f(i,6))=f(i,7);
%    Mat(f(i,3):f(i,4),f(i,1):f(i,2),f(i,6))=f(i,7)
   Q(f(i,1):f(i,2),f(i,3):f(i,4),f(i,6))=f(i,5);
end
Mat=rot90(Mat);
Q=(rot90(Q)/meshdensity^2);
[~,~,lm]=size(Mat);
for i=1:lm
B=Mat(:,:,i);                                                               % alternativly s( s==0 )=-1; should be used but assignment to correct layer in 3d matrix was not able to be achieved
B(B==0)=bmat(i,1);                                                          % only layer 1 or all layers was suffieicently handled by the previous mention. Does not allow for multiple fill materials
Mat(:,:,i)=B;
end
end



