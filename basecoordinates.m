function [baseX,baseY,baseZ] = basecoordinates( row,layerstack,basedata,xlayout,ylayout,basetype)
baseX=zeros(1,5);
baseY=zeros(1,4);
baseZ=layerstack(row,:);                                                   % always creates layer stack
if basetype>2 % User Defined Coordinates
    if length(basedata)==2 %centered on features
        minx=min(min(xlayout(:,1:4)));                                      % calculates min max range of x and y coordinates
        maxx=max(max(xlayout(:,1:4)));
        miny=min(min(ylayout(:,1:4)));
        maxy=max(max(ylayout(:,1:4)));
        cntrx=(minx+maxx)/2;                                                % finds center of coordinates
        cntry=(miny+maxy)/2;
        baseX(1,1:4)=[cntrx cntrx cntrx cntrx]+([-basedata(1,1) -basedata(1,1) basedata(1,1) basedata(1,1)]/2); %Device Top all coordiates are defined from the bottom right corner, clockwise when facing the plane normally.
        baseX(1,5:6)= [0 row];
        baseY(1,1:4)=[cntry cntry cntry cntry]+([-basedata(1,2) basedata(1,2) basedata(1,2) -basedata(1,2)]/2);
    else %independent
        len=basedata(1,3);                                                  % pulls len from base definition table
        wid=basedata(1,4);
        minx=basedata(1,1)-(len/2);                                         % solves min max of edges
        maxx=basedata(1,1)+(len/2);
        miny=basedata(1,2)-(wid/2);
        maxy=basedata(1,2)+(wid/2);
        baseX(1,1:6)=[minx minx maxx maxx 0 row]; %Device Top all coordiates are defined from the bottom right corner, clockwise when facing the plane normally.
        baseY(1,1:4)=[miny maxy maxy miny];
    end
    
else %Program Controlled
    %Base Layers
    minx=min(min(xlayout(:,1:4)));                                      % stores maximum extents a base layer would need
    maxx=max(max(xlayout(:,1:4)));
    miny=min(min(ylayout(:,1:4)));
    maxy=max(max(ylayout(:,1:4)));
    baseX=[minx-basedata(1,1) minx-basedata(1,1) maxx+basedata(1,1) maxx+basedata(1,1) 0 row]; %Base Layer Top (coordinates in 3D space)
    baseY=[miny maxy maxy miny]+[-basedata(1,2),basedata(1,2),basedata(1,2),-basedata(1,2)];
    
end
end



