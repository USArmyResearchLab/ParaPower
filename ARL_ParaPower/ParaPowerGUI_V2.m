function varargout = ParaPowerGUI_V2(varargin)
% PARAPOWERGUI_V2 MATLAB code for ParaPowerGUI_V2.fig
%      PARAPOWERGUI_V2, by itself, creates a new PARAPOWERGUI_V2 or raises the existing
%      singleton*.
%
%      H = PARAPOWERGUI_V2 returns the handle to a new PARAPOWERGUI_V2 or the handle to
%      the existing singleton*.
%
%      PARAPOWERGUI_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAPOWERGUI_V2.M with the given input arguments.
%
%      PARAPOWERGUI_V2('Property','Value',...) creates a new PARAPOWERGUI_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ParaPowerGUI_V2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ParaPowerGUI_V2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ParaPowerGUI_V2

% Last Modified by GUIDE v2.5 09-Nov-2018 12:32:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ParaPowerGUI_V2_OpeningFcn, ...
                   'gui_OutputFcn',  @ParaPowerGUI_V2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ParaPowerGUI_V2 is made visible.
function ParaPowerGUI_V2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ParaPowerGUI_V2 (see VARARGIN)

% Choose default command line output for ParaPowerGUI_V2
handles.output = hObject;
handles.InitComplete=0;



clear Features ExternalConditions Params PottingMaterial Descr
Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;


% Update handles structure
guidata(hObject, handles);

TimeStep_Callback(hObject, eventdata, handles)
TableHandle=handles.features;
Ci=7; %Column number of material list
UpdateMatList(TableHandle, Ci, 'Do Not Open Mat Dialog Box')
% UIWAIT makes ParaPowerGUI_V2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ParaPowerGUI_V2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in visualize.
function visualize_Callback(hObject, eventdata, handles)
% hObject    handle to visualize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MI=getappdata(handles.figure1,'MI')

figure(2)

cla;Visualize ('Model Input', MI, 'modelgeom','ShowQ')

% --- Executes on button press in AddFeature.
function AddFeature_Callback(hObject, eventdata, handles)
% hObject    handle to AddFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.features,'Data');
data(end+1,:)=0;
set(handles.features,'Data',data)




% --- Executes on button press in addfeature.
function addfeature_Callback(hObject, eventdata, handles)
% hObject    handle to addfeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    x = get(handles.features,'Data');
    x(end+1,:)=mat2cell(0,1,1);
    set(handles.features,'Data',x)



% --- Executes during object creation, after setting all properties.
function Tinit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tinit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Tprocess_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function NumTimeSteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTimeSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [fname,pathname] = uiputfile ('*.mat');
    if fname ~= 0 
        TestCaseModel = getappdata(handles.figure1,'TestCaseModel')
        save([pathname fname], '-struct' , 'TestCaseModel')
    end



% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [filename,pathname] = uigetfile('*.mat');
    if filename~=0
        TestCaseModel = uiimport([pathname filename]);


        ExternalConditions=TestCaseModel.ExternalConditions;
        Features=TestCaseModel.Features;
        Params=TestCaseModel.Params;
        PottingMaterial=TestCaseModel.PottingMaterial;

        %%% Set the External Conditions into the table 
        tabledata = get(handles.ExtCondTable,'data');

       tabledata(1,1) =  mat2cell(ExternalConditions.h_Left,1,1);
       tabledata(1,2) =  mat2cell(ExternalConditions.h_Right,1,1);
       tabledata(1,3) =  mat2cell(ExternalConditions.h_Front,1,1);
       tabledata(1,4) =  mat2cell(ExternalConditions.h_Back,1,1);
       tabledata(1,5) =  mat2cell(ExternalConditions.h_Top,1,1);
       tabledata(1,6) =  mat2cell(ExternalConditions.h_Bottom,1,1);

       tabledata(2,1) =  mat2cell(ExternalConditions.Ta_Left,1,1);
       tabledata(2,2) =  mat2cell(ExternalConditions.Ta_Right,1,1);
       tabledata(2,3) =  mat2cell(ExternalConditions.Ta_Front,1,1);
       tabledata(2,4) =  mat2cell(ExternalConditions.Ta_Back,1,1);
       tabledata(2,5) =  mat2cell(ExternalConditions.Ta_Top,1,1);
       tabledata(2,6) =  mat2cell(ExternalConditions.Ta_Bottom,1,1);

       set(handles.ExtCondTable,'Data',tabledata)


       %%%%Set the Features into the table
       tabledata = get(handles.features,'data');
       [m n] = size(Features); 

       for count = 1: n 

           tabledata(count,1) = mat2cell(Features(count).x(1),1,1);
           tabledata(count,2) = mat2cell(Features(count).y(1),1,1);
           tabledata(count,3) = mat2cell(Features(count).z(1),1,1);
           tabledata(count,4) = mat2cell(Features(count).x(2),1,1);
           tabledata(count,5) = mat2cell(Features(count).y(2),1,1);
           tabledata(count,6) = mat2cell(Features(count).z(2),1,1);
           tabledata(count,7) = cellstr(Features(count).Matl);
           tabledata(count,8) = mat2cell(Features(count).Q,1,1);
           tabledata(count,11) = mat2cell(Features(count).dx,1,1);
           tabledata(count,12) = mat2cell(Features(count).dz,1,1);
       end 

       set(handles.features,'Data',tabledata)

       %%%Set Parameters
       set(handles.Tinit,'String', Params.Tinit)
       set(handles.TimeStep,'String',Params.DeltaT)
       set(handles.NumTimeSteps,'String',Params.Tsteps)
       set(handles.Tprocess,'String',ExternalConditions.Tproc)
    end
   


    

% --- Executes on button press in RunAnalysis.
function RunAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to RunAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        if handles.InitComplete == 0 
            Initialize_Callback(hObject, eventdata, handles)
        end
        numplots = 1;
        MI = getappdata(handles.figure1,'MI');
        %MI=FormModel(TestCaseModel);
        %figure(numplots)
        %Visualize ('Model Input', MI, 'modelgeom','ShowQ')

        pause(.001)
        fprintf('Analysis executing...')
        
        TimeStepOutput = get(handles.slider1,'Value');

        GlobalTime=[0:MI.Tsteps-1]*MI.DeltaT;  %Since there is global time vector, construct one here.
        [Tprnt, Stress, MeltFrac]=ParaPowerThermal(MI.NL,MI.NR,MI.NC, ...
                                               MI.h,MI.Ta, ...
                                               MI.X,MI.Y,MI.Z, ...
                                               MI.Tproc, ...
                                               MI.Model,MI.Q, ...
                                               MI.DeltaT,MI.Tsteps,MI.Tinit,MI.matprops);
                                       
       fprintf('Complete.\n')
       

       
       StateN=round(length(GlobalTime)*TimeStepOutput,0);
       
       %%%%Plot time dependent plots for temp, stress and melt fraction 
        Dout(:,1)=GlobalTime;
        Dout(:,2)=zeros(size(GlobalTime));
        Dout(:,3)=zeros(size(GlobalTime));
        Dout(:,4)=zeros(size(GlobalTime));
        
    
       
       for I=1:length(GlobalTime)
            Dout(I,2)=max(max(max(Tprnt(:,:,:,I))));
            %Dout(I,3)=max(max(max(Stress(:,:,:,I))));
            Dout(I,4)=max(max(max(MeltFrac(:,:,:,I))));
       end
       
       numplots=numplots+1;
       figure(numplots)
       plot (Dout(:,1), Dout(:,2))
       
       Tprnt = setappdata(handles.figure1, 'Tprint', Tprint);
       Stress = setappdata( handles.figure1, 'Stress', Stress);
       MeltFrac = setappdata (handles.figure1, 'MeltFrac', MeltFrac);
       
