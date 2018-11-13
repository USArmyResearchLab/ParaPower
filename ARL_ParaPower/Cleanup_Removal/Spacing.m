function [dx,dy,NR,NC,xgrid,ygrid,ND] = Spacing(xlayout,ylayout,meshdensity)
meshdensity=meshdensity+1;
heatsup=find(xlayout(:,5)>0);                                               % finds locations in which heat is supplied, ie a device
idx=xlayout(heatsup,1:4);                                                   % finds the associated feature coor. of heated devices X 
idy=ylayout(heatsup,1:4);                                                   % Y
xlayout=xlayout(:,1:4);                                                     % removes layer, material and any excess data from xlayout matrix
[lx,~]=size(xlayout);                                                       % determines how many features and layers are in the stack
[ly,~]=size(ylayout);   
[ND,~]=size(idx);                                                           % determines the number of devices that generate heat
extrarangex=zeros(ND,meshdensity);                                          % pre allocate the matrix for the added mesh density in areas of devices
extrarangey=extrarangex;
for i=1:ND
    extrarangex(i,1:meshdensity)=linspace(idx(i,2),idx(i,3),meshdensity);   % linearly spreads the increased density between the normal bounds of the device's coor. 
    extrarangey(i,1:meshdensity)=linspace(idy(i,1),idy(i,2),meshdensity);
end
extrarangexskinny=reshape(extrarangex,1,meshdensity*ND);                    % converts to 1d vector
extrarangeyskinny=reshape(extrarangey,1,meshdensity*ND);
xskinny=reshape(xlayout,1,4*lx);
yskinny=reshape(ylayout,1,4*ly);
xgrid=uniquetol([xskinny,extrarangexskinny],.001);                                  % combines coor vectors and finds only unique instances
ygrid=uniquetol([yskinny,extrarangeyskinny],.001);
dx=zeros(1,length(xgrid)-1);                                                % builds empty displacement vectors
dy=zeros(1,length(ygrid)-1);
for i=1:length(xgrid)-1
    dx(1,i)=xgrid(1,i+1)-xgrid(1,i);                                        % differeance between two adjacent coordinates is equal to dx
end
for i=1:length(ygrid)-1
    dy(1,i)=ygrid(1,i+1)-ygrid(1,i);
end
NC=length(dx);                                                              % number of columns is equal to the number of spaces.
NR=length(dy);
end

