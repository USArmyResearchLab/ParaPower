function [NL,Tproc,basegeo,h,Ta,tabstatus,layoutfeatdata,layoutgeodata,layerdata,T_init,boundarydata,parameterdata,groupdata] = Profiles(profilename)

% [NL,Tproc,basegeo,h,Ta,layout1featdata,layout1geodata,layout2featdata,layout2geodata,...
%     layerdata,NLayouts,T_init] = Profiles(profilename)
%Thermal Profiles store profile based information to publish tables and
%figures of the Thermal GUI. Additional profiles can be added manually with
%elseif statmetn following the last profile definintion. The assocaited
%name of any new profile must also be added to the "popdetails.m" function
%to allow it to be selected from the gui pop-up menu.    

if strcmp(profilename,'Standard Package')==1                        %compares the selection made within gui to an associated profile
%     NL=6;                                                                   %number of layers
%     Tproc=280;                                                              %processing temperature
%     basegeo=[0 0];
%     h=[10 10 10 10 1000 10];                                                %convenction coefficeint definded by face, L,R,FRNT,BK,TP,BTM
%     Ta=[20 20 20 20 20 20];                                                 %Ambient temperature defined by face
%     layout1featdata=[4];
% %     layout1geodata=[0 0 0.008 0.008 64; 0 0.018 0.008 0.008 64; 0.018 0.018 0.008 0.008 64;0.018 0 0.008 0.008 64];   
%     layout1geodata={'SiC' 0 0 0.008 0.008 64;'SiC' 0 0.018 0.008 0.008 64;'SiC' 0.018 0.018 0.008 0.008 64;'SiC' 0.018 0 0.008 0.008 64};  %device center locations. 
%     layout2featdata=[3];
%     layout2geodata={'Cu' 0 0 0.012 0.012 0 ;'Cu' 0 0.018 0.012 0.012 0 ;'Cu' 0.018 0.009 0.012 0.03 0};
%     layerdata={'Al' 0.01 'Base P.C.' 0;'Cu' 0.0003 'Base P.C.' 0;'AlN' 0.00064 'Base P.C.' 0;'EN' 0.0003 'Layout 2' 2;'EN' 0.0005 'Layout 1' 1;'EN' 0.0058 'Base P.C.' 0};            %layer thickness definition
%     NLayouts=2;  
    NL=6;                                                                   %number of layers
    Tproc=280;                                                              %processing temperature
    T_init=20;
    basegeo=[0 0];
    h=[10 10 10 10 1000 10];                                                %convenction coefficeint definded by face, L,R,FRNT,BK,TP,BTM
    Ta=[20 20 20 20 20 20];                                                 %Ambient temperature defined by face
     tabstatus=[1 1 0 0 0 0 0 0 0 0 0];%Ambient temperature defined by face
    layoutfeatdata=[1 4 0;2 2 1]; 
%     layout1geodata=[0 0 0.008 0.008 64; 0 0.018 0.008 0.008 64; 0.018 0.018 0.008 0.008 64;0.018 0 0.008 0.008 64];   
    layoutgeodata={'SiC' 0 0 0.008 0.008 64;'SiC' 0 0.018 0.008 0.008 64;'SiC' 0.018 0.018 0.008 0.008 64;'SiC' 0.018 0 0.008 0.008 64;...
        'Cu' 0 0 0.012 0.012 0 ;'Cu' 0 0.018 0.012 0.012 0 ;'Cu' 0.018 0.009 0.012 0.03 0};  %device center locations. 
%     layout2featdata=[3];
%     layout2geodata={'Cu' 0 0 0.012 0.012 0 ;'Cu' 0 0.018 0.012 0.012 0 ;'Cu' 0.018 0.009 0.012 0.03 0};
    layerdata={'Al' 0.01 'Base P.C.' 0;'Cu' 0.0003 'Base P.C.' 0;'AlN' 0.00064 'Base P.C.' 0;'EN' 0.0003 'Layout 2' 2;'EN' 0.0005 'Layout 1' 1;'EN' 0.0058 'Base P.C.' 0};            %layer thickness definition
%     NLayouts=2;  
    parameterdata=cell(1,6);
    boundarydata=cell(1,6);
    groupdata=cell(1,6);
