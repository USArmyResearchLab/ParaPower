%This M files executes the set of validation test cases for ParaPower

%********************************************************
%**           Test Case #1, 1D                         **
%********************************************************
if 1
    clear Features ExternalConditions Params PottingMaterial
    
    ExternalConditions.h_Left=0;
    ExternalConditions.h_Right=0;
    ExternalConditions.h_Front=0;
    ExternalConditions.h_Back=0;
    ExternalConditions.h_Top=1e12;
    ExternalConditions.h_Bottom=0;

    ExternalConditions.Ta_Left=20;
    ExternalConditions.Ta_Right=20;
    ExternalConditions.Ta_Front=20;
    ExternalConditions.Ta_Back=20;
    ExternalConditions.Ta_Top=0;
    ExternalConditions.Ta_Bottom=20;

    ExternalConditions.Tproc=280;

    EndTime          = 30; 
    Params.Tinit     = 20;
    Params.DeltaT    = 2e-2;
    Params.Tsteps    = EndTime/Params.DeltaT;

    PottingMaterial  = 0;
    
    Features(1).x    = [0 .001];
    Features(1).y    = [0 .001];
    Features(1).z    = [0 .01];
    Features(1).dx   = 2;
    Features(1).dy   = 2;
    Features(1).dz   = 10;
    Features(1).Matl = 'Fields Metal';
    Features(1).Q    = 0;

    Features(2)=Features(1);
    Features(2).z    = [0 0];
    Features(2).dz   = 1;
    Features(2).Matl = 'Cu';
    Features(2).Q    = 10/(Features(1).dy*Features(1).dx);

    [GlobalTime, Tprnt, Stress, MeltFrac]=CLI_Input(Features, PottingMaterial, ExternalConditions, Params, true);
end

%********************************************************
%**           Test Case #2, 1D in 3 directions         **
%********************************************************
if 0
    
    clear Features ExternalConditions Params PottingMaterial
    
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

    ExternalConditions.Tproc=280;

    Params.Tinit     = 20;
    Params.DeltaT    = 1e-5;
    Params.Tsteps    = 100;

    PottingMaterial  = 0;
    
    BarLen=.01;
    BarWid=0.001;
    BarDiv=10;
    BarBas=1e-3;
    
    Features(1).x    = [0 BarWid];
    Features(1).y    = [0 BarWid];
    Features(1).z    = [BarBas BarLen];
    Features(1).dx   = 2;
    Features(1).dy   = 2;
    Features(1).dz   = BarDiv;
    Features(1).Matl = 'Cu';
    Features(1).Q    = 0;

    Features(2).x      = [BarBas BarLen];
    Features(end).y    = [0 BarWid];
    Features(end).z    = [0 BarWid];
    Features(end).dx   = BarDiv;
    Features(end).dy   = 2;
    Features(end).dz   = 2;
    Features(end).Matl = 'Cu';
    Features(end).Q    = 0;

    Features(3).x      = [0 BarWid];
    Features(end).y    = [BarBas BarLen];
    Features(end).z    = [0 BarWid];
    Features(end).dx   = 2;
    Features(end).dy   = BarDiv;
    Features(end).dz   = 2;
    Features(end).Matl = 'Cu';
    Features(end).Q    = 0;

    Features(4)=Features(1);
    Features(end).z    = [0 BarBas];
    Features(end).y    = [0 BarBas];
    Features(end).z    = [0 BarBas];
    Features(end).dx   = 1;
    Features(end).dy   = 1;
    Features(end).dz   = 1;
    Features(end).Matl = 'Cu';
    Features(end).Q    = 1000;

    [GlobalTime, Tprnt, Stress, MeltFrac]=CLI_Input(Features, PottingMaterial, ExternalConditions, Params, true);
end

%********************************************************
%**           Test Case #3, Convergence Study          **
%********************************************************
if 0
    clear Features ExternalConditions Params PottingMaterial

    NumDiv=1;  %Number of divisions/feature in X/Y
    NumLayer=1; %Number of layers/feature

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
    Params.DeltaT=1e-3; %Time Step Size
    Params.Tsteps=100; %Number of time steps

    %Layer 1 is at bottom

    %Material for all elements not otherwise defined
    PottingMaterial=0;  %If 0, then non-feature area is empty, otherwise should be a mat'l defined in matlist


    %Base Feature
    Features(1).x  =  [0 1]*0.03;  % X Coordinates of edges of elements
    Features(end).y=  [0 1]*0.03;  % y Coordinates of edges of elements
    Features(end).z=  [0 1]*0.001; % Height in z directions
    Features(end).dx=NumDiv;
    Features(end).dy=NumDiv;
    Features(end).dz=NumLayer;
    Features(end).Matl='Cu';
    Features(end).Q=0;

    %Zero height Features to add meshing
    Features(end+1).x=[0 1]*0.01;  % X Coordinates of edges of elements
    Features(end).y  =[0 1]*0.01;  % y Coordinates of edges of elements
    Features(end).z  =[1 1]*0.001; % Height in z directions
    Features(end).dx=NumDiv;
    Features(end).dy=NumDiv;
    Features(end).dz=NumLayer;
    Features(end).Matl='Cu';
    Features(end).Q=0;

    %Zero height Features to add meshing
    Features(end+1).x=0.02  + [0 1]*0.01;  % X Coordinates of edges of elements
    Features(end).y  =0.02  + [0 1]*0.01;  % y Coordinates of edges of elements
    Features(end).z  =[1 1]*0.001; % Height in z directions
    Features(end).dx =NumDiv;
    Features(end).dy =NumDiv;
    Features(end).dz =NumLayer;
    Features(end).Matl='Cu';
    Features(end).Q(:,1)=[.001 .002];
    Features(end).Q(:,2)=[100 200];

    %Main Features
    Features(end+1).x=0.01  + [0 1]*0.01;  % X Coordinates of edges of elements
    Features(end).y=0.01  + [0 1]*0.01;  % y Coordinates of edges of elements
    Features(end).z=0.001 + [0 1]*0.0005; % Height in z directions
    Features(end).dx=NumDiv;
    Features(end).dy=NumDiv;
    Features(end).dz=NumLayer;
    Features(end).Matl='SiC';
    Features(end).Q=0;

    %Zero height Main Feature heat source
    Features(end+1).x=0.01  + [0 1]*0.01;  % X Coordinates of edges of elements
    Features(end).y=0.01  + [0 1]*0.01;  % y Coordinates of edges of elements
    Features(end).z=0.001 + [1 1]*0.0005; % Height in z directions
    Features(end).dx=NumDiv;
    Features(end).dy=NumDiv;
    Features(end).dz=NumLayer;
    Features(end).Matl='SiC';
    Features(end).Q=500;  %Q(:,1)=time, Q(:,2)=value of q

    CLI_Input(Features, PottingMaterial, ExternalConditions, Params, true);


end

