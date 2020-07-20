%Shell to call the Miner non-directional model
function Stress = Stress_iPack2019_Miner (Results)

    MFPath=[strrep(mfilename('fullpath'),mfilename,'') 'iPack2019'];
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
        
        [StressX, StressY, StressZ, StressVM] = Stress_Miner_time_loop(Results);        
        
        path(OldPath);
        Stress.X = StressX;
        Stress.Y = StressY;
        Stress.Z = StressZ;
        Stress.VM = StressVM;
        
    end

end