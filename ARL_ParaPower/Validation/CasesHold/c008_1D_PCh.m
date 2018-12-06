    
%Template: Describe what this test case consists of

%Clear the main variables that are passed out from it.
clear Features ExternalConditions Params PottingMaterial Descr
Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;

Desc='Test Case Template';  %Description of the test case

    clear Features ExternalConditions Params PottingMaterial
    
    ExternalConditions.h_Left=0;
    ExternalConditions.h_Right=0;
    ExternalConditions.h_Front=0;
    ExternalConditions.h_Back=0;
    ExternalConditions.h_Top=10000;
    ExternalConditions.h_Bottom=10000;

    ExternalConditions.Ta_Left=20;
    ExternalConditions.Ta_Right=20;
    ExternalConditions.Ta_Front=20;
    ExternalConditions.Ta_Back=20;
    ExternalConditions.Ta_Top=50;
    ExternalConditions.Ta_Bottom=40;

    ExternalConditions.Tproc=280;

    Params.Tinit     = 50;
    Params.DeltaT    = .2e-2;
    Params.Tsteps    = 90000;

    PottingMaterial  = 0;
    
    BarLen=.02;
    BarWid=0.001;
    BarDiv=60;
    BarBas=1e-3;
    
    Features(1).x    = [0 BarWid];
    Features(1).y    = [0 BarWid];
    Features(1).z    = [BarBas BarLen];
    Features(1).dx   = 1;
    Features(1).dy   = 1;
    Features(1).dz   = BarDiv;
    Features(1).Matl = 'Fields Metal';
    Features(1).Q    = 0;

    Features(2)=Features(1);
    Features(end).x    = [0 BarBas];
    Features(end).y    = [0 BarBas];
    Features(end).z    = [BarBas BarBas];
    Features(end).dx   = 1;
    Features(end).dy   = 1;
    Features(end).dz   = 1;
    Features(end).Matl = 'Cu';
    Features(end).Q    = '0.3*sin(0.25*t)+0.3';

   
    %{
    Features(3)=Features(2);
    Features(3).z    = [.01 .01];
    Features(3).dz   = 1;
    Features(3).Matl = 'Cu';
    Features(3).Q    = 0;
    %}

    
%Assemble the above definitions into a single variablel that will be used
%to run the analysis.  This is the only variable that is used from this
%M-file.  
TestCaseModel.Features=Features;
TestCaseModel.Params=Params;
TestCaseModel.PottingMaterial=PottingMaterial;
TestCaseModel.ExternalConditions=ExternalConditions;
TestCaseModel.Desc=Desc;
