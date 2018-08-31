function cbk=back(row,col,lay,h,Mat,kond,dx,dy,dz,NR)
% global NR h Mat kond dx dy dz
if row<NR
    if Mat(row,col,lay)==0 || Mat(row+1,col,lay)==0
        cbk=0;
    else
        cbk=1/(dy(row)/(2*kond(Mat(row,col,lay))*dx(col)*dz(lay))+dy(row+1)/(2*kond(Mat(row+1,col,lay))*dx(col)*dz(lay)));
    end
end
if row==NR
    if h(4)==0 || Mat(row,col,lay)==0
        cbk=0;
    else
        cbk=1/(dy(row)/(2*kond(Mat(row,col,lay))*dx(col)*dz(lay))+1/(h(4)*dx(col)*dz(lay)));
    end
end