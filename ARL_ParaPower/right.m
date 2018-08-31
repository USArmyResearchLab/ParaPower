function crt=right(row,col,lay,h,Mat,kond,dx,dy,dz,NC)
% global NC h Mat kond dx dy dz
if col<NC
    if Mat(row,col+1,lay)==0 || Mat(row,col,lay)==0
        crt=0;
    else
        crt=1/(dx(col)/(2*kond(row,col,lay)*dy(row)*dz(lay))+dx(col+1)/(2*kond(row,col+1,lay)*dy(row)*dz(lay)));
    end
end
if col==NC
    if h(2)==0 || Mat(row,col,lay)==0
        crt=0;
    else
        crt=1/(dx(col)/(2*kond(row,col,lay)*dy(row)*dz(lay))+1/(h(2)*dy(row)*dz(lay)));
    end
end
