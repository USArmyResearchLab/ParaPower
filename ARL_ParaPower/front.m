function cft=front(row,col,lay,h,Mat,kond,dx,dy,dz)
% global h Mat kond dx dy dz
if row==1
    if h(3)==0 || Mat(row,col,lay)==0
        cft=0;
    else
        cft=1/(1/(h(3)*dx(col)*dz(lay))+dy(row)/(2*kond(row,col,lay)*dx(col)*dz(lay)));
    end
end
if row>1
    if Mat(row-1,col,lay)==0 || Mat(row,col,lay)==0
        cft=0;
    else
        cft=1/(dy(row-1)/(2*kond(row-1,col,lay)*dx(col)*dz(lay))+dy(row)/(2*kond(row,col,lay)*dx(col)*dz(lay)));
    end
end