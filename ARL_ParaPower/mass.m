function cap=mass(Mat,dx,dy,dz,rho,spht,delta_t)
% global Mat dx dy dz rho spht delta_t
    if Mat==0
        cap=0;
    else
        cap=rho*spht*dx*dy*dz/delta_t;
    end
end