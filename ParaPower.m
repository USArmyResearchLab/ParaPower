function [Temp,Stress,xgrid,ygrid,NR,NC,ND,NL,xlayout,ylayout]=ParaPower(xlayout,ylayout,dz,bmat,h,Ta,Tproc,delta_t,transteps,T_init,matprops,meshdensity)
clear global

[xlayout,ylayout,NL,dz,bmat] = PCMslice(xlayout,ylayout,dz,bmat,matprops);

[dx,dy,NR,NC,xgrid,ygrid,ND]=Spacing(xlayout,ylayout,meshdensity);
[Mat,Q] = GridLocations(NR,NC,NL,xlayout,ylayout,dx,dy,bmat,meshdensity);
[Temp,Stress]=ParaPowerThermal(NL,NR,NC,h,Ta,dx,dy,dz,Tproc,Mat,Q,delta_t,transteps,T_init,matprops);



