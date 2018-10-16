%********************************************************
%**           Test Case #3, Convergence Study          **
%********************************************************

    clear Features ExternalConditions Params PottingMaterial

    Desc='Pretty Picture';
    
    NumDiv=3;  %Number of divisions/feature in X/Y
    NumLayer=3; %Number of layers/feature

    %Setting Structural BCs, using direction below if non-zero
    ExternalConditions.h_Left=0;
    ExternalConditions.h_Right=0;
    ExternalConditions.h_Front=0;
    ExternalConditions.h_Back=0;
    ExternalConditions.h_Top=0;
    ExternalConditions.h_Bottom=1000;

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
    PottingMaterial='Ga';%'AIR';  %If 0, then non-feature area is empty, otherwise should be a mat'l defined in matlist


    %Base Feature
    Features(1).x  =  [0 40];  % X Coordinates of edges of elements
    Features(end).y=  [0 40];  % y Coordinates of edges of elements
    Features(end).z=  [0 3]; % Height in z directions
    Features(end).dx=2;
    Features(end).dy=2;
    Features(end).dz=NumLayer;
    Features(end).Matl='AlN';
    Features(end).Q=0;

    Features(end+1).x  =  [15 25 ];  % X Coordinates of edges of elements
    Features(end).y=  [15 25 ];  % y Coordinates of edges of elements
    Features(end).z=  [0 0]; % Height in z directions
    Features(end).dx=3;
    Features(end).dy=3;
    Features(end).dz=1;
    Features(end).Matl=PottingMaterial;
    Features(end).Q=0;

    
    Features(end+1).x  =  [0 40];  % X Coordinates of edges of elements
    Features(end).y=  [0 40];  % y Coordinates of edges of elements
    Features(end).z=  [3.5 8.5]; % Height in z directions
    Features(end).dx=1;
    Features(end).dy=1;
    Features(end).dz=5;
    Features(end).Matl=PottingMaterial;
    Features(end).Q=0;
    
    %Chip 1 Feature
    Features(end+1).x=5 + [0 1]*10;  % X Coordinates of edges of elements
    Features(end).y  =5 + [0 1]*10;  % y Coordinates of edges of elements
    Features(end).z  =3  + [0 1]*.5; % Height in z directions
    Features(end).dx=NumDiv;
    Features(end).dy=NumDiv;
    Features(end).dz=NumLayer;
    Features(end).Matl='Chip';
    Features(end).Q=0;
    Features(end+1)=Features(end);
    Features(end).z=[1 1]*max(Features(end-1).z); % Height in z directions
    Features(end).dz=1;
    Features(end).Matl='SiC';
    Features(end).Q=500;  %Q(:,1)=time, Q(:,2)=value of q
    
    %Chip 2 Feature
    Features(end+1).x=25 + [0 1]*10;  % X Coordinates of edges of elements
    Features(end).y  =5 + [0 1]*10;  % y Coordinates of edges of elements
    Features(end).z  =3  + [0 1]*.5; % Height in z directions
    Features(end).dx=NumDiv;
    Features(end).dy=NumDiv;
    Features(end).dz=NumLayer;
    Features(end).Matl='Chip';
    Features(end).Q=0;
    Features(end+1)=Features(end);
    Features(end).z=[1 1]*max(Features(end-1).z); % Height in z directions
    Features(end).dz=1;
    Features(end).Matl='SiC';
    Features(end).Q=1500;  %Q(:,1)=time, Q(:,2)=value of q
    
    %Chip 3 Feature
    Features(end+1).x=25 + [0 1]*10;  % X Coordinates of edges of elements
    Features(end).y  =25 + [0 1]*10;  % y Coordinates of edges of elements
    Features(end).z  =3  + [0 1]*.5; % Height in z directions
    Features(end).dx=NumDiv;
    Features(end).dy=NumDiv;
    Features(end).dz=NumLayer;
    Features(end).Matl='Chip';
    Features(end).Q=0;
    Features(end+1)=Features(end);
    Features(end).z=[1 1]*max(Features(end-1).z); % Height in z directions
    Features(end).dz=1;
    Features(end).Matl='SiC';
    Features(end).Q=500;  %Q(:,1)=time, Q(:,2)=value of q

    %Chip 4 Feature
    Features(end+1).x=5 + [0 1]*10;  % X Coordinates of edges of elements
    Features(end).y  =25 + [0 1]*10;  % y Coordinates of edges of elements
    Features(end).z  =3  + [0 1]*.5; % Height in z directions
    Features(end).dx=NumDiv;
    Features(end).dy=NumDiv;
    Features(end).dz=NumLayer;
    Features(end).Matl='Chip';
    Features(end).Q=0;
    Features(end+1)=Features(end);
    Features(end).z=[1 1]*max(Features(end-1).z); % Height in z directions
    Features(end).dz=1;
    Features(end).Matl='SiC';
    Features(end).Q=250;  %Q(:,1)=time, Q(:,2)=value of q
    
    
    %     %Chip 5 Feature
%     Features(end+1).x=40 + [0 1]*20;  % X Coordinates of edges of elements
%     Features(end).y  =140 + [0 1]*20;  % y Coordinates of edges of elements
%     Features(end).z  =3  + [0 1]*.5; % Height in z directions
%     Features(end).dx=NumDiv;
%     Features(end).dy=NumDiv;
%     Features(end).dz=NumLayer;
%     Features(end).Matl='Chip';
%     Features(end).Q=0;
%     Features(end+1)=Features(end);
%     Features(end).z=[1 1]*max(Features(end-1).z); % Height in z directions
%     Features(end).dz=1;
%     Features(end).Matl='SiC';
%     Features(end).Q=500;  %Q(:,1)=time, Q(:,2)=value of q

    %Convert back to meters from millimeters
    for Fi=1:length(Features)
        Features(Fi).x=Features(Fi).x*.001;
        Features(Fi).y=Features(Fi).y*.001;
        Features(Fi).z=Features(Fi).z*.001;
    end

    TestCaseModel.ExternalConditions=ExternalConditions;
    TestCaseModel.Features=Features;
    TestCaseModel.Params=Params;
    TestCaseModel.PottingMaterial=PottingMaterial;
    TestCasemodel.Desc=Desc;
