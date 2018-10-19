%This M files executes the set of validation test cases for ParaPower

%Ti=0;
imax=7;
jmax=7;
kmax=2;

max_temp=zeros(imax,jmax,kmax);
thermal_run_time=max_temp;
query_temp=max_temp;

for i=1:imax
   for j=1:jmax 
    for k=1:kmax
%********************************************************
%**           Test Case #3, Convergence Study          **
%********************************************************
I=[3:2:imax*2+1];

    clear Features ExternalConditions Params PottingMaterial

    NumDiv=I(i);  %Number of divisions/feature in X/Y
    NumLayer=j; %Number of layers/feature

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
    ExternalConditions.Ta_Bottom=0;

    ExternalConditions.Tproc = 280; %Processing temperature

    %Parameters that govern global analysis
    Params.Tinit=0; %Initial temp of all nodes
    end_time=10;
    Params.Tsteps=1; %2^8; %Number of time steps
    Params.DeltaT=end_time/Params.Tsteps; %Time Step Size

    %Layer 1 is at bottom

    %Material for all elements not otherwise defined
    PottingMaterial=0;  %If 0, then non-feature area is empty, otherwise should be a mat'l defined in matlist
    
    tweak=1;

    %Base Feature
    Features(1).x  =  [0 1]*0.03;  % X Coordinates of edges of elements
    Features(end).y=  [0 1]*0.03;  % y Coordinates of edges of elements
    Features(end).z=  [0 1]*0.001*tweak; % Height in z directions
    Features(end).dx=I(i)*3;
    Features(end).dy=I(j)*3;
    Features(end).dz=NumLayer*2;
    Features(end).Matl='Cu';
    Features(end).Q=0;
    
    %Underside zero layer for surface temp
    Features(end+1).x  =  [0 1]*0.03;  % X Coordinates of edges of elements
    Features(end).y=  [0 1]*0.03;  % y Coordinates of edges of elements
    Features(end).z=  [0 0]; % Height in z directions
    Features(end).dx=I(i)*3;
    Features(end).dy=I(j)*3;
    Features(end).dz=1;
    Features(end).Matl='Cu';
    Features(end).Q=0;

    %Zero height Features to add meshing
    Features(end+1).x=[0 1]*0.01;  % X Coordinates of edges of elements
    Features(end).y  =[0 1]*0.01;  % y Coordinates of edges of elements
    Features(end).z  =[1 1]*0.001*tweak; % Height in z directions
    Features(end).dx=I(i);
    Features(end).dy=I(j);
    Features(end).dz=1;
    Features(end).Matl='EN';
    Features(end).Q=0;

    %Zero height Features to add meshing
    Features(end+1).x=0.02  + [0 1]*0.01;  % X Coordinates of edges of elements
    Features(end).y  =0.02  + [0 1]*0.01;  % y Coordinates of edges of elements
    Features(end).z  =[1 1]*0.001*tweak; % Height in z directions
    Features(end).dx=I(i);
    Features(end).dy=I(j);
    Features(end).dz =1;
    Features(end).Matl='EN';
    Features(end).Q(:,1)=[.001 .002];
    Features(end).Q(:,2)=[100 200];
    Features(end).Q=0;
    
    %Zero height Features to add meshing
    Features(end+1).x=0.01  + [0 1]*0.01;  % X Coordinates of edges of elements
    Features(end).y  =0.01  + [0 1]*0.01;  % y Coordinates of edges of elements
    Features(end).z  =[1 1]*0.001*tweak; % Height in z directions
    Features(end).dx=I(i);
    Features(end).dy=I(j);
    Features(end).dz =1;
    Features(end).Matl='EN';
    Features(end).Q(:,1)=[.001 .002];
    Features(end).Q(:,2)=[100 200];
    Features(end).Q=0;
    
    
    %Main Features
    Features(end+1).x=0.01  + [0 1]*0.01;  % X Coordinates of edges of elements
    Features(end).y=0.01  + [0 1]*0.01;  % y Coordinates of edges of elements
    Features(end).z=0.001*tweak + [0 1]*0.0005*tweak; % Height in z directions
    Features(end).dx=I(i);
    Features(end).dy=I(j);
    Features(end).dz=NumLayer;
    Features(end).Matl='SiC';
    Features(end).Q=0;

    %Zero height Main Feature heat source
    Features(end+1).x=0.01  + [0 1]*0.01;  % X Coordinates of edges of elements
    Features(end).y=0.01  + [0 1]*0.01;  % y Coordinates of edges of elements
    Features(end).z=0.001*tweak + [1 1]*0.0005*tweak; % Height in z directions
    Features(end).dx=I(i);
    Features(end).dy=I(j);
    Features(end).dz=1;
    Features(end).Matl='Al';
    feat_area = (Features(end).y(end)-Features(end).y(1))*(Features(end).x(end)-Features(end).x(1));
    %assumes uniform areas!! otherwise you will get the right total, but
    %flux will be concentrated in smaller areas
    Features(end).Q=200e4*feat_area;  %200 W/cm2 * area in [m]   %Q(:,1)=time, Q(:,2)=value of q
    
    TestCaseModel.ExternalConditions=ExternalConditions;
    TestCaseModel.Features=Features;
    TestCaseModel.Params=Params;
    TestCaseModel.PottingMaterial=PottingMaterial;

    MI=FormModel(TestCaseModel);
    %Visualize ('Model Input', MI, 'modelgeom','ShowQ')
    pause(.001)
    fprintf('Analysis executing...')


    GlobalTime=[0:MI.Tsteps-1]*MI.DeltaT;  %Since there is global time vector, construct one here.
    ext_time=tic;
    [Tprnt, Stress, MeltFrac]=ParaPowerThermal(MI.NL,MI.NR,MI.NC, ...
                                           MI.h,MI.Ta, ...
                                           MI.X,MI.Y,MI.Z, ...
                                           MI.Tproc, ...
                                           MI.Model,MI.Q, ...
                                           MI.DeltaT,MI.Tsteps,MI.Tinit,MI.matprops);
    thermal_run_time(i,j,k)=toc(ext_time);
    fprintf('Complete.\n')
    %Ti=Ti+1;
    %Model{Ti}={TestCaseModel};
    %Results{Ti}=Tprnt; 
    max_temp(i,j,k)=max(Tprnt(:));
    query_temp(i,j,k)=Tprnt(i+1,j+1,1);
    
    %sum(MI.X(1:i+1))-MI.X(i+1)/2
%pause                    
     end
    end
end

collated=cat(4,max_temp, query_temp, thermal_run_time)

%[temps1,temps2]=Results{1,1:2};