% <<<<<<< HEAD
%        
%        
% =======
%        if get(handles.VisualTemp,'Value')==1
%            numplots = numplots+1;
%            figure(numplots)
%            pause(.001)
%            
%            T=Tprnt(:,:,:,end);
%            T(MI.Model==0)=max(T(:));
%            
%            cla;Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Tprnt(1,1,1,:))),MI ...
%            ,'state', T, 'RemoveMaterial',[0] ...
%            ,'scaletitle', 'Temperature' ...
%            )                      
%        end
%        
%        if get(handles.VisualStress,'Value')==1
%            numplots =numplots+1;
%            figure(numplots)
%            pause(.001)
%            %StateN=length(GlobalTime)*TimeStepOutput;
%            cla;Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Stress(1,1,1,:))),MI ...
%            ,'state', Stress(:,:,:,StateN) ...
%            ,'scaletitle', 'Stress' ...
%            )                      
%        end
%        
%        if get(handles.VisualMelt,'Value')==1
%            figure(numplots+1)
%            pause(.001)
%            %StateN=length(GlobalTime)*TimeStepOutput;
%            cla;Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(MeltFrac(1,1,1,:))),MI ...
%            ,'state', MeltFrac(:,:,:,StateN) ...
%            ,'scaletitle', 'Melt Fraction' ...
%            )                      
%        end
%            
%                                            
%        %figure(3);clf;           
%        %figure(3);clf; pause(.001)
%        %Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Tprnt(1,1,1,:))),[0 0 0 ],{MI.X MI.Y MI.Z}, MI.Model, MeltFrac(:,:,:,StateN),'Melt Fraction')                                
%        %disp('Press key to continue.');pause
% >>>>>>> 1f37ff200b7b777b5956ddab572d388f6914c790



% --- Executes on button press in VisualStress.
function VisualStress_Callback(hObject, eventdata, handles)
% hObject    handle to VisualStress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VisualStress




% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

TimeStepOutput = get(handles.slider1,'Value'); %value between 0 and 1 from the slider

NumStep =str2num(get(handles.NumTimeSteps,'String')); %total number of time steps
StateN=round(NumStep*TimeStepOutput,0); %time step of interest 
TimeStepString = strcat('Time Step Output = ',int2str(StateN)) %create output string
set(handles.TextTimeStep,'String',TimeStepString)   %output string to GUI


TimeStep = str2num(get(handles.TimeStep,'String'));  %individual time step in seconds 
timeofinterest = TimeStep*NumStep*TimeStepOutput
TimeString = strcat('Time of Interest = ',num2str(timeofinterest),' sec')
set(handles.InterestTime,'String',TimeString)


       


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in AddMaterial.
function AddMaterial_Callback(hObject, eventdata, handles)
% hObject    handle to AddMaterial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TableHandle=handles.features;
Ci=7; %Column number of material list
UpdateMatList(TableHandle, Ci)


% --- Executes on button press in Initialize.
function Initialize_Callback(hObject, eventdata, handles)
% hObject    handle to Initialize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clear the main variables that are passed out from it.
clear Features ExternalConditions Params PottingMaterial Descr
Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;

%0 = init has not been complete, 1 = init has been completed
handles.InitComplete = 1; 
guidata(hObject,handles)
x=2

FeaturesMatrix = get(handles.features,'Data')
ExtBoundMatrix = get(handles.ExtCondTable,'Data')

%Setting Structural BCs, using direction below if non-zero
    ExternalConditions.h_Left=ExtBoundMatrix{1,1};    %Heat transfer coefficient from each side to the external environment
    ExternalConditions.h_Right=ExtBoundMatrix{1,2};
    ExternalConditions.h_Front=ExtBoundMatrix{1,3};
    ExternalConditions.h_Back=ExtBoundMatrix{1,4};
    ExternalConditions.h_Top=ExtBoundMatrix{1,5};
    ExternalConditions.h_Bottom=ExtBoundMatrix{1,6};

    ExternalConditions.Ta_Left=ExtBoundMatrix{2,1};   %Ambiant temperature outside the defined the structure
    ExternalConditions.Ta_Right=ExtBoundMatrix{2,2};
    ExternalConditions.Ta_Front=ExtBoundMatrix{2,3};
    ExternalConditions.Ta_Back=ExtBoundMatrix{2,4};
    ExternalConditions.Ta_Top=ExtBoundMatrix{2,5};
    ExternalConditions.Ta_Bottom=ExtBoundMatrix{2,6};

    ExternalConditions.Tproc = str2num(get(handles.Tprocess,'String')); %Processing temperature, used for stress analysis

    %Parameters that govern global analysis
    Params.Tinit=str2num(get(handles.Tinit,'String')); %Initial temp of all nodes
    Params.DeltaT=str2num(get(handles.TimeStep,'String')); %Time Step Size
    Params.Tsteps=str2num(get(handles.NumTimeSteps,'String')); %Number of time steps
    
    PottingMaterial  = 0;  %Material that surrounds features in each layer as defined by text strings in matlibfun. 
                       %If Material is 0, then the space is empty and not filled by any material.


