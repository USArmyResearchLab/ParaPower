%ParaPowerThermal
%given timestep size,geometry, temperature, and material properties, this 
%program estimates the temperature and thermally induced stresses in the 
%control geometry for the all timesteps

%WARNING: Coefficients of thermal expansion, thermal stresses, and residual
%stresses from processing temperatures have not been implemented for all
%materials
        
function [Stress] = Stress_V1(ModelInput,Tres)


dx=ModelInput.X;
dy=ModelInput.Y;
dz=ModelInput.Z;
Tproc=ModelInput.Tproc;
Mat=ModelInput.Model;
T_init=ModelInput.Tinit;
GlobalTime=ModelInput.GlobalTime;

%kond = MIMI.MatLib.GetParamVector('k')

E = ModelInput.MatLib.GetParamVector('E');
cte = ModelInput.MatLib.GetParamVector('CTE');
nu = ModelInput.MatLib.GetParamVector('Nu');

[Num_Row, Num_Col, Num_Lay]=size(Mat);
NL=Num_Lay;

nlsub=1; % # layers that are substrate material
disp('Stress model assumes that layer 1 is substrate.')

Stress=zeros(size(Mat)); % Nodal thermal stress results
Strprnt=zeros(size(Mat)); % Nodal stress results realigned to match mesh layout

if min(Mat(:,:,nlsub)) <= 0
    Msg=sprintf('Invalid layer 1 assumption of substrate in stress model (%s).',mfilename);
    warning(Msg);
    Stress=Msg;
    return
end
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
                %if ii==1 && jj==1 & kk==2
                %    fprintf('SM MAT(%.0f, %.0f, %.0f) = %.0f\n',ii,jj,kk, Mat(ii,jj,kk))
                %end
                if Mat(ii,jj,kk) <= 0
                    Stress(ii,jj,kk,it)=0;
                elseif kk <= nlsub
                    Stress(ii,jj,kk,it)=substrate_ex(ii,jj,kk,delT,dz,cte,E,nu,nlsub,Mat,NL);
                else
                    Stress(ii,jj,kk,it)=layer_ex(ii,jj,kk,delT,dz,cte,E,nu,nlsub,Mat,NL);
                end
                % Makes the stresses print in the same order as nodes for
                % any partucular layer
                Strprnt(Num_Row+1-ii,jj,kk,it)=Stress(ii,jj,kk,it);
            end
        end
    end
end

end