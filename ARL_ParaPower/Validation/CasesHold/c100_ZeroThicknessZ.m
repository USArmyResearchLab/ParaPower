%Template: Describe what this test case consists of

%Clear the main variables that are passed out from it.
clear Features ExternalConditions Params PottingMaterial Descr
Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;

Desc='Test Case Template';  %Description of the test case


ExternalConditions.h_Left=0;  %Heat transfer coefficient from each side to the external environment
ExternalConditions.h_Right=0;
ExternalConditions.h_Front=0;
ExternalConditions.h_Back=0;
ExternalConditions.h_Top=0000;
ExternalConditions.h_Bottom=0;

ExternalConditions.Ta_Left=20;  %Ambiant temperature outside the defined the structure
ExternalConditions.Ta_Right=20;
ExternalConditions.Ta_Front=20;
ExternalConditions.Ta_Back=20;
ExternalConditions.Ta_Top=20;
ExternalConditions.Ta_Bottom=20;

ExternalConditions.Tproc=217; %Processing temperature, used for stress analysis

Params.Tinit     = 200;  %Initial temperature of all materials
Params.DeltaT    = .0100; %Time step size, in seconds
Params.Tsteps    = 20; %Number of time steps.

PottingMaterial  = 0;  %Material that surrounds features in each layer as defined by text strings in matlibfun. 
                       %If Material is 0, then the space is empty and not filled by any material.

%Each feature is defined separately.  There is no limit to the number of
%features that can be defined.  For each layer of the model, unless a
%feature exists, the material is defined as "potting material."  There is
%no checking to ensure that features do not overlap.  The behavior for
%overlapping features is not defined.

%Bottom 1/3 layer of material #1
Features(1).z      = [0 .05];  %.x, .y & .z are the two element vectors that define the corners
Features(end).y    = [0 .15];  %of each features.  X=[X1 X2], Y=[Y1 Yz], Z=[Z1 Z2] is interpreted
Features(end).x    = [0 .15];   %that corner of the features are at points (X1, Y1, Z1) and (X2, Y2, Z2).
                              %It is possible to define zero thickness features where Z1=Z2 (or X or Y)
                              %to ensure a heat source at a certain layer or a certain discretization.
Features(end).dz   = 1;     %These define the number of elements in each features.  While these can be 
Features(end).dy   = 3;     %values from 2 to infinity, only odd values ensure that there is an element
Features(end).dx   = 3;    %at the center of each features
Features(end).Matl = 'Cu'; %Material text as defined in matlibfun
Features(end).Q    = 0;  %Total heat input at this features in watts.  The heat per element is Q/(# elements)

%Top 2/3 Layer of material #2
Features(end+1)    = Features(end);
Features(end).z  = [.05 .15];  %.x, .y & .z are the two element vectors that define the corners
Features(end).dz   = 2;     %These define the number of elements in each features.  While these can be 
Features(end).Matl = 'Al'; %Material text as defined in matlibfun

%Zero layer thickness at max X, only the central element
Features(end+1)=Features(1); 
Features(end).z    = [ 1 1]*min(Features(1).x);
Features(end).y    = [.05 .10];
Features(end).x    = [.05 .10];
Features(end).Matl = 'Air';
Features(end).dx   = 1;
Features(end).dy   = 1;
Features(end).dz   = 1;
Features(end).Q    = 0;

%Zero layer thickness at intermediate X
Features(end+1)=Features(end);
Features(end).z    = [ 1 1]*max(Features(1).z);
Features(end).Matl = 'Air';

%Zero layer thickness at max X
Features(end+1)=Features(end);
Features(end).z    = [ 1 1]*max(Features(2).z);
Features(end).Matl = 'Air';

%Assemble the above definitions into a single variablel that will be used
%to run the analysis.  This is the only variable that is used from this
%M-file.  
TestCaseModel.Features=Features;
TestCaseModel.Params=Params;
TestCaseModel.PottingMaterial=PottingMaterial;
TestCaseModel.ExternalConditions=ExternalConditions;
TestCaseModel.Desc=Desc;
