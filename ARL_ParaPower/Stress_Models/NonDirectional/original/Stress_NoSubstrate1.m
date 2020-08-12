function [stressx,stressy,stressz]=Stress_NoSubstrate1(Results)
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
Temp=Temp(:,:,:,2);
Melt=Results.getState('MeltFrac');
Melt=Melt(:,:,:,2);
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
NLz=length(dz);
%NR=length(dy);
%NC=length(dx);

NRx=length(dx);  %Morris switched these
NCy=length(dy);  %to match the substrate based model

% Load Material Numbers for every element in the model
Mats=Results.Model.Model;
% Loop over Cols, Rows and Lays to determine locations that have no
% material, IBC's, or Fluid
for Xi=1:NRx
    for Yj=1:NCy
        for Zk=1:NLz
            if Mats(Xi,Yj,Zk) == 0
                ckMatl(Xi,Yj,Zk)=false;
            else
                ckMatl(Xi,Yj,Zk)=isa(Results.Model.MatLib.GetMatNum(Mats(Xi,Yj,Zk)),'PPMatSolid');
            end
        end
    end
end
clear Xi Yj Zk Xii Yjj Zkk

% Loop over Cols, Rows and Lays to determine the final x, y and z lengths of
% the elements, as a result of the CTE mismatch between the materials in all the layers
% x-direction final length
for Yjj=1:NCy
    sumn=0;
    sumd=0;
        for Zk=1:NLz
            for Xi=1:NRx
                % Skip locations that have no material, IBC's, Fluid and
                % non-zero Melt fractions
                if  ckMatl(Xi,Yjj,Zk) == 0 || Melt(Xi,Yjj,Zk) > 0
                    sumn=sumn+0;
                    sumd=sumd+0;
                else
                    sumn=sumn+(EX(Mats(Xi,Yjj,Zk))/(1-nuX(Mats(Xi,Yjj,Zk))))*dy(Yjj)*dz(Zk);
                    sumd=sumd+((EX(Mats(Xi,Yjj,Zk))/(1-nuX(Mats(Xi,Yjj,Zk))))*dy(Yjj)*dz(Zk))/(dx(Xi)*(cteX(Mats(Xi,Yjj,Zk))*delT(Xi,Yjj,Zk)+1));
                end
           end
        end
    Lfx(Yjj)=sumn/sumd;
end

clear Xi Yj Zk Xii Yjj Zkk

% y-direction final length
for Xii=1:NRx
    sumn=0;
    sumd=0;
        for Zk=1:NLz
            for Yj=1:NCy
                % Skip locations that have no material, IBC's, Fluid and
                % non-zero Melt fractions
                if  ckMatl(Xii,Yj,Zk) == 0 || Melt(Xii,Yj,Zk) > 0
                    sumn=sumn+0;
                    sumd=sumd+0;
                else
                    sumn=sumn+(EY(Mats(Xii,Yj,Zk))/(1-nuY(Mats(Xii,Yj,Zk))))*dx(Xii)*dz(Zk);
                    sumd=sumd+((EY(Mats(Xii,Yj,Zk))/(1-nuY(Mats(Xii,Yj,Zk))))*dx(Xii)*dz(Zk))/(dy(Yj)*(cteY(Mats(Xii,Yj,Zk))*delT(Xii,Yj,Zk)+1));
                end
            end
        end
    Lfy(Xii)=sumn/sumd;
end

clear Xi Yj Zk Xii Yjj Zkk

% z-direction final length
for Zkk=1:NLz
    sumn=0;
    sumd=0;
        for Xi=1:NRx
            for Yj=1:NCy
                % Skip locations that have no material, IBC's, Fluid and
                % non-zero Melt fractions
                if  ckMatl(Xi,Yj,Zkk) == 0 || Melt(Xi,Yj,Zkk) > 0
                    sumn=sumn+0;
                    sumd=sumd+0;
                else
                    sumn=sumn+(EZ(Mats(Xi,Yj,Zkk))/(1-nuZ(Mats(Xi,Yj,Zkk))))*dx(Xi)*dy(Yj);
                    sumd=sumd+((EZ(Mats(Xi,Yj,Zkk))/(1-nuZ(Mats(Xi,Yj,Zkk))))*dx(Xi)*dy(Yj))/(dz(Zkk)*(cteZ(Mats(Xi,Yj,Zkk))*delT(Xi,Yj,Zkk)+1));
                end
            end
        end
    Lfz(Zkk)=sumn/sumd;
end

clear Xi Yj Zk Xii Yjj Zkk

% Loop over all elements to claculate stress due to CTE mismatch for each
% element
for Zkk=1:NLz
    for Xii=1:NRx
        for Yjj=1:NCy
            if  ckMatl(Xii,Yjj,Zkk) == 0 || Melt(Xii,Yjj,Zkk) > 0
                stressx(Xii,Yjj,Zkk)=NaN;
                stressy(Xii,Yjj,Zkk)=NaN;
                stressz(Xii,Yjj,Zkk)=NaN;
            else
                stressx(Xii,Yjj,Zkk)=(EX(Mats(Xii,Yjj,Zkk))/(1-nuX(Mats(Xii,Yjj,Zkk))))*((Lfx(Yjj)/(dx(Xii)*(cteX(Mats(Xii,Yjj,Zkk))*delT(Xii,Yjj,Zkk)+1)))-1);
                stressy(Xii,Yjj,Zkk)=(EY(Mats(Xii,Yjj,Zkk))/(1-nuY(Mats(Xii,Yjj,Zkk))))*((Lfy(Xii)/(dy(Yjj)*(cteY(Mats(Xii,Yjj,Zkk))*delT(Xii,Yjj,Zkk)+1)))-1);
                stressz(Xii,Yjj,Zkk)=(EZ(Mats(Xii,Yjj,Zkk))/(1-nuZ(Mats(Xii,Yjj,Zkk))))*((Lfz(Zkk)/(dz(Zkk)*(cteZ(Mats(Xii,Yjj,Zkk))*delT(Xii,Yjj,Zkk)+1)))-1);
            end
        end
    end
end

clear Xi Yj Zk Xii Yjj Zkk

% Stress check, sum forces to be sure they go to zero
SumforceX=0;
SumforceY=0;
SumforceZ=0;
for Xii=1:NRx
    for Yjj=1:NCy
        for Zkk=1:NLz
            ForceX(Xii,Yjj,Zkk)=stressx(Xii,Yjj,Zkk)*dy(Yjj)*dz(Zkk);
            ForceY(Xii,Yjj,Zkk)=stressy(Xii,Yjj,Zkk)*dx(Xii)*dz(Zkk);
            ForceZ(Xii,Yjj,Zkk)=stressz(Xii,Yjj,Zkk)*dy(Yjj)*dx(Xii);
        end
    end
end
SumforceX=sum(ForceX(~isnan(ForceX)));
SumforceY=sum(ForceY(~isnan(ForceY)));
SumforceZ=sum(ForceZ(~isnan(ForceZ)));


fprintf('Net Force X: %f, Y: %f, Z: %f\n',SumforceX, SumforceY, SumforceZ)