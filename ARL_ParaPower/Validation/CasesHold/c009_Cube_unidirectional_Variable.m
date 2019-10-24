%Template: Describe what this test case consists of
%warning('This is a template only and will not result in a usable case')    

%Clear the main variables that are passed out from it.
clear Features ExternalConditions Params PottingMaterial Descr MatLib

ParamList={'B'  '[2 3]' ...
          ;'Ta' '20' ...
          };

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
                           ,'cp'     , 340   ...
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

Desc='1D_ParamList';  %Description of the test case

ExternalConditions.h_Xminus=0;
ExternalConditions.h_Xplus =0;
ExternalConditions.h_Yminus=0;
ExternalConditions.h_Yplus =0;
ExternalConditions.h_Zminus=0;
ExternalConditions.h_Zplus = 25000;

ExternalConditions.Ta_Xminus='Ta';
ExternalConditions.Ta_Xplus ='Ta';
ExternalConditions.Ta_Yminus='Ta';
ExternalConditions.Ta_Yplus ='Ta';
ExternalConditions.Ta_Zminus='Ta';
ExternalConditions.Ta_Zplus ='Ta';

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

Features(1).x    = {0 .001};
Features(1).y    = {0 .001};
Features(1).z    = {0 .001};
Features(1).dx   = 'B';
Features(1).dy   = 2;
Features(1).dz   = 2;
Features(1).Matl = 'Cu';
Features(1).Q    = 0;  %Total watts per features dissipated.

Features(2)      = Features(1);
Features(2).z    = {0 0};
Features(2).dz   = 1;
Features(2).Q    = 1;
Features(2).Matl = 'No_Matl';

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
TestCaseModel.TCM.VariableList=ParamList;
TestCaseModel.TCMs=TestCaseModel.TCM.GenerateCases;
TestCaseModel.CaseNumber=1;
if length(TestCaseModel.TCMs) > 1
    TestCaseModel.TCM=TestCaseModel.TCMs(TestCaseModel.CaseNumber);
end

MFILE=mfilename('fullpath');
