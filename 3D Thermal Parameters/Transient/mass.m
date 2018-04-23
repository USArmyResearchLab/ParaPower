function cap=mass(row,col,lay)
global Mat dx dy dz rho spht delta_t
    if Mat(row,col,lay)==0
        cap=0;
    else
        cap=rho(Mat(row,col,lay))*spht(Mat(row,col,lay))*dx(col)*dy(row)*dz(lay)/delta_t;
    end
end