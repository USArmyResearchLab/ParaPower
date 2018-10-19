%********************************************************
%**           Test Case #2, 1D in 3 directions         **
%********************************************************
    
    clear Features ExternalConditions Params PottingMaterial
    
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

    Params.Tinit     = 20;
    Params.DeltaT    = 1e-3;
    Params.Tsteps    = 100;

    PottingMaterial  = 0;
    
    BarLen=.01;
    BarWid=0.001;
    BarDiv=10;
    BarBas=1e-3;
    
    Features(1).x    = [0 BarWid];
    Features(1).y    = [0 BarWid];
    Features(1).z    = [BarBas BarLen];
    Features(1).dx   = 2;
    Features(1).dy   = 2;
    Features(1).dz   = BarDiv;
    Features(1).Matl = 'Cu';
    Features(1).Q    = 0;

    Features(2).x      = [BarBas BarLen];
    Features(end).y    = [0 BarWid];
    Features(end).z    = [0 BarWid];
    Features(end).dx   = BarDiv;
    Features(end).dy   = 2;
    Features(end).dz   = 2;
    Features(end).Matl = 'Cu';
    Features(end).Q    = 0;

    Features(3).x      = [0 BarWid];
    Features(end).y    = [BarBas BarLen];
    Features(end).z    = [0 BarWid];
    Features(end).dx   = 2;
    Features(end).dy   = BarDiv;
    Features(end).dz   = 2;
    Features(end).Matl = 'Cu';
    Features(end).Q    = 0;

    Features(4)=Features(1);
    Features(end).x    = [0 BarBas];
    Features(end).y    = [0 BarBas];
    Features(end).z    = [BarBas BarBas];
    Features(end).dx   = 1;
    Features(end).dy   = 1;
    Features(end).dz   = 1;
    Features(end).Matl = 'Cu';
    Features(end).Q    = 1000;

    Features(5)=Features(1);
    Features(end).x    = [0 BarBas];
    Features(end).y    = [BarBas BarBas];
    Features(end).z    = [0 BarBas];
    Features(end).dx   = 1;
    Features(end).dy   = 1;
    Features(end).dz   = 1;
    Features(end).Matl = 'Cu';
    Features(end).Q    = 1000;

    Features(6)=Features(1);
    Features(end).x    = [BarBas BarBas];
    Features(end).y    = [0 BarBas];
    Features(end).z    = [0 BarBas];
    Features(end).dx   = 1;
    Features(end).dy   = 1;
    Features(end).dz   = 1;
    Features(end).Matl = 'Cu';
    Features(end).Q    = 1000;

    TestCaseModel.ExternalConditions=ExternalConditions;
    TestCaseModel.Features=Features;
    TestCaseModel.Params=Params;
    TestCaseModel.PottingMaterial=PottingMaterial;
%    [GlobalTime, Tprnt, Stress, MeltFrac]=CLI_Input(Features, PottingMaterial, ExternalConditions, Params, true);
%    disp('Press any key');pause
