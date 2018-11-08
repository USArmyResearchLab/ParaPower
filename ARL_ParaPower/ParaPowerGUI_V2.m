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

% Last Modified by GUIDE v2.5 31-Oct-2018 15:06:39

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

% Update handles structure
guidata(hObject, handles);
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


% --- Executes when entered data in editable cell(s) in features.
function features_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to features (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in addfeature.
function addfeature_Callback(hObject, eventdata, handles)
% hObject    handle to addfeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    x = get(handles.features,'Data');
    x(end+1,:)=mat2cell(0,1,1);
    set(handles.features,'Data',x)



function Tinit_Callback(hObject, eventdata, handles)
% hObject    handle to Tinit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tinit as text
%        str2double(get(hObject,'String')) returns contents of Tinit as a double


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



function Tprocess_Callback(hObject, eventdata, handles)
% hObject    handle to Tprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tprocess as text
%        str2double(get(hObject,'String')) returns contents of Tprocess as a double


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



function TimeStep_Callback(hObject, eventdata, handles)
% hObject    handle to TimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeStep as text
%        str2double(get(hObject,'String')) returns contents of TimeStep as a double


% --- Executes during object creation, after setting all properties.
function TimeStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTimeSteps_Callback(hObject, eventdata, handles)
% hObject    handle to NumTimeSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTimeSteps as text
%        str2double(get(hObject,'String')) returns contents of NumTimeSteps as a double


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
    TestCaseModel = getappdata(handles.figure1,'TestCaseModel')
    save([pathname fname], '-struct' , 'TestCaseModel')



% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [filename,pathname] = uigetfile('*.mat');
    TestCaseModel = uiimport([pathname filename]);


    ExternalConditions=TestCaseModel.ExternalConditions;
    Features=TestCaseModel.Features;
    Params=TestCaseModel.Params;
    PottingMaterial=TestCaseModel.PottingMaterial;
    
    %%% Set the External Conditions into the table 
    tabledata = get(handles.ExtCondTable,'data');

   tabledata(1,1) = mat2cell(ExternalConditions.h_Left,1,1);
   tabledata(1,2) = mat2cell(ExternalConditions.h_Right,1,1);
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
   


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function DeleteFeature_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DeleteFeature as text
%        str2double(get(hObject,'String')) returns contents of DeleteFeature as a double


% --- Executes during object creation, after setting all properties.
function DeleteFeature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DeleteFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%     x = get(handles.features,'Data');
%     choice = get(handles.DeleteFeature,'String');
%     choice = str2num(choice);
%     x([choice],:) = [];
%     set(handles.features,'Data',x)
    
    
    
    
    

%{
% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
axes(hObject);
imshow('ARLlogo.jpg');


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
axes(hObject);
imshow('RDECOMlogo.jpg');
%}


% --- Executes on button press in RunAnalysis.
function RunAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to RunAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

numplots = 1;
    TestCaseModel = getappdata(handles.figure1,'TestCaseModel')
    MI=FormModel(TestCaseModel);
    figure(numplots)
    cla;Visualize ('Model Input', MI, 'modelgeom','ShowQ')

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
       
       %TimeVsMax=CreateTime(GlobalTime, Tprnt, Stress, MeltFrac)                                 
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
       
       
       if get(handles.VisualTemp,'Value')==1
           numplots = numplots+1;
           figure(numplots)
           pause(.001)
           
           T=Tprnt(:,:,:,end);
           T(MI.Model==0)=max(T(:));
           
           cla;Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Tprnt(1,1,1,:))),MI ...
           ,'state', T, 'RemoveMaterial',[0] ...
           ,'scaletitle', 'Temperature' ...
           )                      
       end
       
       if get(handles.VisualStress,'Value')==1
           numplots =numplots+1;
           figure(numplots)
           pause(.001)
           %StateN=length(GlobalTime)*TimeStepOutput;
           cla;Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Stress(1,1,1,:))),MI ...
           ,'state', Stress(:,:,:,StateN) ...
           ,'scaletitle', 'Stress' ...
           )                      
       end
       
       if get(handles.VisualMelt,'Value')==1
           figure(numplots+1)
           pause(.001)
           %StateN=length(GlobalTime)*TimeStepOutput;
           cla;Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(MeltFrac(1,1,1,:))),MI ...
           ,'state', MeltFrac(:,:,:,StateN) ...
           ,'scaletitle', 'Melt Fraction' ...
           )                      
       end
           
                                           
       %figure(3);clf;           
       %figure(3);clf; pause(.001)
       %Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Tprnt(1,1,1,:))),[0 0 0 ],{MI.X MI.Y MI.Z}, MI.Model, MeltFrac(:,:,:,StateN),'Melt Fraction')                                
       %disp('Press key to continue.');pause


