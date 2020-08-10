%Shell to call the Hsueh substrate model
function Stress=Stress_Hsueh(Results)

    MFPath=[strrep(mfilename('fullpath'),mfilename,'') 'Hsueh'];
    OldPath=addpath(MFPath);

    ErrText=[];
    ModelInput=Results.Model;
    if ~isempty(find(strcmpi(Results.StatesAvail,'Thermal')))
        Tres=Results.getState('Thermal');
    else
        ErrText=[ErrText 'No thermal state exists for computing stress.' newline ];
    end

    %Error check to ensure that substrate is the bottom-most layer and continuous
    SubstrateKeyWord='substrate';
    SubstrateFeature=find(strcmpi(ModelInput.FeatureDescr,SubstrateKeyWord));
    if isempty(SubstrateFeature)
        ErrText=[ErrText 'No substrate found.  A feature named "' SubstrateKeyWord '" must exist to use this substrate dominated stress model.' newline];
    else
        SubLayers=find(ModelInput.FeatureMatrix(1,1,:)==SubstrateFeature);
        if isempty(SubLayers)
            ErrText=[ErrText 'Substrate must extend across entire base layer.' newline];
        else
            if SubLayers(1) ~= 1
                ErrText=[ErrText 'Substrate must start at the bottom layer.' newline];
            end
            if (length(SubLayers) > 1) && max((SubLayers(2:end)-SubLayers(1:end-1)))>1
                ErrText=[ErrText 'Substrate must be continuous from the bottom' newline];
            end
            for Layer=SubLayers(:)'
                if ~all(ModelInput.FeatureMatrix(:,:,Layer)==SubstrateFeature,'all')
                    ErrText=[ErrText sprintf('Layer %i discontinuous. Substrate feature must be continuous across the length & width of the model.\n', Layer)];
                end
            end
        end
    end

    if ~isempty(ErrText)
        Stress=ErrText(1:end-1);
        return
    else
        [StressX,StressY]=Stress_Substrate_Hsueh(Results, length(SubLayers));
        path(OldPath);
        Stress.X=StressX;
        Stress.Y=StressY;
        Stress.Z=Stress.X*0;
        Stress.VM=(((Stress.X-Stress.Z).^2 + (Stress.X-Stress.Y).^2 + (Stress.Y-Stress.Z).^2)/2).^.5;
        Stress.Z=NaN*StressX;
    end

end