function [ ] = plotcoordinates( numfeat,featloc )

for i=1:numfeat
    x(:,ii+1)=[featloc(i,2) featloc(i,1) featloc(i,1) featloc(i,2)]; %Device Side 1
    y(:,ii+1)=[featloc(i,3) featloc(i,3) featloc(i,3) featloc(i,3)];
    z(:,ii+1)=zoo(numbaselayers+1,1)+layerstack(multimatindex(1,1),1)+[0 0 layerstack(multimatindex(2,1)+1,1) layerstack(multimatindex(2,1)+1,1)];

    x(:,ii+2)=[featloc(i,1) featloc(i,1) featloc(i,1) featloc(i,1)]; % Device Side 4
    y(:,ii+2)=[featloc(i,3) featloc(i,4) featloc(i,4) featloc(i,3)];
    z(:,ii+2)=zoo(numbaselayers+1,1)+layerstack(multimatindex(1,1),1)+[0 0 layerstack(multimatindex(2,1)+1,1) layerstack(multimatindex(2,1)+1,1)];
end

end

