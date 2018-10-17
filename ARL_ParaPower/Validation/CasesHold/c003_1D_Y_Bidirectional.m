clear Features ExternalConditions Params PottingMaterial Descr

%***************************************
%**   Bidrectional in Y Direction     **
%***************************************
    Descr='Bidirectional in y Direction';
    
    ExternalConditions.h_Left=0;
    ExternalConditions.h_Right=0;
    ExternalConditions.h_Front=0;
    ExternalConditions.h_Back=0;
    ExternalConditions.h_Top=0;
    ExternalConditions.h_Bottom=0;

    ExternalConditions.Ta_Left=20;
    ExternalConditions.Ta_Right=20;
    ExternalConditions.Ta_Front=20;
    ExternalConditions.Ta_Back=20;
    ExternalConditions.Ta_Top=20;
    ExternalConditions.Ta_Bottom=20;

    ExternalConditions.Tproc=280;

    EndTime          = .01; 
    Params.Tinit     = 20;
    Params.DeltaT    = 1e-5;
    Params.Tsteps    = EndTime/Params.DeltaT;

    PottingMaterial  = 0;
    
    Features(1).x    = [0 .001];
    Features(1).y    = Features(1).x*20;
    Features(1).z    = [0 .001];
    Features(1).dx   = 2;
    Features(1).dy   = 10;
    Features(1).dz   = 2;
    Features(1).Matl = 'Cu';
    Features(1).Q    = 0;

    Features(2)=Features(1);
    Features(2).y=Features(2).y*-1;

    Features(end+1)=Features(1);
    Features(end).y    = [0 0];
    Features(end).dx   = 1;
    Features(end).dy   = 1;
    Features(end).dz   = 1;
    Features(end).Matl = 'AIR';
    Features(end).Q    = 100;
%     
%     Define Q as @(T,Q,Ti)interp1(T,Q,Ti,'spline');
%     if Q is cell then do interp, otherwise 
%         Q{ii,jj,kk}(Arg1 Arg2 Arg3)

    TestCaseModel.ExternalConditions=ExternalConditions;
    TestCaseModel.Features=Features;
    TestCaseModel.Params=Params;
    TestCaseModel.PottingMaterial=PottingMaterial;
    TestCaseModel.Desc=Descr;
%    [GlobalTime, Tprnt, Stress, MeltFrac]=CLI_Input(Features, PottingMaterial, ExternalConditions, Params, true);
%    disp('Press any key');pause