%%%% SET ALL Feature Parameters
%Each feature is defined separately.  There is no limit to the number of
%features that can be defined.  For each layer of the model, unless a
%feature exists, the material is defined as "potting material."  There is
%no checking to ensure that features do not overlap.  The behavior for
%overlapping features is not defined.
 %Layer 1 is at bottom



[rows,cols]=size(FeaturesMatrix)
CheckMatrix=FeaturesMatrix(:,[1:8 11:12]);
for K=1:length(CheckMatrix(:))
    if isempty(CheckMatrix{K})
        msgbox('Features table is not fully defined.','Warning')
        return
    end
end

for count = 1:rows
    
    %.x, .y & .z are the two element vectors that define the corners
    %of each features.  X=[X1 X2], Y=[Y1 Yz], Z=[Z1 Z2] is interpreted
    %that corner of the features are at points (X1, Y1, Z1) and (X2, Y2, Z2).
    %It is possible to define zero thickness features where Z1=Z2 (or X or Y)
     %to ensure a heat source at a certain layer or a certain discretization.
    Features(count).x  =  [FeaturesMatrix{count, 1} FeaturesMatrix{count, 4}]  % X Coordinates of edges of elements
    Features(count).y =   [FeaturesMatrix{count, 2} FeaturesMatrix{count, 5}];  % y Coordinates of edges of elements
    Features(count).z =   [FeaturesMatrix{count, 3} FeaturesMatrix{count, 6}]; % Height in z directions
    
    %These define the number of elements in each features.  While these can be 
    %values from 2 to infinity, only odd values ensure that there is an element
	%at the center of each features
    
    Features(count).dx =  FeaturesMatrix{count, 11}; %Number of divisions/feature in X
    Features(count).dy =  FeaturesMatrix{count, 11}; %Number of divisions/feature in Y
    Features(count).dz =  FeaturesMatrix{count, 12}; %Number of divisions/feature in Z (layers)
    
    
    Features(count).Matl = FeaturesMatrix{count, 7}; %Material text as defined in matlibfun
    Features(count).Q = FeaturesMatrix{count, 8}; %Total heat input at this features in watts.  The heat per element is Q/(# elements)
end

%Assemble the above definitions into a single variablel that will be used
%to run the analysis.  This is the only variable that is used from this M-file.

TestCaseModel.ExternalConditions=ExternalConditions;
TestCaseModel.Features=Features;
TestCaseModel.Params=Params;
TestCaseModel.PottingMaterial=PottingMaterial;

MI=FormModel(TestCaseModel);

%axes(handles.GeometryVisualization);
setappdata(handles.figure1,'TestCaseModel',TestCaseModel)
setappdata(handles.figure1,'MI',MI)

MI=getappdata(handles.figure1,'MI')
figure(2)

Visualize ('Model Input', MI, 'modelgeom','ShowQ')
pause(.001)





% --- Executes during object creation, after setting all properties.
function logoaxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logoaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate logoaxes
axes(hObject);
imshow('ARLlogo.jpg')





% --- Executes during object creation, after setting all properties.
function GeometryVisualization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GeometryVisualization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate GeometryVisualization








function Feature2Del_Callback(hObject, eventdata, handles)
% hObject    handle to Feature2Del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Feature2Del as text
%        str2double(get(hObject,'String')) returns contents of Feature2Del as a double


% --- Executes during object creation, after setting all properties.
function Feature2Del_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Feature2Del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DeleteFeature.
function DeleteFeature_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = get(handles.features, 'Data');
D = get(handles.Feature2Del, 'String');
D = str2num(D);
if isempty(D)
    fprintf('Error: No feature selected, please select feature')
else 
    data(D,:)=[];
    set(handles.features, 'Data', data); 
end






% --- Executes on button press in ClearGUI.
function ClearGUI_Callback(hObject, eventdata, handles)
% hObject    handle to ClearGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clear figure in GUI
axes(handles.GeometryVisualization)
cla reset;

%Clear figures external to GUI 
Figures = findobj( 'Type', 'Figure' , '-not' , 'Tag' , get(ParaPowerGUI_V2, 'Tag' ) );
NFigures = length( Figures );
for nFigures = 1 : NFigures;
  close( Figures( nFigures ) );
end;

%Delete features matrix
data = get(handles.features, 'Data');
[M,N] = size(data);
for count = 1:M
    data(1,:)=[];
end
data(1,:)=mat2cell(0,1,1);
set(handles.features, 'Data', data);

%Set Environmental Parameters to zero 
T = num2cell([0]);
set(handles.ExtCondTable, 'Data', [T T T T T T; T T T T T T]);

%Set Transient/Stress Conditions to 0 or 1
zero = num2str(0);
one = num2str(1);
set(handles.Tinit,'String',zero);
set(handles.TimeStep,'String',zero); 
set(handles.NumTimeSteps,'String',one)
set(handles.Tprocess,'String',zero);









% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in MeshConverg.
function MeshConverg_Callback(hObject, eventdata, handles)
% hObject    handle to MeshConverg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Parametric analysis

% %Delete features matrix
% data = get(handles.features, 'Data');
% [M,N] = size(data);  %M is the number of features you have 
% for count = 1:M
%     dx =  data{N, 11}; %Number of divisions/feature in X
%     dy =  data{N, 11}; %Number of divisions/feature in Y
%     dz =  data(N, 12}; %Number of divisions/feature in Z (layers)
%     
%     
% end

    
    




% --- Executes during object creation, after setting all properties.
function TextTimeStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TextTimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in View.
function View_Callback(hObject, eventdata, handles)
% hObject    handle to View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MI = getappdata(handles.figure1,'MI');

       Tprnt = getappdata(handles.figure1, 'Tprint');
       Stress = getappdata( handles.figure1, 'Stress');
       MeltFrac = getappdata (handles.figure1, 'MeltFrac');

numplots = 3; 

if get(handles.VisualTemp,'Value')==1
           numplots = numplots+1;
           figure(numplots)
           pause(.001)
           
           T=Tprnt(:,:,:,end);
           T(MI.Model==0)=max(T(:));
           
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Tprnt(1,1,1,:))),MI ...
           ,'state', T, 'RemoveMaterial',[0] ...
           ,'scaletitle', 'Temperature' ...
           )                      
       end
       
       if get(handles.VisualStress,'Value')==1
           numplots =numplots+1;
           figure(numplots)
           pause(.001)
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Stress(1,1,1,:))),MI ...
           ,'state', Stress(:,:,:,StateN) ...
           ,'scaletitle', 'Stress' ...
           )                      
       end
       
       if get(handles.VisualMelt,'Value')==1
           figure(numplots+1)
           pause(.001)
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(MeltFrac(1,1,1,:))),MI ...
           ,'state', MeltFrac(:,:,:,StateN) ...
           ,'scaletitle', 'Melt Fraction' ...
           )                      
       end


% --- Executes during object creation, after setting all properties.
function VisualTemp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VisualTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called










function TimeStep_Callback(hObject, eventdata, handles)
% hObject    handle to TimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeStep as text
%        str2double(get(hObject,'String')) returns contents of TimeStep as a double


TimeStepOutput = str2num(get(handles.TimeStep,'String')); 
NumStepOutput = str2num(get(handles.NumTimeSteps,'String')); 
TotalTime = TimeStepOutput*NumStepOutput;

TimeStepString = strcat('Total Time = ',num2str(TotalTime), ' sec') %create output string
set(handles.totaltime,'String',TimeStepString)   %output string to GUI




function NumTimeSteps_Callback(hObject, eventdata, handles)
% hObject    handle to NumTimeSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTimeSteps as text
%        str2double(get(hObject,'String')) returns contents of NumTimeSteps as a double

TimeStep_Callback(hObject, eventdata, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
F=get(handles.features,'userdata');
if not(isempty(F))
    delete(F)
end
delete(hObject);


% --- Executes during object creation, after setting all properties.
function LogoAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LogoAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate LogoAxes

imshow('ARLlogoParaPower.png')