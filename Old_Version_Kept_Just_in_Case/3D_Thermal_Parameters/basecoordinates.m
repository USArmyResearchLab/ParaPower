function [bx,by,bz,bX,bY] = basecoordinates( row,layerstack,basedata,xlayout,ylayout,Xlayout,Ylayout,basetype)
bx=zeros(1,5);
by=zeros(1,4);
bz=bx;
bX=0;
bY=0;
if basetype>2 % User Defined Coordinates
    if length(basedata)==2 %centered on features
        minx=min(min(xlayout(:,1:4)));                                      % calculates min max range of x and y coordinates
        maxx=max(max(xlayout(:,1:4)));
        miny=min(min(ylayout(:,1:4)));
        maxy=max(max(ylayout(:,1:4)));
        cntrx=(minx+maxx)/2;                                                % finds center of coordinates
        cntry=(miny+maxy)/2;
         bx(1,1:4)=[cntrx cntrx cntrx cntrx]+([-basedata(1,1) -basedata(1,1) basedata(1,1) basedata(1,1)]/2); %Device Top all coordiates are defined from the bottom right corner, clockwise when facing the plane normally.
         bx(1,5:6)= [0 row];
         by(1,1:4)=[cntry cntry cntry cntry]+([-basedata(1,2) basedata(1,2) basedata(1,2) -basedata(1,2)]/2);
    else %independent
        len=basedata(1,3);                                                  % pulls len from base definition table
        wid=basedata(1,4);
        minx=basedata(1,1)-(len/2);                                         % solves min max of edges
        maxx=basedata(1,1)+(len/2);
        miny=basedata(1,2)-(wid/2);
        maxy=basedata(1,2)+(wid/2);  
    bx(1,1:6)=[minx minx maxx maxx 0 row]; %Device Top all coordiates are defined from the bottom right corner, clockwise when facing the plane normally.
    by(1,1:4)=[miny maxy maxy miny];
    end
    bz=layerstack(row,:);                                                   % always creates layer stack 
else %Program Controlled
 %Base Layers
 minX=min(Xlayout(:));                                                      % stores maximum extents a base layer would need
 maxX=max(Xlayout(:));
 minY=min(Ylayout(:));
 maxY=max(Ylayout(:));
    bx=[minX-basedata(1,1) minX-basedata(1,1) maxX+basedata(1,1) maxX+basedata(1,1) 0 row]; %Base Layer Top (coordinates in 3D space)
    by=[minY maxY maxY minY]+[-basedata(1,2),basedata(1,2),basedata(1,2),-basedata(1,2)];
    bz=layerstack(row,:);
end
end 



