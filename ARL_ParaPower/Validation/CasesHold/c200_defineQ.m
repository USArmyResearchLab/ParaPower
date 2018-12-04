%********************************************************
%**           Test Case #200, Define Q                **
%********************************************************

    clear Features ExternalConditions Params PottingMaterial

    %Setting Structural BCs, using direction below if non-zero
    ExternalConditions.h_Left=0;
    ExternalConditions.h_Right=0;
    ExternalConditions.h_Front=0;
    ExternalConditions.h_Back=0;
    ExternalConditions.h_Top=0;
    ExternalConditions.h_Bottom=0;

    ExternalConditions.Ta_Left=20;
    ExternalConditions.Ta_Right=20;
    ExternalConditions.Ta_Front=20;
    ExternalConditions.Ta_Back=20;
    ExternalConditions.Ta_Top=20;
    ExternalConditions.Ta_Bottom=20;

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

    Features(end+1)=Features(end);
    Features(end).z =Features(end).z(2)*[1 1] + [0 1]*(Features(end).z(2)-Features(end).z(1));
    Features(end).dz=Features(end).dz*2;
    Features(end).Matl='AlN';
    Features(end).Q=0;

    Features(end+1)=Features(end);
    Features(end).z =Features(end).z(2)*[1 1] + [0 1]*(Features(end).z(2)-Features(end).z(1));
    %Features(end).dz=Features(end).dz*2;
    Features(end).Matl='SiC';
    Features(end).Q=0;

    Features(end+1)=Features(end);
    Features(end).x = [0 .5] .* Features(end).x;
    Features(end).z = Features(end).z(2)*[1 1];
    Features(end).Matl='Air';
    %Features(end).Q(:,1)=[.001 .002];
    %Features(end).Q(:,2)=[100 200];
    Features(end).Q=1;
    
    Features(end+1)=Features(end);
    Features(end).x = [.5 1] .* Features(end-2).x(2);
    Features(end).z = Features(end).z(2)*[1 1];
    Features(end).dx = 5;
    Features(end).Matl='Al';
    %Features(end).Q(:,1)=[.001 .002];
    %Features(end).Q(:,2)=[100 200];
    Features(end).Q=1;

    MatF=MaterialDatabase('nonmodal');
    Mats=getappdata(MatF,'Materials');
    delete(MatF);
    
    TestCaseModel.ExternalConditions=ExternalConditions;
    TestCaseModel.Features=Features;
    TestCaseModel.Params=Params;
    TestCaseModel.PottingMaterial=PottingMaterial;
    TestCaseModel.MatLib=Mats;
    TestCaseModel.Version='V2.0';
    
    
    
