%Shell to call the Miner non-directional model
<<<<<<< HEAD
function Stress=Stress_NonDirectional(Results)

    MFPath=[strrep(mfilename('fullpath'),mfilename,'') 'NonDirectional'];
=======
function Stress = Stress_NonDirectional(Results)

    MFPath=[strrep(mfilename('fullpath'),mfilename,'') 'iPack2019'];
>>>>>>> P_20200709_Vectorize_NonDirectional
    OldPath=addpath(MFPath);
    
    ErrText=[];
    ModelInput=Results.Model;
    if ~isempty(find(strcmpi(Results.StatesAvail,'Thermal')))
        Tres=Results.getState('Thermal');
    else
        ErrText=[ErrText 'No thermal state exists for computing stress.' newline ];
    end

    if ~isempty(ErrText)
        Stress=ErrText(1:end-1);
        return
    else
        
<<<<<<< HEAD
        [StressX,StressY,StressZ]=Stress_NoSubstrate1(Results);        
        path(OldPath);
        Stress.X=StressX;
        Stress.Y=StressY;
        Stress.Z=StressZ;
        Stress.VM=(((Stress.X-Stress.Z).^2 + (Stress.X-Stress.Y).^2 + (Stress.Y-Stress.Z).^2)/2).^.5;
=======
        % second parameter: 1 = vectorized
        [StressX, StressY, StressZ, StressVM] = Stress_NoSubstrate3D_time(Results);  
        
        path(OldPath);
        Stress.X = StressX;
        Stress.Y = StressY;
        Stress.Z = StressZ;
        Stress.VM = StressVM
        
>>>>>>> P_20200709_Vectorize_NonDirectional
    end

end