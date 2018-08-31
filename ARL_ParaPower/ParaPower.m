function [Temp,Stress,xgrid,ygrid,NR,NC,ND,NL,xlayout,ylayout]=ParaPower(xlayout,ylayout,dz,bmat,h,Ta,Tproc,delta_t,transteps,T_init,matprops,meshdensity)

[xlayout,ylayout,NL,dz,bmat,Q_matrix] = PCMslice(xlayout,ylayout,dz,bmat,matprops,delta_t,transteps);

[dx,dy,NR,NC,xgrid,ygrid,ND]=Spacing(xlayout,ylayout,meshdensity);
[Mat,Q] = GridLocations(NR,NC,NL,xlayout,ylayout,dx,dy,bmat,Q_matrix);
[Temp,Stress]=ParaPowerThermal(NL,NR,NC,h,Ta,dx,dy,dz,Tproc,Mat,Q,delta_t,transteps,T_init,matprops);



