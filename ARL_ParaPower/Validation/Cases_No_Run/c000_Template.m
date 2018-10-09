    
%Template: Describe what this test case consists of

%Clear the main variables that are passed out from it.
clear Features ExternalConditions Params PottingMaterial Descr
Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;

Desc='Test Case Template';  %Description of the test case


ExternalConditions.h_Left=0;  %Heat transfer coefficient from each side to the external environment
ExternalConditions.h_Right=0;
ExternalConditions.h_Front=0;
ExternalConditions.h_Back=500;
ExternalConditions.h_Top=1e10;
ExternalConditions.h_Bottom=0;

ExternalConditions.Ta_Left=20;  %Ambiant temperature outside the defined the structure
ExternalConditions.Ta_Right=20;
ExternalConditions.Ta_Front=20;
ExternalConditions.Ta_Back=20;
ExternalConditions.Ta_Top=20;
ExternalConditions.Ta_Bottom=20;

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
Features(1).x    = [0 .001];  %.x, .y & .z are the two element vectors that define the corners
Features(1).y    = [0 .001];  %of each features.  X=[X1 X2], Y=[Y1 Yz], Z=[Z1 Z2] is interpreted
Features(1).z    = [0 .01];   %that corner of the features are at points (X1, Y1, Z1) and (X2, Y2, Z2).
                              %It is possible to define zero thickness features where Z1=Z2 (or X or Y)
                              %to ensure a heat source at a certain layer or a certain discretization.
                              
Features(1).dx   = 3;     %These define the number of elements in each features.  While these can be 
Features(1).dy   = 3;     %values from 2 to infinity, only odd values ensure that there is an element
Features(1).dz   = 10;    %at the center of each features

Features(1).Matl = 'Cu'; %Material text as defined in matlibfun

Features(1).Q    = 0;  %Total heat input at this features in watts.  The heat per element is Q/(# elements)


%Assemble the above definitions into a single variablel that will be used
%to run the analysis.  This is the only variable that is used from this
%M-file.  
TestCaseModel.Features=Features;
TestCaseModel.Params=Params;
TestCaseModel.PottingMaterial=PottingMaterial;
TestCaseModel.ExternalConditions=ExternalConditions;
TestCaseModel.Desc=Desc;