% --- Executes on button press in VisualTemp.
function VisualTemp_Callback(hObject, eventdata, handles)
% hObject    handle to VisualTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VisualTemp


% --- Executes on button press in VisualMelt.
function VisualMelt_Callback(hObject, eventdata, handles)
% hObject    handle to VisualMelt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VisualMelt


% --- Executes on button press in VisualStress.
function VisualStress_Callback(hObject, eventdata, handles)
% hObject    handle to VisualStress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VisualStress


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2




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


% --- Executes on button press in AddMaterial.
function AddMaterial_Callback(hObject, eventdata, handles)
% hObject    handle to AddMaterial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%oldstr = get(handles.MaterialsList, 'string')
TableHandle=handles.features;
Ci=7; %Column number of material list
UpdateMatList(TableHandle, Ci)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

TimeStepOutput = get(handles.slider1,'Value');
NumStep =str2num(get(handles.NumTimeSteps,'String'));
StateN=round(NumStep*TimeStepOutput,0);
TimeStepString = strcat('Time Step Output = ',int2str(StateN))
set(handles.TextTimeStep,'String',TimeStepString)


       


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Initialize.
function Initialize_Callback(hObject, eventdata, handles)
% hObject    handle to Initialize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear Features ExternalConditions Params PottingMaterial Descr
Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;

 

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

[rows,cols]=size(FeaturesMatrix)
CheckMatrix=FeaturesMatrix(:,[1:8 11:12]);
for K=1:length(CheckMatrix(:))
    if isempty(CheckMatrix{K})
        msgbox('Features table is not fully defined.','Warning')
        return
    end
end

for count = 1:rows
    Features(count).x  =  [FeaturesMatrix{count, 1} FeaturesMatrix{count, 4}]  % X Coordinates of edges of elements
    Features(count).y =   [FeaturesMatrix{count, 2} FeaturesMatrix{count, 5}];  % y Coordinates of edges of elements
    Features(count).z =   [FeaturesMatrix{count, 3} FeaturesMatrix{count, 6}]; % Height in z directions
    Features(count).dx =  FeaturesMatrix{count, 11};
    Features(count).dy =  FeaturesMatrix{count, 11};
    Features(count).dz =  FeaturesMatrix{count, 12};
    Features(count).Matl = FeaturesMatrix{count, 7};
    Features(count).Q = FeaturesMatrix{count, 8};
end

TestCaseModel.ExternalConditions=ExternalConditions;
TestCaseModel.Features=Features;
TestCaseModel.Params=Params;
TestCaseModel.PottingMaterial=PottingMaterial;

MI=FormModel(TestCaseModel);

setappdata(handles.figure1,'TestCaseModel',TestCaseModel)
setappdata(handles.figure1,'MI',MI)

MI=getappdata(handles.figure1,'MI')
figure(2)
Visualize ('Model Input', MI, 'modelgeom','ShowQ')


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
axes(hObject);
imshow('ARLlogo.jpg')
% Hint: place code in OpeningFcn to populate axes5
