function [featloc, x, y, z, X,Y] = featurecoordinates(layerstack,row,featdata,numfeat)
%% Feature Locations

layerstack=cell2mat(layerstack);

if layerstack(row,2)>0 && layerstack(row,2)<99
featloc(:,1)=featdata(:,1)-(featdata(:,3)/2);                                  %calculates device location from central point and length/ width sizing
featloc(:,2)=featloc(:,1)+featdata(:,3);                                       % devloc=[xmin, xmax, ymin, ymax]
featloc(:,3)=featdata(:,2)-(featdata(:,4)/2);
featloc(:,4)=featloc(:,3)+featdata(:,4);


X=zeros(2,numfeat);                                                  % since grid locations will occur at the maximum and minimum values of each object, this matrix will store the quantites as the coordinates are considered. 
Y=X;                                                                        % X=[xmin;xmax]
x=zeros(4,numfeat*3);                                              % matrix used to store x-coor of device and pad locations x=[xtop xs1 xs2 ...] 
y=x;                                                                        % matrix used to store y-coor of device and pad locations
z=x;                                                                        % matrix used to store x-coor of device and pad locations

for i=1:numfeat
    x(i,1:4)=[devloc(i,1); devloc(i,1); devloc(i,2); devloc(i,2)]; %Device Top all coordiates are defined from the bottom right corner, clockwise when facing the plane normally.
    y(i,1:4)=[devloc(i,3); devloc(i,4); devloc(i,4); devloc(i,3)];
    z(i,1,4)=[layerstack(row,3),layerstack(row,3),layerstack(row,3),layerstack(row,3)];
%     z(i,1:4)=zoo(numbaselayers+1,1)+layerstack(multimatindex(1,1),1)+[layerstack(multimatindex(2,1)+1,1); layerstack(multimatindex(2,1)+1,1); layerstack(multimatindex(2,1)+1,1); layerstack(multimatindex(2,1)+1,1)];    
    X(1,i)=min(x);                                                    % stores min value of top surface for use in calculation grid locations 
    X(2,i)=max(x);                                                    % stores respective value from top surface
    Y(1,i)=min(y);
    Y(2,i)=max(y);
%     ii=ii+3;                                                                % shift required to store next device's x values proceeding the previous device
end

end
%% Base Locations
bx=zeros(4,numbaselayers*3);
by=bx;
bz=bx;

    if layerstack(row,2)==99
    baseloc(1,1)=basedata(1,1)-(basedata(1,3)/2);                                  %calculates device location from central point and length/ width sizing
    baseloc(1,2)=baseloc(1,1)+basedata(1,3);                                       % devloc=[xmin, xmax, ymin, ymax]
    baseloc(1,3)=basedata(1,2)-(basedata(1,4)/2);
    baseloc(1,4)=baseloc(1,3)+basedata(1,4);
    end
%Check baseloc vs max and min X,Y coordinates of all features, if less
%fail. And ask for another input. Also publish which dimension could need
%changing 

if layerstack(row,2)==0
 %Base Layers
     
    maxmin(i,1)=max(x(:,iii));                                              % stores the extreme values of boards to calcualte adequate base layer sizes assumes board is always beyond or equal to device    
    maxmin(i,2)=max(y(:,iii));
    maxmin(i,3)=min(x(:,iii));
    maxmin(i,4)=min(y(:,iii)); 
 
    maxX=max(maxmin(:,1));                                                  %defines extreme values that are required to cover all pad/devices 
    maxY=max(maxmin(:,2));
    minX=min(maxmin(:,3));
    minY=min(maxmin(:,4));
    
for i=1:numbaselayers                                                            
    bx(:,iiii)=[minX minX maxX maxX]; %Base Layer Top (coordinates in 3D space)
    by(:,iiii)=[minY maxY maxY minY];
    bz(:,iiii)=[zoo(i+1,1) zoo(i+1,1) zoo(i+1,1) zoo(i+1,1)];

    bx(:,iiii+1)=[maxX minX minX maxX]; %Base Layer Side 1
    by(:,iiii+1)=[minY minY minY minY];
    bz(:,iiii+1)=[zoo(i,1) zoo(i,1) zoo(i+1,1) zoo(i+1,1)];

    bx(:,iiii+2)=[minX minX minX minX]; %Base Layer Side 4
    by(:,iiii+2)=[minY maxY maxY minY];
    bz(:,iiii+2)=[zoo(i,1) zoo(i,1) zoo(i+1,1) zoo(i+1,1)];
    iiii=iiii+3;
end
end
end 

