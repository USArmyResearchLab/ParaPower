%Template: Describe what this test case consists of
%warning('This is a template only and will not result in a usable case')    

%Clear the main variables that are passed out from it.
clear Features ExternalConditions Params PottingMaterial Descr MatLib

MatLib=PPMatLib;
MatLib.AddMatl(PPMatPCM(  'name'  , 'Ga'  ...
                           ,'k_l'   , 24    ...
                           ,'rho_l' , 6093  ...
                           ,'cp_l'  , 397   ...
                           ,'lf'    , 80300 ...
                           ,'tmelt' , 29.8  ...
                           ,'cte'   , 0     ...
                           ,'E'     , 0     ...
                           ,'nu'    , 0     ...
                           ,'k'     , 33.7  ...
                           ,'rho'   , 5903  ...
                           ,'cp'    , 340   ...
                        )) ;
MatLib.AddMatl(PPMatSolid('name'  , 'cu'  ...
                           ,'cte'   , 2.4e-5...
                           ,'E'     , 1.1e11...
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

Desc='PCM Block';  %Description of the test case

ExternalConditions.h_Xminus=25000;
ExternalConditions.h_Xplus =0;
ExternalConditions.h_Yminus=25000;
ExternalConditions.h_Yplus =0;
ExternalConditions.h_Zminus=25000;
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

Features(1).x    = [0 .01];
Features(1).y    = [0 .01];
Features(1).z    = [0 .01];
Features(1).dx   = 10;
Features(1).dy   = 10;
Features(1).dz   = 10;
Features(1).Matl = 'Ga';
Features(1).Q    = 0;  %Total watts per features dissipated.

Features(2)      = Features(1);
Features(2).x    = max(Features(1).x) * [1-1/Features(1).dx 1];
Features(2).y    = max(Features(1).y) * [1-1/Features(1).dy 1];
Features(2).z    = max(Features(1).z) * [1-1/Features(1).dz 1];
Features(2).dx   = 1;
Features(2).dy   = 1;
Features(2).dz   = 1;
Features(2).Q    = 20;
Features(2).Matl = 'No_Matl';

% Features(1).x    = [0  1];
% Features(1).y    = [0  1];
% Features(1).z    = [1 10];
% Features(1).dx   = 2;
% Features(1).dy   = 2;
% Features(1).dz   = 10;
% Features(1).Matl = 'Cu';
% Features(1).Q    = 0;  %Total watts per features dissipated.
% 
% Features(2)      = Features(1);
% Features(2).z    = [1 1]*min(Features(end-1).z);
% Features(2).dz   = 1;
% Features(2).Q    = 100000;
% Features(2).Matl = 'No_Matl';

% Features(end+1).x    = Features(1).z;
% Features(end).y      = Features(1).x;
% Features(end).z      = Features(1).x;
% Features(end).dx     = Features(1).dz;
% Features(end).dy     = Features(1).dx;
% Features(end).dz     = Features(1).dx;
% Features(end).Matl   = Features(1).Matl;
% Features(end).Q      = 0;  %Total watts per features dissipated.
% 
% Features(end+1)    = Features(end);
% Features(end).x    = [1 1]*min(Features(end-1).x);
% Features(end).dx   = 1;
% Features(end).Q    = Features(2).Q;
% Features(end).Matl = 'No_Matl';
% 
% Features(end+1).x    = Features(1).x;
% Features(end).y      = Features(1).z;
% Features(end).z      = Features(1).x;
% Features(end).dx     = Features(1).dx;
% Features(end).dy     = Features(1).dz;
% Features(end).dz     = Features(1).dx;
% Features(end).Matl   = Features(1).Matl;
% Features(end).Q      = 0;  %Total watts per features dissipated.
% 
% Features(end+1)      = Features(end);
% Features(end).y    = [1 1]*min(Features(end-1).y);;
% Features(end).dy   = 1;
% Features(end).Q    = Features(2).Q;
% Features(end).Matl = 'No_Matl';

%     Define Q as @(T,Q,Ti)interp1(T,Q,Ti,'spline');
%     if Q is cell then do interp, otherwise 
%         Q{ii,jj,kk}(Arg1 Arg2 Arg3)

TestCaseModel.Desc=Desc;
TestCaseModel.TCM=PPTCM;
TestCaseModel.TCM.Features=Features;
TestCaseModel.TCM.Params=Params;
TestCaseModel.TCM.PottingMaterial=PottingMaterial;
TestCaseModel.TCM.ExternalConditions=ExternalConditions;
TestCaseModel.TCM.MatLib=MatLib;

MFILE=mfilename('fullpath');
