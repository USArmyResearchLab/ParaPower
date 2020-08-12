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
                    
MatLib.AddMatl(PPMatSolid('name'  , 'Cu'  ...
                           ,'cte'   , 2.4e-5...
                           ,'E'     , 1.1e10...
                           ,'nu'    , .33   ...
                           ,'k'     , 172   ...
                           ,'rho'   , 2700  ...
                           ,'cp'     , 900   ...
                        )) ;
                    
MatLib.AddMatl(PPMatSolid('name'  , 'Al'  ...
                           ,'cte'   , 2.35e-5...
                           ,'E'     , 6.9e11...
                           ,'nu'    , .37   ...
                           ,'k'     , 390   ...
                           ,'rho'   , 8900  ...
                           ,'cp'     , 390   ...
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

Desc='iPACK Model';  %Description of the test case

ExternalConditions.h_Xminus = 0;
ExternalConditions.h_Xplus  = 0;
ExternalConditions.h_Yminus = 0;
ExternalConditions.h_Yplus  = 0;
ExternalConditions.h_Zminus = 20000;
ExternalConditions.h_Zplus  = 0;

ExternalConditions.Ta_Xminus = 20;
ExternalConditions.Ta_Xplus  = 20;
ExternalConditions.Ta_Yminus = 20;
ExternalConditions.Ta_Yplus  = 20;
ExternalConditions.Ta_Zminus = 20;
ExternalConditions.Ta_Zplus  = 20;

ExternalConditions.Tproc=217; %Processing temperature, used for stress analysis

Params.Tinit     = 20;  %Initial temperature of all materials
Params.DeltaT    = 1e-1; %Time step size, in seconds
Params.Tsteps    = 100; %Number of time steps.

PottingMaterial  = 0;  %Material that surrounds features in each layer as defined by text strings in matlibfun. 
                       %If Material is 0, then the space is empty and not filled by any material.

%Each feature is defined separately.  There is no limit to the number of
%features that can be defined.  For each layer of the model, unless a
%feature exists, the material is defined as "potting material."  There is
%no checking to ensure that features do not overlap.  The behavior for
%overlapping features is not defined.


% Aluminum heat spreader, two layers of 5 mm thickness

Features(1).Desc = 'Substrate';
Features(end).x    = [0     30];
Features(end).y    = [0     30];
Features(end).z    = [0  10];
Features(end).dx   = 2;
Features(end).dy   = 2;
Features(end).dz   = 2;
Features(end).Matl = 'Al';
Features(end).Q    = 0;  %Total watts per features dissipated.

% Lower copper

Features(end+1)  = Features(end);
Features(end).Desc = 'Lower Copper';
Features(end).x    = [0 30];
Features(end).y    = [0 30];
Features(end).z    = [10 10.3048];
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Matl = 'Cu';
Features(end).Q    = 0;  %Total watts per features dissipated.

% Aluminum heat spreader, part 2

Features(end+1)  = Features(end);
Features(end).Desc = 'AlN';
Features(end).x    = [0 30];
Features(end).y    = [0 30];
Features(end).z    = [10.3048 10.9398];
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Matl = 'AlN';
Features(end).Q    = 0;  %Total watts per features dissipated.

% Upper copper

Features(end+1)  = Features(end);
Features(end).Desc = 'Upper Copper (a)';
Features(end).x    = [0 12];
Features(end).y    = [0 12];
Features(end).z    = [10.9398 11.2446];
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Matl = 'AlN';
Features(end).Q    = 0;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc = 'Upper Copper (b)';
Features(end).x    = [18 30];
Features(end).y    = [0 12];
Features(end).z    = [10.9398 11.2446];
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Matl = 'AlN';
Features(end).Q    = 0;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc = 'Upper Copper (c)';
Features(end).x    = [0 30];
Features(end).y    = [18 30];
Features(end).z    = [10.9398 11.2446];
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Matl = 'AlN';
Features(end).Q    = 0;  %Total watts per features dissipated.

% Device layers (SiC): one layer of 0.4mm thickness and one of 0.1 mm
% thickness

Features(end+1)  = Features(end);
Features(end).Desc = 'Dev (1a)';
Features(end).x    = [2 10];
Features(end).y    = [2 10];
Features(end).z    = [11.2446 11.6446];
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Matl = 'SiC';
Features(end).Q    = 0;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc = 'Dev (1b)';
Features(end).x    = [20 28];
Features(end).y    = [2 10];
Features(end).z    = [11.2446 11.6446];
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Matl = 'SiC';
Features(end).Q    = 0;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc = 'Dev (1c)';
Features(end).x    = [2 10];
Features(end).y    = [20 28];
Features(end).z    = [11.2446 11.6446];
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Matl = 'SiC';
Features(end).Q    = 0;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc = 'Dev (1d)';
Features(end).x    = [20 28];
Features(end).y    = [20 28];
Features(end).z    = [11.2446 11.6446];
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Matl = 'SiC';
Features(end).Q    = 0;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc = 'Dev (2a)';
Features(end).x    = [2 10];
Features(end).y    = [2 10];
Features(end).z    = [11.6446 11.7446];
Features(end).dx   = 3;
Features(end).dy   = 3;
Features(end).dz   = 1;
Features(end).Matl = 'SiC';
Features(end).Q    = 80;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc = 'Dev (2b)';
Features(end).x    = [20 28];
Features(end).y    = [2 10];
Features(end).z    = [11.6446 11.7446];
Features(end).dx   = 3;
Features(end).dy   = 3;
Features(end).dz   = 1;
Features(end).Matl = 'SiC';
Features(end).Q    = 80;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc = 'Dev (2c)';
Features(end).x    = [2 10];
Features(end).y    = [20 28];
Features(end).z    = [11.6446 11.7446];
Features(end).dx   = 3;
Features(end).dy   = 3;
Features(end).dz   = 1;
Features(end).Matl = 'SiC';
Features(end).Q    = 80;  %Total watts per features dissipated.

Features(end+1)  = Features(end);
Features(end).Desc = 'Dev (2d)';
Features(end).x    = [20 28];
Features(end).y    = [20 28];
Features(end).z    = [11.6446 11.7446];
Features(end).dx   = 3;
Features(end).dy   = 3;
Features(end).dz   = 1;
Features(end).Matl = 'SiC';
Features(end).Q    = 80;  %Total watts per features dissipated.

TestCaseModel.Desc = Desc;
TestCaseModel.TCM = PPTCM;
TestCaseModel.TCM.Features = Features;
TestCaseModel.TCM.Params = Params;
TestCaseModel.TCM.PottingMaterial = PottingMaterial;
TestCaseModel.TCM.ExternalConditions = ExternalConditions;
TestCaseModel.TCM.MatLib = MatLib;


MFILE = mfilename('fullpath');
StressModel = 'NonDirectional';  %"Stress_" is assumed