elseif strcmp(profilename,'Standard Package Parametric')==1                        %compares the selection made within gui to an associated profile
    NL=6;                                                                   %number of layers
    Tproc=280;                                                              %processing temperature
    T_init=20;
    basegeo=[0 0];
    h=[10 10 10 10 1000 10];                                                %convenction coefficeint definded by face, L,R,FRNT,BK,TP,BTM
    Ta=[20 20 20 20 20 20];                                                 %Ambient temperature defined by face
     tabstatus=[1 1 0 0 0 0 0 0 0 0 0];%Ambient temperature defined by face
    layoutfeatdata=[1 4 0;2 2 1]; 
    layoutgeodata={'SiC' 0 0 0.008 0.008 64;'SiC' 0 0.018 0.008 0.008 64;'SiC' 0.018 0.018 0.008 0.008 64;'SiC' 0.018 0 0.008 0.008 64;...
        'Cu' 0 0 0.012 0.012 0 ;'Cu' 0 0.018 0.012 0.012 0 ;'Cu' 0.018 0.009 0.012 0.03 0};  %device center locations. 
    layerdata={'Al' 0.01 'Base P.C.' 0;'Cu' 0.0003 'Base P.C.' 0;'AlN' 0.00064 'Base P.C.' 0;'EN' 0.0003 'Layout 2' 2;'EN' 0.0005 'Layout 1' 1;'EN' 0.0058 'Base P.C.' 0};            %layer thickness definition  
    parameterdata={'Position X' 'N/A' 'N/A' 0 100 25;'Position X' 'N/A' 'N/A' 0 100 25:'Thickness' 'Layer 1' 'N/A' 0.0058 1 0.0068};
    boundarydata=cell(1,6);
    groupdata=cell(1,6);
elseif strcmp(profilename,'Simple Transient')==1                        %compares the selection made within gui to an associated profile
    NL=2;                                                                   %number of layers
    Tproc=217;                                                              %processing temperature
    T_init=20;
    basegeo=[0 0];
    h=[0 0 0 0 5000 0];                                                %convenction coefficeint definded by face, L,R,FRNT,BK,TP,BTM
    Ta=[20 20 20 20 20 20]; 
    tabstatus=[1 0 0 0 0 0 0 0 0 1 0];%Ambient temperature defined by face
    layoutfeatdata=[2, 1, 1];   
    layoutgeodata={'SiC' 0.00075 0.00075 0.0015 0.0015 0;'SiC' 0.00125 0.0005 0.0005 0.001 0.125};  %device center locations.
    layerdata={'Cu' 0.002 'Base P.C.' 0;'SiC' 0.0005 'Layout 1' 1};            %layer thickness definition 
    parameterdata={'Transient' 'N/A' 'N/A' 0 100 25};
    boundarydata={};
    groupdata={};
