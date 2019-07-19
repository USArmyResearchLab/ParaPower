clear TestCaseModel;
load DefaultMaterials
TestCaseModel=PPTCM;
TestCaseModel.Features(1).x=[0 1];
TestCaseModel.Features(1).y=[0 1];
TestCaseModel.Features(1).z=[0 1];
TestCaseModel.Features(1).Matl='Ga';
TestCaseModel.Features(1).Q=0;
TestCaseModel.Features(1).dx=1;
TestCaseModel.Features(1).dy=1;
TestCaseModel.Features(1).dz=2;
TestCaseModel.Features(1).Desc='P1';

% TestCaseModel.Features(2)=TestCaseModel.Features(1);
% TestCaseModel.Features(2).Matl='Al';
% TestCaseModel.Features(2).x=[.5 1];
% TestCaseModel.Features(2).y=TestCaseModel.Features(2).x;
% TestCaseModel.Features(2).z=[1 2];

TestCaseModel.Features(end+1)=TestCaseModel.Features(end);
TestCaseModel.Features(end).Matl='Cu';
TestCaseModel.Features(end).x=[0 1];
TestCaseModel.Features(end).y=TestCaseModel.Features(end-1).x;
TestCaseModel.Features(end).z=[0 0];
TestCaseModel.Features(end).dz=1;

TestCaseModel.Params.Tinit=0;
TestCaseModel.Params.DeltaT=0.1;
TestCaseModel.Params.Tsteps=10;

TestCaseModel.ExternalConditions.h_Xminus=0;
TestCaseModel.ExternalConditions.h_Xplus=0;
TestCaseModel.ExternalConditions.h_Yminus=0;
TestCaseModel.ExternalConditions.h_Yplus=0;
TestCaseModel.ExternalConditions.h_Zminus=0;
TestCaseModel.ExternalConditions.h_Zplus=0;

TestCaseModel.ExternalConditions.Ta_Xminus=0;
TestCaseModel.ExternalConditions.Ta_Xplus=0;
TestCaseModel.ExternalConditions.Ta_Yminus=0;
TestCaseModel.ExternalConditions.Ta_Yplus=0;
TestCaseModel.ExternalConditions.Ta_Zminus=0;
TestCaseModel.ExternalConditions.Ta_Zplus=0;

TestCaseModel.ExternalConditions.Tproc=0;

TestCaseModel.PottingMaterial=0;

TestCaseModel.MatLib=MatLib;

%TestCaseModel.Version='V2.1';

MI=FormModel(TestCaseModel);
Visualize('xx',MI,'ModelGeometry')
MI