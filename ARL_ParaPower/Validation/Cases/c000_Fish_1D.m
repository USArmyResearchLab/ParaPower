    
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
    ExternalConditions.h_Top=1e12;
    ExternalConditions.h_Bottom=0;

    ExternalConditions.Ta_Left=20;
    ExternalConditions.Ta_Right=20;
    ExternalConditions.Ta_Front=20;
    ExternalConditions.Ta_Back=20;
    ExternalConditions.Ta_Top=0;
    ExternalConditions.Ta_Bottom=20;

    ExternalConditions.Tproc=280;

    EndTime          = 30; 
    Params.Tinit     = 20;
    Params.DeltaT    = 2e-2;
    Params.Tsteps    = EndTime/Params.DeltaT;

    PottingMaterial  = 0;
    
    Features(1).x    = [0 .001];
    Features(1).y    = [0 .001];
    Features(1).z    = [0 .01];
    Features(1).dx   = 2;
    Features(1).dy   = 2;
    Features(1).dz   = 10;
    Features(1).Matl = 'Fields Metal';
    Features(1).Q    = 0;

    Features(2)=Features(1);
    Features(2).z    = [0 0];
    Features(2).dz   = 1;
    Features(2).Matl = 'Cu';
    Features(2).Q    = 10/(Features(1).dy*Features(1).dx);

    
%Assemble the above definitions into a single variablel that will be used
%to run the analysis.  This is the only variable that is used from this
%M-file.  
TestCaseModel.Features=Features;
TestCaseModel.Params=Params;
TestCaseModel.PottingMaterial=PottingMaterial;
TestCaseModel.ExternalConditions=ExternalConditions;
TestCaseModel.Desc=Desc;
