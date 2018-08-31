function [Tres,hft,meltfrac,K,CP,RHO,Cap] = Phase_Change(Mat,Tres,Tm,hft,Lw,CP,kondl,kond,sphtl,spht,rhol,rho,dx,dy,dz,delta_t)


%if the material is PCM
%need to figure out how to change both the A matrix of
%PCM nodes, and the A matrix for nodes next to PCM
%nodes
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
