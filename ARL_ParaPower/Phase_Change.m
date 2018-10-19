function [Tres,hft,meltfrac,K,CP,RHO,Cap] = Phase_Change(Mat,Tres,Tm,hft,Lw,CP,kondl,kond,sphtl,spht,rhol,rho,dx,dy,dz,delta_t)


%if the material is PCM
%need to figure out how to change both the A matrix of
%PCM nodes, and the A matrix for nodes next to PCM
%nodes

%current pass in
%Phase_Change(Mat,Tres(ii,jj,kk,it),Tm(Mat(ii,jj,kk)),hft(ii,jj,kk),Lw(Mat(ii,jj,kk)),
%   CP(ii,jj,kk),kondl(Mat(ii,jj,kk)),kond(Mat(ii,jj,kk)),sphtl(Mat(ii,jj,kk)),
%       spht(Mat(ii,jj,kk)),rhol(Mat(ii,jj,kk)),rho(Mat(ii,jj,kk)),dx(ii),dy(jj),dz(kk),delta_t);

%want to pass in
% T(:,t),PH(:,t),Mat,properties,geometry
%properties.X is list of fixed property X by material number
%geometry is dx dy dz dt in some sensible format
%
%pass out T_prm(:,t),PH_prm(:,t),T(:,t),PH(:,t),K,CP,RHO
% saving the pre-phase change dof for diagnostic and updating working copy
% post melt.


if Tres > Tm && hft < Lw %is the temp higher than melting point?
    
    if hft + (Tres-Tm)*CP > Lw %is energy enough to fully melt element?
        Tres = Tm + (hft + (Tres-Tm)*CP - Lw)/CP; %determines the temp of element after melting
        hft = Lw;
    else
        hft = hft + (Tres-Tm)*CP; %if not enough energy, determine amount of element melted
        Tres = Tm;
    end
end

if Tres < Tm && hft > 0 %this section is smae as above, but for solidification
    if hft + (Tres-Tm)*CP < 0
        Tres = Tm + (hft + (Tres-Tm)*CP)/CP;
        hft = 0;
    else
        hft = hft + (Tres-Tm)*CP;
        Tres = Tm;
    end
end

meltfrac = hft/Lw; %percent melted for each node
%                     K(ii,jj,kk) = kondl(Mat(ii,jj,kk))*meltfrac(ii,jj,kk,it)+kond(Mat(ii,jj,kk))*(1-meltfrac(ii,jj,kk,it));
K = 1/(meltfrac/kondl+(1-meltfrac)/kond);
CP = sphtl*meltfrac+spht*(1-meltfrac);
RHO = rhol*meltfrac+rho*(1-meltfrac);
Cap=mass(Mat,dx,dy,dz,RHO,CP,delta_t); %update capacitance for next time step of a transient solution
%A(Ind,Ind)=A_stead(Ind,Ind)-Cap(ii,jj,kk); %Includes Transient term in the A matrix
