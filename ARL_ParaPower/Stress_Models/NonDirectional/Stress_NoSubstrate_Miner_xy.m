% TC debugging 7/17/2020

function [stressx,stressy,stressz]=Stress_NoSubstrate_Miner_xy(Results, time)
% This function calculates the thermal stress based on CTE mismatch for each element in the model.
% This is a quasi 3-D approach that sums the forces in one plane to get the
% final length of all the elelments in that plane. Each plane is taken
% individually capturing intra-planar effects (2-D). The 3-D effects are
% captured by by considering multiple planes in each direction. The
% following planes are used in calculating the final length in each
% direction; x-Direction: y-z plane; y-direction: x-z plane; z-Direction:
% x-y plane.
% Load Temperature Results, Melt Fraction Results and Processing Temp
Temp=Results.getState('Thermal');
Temp=Temp(:,:,:,time);
Melt=Results.getState('MeltFrac');
Melt=Melt(:,:,:,time);
ProcT=Results.Model.Tproc;
% Load material properties E, cte, nu
EX=Results.Model.MatLib.GetParam('E');
EY=Results.Model.MatLib.GetParam('E');
EZ=Results.Model.MatLib.GetParam('E');
nuX=Results.Model.MatLib.GetParam('nu');
nuY=Results.Model.MatLib.GetParam('nu');
nuZ=Results.Model.MatLib.GetParam('nu');
cteX=Results.Model.MatLib.GetParam('cte');
cteY=Results.Model.MatLib.GetParam('cte');
cteZ=Results.Model.MatLib.GetParam('cte');
% Calculate the difference between the operating temp and the processing
% temp for thermal stress calc
delT=Temp-ProcT;
% Load dx, dy, dz values and number of Layers, Rows and Columns
dx=Results.Model.X;
dy=Results.Model.Y;
dz=Results.Model.Z;
NL=length(dz);
NR=length(dy);
NC=length(dx);
% Load Material Numbers for every element in the model
Mats=Results.Model.Model;
% Loop over Cols, Rows and Lays to determine locations that have no
% material, IBC's, or Fluid
for i=1:NR
    for j=1:NC
        for k=1:NL
            if Mats(i,j,k) == 0
                ckMatl(j,i,k)=false;
            else
                ckMatl(j,i,k)=isa(Results.Model.MatLib.GetMatNum(Mats(j,i,k)),'PPMatSolid');
            end
        end
    end
end
% Loop over Cols, Rows and Lays to determine the final x, y and z lengths of
% the elements, as a result of the CTE mismatch between the materials in all the layers
% x-direction final length
for jj=1:NC
    sumn=0;
    sumd=0;
        for k=1:NL
            for i=1:NR
                % Skip locations that have no material, IBC's, Fluid and
                % non-zero Melt fractions
                if  ckMatl(jj,i,k) == 0 || Melt(jj,i,k) > 0
                    sumn=sumn+0;
                    sumd=sumd+0;
                else
                    sumn=sumn+(EX(Mats(jj,i,k))/(1-nuX(Mats(jj,i,k))))*dy(i)*dz(k);
                    sumd=sumd+((EX(Mats(jj,i,k))/(1-nuX(Mats(jj,i,k))))*dy(i)*dz(k))/(dx(jj)*(cteX(Mats(jj,i,k))*delT(jj,i,k)+1));
                end
           end
        end
    Lfx(jj)=sumn/sumd;
end
% y-direction final length
for ii=1:NR
    sumn=0;
    sumd=0;
        for k=1:NL
            for j=1:NC
                % Skip locations that have no material, IBC's, Fluid and
                % non-zero Melt fractions
                if  ckMatl(j,ii,k) == 0 || Melt(j,ii,k) > 0
                    sumn=sumn+0;
                    sumd=sumd+0;
                else
                    sumn=sumn+(EY(Mats(j,ii,k))/(1-nuY(Mats(j,ii,k))))*dx(j)*dz(k);
                    sumd=sumd+((EY(Mats(j,ii,k))/(1-nuY(Mats(j,ii,k))))*dx(j)*dz(k))/(dy(ii)*(cteY(Mats(j,ii,k))*delT(j,ii,k)+1));
                end
            end
        end
    Lfy(ii)=sumn/sumd;
end
% z-direction final length
for kk=1:NL
    sumn=0;
    sumd=0;
        for i=1:NR
            for j=1:NC
                % Skip locations that have no material, IBC's, Fluid and
                % non-zero Melt fractions
                if  ckMatl(j,i,kk) == 0 || Melt(j,i,kk) > 0
                    sumn=sumn+0;
                    sumd=sumd+0;
                else
                    sumn=sumn+(EZ(Mats(j,i,kk))/(1-nuZ(Mats(j,i,kk))))*dx(j)*dy(i);
                    sumd=sumd+((EZ(Mats(j,i,kk))/(1-nuZ(Mats(j,i,kk))))*dx(j)*dy(i))/(dz(kk)*(cteZ(Mats(j,i,kk))*delT(j,i,kk)+1));
                end
            end
        end
    Lfz(kk)=sumn/sumd;
end
% Loop over all elements to claculate stress due to CTE mismatch for each
% element
for kk=1:NL
    for ii=1:NR
        for jj=1:NC
            if  ckMatl(jj,ii,kk) == 0 || Melt(jj,ii,kk) > 0
                stressx(jj,ii,kk)=NaN;
                stressy(ii,jj,kk)=NaN;
                stressz(ii,jj,kk)=NaN;
            else
                stressx(ii,jj,kk)=(EX(Mats(ii,jj,kk))/(1-nuX(Mats(ii,jj,kk))))*((Lfx(jj)/(dx(jj)*(cteX(Mats(ii,jj,kk))*delT(ii,jj,kk)+1)))-1);
                stressy(ii,jj,kk)=(EY(Mats(ii,jj,kk))/(1-nuY(Mats(ii,jj,kk))))*((Lfy(ii)/(dy(ii)*(cteY(Mats(ii,jj,kk))*delT(ii,jj,kk)+1)))-1);
                stressz(ii,jj,kk)=(EZ(Mats(ii,jj,kk))/(1-nuZ(Mats(ii,jj,kk))))*((Lfz(kk)/(dz(kk)*(cteZ(Mats(ii,jj,kk))*delT(ii,jj,kk)+1)))-1);
            end
        end
    end
end
% Stress check, sum forces to be sure they go to zero
SumforceX=0;
SumforceY=0;
SumforceZ=0;
for ii=1:NR
    for jj=1:NC
        for kk=1:NL
            ForceX(ii,jj,kk)=stressx(ii,jj,kk)*dy(ii)*dz(kk);
            SumforceX=SumforceX+ForceX(ii,jj,kk);
            ForceY(ii,jj,kk)=stressy(ii,jj,kk)*dx(jj)*dz(kk);
            SumforceY=SumforceY+ForceY(ii,jj,kk);
            ForceZ(ii,jj,kk)=stressz(ii,jj,kk)*dy(ii)*dx(jj);
            SumforceZ=SumforceZ+ForceZ(ii,jj,kk);
        end
    end
end
1