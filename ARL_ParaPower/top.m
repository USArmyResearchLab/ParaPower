function ctp=top(row,col,lay,h,Mat,kond,dx,dy,dz,NL)
% global NL h Mat kond dx dy dz
if lay<NL
    if Mat(row,col,lay+1)==0 || Mat(row,col,lay)==0
        ctp=0;
    else
% % %         kond
% % %         Mat
% % %         row 
% % %         col
% % %         lay+1
% % % Mat(row,col,lay+1)
% % %       kond(Mat(row,col,lay+1))
% % %       dx(col)
% % %       dy(row)
        ctp=1/(dz(lay)/(2*kond(row,col,lay)*dx(col)*dy(row))+dz(lay+1)/(2*kond(row,col,lay+1)*dx(col)*dy(row)));
    end
end
if lay==NL
    if h(6)==0 || Mat(row,col,lay)==0
        ctp=0;
    else
        ctp=1/(dz(lay)/(2*kond(row,col,lay)*dx(col)*dy(row))+1/(h(6)*dx(col)*dy(row)));
    end
end
