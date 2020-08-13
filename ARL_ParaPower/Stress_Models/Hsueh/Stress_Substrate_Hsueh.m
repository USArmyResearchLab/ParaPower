function [stressX,stressY]=Stress_Substrate_Miner1(Results,nlsub)
% This function calculates the thermal stress based on CTE mismatch for 
% each element in the model.
% Based on paper by C. H. Hsueh, Thin Solid Films, Vol 418, 2002
% Load Temperature Results, Melt Fraction Results and Processing Temp
    DEBUG=false;
    Temps=Results.getState('Thermal');
    Melts=Results.getState('MeltFrac');
    if size(Temps,4) ~= size(Melts,4)
        error('MeltFrac and Thermal must have the same number of states.')
    end
    stressX=nan(size(Temps));
    stressY=nan(size(Temps));
    if DEBUG
        fprintf('Computing %i states...',size(Temps,4))
    end
    for state=1:size(Temps,4)
        if DEBUG
            if mod(state,10)==0
                fprintf('%i...',state)
            end
            if mod(state,100)==0
                fprintf('\n')
            end
        end
        Temp=Temps(:,:,:,state);
        Melt=Melts(:,:,:,state);
        ProcT=Results.Model.Tproc;
        % Load material properties E, cte, nu
        EX=Results.Model.MatLib.GetParam('E');
        EY=Results.Model.MatLib.GetParam('E');
        nuX=Results.Model.MatLib.GetParam('nu');
        nuY=Results.Model.MatLib.GetParam('nu');
        cteX=Results.Model.MatLib.GetParam('cte');
        cteY=Results.Model.MatLib.GetParam('cte');
        % Calculate the difference between the operating temp and the processing
        % temp for thermal stress calc
        delT=Temp-ProcT;
        % Load dz values and number of Layers, Rows and Columns
        dz=Results.Model.Z;

        % NL=length(Results.Model.Z);
        % NR=length(Results.Model.Y);
        % NC=length(Results.Model.X);

        NL=length(Results.Model.Z); %Morris changed
        NR=length(Results.Model.X); %these as they
        NC=length(Results.Model.Y); %appeared to be incorrect

        % Load Material Numbers for every element in the model
        Mat=Results.Model.Model;
        % Loop over all the elements in the model
        for kk=1:NL
            for ii=1:NR
                for jj=1:NC

                        % Calculate the thermal stress
                        % Skip locations that have no material, IBC's, Fluid and
                        % non-zero Melt fractions
                        % Check for No material
                        if Mat(ii,jj,kk) == 0
                            ckMatl=false;
                        else
                            ckMatl=isa(Results.Model.MatLib.GetMatNum(Mat(ii,jj,kk)),'PPMatSolid');
                        end
                        if  ckMatl == 0 || Melt(ii,jj,kk) > 0
                            stressX(ii,jj,kk,state)=NaN;
                            stressY(ii,jj,kk,state)=NaN;
                        elseif kk <= nlsub
                            [stressX(ii,jj,kk,state),stressY(ii,jj,kk,state)]=substrate_ex_Hsueh(Results,ii,jj,kk,delT,dz,nlsub,NL,EX,EY,nuX,nuY,cteX,cteY,Mat,Melt);
                        else
                            [stressX(ii,jj,kk,state),stressY(ii,jj,kk,state)]=layer_ex_Hsueh(Results,ii,jj,kk,delT,dz,nlsub,NL,EX,EY,nuX,nuY,cteX,cteY,Mat,Melt);
                        end
                end
            end
        end
    end
end
