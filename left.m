function clt=left(row,col,lay,h,Mat,kond,dx,dy,dz)
% global h Mat kond dx dy dz
if col==1
    if h(1)==0 || Mat(row,col,lay)==0
        clt=0;
    else
        clt=1/(1/(h(1)*dy(row)*dz(lay))+dx(col)/(2*kond(row,col,lay)*dy(row)*dz(lay)));     
    end
end
if col>1
    if Mat(row,col-1,lay)==0 || Mat(row,col,lay)==0
        clt=0;
    else
        clt=1/(dx(col-1)/(2*kond(row,col-1,lay)*dy(row)*dz(lay))+dx(col)/(2*kond(row,col,lay)*dy(row)*dz(lay)));
    end
end