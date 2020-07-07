%Template: Describe what this test case consists of
%warning('This is a template only and will not result in a usable case')    

%Clear the main variables that are passed out from it.
clear Features ExternalConditions Params PottingMaterial Descr MatLib

MatLib=PPMatLib;
MatLib.AddMatl(PPMatPCM(  'name'  , 'AlN'  ...
                           ,'cte'   , 5.3e-6     ...
                           ,'E'     , 344000000000      ...
                           ,'nu'    , 0.24     ...
                           ,'k'     , 170  ...
                           ,'rho'   , 3260  ...
                           ,'cp'    , 740   ...
                        )) ;
                    
MatLib.AddMatl(PPMatNull('name'  , 'NoMat'  ...
                        )) ;
                    
MatLib.AddMatl(PPMatSolid('name'  , 'SiC'  ...
                           ,'cte'   , 4e-6 ...
                           ,'E'     , 4.1e11...
                           ,'nu'    , .14   ...
                           ,'k'     , 120   ...
                           ,'rho'   , 3100  ...
                           ,'cp'     , 750   ...
                        )) ;
                    
MatLib.AddMatl(PPMatNull('name'  , 'No_Matl'  ...
                           ));
                       
Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;

Desc='Simple Substrate';  %Description of the test case

ExternalConditions.h_Xminus=0;
ExternalConditions.h_Xplus =0;
ExternalConditions.h_Yminus=0;
ExternalConditions.h_Yplus =0;
ExternalConditions.h_Zminus=200;
ExternalConditions.h_Zplus =0;

ExternalConditions.Ta_Xminus=20;
ExternalConditions.Ta_Xplus =20;
ExternalConditions.Ta_Yminus=20;
ExternalConditions.Ta_Yplus =20;
ExternalConditions.Ta_Zminus=20;
ExternalConditions.Ta_Zplus =20;

ExternalConditions.Tproc=280; %Processing temperature, used for stress analysis

Params.Tinit     = 20;  %Initial temperature of all materials
Params.DeltaT    = 1e-2; %Time step size, in seconds
Params.Tsteps    = 1000; %Number of time steps.

PottingMaterial  = 0;  %Material that surrounds features in each layer as defined by text strings in matlibfun. 
                       %If Material is 0, then the space is empty and not filled by any material.

%Each feature is defined separately.  There is no limit to the number of
%features that can be defined.  For each layer of the model, unless a
%feature exists, the material is defined as "potting material."  There is
%no checking to ensure that features do not overlap.  The behavior for
%overlapping features is not defined.

PottingMaterial  = 0;

Features(1).Desc='Substrate';
Features(end).x    = [0     10];
Features(end).y    = [0     30];
Features(end).z    = [0  1];
Features(end).dx   = 5;
Features(end).dy   = 10;
Features(end).dz   = 3;
Features(end).Matl = 'AlN';
Features(end).Q    = 0;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc='Dev';
Features(end).x   = [3 7];
Features(end).y   = [12 17];
Features(end).z    = max(Features(end-1).z) + [0 0.5];
Features(end).dz   = 3;
Features(end).Matl = 'SiC';

Features(end+1)  = Features(end);
Features(end).z    = [1 1] * max(Features(end-1).z);
Features(end).dz   = 1;
Features(end).Q    = 10;
Features(end).Matl = 'NoMat';


TestCaseModel.Desc=Desc;
TestCaseModel.TCM=PPTCM;
TestCaseModel.TCM.Features=Features;
TestCaseModel.TCM.Params=Params;
TestCaseModel.TCM.PottingMaterial=PottingMaterial;
TestCaseModel.TCM.ExternalConditions=ExternalConditions;
TestCaseModel.TCM.MatLib=MatLib;


MFILE=mfilename('fullpath');
StressModel='Hsueh';  %"Stress_" is assumed