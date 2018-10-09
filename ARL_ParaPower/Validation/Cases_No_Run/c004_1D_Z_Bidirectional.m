%***************************************
%**   Bidrectional in Z Direction     **
%***************************************
    clear Features ExternalConditions Params PottingMaterial
    ExternalConditions.h_Left=0;
    ExternalConditions.h_Right=0;
    ExternalConditions.h_Front=0;
    ExternalConditions.h_Back=0;
    ExternalConditions.h_Top=1e20;
    ExternalConditions.h_Bottom=1e20;

    ExternalConditions.Ta_Left=20;
    ExternalConditions.Ta_Right=20;
    ExternalConditions.Ta_Front=20;
    ExternalConditions.Ta_Back=20;
    ExternalConditions.Ta_Top=20;
    ExternalConditions.Ta_Bottom=20;

    ExternalConditions.Tproc=280;

    EndTime          = 1; 
    Params.Tinit     = 20;
    Params.DeltaT    = 1e-3;
    Params.Tsteps    = EndTime/Params.DeltaT;

    PottingMaterial  = 0;
    
    Features(1).x    = [0 .001];
    Features(1).y    = [0 .001];
    Features(1).z    = Features(1).x*20;
    Features(1).dx   = 2;
    Features(1).dy   = 2;
    Features(1).dz   = 10;
    Features(1).Matl = 'Cu';
    Features(1).Q    = 0;

    Features(2)=Features(1);
    Features(2).z=Features(2).z*-1;

    Features(3)=Features(1);
    Features(3).z    = [0 0];
    Features(3).dx   = 1;
    Features(3).dy   = 1;
    Features(3).dz   = 1;
    Features(3).Matl = 'AIR';
    Features(3).Q    = 100;

    Features(4) = Features(3);
    Features(4).Q  = 0;
    Features(4).dz = 1;
    Features(4).z  = [1 1] * max(Features(1).z);
    
    Features(5) = Features(4);
    Features(5).z  = [1 1] * min(Features(2).z);
    
    
%     Define Q as @(T,Q,Ti)interp1(T,Q,Ti,'spline');
%     if Q is cell then do interp, otherwise 
%         Q{ii,jj,kk}(Arg1 Arg2 Arg3)

    TestCaseModel.ExternalConditions=ExternalConditions;
    TestCaseModel.Features=Features;
    TestCaseModel.Params=Params;
    TestCaseModel.PottingMaterial=PottingMaterial;
%    [GlobalTime, Tprnt, Stress, MeltFrac]=CLI_Input(Features, PottingMaterial, ExternalConditions, Params, true);
%    disp('Press any key');pause