%ParaPowerThermal
%given timestep size,geometry, temperature, and material properties, this 
%program estimates the temperature and thermally induced stresses in the 
%control geometry for the all timesteps

%WARNING: Coefficients of thermal expansion, thermal stresses, and residual
%stresses from processing temperatures have not been implemented for all
%materials
        
function [Stress] = ParaPowerStress(ModelInput,Tres)


h=ModelInput.h;
Ta=ModelInput.Ta;
dx=ModelInput.X;
dy=ModelInput.Y;
dz=ModelInput.Z;
Tproc=ModelInput.Tproc;
Mat=ModelInput.Model;
Q=ModelInput.Q;
T_init=ModelInput.Tinit;
matprops=ModelInput.matprops;
GlobalTime=ModelInput.GlobalTime;


Num_Lay = size(Mat,3);
Num_Row = size(Mat,1);
Num_Col = size(Mat,2);

nlsub=1; % # layers that are substrate material

Stress=zeros(size(Mat)); % Nodal thermal stress results

for it=1:length(GlobalTime)
    % Calculate the difference between the operating temp and the processing
    % temp for thermal stress calc
    delT=Tres(:,:,:,it)-Tproc;
    % Loop over all the nodes in the model
    for kk=1:Num_Lay
        for ii=1:Num_Row
            for jj=1:Num_Col
                % Calculate the thermal stress
                % Skip locations that have no material
                if Mat(ii,jj,kk) == 0
                    Stress(ii,jj,kk,it)=0;  %Should this be NaN?
                elseif kk <= nlsub
                    Stress(ii,jj,kk,it)=substrate_ex(ii,jj,kk,delT,dz,cte,E,nu,nlsub,Mat,Num_Lay);
                else
                    Stress(ii,jj,kk,it)=layer_ex(ii,jj,kk,delT,dz,cte,E,nu,nlsub,Mat,Num_Lay);
                end

            end
        end
    end
end


end