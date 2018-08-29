function [x, y, z] = featurecoordinates(layerstack,row,geodata,numfeat,featmat,layoutint,layoutfeatnum)
%% Feature Locations
% layerstack=cell2mat(layerstack);
% geodata
% layerstack,row,geodata,numfeat,featmat
featloc(:,1)=geodata(:,1)-(geodata(:,3)/2);                                  %calculates device location from central point and length/ width sizing
featloc(:,2)=featloc(:,1)+geodata(:,3);                                       % featloc=[xmin, xmax, ymin, ymax]
featloc(:,3)=geodata(:,2)-(geodata(:,4)/2);
featloc(:,4)=featloc(:,3)+geodata(:,4);

X=zeros(numfeat,2);                                                  % since grid locations will occur at the maximum and minimum values of each object, this matrix will store the quantites as the coordinates are considered. 
Y=X;                                                                        % X=[xmin;xmax]
x=zeros(numfeat,4);
% x=zeros(4,numfeat*3);                                              % matrix used to store x-coor of device and pad locations x=[xtop xs1 xs2 ...] 
y=x;                                                                        % matrix used to store y-coor of device and pad locations
z=x(:,1);                                                                        % matrix used to store x-coor of device and pad locations
for i=1:numfeat
    x(i,1:4)=[featloc(i,1); featloc(i,1); featloc(i,2); featloc(i,2)]; %Device Top all coordiates are defined from the bottom right corner, clockwise when facing the plane normally.
    y(i,1:4)=[featloc(i,3); featloc(i,4); featloc(i,4); featloc(i,3)];
    x(i,5)=geodata(i,5);
    x(i,6)=row;
    x(i,7)=featmat(i,1);
    x(i,8)=layoutint;
    x(i,9)=layoutfeatnum(i,1);
%     z(i,1:4)=[layerstack(row,2),layerstack(row,2),layerstack(row,2),layerstack(row,2)];
% z
% layerstack
    z(i,1:2)=layerstack(row,:);
                                                              % shift required to store next device's x values proceeding the previous device
end
xdim=x(:,1:4);
    X(1,1)=min(xdim(:));                                                   % stores min value of top surface for use in calculation grid locations 
    X(1,2)=max(xdim(:));                                                    % stores respective value from top surface
    Y(1,1)=min(y(:));
    Y(1,2)=max(y(:));
    
end