function [Mat,Q] = GridLocations(NR,NC,NL,xlayout,ylayout,dx,dy,bmat,meshdensity)
%% Device location within grid 
% mat=[1 2 3 2 2 2 4 4 4 4 5]';
% QQ=zeros(20,1);
count=1;                                                                    % counting variable for assorted use
count2=1;
pointerx=zeros(1,NC+1);                                                       % loactions in the x-dir where grid lines exist
pointery=zeros(1,NR+1);                                                       % loactions in the y-dir where grid lines exist
pointerx(1,1)=min(min(xlayout(:,1:4)));                                                 % first pointer location is equal to the min value of base layer
pointery(1,1)=min(ylayout(:));
[lx,~]=size(xlayout);
f=zeros(lx,4);
tol=0.001*max(max([xlayout(:,1:4) ylayout(:,1:4)]));                                                                 % defines tolerance for floating point comparison, required because comparing zero and the difference between 0.024-0.024000001 are not equal under normal matlab conditions
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
for ii=1:lx                                                                 %for each recorded x dimension where the edge of a feature should be
for i=1:length(pointerx)                                                    %and for each pointer to an x dimension
    if(abs(pointerx(1,i)-xdim(ii,col)) < tol)==1                            %find the index of the pointer that coresponds to the x dimension of each edge of each feature
        f(ii,col2)=i;                                                       %f becomes a matrix of indexes for the pointers. each row is a feature, and each column is the x and y dimensions in [xmin xmax ymin ymax]
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
Mat=zeros(NC,NR,NL);
Q=Mat;
grid_area = zeros(NR,NC,NL);
for i = 1:NL
    grid_area(:,:,i) = flipud(dy'*dx);                                     %creates an array of the areas of each element in each layer; assumes all layers have the same gridspacing
end
f(:,5:7)=xlayout(:,5:7);
f_area(:,1) = (pointerx(1,f(:,2))-pointerx(1,f(:,1))).*(pointery(1,f(:,4))-pointery(1,f(:,3))); %creates an array of areas for each feature, size is (lf,1)
f_q = f(:,5)./f_area(:,1);                                                 %converts total heat generation for each feature into a per area heat generation
% f(:,7)=mat;
f(:,[2 4])=f(:,[2 4])-1;
[lf,~]=size(f);
for i=1:lf
    Mat(f(i,1):f(i,2),f(i,3):f(i,4),f(i,6))=f(i,7);
    %    Mat(f(i,3):f(i,4),f(i,1):f(i,2),f(i,6))=f(i,7)
    Q(f(i,1):f(i,2),f(i,3):f(i,4),f(i,6))=f_q(i);                          %creates an array of per area heat generation for each element in the simulation
end
Mat=rot90(Mat);                                                             %rotates Mat and Q matricies to have correct spacial orientation with standard xy axes
Q=rot90(Q);
Q = Q.*grid_area;                                                           %generates a total heat generation for each element in the simulation
[~,~,lm]=size(Mat);
for i=1:lm
    B=Mat(:,:,i);                                                               % alternativly s( s==0 )=-1; should be used but assignment to correct layer in 3d matrix was not able to be achieved
    B(B==0)=bmat(i,1);                                                          % only layer 1 or all layers was suffieicently handled by the previous mention. Does not allow for multiple fill materials
    Mat(:,:,i)=B;
end
end