elseif strcmp(profilename,'Mike2')==1                        %compares the selection made within gui to an associated profile
    NL=6;                                                                   %number of layers
    Tproc=280;                                                              %processing temperatures
    numdev=5;                                                               %number of devices
    numpads=3;                                                              %number of pads
    h=[10 10 10 10 1000 10];                                                %convenction coefficeint definded by face, L,R,FRNT,BK,TP,BTM
    Ta=[20 20 20 20 20 20];                                                 %Ambient temperature defined by face
    devdata=[0 0 0.008 0.008 64; 0 0.018 0.008 0.008 64; 0.03 0.018 0.008 0.008 64; ...
    0.03 0 0.008 0.008 64;0.03 0.009 0.008 0.008 10];                                         %device center locations. 
    paddata=[0 0 0.012 0.012 ; 0 0.018 0.012 0.012 ; 0.0250 0.009 0.03 0.022];
    matbylayer={'Al';'Cu';'AlN';'Cu';'EN';'SiC';'EN';'EN'};                  %material definition per layer
    layerthick=[.01 .0003 .00064 .0003 .0003 .0005 .0005 .0058];            %layer thickness definition
    multimatlayers=[0; 0; 0; 1; 1; 0];                                      %index to store which layers in stack have multiple materials, i.e. pad layer and device layer
    
    elseif strcmp(profilename,'Mike')==1                        %compares the selection made within gui to an associated profile
    NL=10;                                                                   %number of layers
    Tproc=280;                                                              %processing temperatures
    numdev=5;                                                               %number of devices
    numpads=3;                                                              %number of pads
    h=[10 10 10 10 1000 10];                                                %convenction coefficeint definded by face, L,R,FRNT,BK,TP,BTM
    Ta=[20 20 20 20 20 20];                                                 %Ambient temperature defined by face
    devdata=[0 0 0.008 0.008 64; 0 0.018 0.008 0.008 64; 0.018 0.018 0.008 0.008 64; ...
    0.018 0 0.008 0.008 64;0.009 0.009 0.008 0.008 64];                                         %device center locations. 
    paddata=[0 0 0.012 0.012 ; 0 0.018 0.012 0.012 ; 0.0135 0.009 0.03 0.013];
    matbylayer={'Al';'Cu';'AlN';'Al';'Cu';'Cu';'EN';'SiC';'EN';'EN';'AlN';'Cu'};                  %material definition per layer
    layerthick=[.01 .0003 .00064 0.005 0.005 .0003 .0003 .0005 .0005 .0058 0.003 0.003];            %layer thickness definition
    multimatlayers=[0; 0; 0; 0; 0; 1; 1; 0; 0; 0];    
    
    elseif strcmp(profilename,'4x4 Even')==1                        %compares the selection made within gui to an associated profile
    NL=6;                                                                   %number of layers
    Tproc=280;                                                              %processing temperatures
    numdev=16;                                                               %number of devices
    numpads=16;                                                              %number of pads
    h=[10 10 10 10 1000 10];                                                %convenction coefficeint definded by face, L,R,FRNT,BK,TP,BTM
    Ta=[20 20 20 20 20 20];                                                 %Ambient temperature defined by face
    devdata=[0 0 0.008 0.008 10; 0 0.012 0.008 0.008 10;0 0.024 0.008 0.008 10;0 0.036 0.008 0.008 10;...
        0.012 0 0.008 0.008 10; 0.012 0.012 0.008 0.008 10;0.012 0.024 0.008 0.008 10;0.012 0.036 0.008 0.008 10;...
        0.024 0 0.008 0.008 10; 0.024 0.012 0.008 0.008 10;0.024 0.024 0.008 0.008 10;0.024 0.036 0.008 0.008 10;...
        0.036 0 0.008 0.008 10; 0.036 0.012 0.008 0.008 10;0.036 0.024 0.008 0.008 10;0.036 0.036 0.008 0.008 10]; %device center locations. 
    paddata=[0 0 0.009 0.009; 0 0.012 0.009 0.009 ;0 0.024 0.009 0.009 ;0 0.036 0.009 0.009;...
        0.012 0 0.009 0.009 ; 0.012 0.012 0.009 0.009 ;0.012 0.024 0.009 0.009 ;0.012 0.036 0.009 0.009 ;...
        0.024 0 0.009 0.009 ; 0.024 0.012 0.009 0.009 ;0.024 0.024 0.009 0.009 ;0.024 0.036 0.009 0.009 ;...
        0.036 0 0.009 0.009 ; 0.036 0.012 0.009 0.009 ;0.036 0.024 0.009 0.009 ;0.036 0.036 0.009 0.009];
    matbylayer={'Al';'Cu';'AlN';'Cu';'EN';'SiC';'EN';'EN'};                  %material definition per layer
    layerthick=[.01 .0003 .00064 .0003 .0003 .0005 .0005 .0058];            %layer thickness definition
    multimatlayers=[0; 0; 0; 1; 1; 0];                                      %index to store which layers in stack have multiple materials, i.e. pad layer and device layer
    
        elseif strcmp(profilename,'4x4 Random')==1                        %compares the selection made within gui to an associated profile
    NL=6;                                                                   %number of layers
    Tproc=280;                                                              %processing temperatures
    numdev=16;                                                               %number of devices
    numpads=5;                                                              %number of pads
    h=[10 10 10 10 1000 10];                                                %convenction coefficeint definded by face, L,R,FRNT,BK,TP,BTM
    Ta=[20 20 20 20 20 20];                                                 %Ambient temperature defined by face
    devdata=[-0.0050 -0.006 0.008 0.004 10;-0.004 0.012 0.008 0.005 10;0 0.024 0.005 0.008 10;0 0.036 0.01 0.004 10;...
        0.003 0 0.012 0.01 10; 0.005 0.012 0.008 0.008 10;0.012 0.024 0.004 0.008 10;0.012 0.036 0.005 0.005 10;...
        0.026 -0.01 0.004 0.008 10; 0.028 0.001 0.011 0.008 10;0.024 0.024 0.004 0.003 10;0.044 0.0015 0.018 0.012 10;...
        0.022 .040 0.006 0.01 10; 0.032 0.044 0.008 0.008 10;0.036 0.024 0.005 0.008 10;0.042 0.040 0.012 0.01 10]; %device center locations. 
% paddata=[0.018 0.018 0.07 0.07];
paddata=[0.0018 0.0045 0.03 0.02;0.018 0.024 0.007 0.06;0 0.036 0.014 0.008;0.033 .040 0.02 0.05 ;0.034 0 0.03 0.035];
    matbylayer={'Al';'Cu';'AlN';'Cu';'EN';'SiC';'EN';'EN'};                  %material definition per layer
    layerthick=[.01 .0003 .00064 .0003 .0003 .0005 .0005 .0058];            %layer thickness definition
    multimatlayers=[0; 0; 0; 1; 1; 0];  
else
    errordlg('Invalid selection, please select a profile','Incorrect Selection','modal')
%     NL=0;h=0;Ta=0;Tproc=0;MatList=0;devdata=0;paddata=0;numdev=0;numpads=0;layerthick=0;multimatlayers=0;
end
end

