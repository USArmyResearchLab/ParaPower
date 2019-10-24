%********************************************************
%**           Test Case #200, Define Q                **
%********************************************************

    clear Features ExternalConditions Params PottingMaterial
    
    Desc='Defined Q';

    ExternalConditions.h_Xminus=0;
    ExternalConditions.h_Xplus=0;
    ExternalConditions.h_Yminus=0;
    ExternalConditions.h_Yplus=500;
    ExternalConditions.h_Zminus=1e10;
    ExternalConditions.h_Zplus=0;

    ExternalConditions.Ta_Xminus=20;
    ExternalConditions.Ta_Xplus=20;
    ExternalConditions.Ta_Yminus=20;
    ExternalConditions.Ta_Yplus=20;
    ExternalConditions.Ta_Zminus=20;
    ExternalConditions.Ta_Zplus=20;


    ExternalConditions.Tproc = 280; %Processing temperature

    %Parameters that govern global analysis
    Params.Tinit=20; %Initial temp of all nodes
    Params.DeltaT=1e-2; %Time Step Size
    Params.Tsteps=500; %Number of time steps

    %Layer 1 is at bottom

    %Material for all elements not otherwise defined
    PottingMaterial=1;  %If 0, then non-feature area is empty, otherwise should be a mat'l defined in matlist


    %Base Feature
    Features(1).x  =  [0 1]*0.03;  % X Coordinates of edges of elements
    Features(end).y=  [0 1]*0.03;  % y Coordinates of edges of elements
    Features(end).z=  [0 1]*0.03; % Height in z directions
    Features(end).dx=3;
    Features(end).dy=3;
    Features(end).dz=3;
    Features(end).Matl='Cu';
    Features(end).Q=0;
    Features(end).Desc='';

    Features(end+1)=Features(end);
    Features(end).z =Features(end).z(2)*[1 1] + [0 1]*(Features(end).z(2)-Features(end).z(1));
    Features(end).dz=Features(end).dz*2;
    Features(end).Matl='AlN';
    Features(end).Q=0;

    Features(end+1)=Features(end);
    Features(end).z =Features(end).z(2)*[1 1] + [0 1]*(Features(end).z(2)-Features(end).z(1));
    %Features(end).dz=Features(end).dz*2;
    Features(end).Matl='AlN';
    Features(end).Q=1;

    Features(end+1)=Features(end);
    Features(end).x = [0 .5] .* Features(end).x;
    Features(end).z = Features(end).z(2)*[1 1];
    Features(end).Matl='NoMatl';
    %Features(end).Q(:,1)=[.001 .002];
    %Features(end).Q(:,2)=[100 200];
    Features(end).Q=[0 0; 0.1 0; 0.1 1; 0.2 1; 0.2 0; 0.25 0];
    
    Features(end+1)=Features(end);
    Features(end).x = [.5 1] .* Features(end-2).x(2);
    Features(end).z = Features(end).z(2)*[1 1];
    Features(end).dx = 5;
    Features(end).Matl='Al';
    %Features(end).Q(:,1)=[.001 .002];
    %Features(end).Q(:,2)=[100 200];
    Features(end).Q=[0 0; 0.1 0; 0.1 1; 0.2 1; 0.2 0; 0.25 0; -inf -inf];

    load('../DefaultMaterials');
    %MatF=MaterialDatabase('nonmodal');
    %Mats=getappdata(MatF,'Materials');
    %delete(MatF);
    
TestCaseModel.Desc=Desc;
TestCaseModel.TCM=PPTCM;
TestCaseModel.TCM.Features=Features;
TestCaseModel.TCM.Params=Params;
TestCaseModel.TCM.PottingMaterial=PottingMaterial;
TestCaseModel.TCM.ExternalConditions=ExternalConditions;
TestCaseModel.TCM.MatLib=MatLib;
    
MFILE=mfilename('fullpath');

    
