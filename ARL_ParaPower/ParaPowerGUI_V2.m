%Wish List
%   Got to figure out how to change cell edit callback to invoke update
%   status.

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

% Last Modified by GUIDE v2.5 14-Feb-2019 10:35:55

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
ErrorStatus()
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

if 0
    %Implement trap to enable double clicking on figure file
    if not(isempty(varargin)) && not(strcmpi(varargin{1}(end-14:end),'CloseRequestFcn'))
        ThisFig=gcf; 
        if ishandle(ThisFig) && isempty(getappdata(ThisFig,'Initialized')) && isempty(varargin{4})
            handles = guihandles(ThisFig);
            guidata(ThisFig, handles);
            InitializeGUI(handles);
        end
    end
end
end

% --- Executes just before ParaPowerGUI_V2 is made visible.
function ParaPowerGUI_V2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ParaPowerGUI_V2 (see VARARGIN)

% Choose default command line output for ParaPowerGUI_V2
handles.output = hObject;


% clear Features ExternalConditions Params PottingMaterial Descr
% Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
% Features.dz=0; Features.dy=0; Features.dz=0;




if not(isappdata(hObject,'Initialized'))
    InitializeGUI(handles);
end



%ClearGUI_Callback(handles.ClearGUI, eventdata, handles, false)

%Setup callbacks to ensure that geometry update notification is displayed
%DispNotice=@(hobject,eventdata) ParaPowerGUI_V2('VisUpdateStatus',guidata(hobject),true);
%set(handles.features,'celleditcallback',DispNotice);
%set(handles.ExtCondTable,'celleditcallback',DispNotice);

end

function InitializeGUI(handles)

    hObject=handles.figure1;

    handles.InitComplete=0;
    % Update handles structure
    guidata(hObject, handles);
    GUIDisable(handles.figure1)

    %Draw Logo
    axes(handles.PPLogo)
    BkgColor=get(handles.figure1,'color');
    Logo=imread('CCDC_RGB_Positive_RLB.lg.png','backgrou',BkgColor);
    image(Logo)
    set(handles.PPLogo,'visi','off')
    Tx=text(0,0,'ParaPower','unit','normal','fontsize',18,'horiz','center');
    E=get(Tx,'extent');
    set(Tx,'posit',[.5 -1*E(4)*0.25])
    set(handles.text9,'background',BkgColor,'enable','on')
    %imshow('ARLlogoParaPower.png')
    text(0,0,['Version ' ARLParaPowerVersion],'vertical','bott')
    setappdata(handles.figure1,'Version',ARLParaPowerVersion)
    set(handles.GeometryVisualization,'visi','off');
    AxPosit=get(handles.PPLogo,'posit');
    set(handles.PPLogo,'posit',AxPosit+[0 .5 0 0 ])
    TimeStep_Callback(handles.TimeStep, [], handles)

    TableHandle=handles.features;
    %Material Database initialization occurs in ClearGUI
%    UpdateMatList('Initialize',TableHandle,FTC('mat'))
    
    AddStatusLine('ClearStatus')
    set(handles.VisualStress,'enable','on');
    disp('stop button functionality is not implemented in this GUI yet.')
    set(handles.pushbutton18,'enable','off')
    ErrorStatus()

    %Set Stress Model Directory
    set(handles.StressModel,'userdata','Stress_Models')

    T=uicontrol(handles.figure1,'style','text','units','normal','posit',[0.01 0 .3 .02],'string','DISTRIBUTION C: See Help for details','horiz','left');
    E=get(T,'extent');
    P=get(T,'posit');
    set(T,'posit',[P(1) P(2) E(3) E(4)]);
    
    %Populate Stress Models.  They exist in the directory and match "Stress_*.m"
    StressDir=get(handles.StressModel,'user');
    StressModels=dir([StressDir '/Stress*.m']);
    for Fi=1:length(StressModels)
        StressModelFunctions{Fi}=StressModels.name;
        StressModelFunctions{Fi}=strrep(StressModelFunctions{Fi},'.m','');
        StressModelFunctions{Fi}=strrep(StressModelFunctions{Fi},'Stress_','');
        AddStatusLine(['Adding stress model ' StressModelFunctions{Fi} '.'])
    end
    ExtCondTable=get(handles.ExtCondTable,'data');
    set(handles.ExtCondTable,'data',ExtCondTable(1:2,:));
    RowName=get(handles.ExtCondTable,'rowname');
    set(handles.ExtCondTable,'rowname',RowName(1:2));
    StressModelFunctions{end+1}='None';
    set(handles.StressModel,'string',StressModelFunctions);
    setappdata(handles.figure1,'Initialized',true);
    ClearGUI_Callback(handles.ClearGUI, [], handles, false)
    ErrorStatus('')
    GUIEnable(handles.figure1)

end

% %LogoAxes_CreateFcn(hObject, eventdata, handles)

% --- Outputs from this function are returned to the command line.
function varargout = ParaPowerGUI_V2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isfield(handles,'output')
    varargout{1} = handles.output;
end
end

%{
% 
% % --- Executes on button press in visualize.
% % function visualize_Callback(hObject, eventdata, handles)
% % % hObject    handle to visualize (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % MI=getappdata(handles.figure1,'MI');
% % 
% % figure(2)
% % 
% % cla;Visualize ('', MI, 'modelgeom','ShowQ','ShowExtent')
% % VisUpdateStatus(false)


%Removed as this seems to have been replaced by below without the capital "A"
% % --- Executes on button press in AddFeature.
% function AddFeature_Callback(hObject, eventdata, handles)
% % hObject    handle to AddFeature (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% data = get(handles.features,'Data');
% data(end+1,:)=0;
% set(handles.features,'Data',data)
%}

% --- Executes on button press in addfeature.
function addfeature_Callback(hObject, eventdata, handles)
% hObject    handle to addfeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    TableData = get(handles.features,'Data');
    QData=getappdata(gcf,TableDataName);
    EmptyRow=EmptyFeatureRow;
    if isempty(TableData)
        TableData=EmptyRow;
    else
        InsertRows=find(cell2mat(TableData(:,FTC('check')))==true);
        if isempty(InsertRows)
            TableData(end+1,:)=EmptyRow;
            QData{length(TableData(:,1))}=[];
        else
            for Irow=reshape(InsertRows(end:-1:1),1,[])
                TableData(Irow+1:end+1,:)=TableData(Irow:end,:);
                TableData(Irow,:)=EmptyFeatureRow;
                QData(Irow+1:end+1)=QData(Irow:end);
            end
        end
    end
    
    set(handles.features,'Data',TableData)
    setappdata(gcf,TableDataName,QData);

    VisUpdateStatus(handles,true);
end

function Out=GetResults()
    Fhandle= ParaPowerGUI_V2;
    if isappdata(Fhandle,'Results')
        Out.R=getappdata(Fhandle,'Results');
        if ~isfield(Out.R,'Tprint')
            Out.R=[];
            disp('No results available from current figure.')
        end
    else
        Out.R=[];
        disp('No results available from current figure.')
    end
    if isappdata(Fhandle,'TestCaseModel')
        Out.M=getappdata(Fhandle,'TestCaseModel');
    else
        Out.M=[];
        disp('No model available from current figure.')
    end
end

function Tinit_Callback(hObject, eventdata, handles)

end
function Tprocess_Callback(hObject, eventdata, handles)

end

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
end

function E=EmptyFeatureRow
    E{1,FTC('NumCols')}=[];
    E{FTC('Check')}=false;
    E{FTC('QVal')}='0';
    E{FTC('QType')}='Scalar';
    E{FTC('Desc')}='';
    E{FTC('DivX')}=1;
    E{FTC('DivY')}=1;
    E{FTC('DivZ')}=1;
    
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
end

% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Initialize_Callback(hObject, eventdata, handles, false)
    TestCaseModel = getappdata(gcf,'TestCaseModel');
    if isappdata(gcf,'Results')
        Results=getappdata(gcf,'Results');
    else
        if isappdata(gcf,'MI')
            Results.Model=getappdata(gcf,'MI');
        else
            Results=[];
        end
    end
    oldpathname=get(handles.loadbutton,'userdata');
    if isnumeric(oldpathname)
        oldpathname='';
    end
    if isempty(TestCaseModel)
        AddStatusLine('Error.',true,'error')
        AddStatusLine('Complete model cannot be saved due to errors. GUI state saved instead.')
        [fname,pathname] = uiputfile ([oldpathname '*.guistate']);
        if fname ~=0
            hgsave(gcf,[pathname fname])
        end
    else
        [fname,pathname] = uiputfile ([oldpathname '*.ppmodel']);
        if fname~= 0
            AddStatusLine(['Saving "' pathname fname '".,,']);
            Source=TestCaseModel.MatLib.Source;
            if Source(end)=='*'
                TestCaseModel.MatLib.Source=[pathname fname];
            end
            save([pathname fname],'TestCaseModel','Results','-mat')  
            AddStatusLine('Done', true);
        end
    end
    if fname ~= 0
        set(handles.loadbutton,'userdata',pathname);
        CurTitle=get(handles.figure1,'name');
        Colon=strfind(CurTitle,':');
        if not(isempty(Colon))
            CurTitle(Colon:end)='';
        end
        CurTitle=[CurTitle ': ' fname];
        set(handles.figure1,'name',CurTitle);
    end
end

% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    oldpathname=get(hObject,'userdata');
    if isnumeric(oldpathname)
        oldpathname='';
    end
    [filename, pathname]= uigetfile({'*.ppmodel' 'Models'; '*.guistate' 'GUI State'; '*.*' 'All Files'},'',oldpathname);
    %[filename,pathname] = uigetfile([oldpathname '*.mat']);
    CurTitle=get(handles.figure1,'name');
    Colon=strfind(CurTitle,':');
    if not(isempty(Colon))
        CurTitle(Colon:end)='';
    end
    CurTitle=[CurTitle ': ' filename];
    if filename~=0
        set(gcf,'name',CurTitle);
        set(hObject,'userdata',pathname);
        try %Load file not knowing if it's a guistate or model. If it's not a GUI state it will kick out an error and be trapped.
            F_Old=gcf;
            OldVersion=getappdata(gcf,'Version');
            Fnew=hgload([pathname filename]);
            NewVersion=getappdata(Fnew,'Version');
            if not(strcmpi(OldVersion,NewVersion))
                figure(F_Old)
                AddStatusLine(['GUISTATE from "' pathname filename '" '])
                AddStatusLine(['is version ' NewVersion '.']);
                AddStatusLine(['Current GUI is version ' OldVersion ' thus file not loaded.' ]);
                delete(Fnew)
            else
                delete(F_Old);
                drawnow
                AddStatusLine(['Loading GUISTATE from "' pathname filename '"...']);
                set(gcf,'name',CurTitle);
            end
            GUIStateLoaded=true;
        catch ME
            load([pathname filename],'-mat');
            GUIStateLoaded=false;
        end
        if GUIStateLoaded
            return
        else
%        if not(strncmpi('etatsiug.',filename(end:-1:1),8)) %If filename is not .guistate, then load model into the GUI
            AddStatusLine(['Loading model "' pathname filename '"...']);
    %        TestCaseModel = uiimport([pathname filename]);
            %Changing from data saved as fields to saved as a structured variable

            %load([pathname filename]);
            if not(exist('TestCaseModel','var'))
                warning(sprintf('"%s" saved in old format.  File will be loaded anyway with no user action necessary. File will be saved in new format by default.',[pathname filename]))
                TestCaseModel.ExternalConditions=ExternalConditions;
                TestCaseModel.Features=Features;
                TestCaseModel.Params=Params;
                TestCaseModel.PottingMaterial=PottingMaterial;
            end
            OldVersion=false;
            if isfield(TestCaseModel,'Version')
               if not(strcmpi(TestCaseModel.Version,'V2.0') )
                   OldVersion=true;
               end
            else
                TestCaseModel.Version='';
                OldVersion=true;
            end

            if OldVersion
                AddStatusLine('Attempting to load data from previous version, profile may be corrupted.','warning')
            end

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


           %%%%Set the features into the table
           %tabledata = get(handles.features,'data');  %No need to load data
           %that won't be used.
           tabledata = {};
           [m n] = size(Features); 
           QData={};

           for count = 1: n 
                %FEATURESTABLE
               tabledata(count,FTC('check'))  = {false};
               if isfield(Features(count),'Desc')
                   tabledata{count,FTC('desc')} = Features(count).Desc;
               else
                   tabledata{count,FTC('desc')} = '';
               end
               tabledata(count,FTC('x1'))  = mat2cell(1000*Features(count).x(1),1,1);
               tabledata(count,FTC('y1'))  = mat2cell(1000*Features(count).y(1),1,1);
               tabledata(count,FTC('z1'))  = mat2cell(1000*Features(count).z(1),1,1);
               tabledata(count,FTC('x2'))  = mat2cell(1000*Features(count).x(2),1,1);
               tabledata(count,FTC('y2'))  = mat2cell(1000*Features(count).y(2),1,1);
               tabledata(count,FTC('z2'))  = mat2cell(1000*Features(count).z(2),1,1);
               tabledata(count,FTC('mat'))  = cellstr(Features(count).Matl);
               if ischar(Features(count).Q)
                    tabledata(count,FTC('qtype'))  = {'Function(t)'};
                    tabledata{count,FTC('qval')} = Features(count).Q;
               elseif isscalar(Features(count).Q)
                    tabledata(count,FTC('qtype'))  = {'Scalar'};
                    tabledata{count,FTC('qval')} = num2str(Features(count).Q);
               elseif isnumeric(Features(count).Q) && length(Features(count).Q(1,:))==2
                    tabledata(count,FTC('qtype'))  = {'Table'};
                    tabledata{count,FTC('qval')} = TableShowDataText;
                    QData{count}=Features(count).Q;
               end
               tabledata(count,FTC('divx')) = mat2cell(Features(count).dx,1,1);
               tabledata(count,FTC('divy')) = mat2cell(Features(count).dy,1,1);
               tabledata(count,FTC('divz')) = mat2cell(Features(count).dz,1,1);
           end 

           set(handles.features,'Data',tabledata)
           if length(QData) < n
               QData{n}=[];
           end
           
           setappdata(gcf,'TestCaseModel',TestCaseModel)
           setappdata(gcf,TableDataName, QData)
           if exist('Results','var')
               setappdata(gcf,'Results',Results)
               if (isfield(Results,'Tprint'))
                    AddStatusLine('Results loaded.');
               end
           end
           
           %Update Materials
           if isfield(TestCaseModel,'MatLib')
               %Is this working properly?  Materials database isn't getting reloaded.
               %UpdateMatList('LoadMatLib',handles.features, FTC('mat'), TestCaseModel.MatLib)
               NewMatLibUpdate(TestCaseModel.MatLib, handles.features)
               MatLib=get(handles.features,'user');
               MatLib.Source=[pathname filename];
               if isfield(MI.MatLib)
                   MI.MatLib=NewMatLibUpdate(MI.MatLib)
               end
           else
               AddStatusLine('Materials database not included in this model.');
               AddStatusLine('It is likely an old model. ');
               AddStatusLine('Current database will be used. ',false,'warning')
               AddStatusLine(' ');
               NewMatLibUpdate([], FeaturesHandle)
           end

           %%%Set Parameters
           set(handles.Tinit,'String', Params.Tinit)
           set(handles.TimeStep,'String',Params.DeltaT)
           set(handles.NumTimeSteps,'String',Params.Tsteps)
           set(handles.Tprocess,'String',ExternalConditions.Tproc)
           AddStatusLine('Done', true);
           slider1_Callback(handles.slider1, eventdata, handles)
           Initialize_Callback(hObject, eventdata, handles, true)
        end
    end
end    

function NewMatLibUpdate(NewMatLib, FeaturesHandle)
    OldMatLib=get(FeaturesHandle,'user');
    if isempty(NewMatLib)
        NewMatLib=OldMatLib;
    end
    MatListCol=FTC('mat');
    ColFormat=get(FeaturesHandle,'columnformat');
    OldMatList=ColFormat{MatListCol};
    if ~strcmpi(class(NewMatLib),'PPMatLib')
        AddStatusLine('Attempting to convert from old materials format.')
        try 
            NewNewMatLib=PPMatLib;
            for I=1:length(NewMatLib.Type)
                eval(['NewMat=PPMat' NewMatLib.Type{I} '(''' NewMatLib.Material{I} ''')'])
                for I=1:length(NewMat.ParamList)
                    P=NewMat.ParamList{I};
                    oP=P;
                    if ~isfield(NewMatLib,P)
                        oP=lower(oP);
                    end
                    NewMat.(P)=NewMatLib.(oP)(I);
                end
                NewNewMatLib.AddMatl(NewMat);
            end
            NewMatLib=NewNewMatLib;
            NewMatLib.Source='Converted from old';
        catch ME
            AddStatusLine('Unknown material library format, using default')
            AddStatusLine(ME.message)
            AddStatusLine(' ')
            NewMatLib=OldMatLib;
        end
    end
    NewMatList=[' ' NewMatLib.MatList()];
    Data=get(FeaturesHandle,'data');
    if not(isempty(Data))
        for I=1:length(Data(:,1))
            MatIndex=find(strcmpi(Data(I,MatListCol),NewMatList));
            if isempty(MatIndex)
                ThisMat='';
            else
                ThisMat=NewMatList{MatIndex};
            end
            Data{I,MatListCol}=ThisMat;
        end
    end
    ColFormat{MatListCol}=NewMatList;
    set(FeaturesHandle,'columnformat',ColFormat);
    set(FeaturesHandle,'data',Data);
    set(FeaturesHandle,'user',NewMatLib);
end
% --- Executes on button press in RunAnalysis.
function RunAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to RunAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        clc
        if handles.InitComplete == 0 %Code modified so that draw does NOT automatically occur on run
            Initialize_Callback(hObject, eventdata, handles, false)
        else
            Initialize_Callback(handles.Initialize, eventdata, handles, false)
        end
        numplots = 1;
        
        GUIDisable(handles.figure1);
        StressModelV=get(handles.StressModel,'value');
        StressModel=get(handles.StressModel,'string');
        StressModel=StressModel{StressModelV};
        
        AddStatusLine('Analysis running...');
        MI = getappdata(handles.figure1,'MI');
        if isempty(MI)
            AddStatusLine('Model not yet fully defined.','error')
            GUIEnable
            return
        end

        drawnow
        AddStatusLine('Thermal ',true)
        
        try
            %not used TimeStepOutput = get(handles.slider1,'Value');
            tic
%            GlobalTime=MI.GlobalTime;  %Since there is global time vector, construct one here.

            InitTime=MI.GlobalTime(1);    %Time at initializatio extracted from MI.GlobalTime
            ComputeTime=MI.GlobalTime(2:end); %extract time to compute states from MI.GlobalTime

            MI.GlobalTime=InitTime;  %Setup initialization
            S1=scPPT('MI',MI); %Initialize object
            
            StepsToEstimate=2;
            tic
            [Tprnt, T_in, MeltFrac,MeltFrac_in]=S1(ComputeTime(1:min(StepsToEstimate,length(ComputeTime))));  %Compute states at times in ComputeTime (S1 must be called with 1 arg in 2017b)
            EstTime=toc;
            if length(ComputeTime)>StepsToEstimate
                AddStatusLine(sprintf(' (est. %.1fs)... ',EstTime*(length(ComputeTime)-StepsToEstimate)/StepsToEstimate), true)
                [Tprnt2, T_in2, MeltFrac2,MeltFrac_in2]=S1(ComputeTime(3:end));  %Compute states at times in ComputeTime (S1 must be called with 1 arg in 2017b)
                Tprnt   =cat(4, T_in        , Tprnt   ,  Tprnt2   );
                MeltFrac=cat(4, MeltFrac_in , MeltFrac,  MeltFrac2);
            else
                Tprnt=cat(4,T_in,Tprnt);
                MeltFrac=cat(4,MeltFrac_in,MeltFrac);
            end

            MI.GlobalTime = [InitTime ComputeTime]; %Reassemble MI's global time to match initialization and computed states.

            Etime=toc;
            AddStatusLine(sprintf('(%3.2fs)...',Etime),true)
        catch ME
            AddStatusLine('Error during thermal solve.')
            AddStatusLine(ME.message,'err')
            AddStatusLine(' ');
            disp(ME.getReport)
            Tprnt=[];
        end
        AddStatusLine(['Stress (' StressModel ')...']);
        try
            if strcmpi(StressModel,'none')
                Stress=[];
            else
                OldPath=path;
                addpath(get(handles.StressModel,'user'));
                tic
                eval(['Stress=Stress_' StressModel '(MI,Tprnt);']);
                Etime=toc;
                AddStatusLine(sprintf('(%3.2fs)...',Etime),true)
                path(OldPath)
            end
            if not(exist('Stress','var'))
                AddStatusLine('Error.','Error')
                AddStatusLine(['Unknown stress model: ' StressModel ]);
                AddStatusLine('');
                Stress=[];
            end
            set(handles.slider1,'value',1);
        catch ME
            AddStatusLine('Error during stress solve.')
            AddStatusLine(ME.message,'err')
            AddStatusLine('');
            disp(ME.getReport)
            Stress=[];
        end
        if ischar(Stress)
            AddStatusLine('Error during stress solve.')
            AddStatusLine(Stress)
            Stress=[];
            AddStatusLine(' ');
        end
        AddStatusLine('Complete.',true)
       
        if exist('ME')
            GUIEnable()
            return
        end
       
       %not used StateN=round(length(GlobalTime)*TimeStepOutput,0);
       
       Results.Tprint=Tprnt;
       Results.Stress=Stress;
       Results.MeltFrac=MeltFrac;
       Results.Model=MI;
       Results.TimeDate=now;
       if get(handles.transient,'value')==1
           %%%%Plot time dependent plots for temp, stress and melt fraction
            MaxPlot_Callback(handles.MaxPlot, eventdata, handles, Results);
           %AddStatusLine('Done.', true);
       end
       setappdata(handles.figure1, 'Results', Results);
       slider1_Callback(handles.slider1, [], handles)
       GUIEnable(handles.figure1);
end
       
% --- Executes on button press in VisualStress.
function VisualStress_Callback(hObject, eventdata, handles)
% hObject    handle to VisualStress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VisualStress
end

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
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

TimeStepOutput = get(handles.slider1,'Value'); %value between 0 and 1 from the slider

Results=getappdata(handles.figure1,'Results');
if not(isfield(Results,'Tprint'))
    TimeStepString = []; %create output string
    set(handles.TextTimeStep,'String',TimeStepString)   %output string to GUI
    TimeString = 'No Model Results';
    set(handles.InterestTime,'String',TimeString)
else
    GlobalTime=Results.Model.GlobalTime;
    
    if isempty(GlobalTime)      %Results represent Static Analysis
        StateN=round(TimeStepOutput)+1;
        TimeStepString = {'Initial Conditions';'Static Solution'}; %create output string
        set(handles.TextTimeStep,'String',TimeStepString{StateN})   %output string to GUI
        TimeString = [];
        set(handles.InterestTime,'String',TimeString)
        setappdata(handles.figure1,'step',StateN);
    else  %Transient analysis results found, use GlobalTime to dictate slider values
        NumStep =length(GlobalTime); %total number of time values found  (will be Steps+1)
        StateN=min([floor(NumStep*TimeStepOutput)+1 NumStep]); %time step of interest, with judo to ensure within index
        TimeStepString = strcat('Time Step Output = ',int2str(StateN-1)); %create output string
        set(handles.TextTimeStep,'String',TimeStepString)   %output string to GUI
        
        TimeStep = GlobalTime(StateN);  %individual time value in seconds
        TimeString = strcat('Time of Interest = ',num2str(TimeStep),' sec');
        set(handles.InterestTime,'String',TimeString)
        setappdata(handles.figure1,'step',StateN);
    end
end
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes on button press in AddMaterial.
function AddMaterial_Callback(hObject, eventdata, handles)
% hObject    handle to AddMaterial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    TableHandle=handles.features;
    MatLib=get(TableHandle,'user');
    MatLib.ShowTable('init');
    uiwait
    %UpdateMatList('EditMats',TableHandle,FTC('mat'))
    NewMatLibUpdate(MatLib, TableHandle)
end

% --- Executes on button press in Initialize.
function Initialize_Callback(hObject, eventdata, handles, DrawModel)
% hObject    handle to Initialize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clear the main variables that are passed out from it.
if not(exist('DrawModel'))
    DrawModel=true;
end
GUIDisable(handles.figure1)
ErrorStatus()
KillInit=0;
AddStatusLine('Initializing...',handles.figure1)
clear Features ExternalConditions Params PottingMaterial Descr

setappdata(gcf,'TestCaseModel',[]);
setappdata(gcf,'MI',[]);

Features.x=[]; Features.y=[]; Features.z=[]; Features.Matl=[]; Features.Q=[]; Features.Matl=''; 
Features.dz=0; Features.dy=0; Features.dz=0;

%0 = init has not been complete, 1 = init has been completed
handles.InitComplete = 1; 
guidata(hObject,handles)

x=2;


FeaturesMatrix = get(handles.features,'Data');
%FeaturesMatrix = FeaturesMatrix(:,2:end);  %Changed to abstracting column numbers
ExtBoundMatrix = get(handles.ExtCondTable,'Data');
for K=1:length(ExtBoundMatrix(:))
    if isempty(ExtBoundMatrix{K})
        AddStatusLine('Error.',true,'error');
        AddStatusLine('Env. parameters must be fully populated','err');
        GUIEnable
        return
    end
end

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
    if get(handles.Static,'value')==1
        Params.Tsteps=[]; %Number of time steps
        FindEps = 0;
    elseif get(handles.transient,'value')==1
        Params.Tsteps=str2num(get(handles.NumTimeSteps,'String')); %Number of time steps
        FindEps = Params.Tsteps * Params.DeltaT;
        if FindEps==0
            AddStatusLine('Error.',true,'error');
            AddStatusLine('End time is 0.  Redefine time step or run as a static analysis.');
            return
        end
        MaxTime=Params.Tsteps * Params.DeltaT;
    end
    PottingMaterial  = 0;  %Material that surrounds features in each layer as defined by text strings in matlibfun. 
                       %If Material is 0, then the space is empty and not filled by any material.


%%%% SET ALL Feature Parameters
%Each feature is defined separately.  There is no limit to the number of
%features that can be defined.  For each layer of the model, unless a
%feature exists, the material is defined as "potting material."  There is
%no checking to ensure that features do not overlap.  The behavior for
%overlapping features is not defined.
 %Layer 1 is at bottom

[rows,cols]=size(FeaturesMatrix);
if rows==0
    AddStatusLine('No features to initialize.','warning')
else
    CheckMatrix=FeaturesMatrix(:,[FTC('x1') FTC('x2') FTC('y1') FTC('y2') FTC('z1') FTC('y2') FTC('mat') FTC('divx') FTC('divy') FTC('divz') ]);  %FEATURESMATRIX
    for K=1:length(CheckMatrix(:))
        if isempty(CheckMatrix{K})
            AddStatusLine('Error.',true,'error');
            if ischar(CheckMatrix{K})
                EmptyPart='Material empty.';
            else
                EmptyPart='X, Y or Z coordinates or divisions Empty.';
            end
            AddStatusLine(['Features table is not fully defined. ' EmptyPart],'err')
            GUIEnable
            return
        end
    end
    QData=getappdata(gcf,TableDataName);
    if isempty(QData)
        QData{length(FeaturesMatrix(:,1))}=[];
    end
    for count = 1:rows

        Features(count).Desc = FeaturesMatrix{count, FTC('desc')};
        
        %.x, .y & .z are the two element vectors that define the corners
        %of each features.  X=[X1 X2], Y=[Y1 Yz], Z=[Z1 Z2] is interpreted
        %that corner of the features are at points (X1, Y1, Z1) and (X2, Y2, Z2).
        %It is possible to define zero thickness features where Z1=Z2 (or X or Y)
        %to ensure a heat source at a certain layer or a certain discretization.
        %FEATURESTABLE
 
        Features(count).x  =  .001*[FeaturesMatrix{count, FTC('x1')} FeaturesMatrix{count, FTC('x2')}];  % X Coordinates of edges of elements
        Features(count).y =   .001*[FeaturesMatrix{count, FTC('y1')} FeaturesMatrix{count, FTC('y2')}];  % y Coordinates of edges of elements
        Features(count).z =   .001*[FeaturesMatrix{count, FTC('z1')} FeaturesMatrix{count, FTC('z2')}]; % Height in z directions

        %These define the number of elements in each features.  While these can be 
        %values from 2 to infinity, only odd values ensure that there is an element
        %at the center of each features

        Features(count).dx =  FeaturesMatrix{count, FTC('divx')}; %Number of divisions/feature in X
        Features(count).dy =  FeaturesMatrix{count, FTC('divy')}; %Number of divisions/feature in Y
        Features(count).dz =  FeaturesMatrix{count, FTC('divz')}; %Number of divisions/feature in Z (layers)


        
        Features(count).Matl = FeaturesMatrix{count, FTC('mat')}; %Material text as defined in matlibfun
        QValue=FeaturesMatrix{count, FTC('qval')};
        Qtype=FeaturesMatrix{count, FTC('qtype')};
        Qtype=lower(Qtype(1:5));
        FindEps=0;
        for I=1:length(QData)
            FindEps=max([FindEps; QData{I}(:)]);
        end
        switch Qtype
            case 'scala'
                if ischar(QValue)
                    QValue=str2double(QValue);
                end
                    
                if QValue==0
                    Features(count).Q = 0;
                else
                    Features(count).Q = QValue;
                end
            case 'table'
                Table=QData{count};
                if isempty(Table)
                    Table=[0 0];
                end
                MakeUnique=eps(FindEps)*2; %Use a value of 3 * epsilon to add to the time steps
                DeltaT=Table(2:end,1)-Table(1:end-1,1);
                if min(DeltaT(DeltaT~=0)) < eps(FindEps)*9
                    AddStatusLine(['Smallest Delta T must be greater than 3*epsilon (machine precision for MaxTime) for feature ' num2str(count)],'warning');
                    KillInit=1;
                else
                    DupTime=(Table(2:end,1)-Table(1:end-1,1)==0)*eps(FindEps)*10;
                    DupTime=[0; DupTime];
                    Table(:,1)=Table(:,1)+DupTime;
                    if min(Table(2:end,1)-Table(1:end-1,1)) <= 0
                        AddStatusLine(['Time must be increasing.  It is not for feature ' num2str(count)],'warning');
                        AddStatusLine('...')
                        KillInit=1;
                    end
                    if max(Table(:,1))<MaxTime
                        Table(end+1,:)=[MaxTime Table(end,2)];
                        AddStatusLine(['Feature ' num2str(count) ' time extended to ' num2str(MaxTime) 's with a flat line from last value.'],'warning')
                        AddStatusLine('...')
                    end
                    if min(Table(:,1))>0
                        Table=[0 0; Table(1,1)-2*eps(MaxTime) 0; Table];
                        AddStatusLine(['Feature ' num2str(count) ' time adjusted to begin at t=0, value of 0'],'warning')
                        AddStatusLine('...')
                    end
                    %Features(count).Q = @(t)interp1(Table(:,1), Table(:,2), t);
                    Features(count).Q = Table;
                end
            case 'funct'
                if isempty(QValue)
                    Features(count).Q=0;
                else
                    try
                        TestQ=@(t)eval(QValue)*(-1);
                        TestQ(0);
                    catch ErrTrap
                        AddStatusLine('Error.', true);
                        AddStatusLine(['For feature ' num2str(count) ' "' QValue '" is not a valid function for Q.'],'error')
                        return
                    end
                    Features(count).Q = QValue;
                end
            otherwise
                AddStatusLine(['Unknown Q type "' FeaturesMatrix{count, FTC('qtype')} '"' ],'error' )
                KillInit=1;
        end
                    
        %Features(count).Q = FeaturesMatrix{count, 8}; %Total heat input at this features in watts.  The heat per element is Q/(# elements)
    end

    %Get Materials Database
    MatLib=get(handles.features,'userdata');
    %MatLib=getappdata(MatHandle,'Materials');
    figure(handles.figure1)
    
    %Assemble the above definitions into a single variablel that will be used
    %to run the analysis.  This is the only variable that is used from this M-file.

    TestCaseModel.ExternalConditions=ExternalConditions;
    TestCaseModel.Features=Features;
    TestCaseModel.Params=Params;
    TestCaseModel.PottingMaterial=PottingMaterial;
    TestCaseModel.MatLib=MatLib;
    TestCaseModel.Version='V2.0';

    if KillInit
        AddStatusLine('Unable to execute model due to errors.','error')
    else
        AddStatusLine('forming...',true)
        try
            MI=FormModel(TestCaseModel);
        catch ME
            disp(ME.getReport)
            AddStatusLine('Error running forming model','Err')
            AddStatusLine(ME.message)
            GUIEnable
            return
        end
        AddStatusLine('storing...',true)

    %    axes(handles.GeometryVisualization);
    %    Visualize ('Model Input', MI, 'modelgeom','ShowQ')

        setappdata(handles.figure1,'TestCaseModel',TestCaseModel);
        setappdata(handles.figure1,'MI',MI);

        MI=getappdata(handles.figure1,'MI');
        axes(handles.GeometryVisualization)
        %figure(2)

        if DrawModel
            AddStatusLine('drawing...',true)
            Visualize ('', MI, 'modelgeom','ShowQ','ShowExtent')
            VisUpdateStatus(handles,false);
            AddStatusLine('Done',true)
            drawnow
        end
    end
end
GUIEnable(handles.figure1)

end

% --- Executes on button press in DeleteFeature.
function DeleteFeature_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = get(handles.features, 'Data');


QData=getappdata(handles.figure1,TableDataName);
if length(QData)<length(data(:,1))
	QData{length(data(:,1))}=[];
end
for I=length(data(:,1)):-1:1
    if data{I,FTC('check')}
        data =[data(1:I-1,:); data(I+1:end,:)];
        QData=[QData(1:I-1)  QData(I+1:end)];
    end
end

if length(data(:,1))==0
    data=EmptyFeatureRow;
end
set(handles.features, 'Data', data);
VisUpdateStatus(handles,true);
end

% --- Executes on button press in ClearGUI.
function ClearGUI_Callback(hObject, eventdata, handles, Confirm)
% hObject    handle to ClearGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if not(exist('Confirm','var'))
    Confirm=true;
end
%Clear figure in GUI
if Confirm
    P=questdlg('Are you sure you want to erase all current model data?','Confirmation','Yes','No','No');
else
    P='Yes';
end

if strcmpi(P,'No')
    AddStatusLine('GUI clear canceled.')
    return
end

if Confirm
    AddStatusLine('CLEARSTATUS');
    AddStatusLine('Clearing GUI...')
end
GUIDisable(handles.figure1)
axes(handles.GeometryVisualization)
cla reset;

%Clear figures external to GUI 
%Figures = findobj( 'Type', 'Figure' , '-not' , 'Tag' , get(ParaPowerGUI_V2, 'Tag' ) );
Figures = findobj( 'Type', 'Figure' );
NFigures = length( Figures );
for nFigures = 1 : NFigures
    if isempty(get(Figures(nFigures),'filename'))
        close( Figures( nFigures ) );
    end
end

Kids=get(handles.uipanel5,'children');
for i=1:length(Kids)
    if strcmpi(get(Kids(i),'type'),'uicontrol') || strcmpi(get(Kids(i),'userdata'),'REMOVE');
        delete(Kids(i))
    end
end


%Set Environmental Parameters to zero 
T = num2cell([0]);
set(handles.ExtCondTable, 'Data', [T T T T T T; T T T T T T]);

%Set Transient/Stress Conditions to 0 or 1
zero = num2str(0);
one = num2str(1);
set(handles.Tinit,'String',zero);
set(handles.TimeStep,'String',num2str(0.1)); 
set(handles.NumTimeSteps,'String',num2str(10));
set(handles.Tprocess,'String',zero);
set(handles.GeometryVisualization,'visi','off')

EmptyRow=EmptyFeatureRow;
set(handles.features, 'Data',EmptyRow); 
if isappdata(handles.figure1,TableDataName)
    rmappdata(handles.figure1,TableDataName)
end

RowNames=get(handles.ExtCondTable,'rowname');
set(handles.ExtCondTable,'rowname',RowNames(1:2,:))
NumCols=length(get(handles.ExtCondTable,'columnwidth'));
TableData{2,NumCols}=[];
set(handles.ExtCondTable,'Data',TableData);

VisUpdateStatus(handles,false)
CurTitle=get(handles.figure1,'name');
Colon=strfind(CurTitle,':');
if not(isempty(Colon))
    CurTitle(Colon:end)='';
end
set(handles.figure1,'name',CurTitle);

handles.InitComplete = 0;
set(handles.transient,'value',1)
AnalysisType_SelectionChangedFcn(handles.transient, eventdata, handles)

%Clear Materials database
% MatHandle=get(handles.features,'userdata');
% delete(MatHandle);
% UpdateMatList('Initialize',handles.features, FTC('mat'))
MatLib=get(handles.features,'userdata');
delete(MatLib);
if exist('DefaultMaterials.mat','file')
    load('DefaultMaterials.mat','MatLib')
    MatLib.Source=which('DefaultMaterials.mat');
end
if ~exist('MatLib','var')
    MatLib=PPMatLib;
    AddStatusLine('No materials library loaded (DefaultMaterials.mat does not exist or MatLib is not defined in it.)')
end
NewMatLibUpdate(MatLib, handles.features);
%set(handles.features,'user',MatLib);

DataToRemove={TableDataName 'TestCaseModel' 'MI' 'Results'};
for I=1:length(DataToRemove)
    if isappdata(handles.figure1,DataToRemove{I})
        rmappdata(handles.figure1,DataToRemove{I});
    end
end
set(handles.StressModel,'value',find(strcmpi(get(handles.StressModel,'string'),'None')))
guidata(hObject, handles);
if Confirm
    AddStatusLine('Done.', true,handles.figure1)
end
GUIEnable(handles.figure1)
end

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

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
end

% --- Executes during object creation, after setting all properties.
function TextTimeStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TextTimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end

% --- Executes on button press in View.
function View_Callback(hObject, eventdata, handles)
% hObject    handle to View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    slider1_Callback(hObject, eventdata, handles)  %call the move slider1 to ensure up-to-date info

TimeString=get(handles.InterestTime,'String'); %this is empty if static analysis results found
TimeStepString=get(handles.InterestTime,'String'); %this is empty if no results

NumPlot = 0; 
NumPlot=NumPlot + get(handles.VisualMelt,'Value');
NumPlot=NumPlot + get(handles.VisualStress,'Value');
NumPlot=NumPlot + get(handles.VisualTemp,'Value');
Objects=findobj(0,'-depth',1,'type','figure');
ResultFigure=find(strcmpi(get(Objects,'name'),'results'));
if isempty(ResultFigure)
    figure
    set(gcf,'unit','normal','posit',[0.05 0.05 0.9 0.85],'name','Results');
else
    figure(Objects(ResultFigure(1)));
end
clf

if isempty(TimeStepString)  %no model results
    MI=getappdata(handles.figure1,'MI');
    if ~isempty('MI')
        AddStatusLine('No Results Exist. Displaying Detailed Geometry','warning')
        numplots=numplots+1;
        figure(numplots)
        Visualize ('', MI, 'modelgeom','ShowQ','ShowExtent')
    else
        AddStatusLine('No Existing Results or Model Info.','warning')
    end
    return
end
    
Results=getappdata(handles.figure1,'Results');
MI = Results.Model;
Tprnt = Results.Tprint;
Stress = Results.Stress;
MeltFrac = Results.MeltFrac;
GlobalTime=MI.GlobalTime;

StateN=getappdata(handles.figure1,'step');

trans_model=~isempty(TimeString);

if ~trans_model
    if StateN==1
        state_str='Initial State';
    elseif StateN==2
        state_str='Static Solution';
    else
        state_str=[];
    end
end
CurPlot=1;
if get(handles.VisualTemp,'Value')==1
    if isempty(Tprnt)
        AddStatusLine('No temperature solution exists.','warning')
    else
       subplot(1,NumPlot,CurPlot)
       CurPlot=CurPlot + 1;
%       figure(numplots)
%       clf;
       if trans_model
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',MI.GlobalTime(StateN)*1000, StateN-1,length(Tprnt(1,1,1,:))-1)...
               ,MI,'state', Tprnt(:,:,:,StateN), 'RemoveMaterial',[0] ...
               ,'scaletitle', 'Temperature', 'BtnLinInt' ...
               )
       else
           Visualize(sprintf(state_str)...
               ,MI,'state',Tprnt(:,:,:,StateN), 'RemoveMaterial',[0] ...
               ,'scaletitle', 'Temperature', 'BtnLinInt' ...
               )
       end
    end
end
if get(handles.VisualStress,'Value')==1
    if isempty(Stress)
        AddStatusLine('No stress solution exists.','warning')
    else
       %numplots =numplots+1;
       subplot(1,NumPlot,CurPlot)
       CurPlot=CurPlot + 1;
%        figure(numplots)
%        clf
       if trans_model
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',MI.GlobalTime(StateN)*1000, StateN-1,length(Stress(1,1,1,:))-1)...
               ,MI,'state', Stress(:,:,:,StateN), 'RemoveMaterial',[0] ...
               ,'scaletitle', 'Stress', 'BtnLinInt' ...
               )
       else
           Visualize(sprintf(state_str)...
               ,MI,'state', Stress(:,:,:,StateN), 'RemoveMaterial',[0] ...
               ,'scaletitle', 'Stress', 'BtnLinInt' ...
               )
       end                   
    end
end

if get(handles.VisualMelt,'Value')==1
    if isempty(MeltFrac)
        AddStatusLine('No melt-fraction solution exists.','warning')
    else
       subplot(1,NumPlot,CurPlot)
       CurPlot=CurPlot + 1;
%        figure(numplots+1)
%        clf
       if trans_model
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',MI.GlobalTime(StateN)*1000, StateN-1,length(MeltFrac(1,1,1,:))-1)...
               ,MI,'state', MeltFrac(:,:,:,StateN), 'RemoveMaterial',[0] ...
               ,'scaletitle', 'Melt Fraction', 'BtnLinInt' ...
               )
       else
           Visualize(sprintf(state_str)...
               ,MI,'state', MeltFrac(:,:,:,StateN), 'RemoveMaterial',[0] ...
               ,'scaletitle', 'Melt Fraction', 'BtnLinInt' ...
               )
       end                           
    end
end
end

% --- Executes during object creation, after setting all properties.
function VisualTemp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VisualTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end

function TimeStep_Callback(hObject, eventdata, handles)
% hObject    handle to TimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeStep as text
%        str2double(get(hObject,'String')) returns contents of TimeStep as a double


TimeStepOutput = str2num(get(handles.TimeStep,'String')); 
NumStepOutput = str2num(get(handles.NumTimeSteps,'String')); 
TotalTime = TimeStepOutput*NumStepOutput;

TimeStepString = strcat('Total Time = ',num2str(TotalTime), ' sec'); %create output string
set(handles.totaltime,'String',TimeStepString);   %output string to GUI
end

function NumTimeSteps_Callback(hObject, eventdata, handles)
% hObject    handle to NumTimeSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTimeSteps as text
%        str2double(get(hObject,'String')) returns contents of NumTimeSteps as a double

TimeStep_Callback(hObject, eventdata, handles);
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
F=get(handles.features,'userdata');
if not(isempty(F)) && ishandle(F)
    delete(F)
end
delete(hObject);
end

% --- Executes during object creation, after setting all properties.
function LogoAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LogoAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate LogoAxes
end

function AddStatusLine(textline,varargin)% Optional args are AddToLastLine,Flag, ThisFig)
%AddStatusLine(TextLine, boolean) OR AddStatusLine(TextLine, figure) or
%AddSTatusLine(TextLine, boolean, figure) OR AddStatusLine(TextLine,boolean, Flag, figure)

    AddToLastLine=false;
    Flag='';
    ThisFig=findobj(0,'-depth',1,'tag','figure1');
    
    if nargin==2
        if ishandle(varargin{1})
            ThisFig=varargin{1};
        elseif islogical(varargin{1})
            AddToLastLine=varargin{1};
        else
            Flag=varargin{1};
        end
    elseif nargin==3
        AddToLastLine=varargin{1};
        if ishandle(varargin{2})
            ThisFig=varargin{2};
        end
    elseif nargin==4
        AddToLastLine=varargin{1};
        Flag=varargin{2};
        ThisFig=varargin{3};
    end
    
    Flag=[Flag '   '];
    d=0.1;
    wf=sin([0:1/8192:d]*3500).*(1-cos([0:1/8192:d]*2*pi/d));
    switch lower(Flag(1:3))
        case 'war'
            sound([wf wf],8192)
            ErrorStatus('warning')
        case 'err'
            sound([wf wf wf wf],8192)
            ErrorStatus('error')
        case 'inf'
        case '   '
        otherwise
            disp(['Unrecognized flag value in AddStatusLine: ' Flag])
    end
    
    if not(exist('ThisFig','var'))
        ThisFig=findobj(0,'-depth',1,'tag','figure1');
    end
    handles=guihandles(ThisFig);
    Hstat=handles.StatusWindow;
    
    if strcmpi(class(textline),'boolean') && textline
        set(Hstat,'text',{})
    else
        OldUnit=get(Hstat,'unit');
        set(Hstat,'unit','char');
        Pos=get(Hstat,'posit');
        Lines=floor(Pos(1));
        %set(Hstat,'style','edit');
        set(Hstat,'enable','inactive')
        set(Hstat,'pos',[Pos(1) Pos(2) Pos(3) floor(Pos(4))+.5]);
        MaxChar=floor(Pos(3));
        MaxWidth=Pos(3)+1;
        set(Hstat,'max',10);
        Indent='   ';
        if strcmpi(textline,'ClearStatus')
            set(Hstat,'string','')
            set(Hstat,'value',1)
        else
            OldText=get(Hstat,'string');
            %textline=textline(1:min([MaxChar length(textline)]));
            if isempty(OldText)
                NewText=textline;
            else
                if AddToLastLine
                    NewText=[OldText(1:end-1); [strtrim(OldText{end}), textline] ];
                else
                    NewText=[OldText; textline];
                end
            end
            if strcmpi(NewText,'CLEARSTATUS')
                NewText={''};
            end
            if ischar(NewText)
                NewText={NewText};
            end
            while length(NewText{end}) > MaxChar
                SpacePos=strfind(NewText{end},' ');
                SpacePos=max(SpacePos(SpacePos<=MaxChar));
                if SpacePos >= MaxChar | SpacePos <= length(Indent)
                    SpacePos=MaxChar;
                end
                NewText{end+1}=[Indent NewText{end}(SpacePos+1:end)];
                NewText{end-1}=NewText{end-1}(1:SpacePos-1);
            end
            E=MaxWidth;  %The following while ensure that lines don't wrap around.
%             while E>Pos(3)  %This was need to ensure lines in an edit box didn't wrap around.
%                 set(Hstat,'string',NewText)
%                 E=get(Hstat,'extent');
%                 E=E(3);
%                 for k=1:length(NewText)
%                     NewText{k}=NewText{k}(1:end-1);
%                     if isempty(NewText{k})
%                         NewText{k}=' ';
%                     end
%                 end
%             end
            set(Hstat,'string',NewText)
            set(Hstat,'unit',OldUnit);
            set(Hstat,'value',length(NewText(:,1)))
        end
    end
    drawnow
end
    
function VisUpdateStatus(handles, NeedsUpdate)
    %handles=guidata(gcf);
    AxisHandle=handles.GeometryVisualization;
    if not(isfield(handles,'VisualUpdateText')) || not(isvalid(handles.VisualUpdateText))
        handles.VisualUpdateText=text(AxisHandle,0.5,0.85,'Geometry Visualization Needs to be Updated',...
            'unit','normal',...
            'horizon','center',...
            'vis','off',...
            'color','red',...
            'background','white',...
            'edgecolor','red',...
            'fontweight','bold');
        guidata(AxisHandle,handles);
    end
    
    if NeedsUpdate
        set(handles.VisualUpdateText,'vis','on');
    else
        set(handles.VisualUpdateText,'vis','off');
    end
end

function ErrorStatus(ErrorFlag)
    %handles=guidata(gcf);
    if ~exist('ErrorFlag','var')
        ErrorFlag='';
    end
    ThisFig=findobj(0,'-depth',1,'tag','figure1');
    if ~isempty(ThisFig) 
        handles=guidata(ThisFig);
        if isfield(handles,'GeometryVisualization')
            AxisHandle=handles.GeometryVisualization;
            if not(isfield(handles,'ErrorStatus')) || not(isvalid(handles.ErrorStatus))
                handles.ErrorStatus=text(AxisHandle,0.5,0.65,'ErrorStatus',...
                    'unit','normal',...
                    'horizon','center',...
                    'vis','off',...
                    'color','white',...
                    'background','red',...
                    'fontweight','bold');
                guidata(AxisHandle,handles);
            end

            if strncmpi(ErrorFlag,'war',3)
                set(handles.ErrorStatus,'vis','on','string','Warning: Check status box.','background','yellow');
            elseif strncmpi(ErrorFlag,'err',3)
                set(handles.ErrorStatus,'vis','on','string','Error: Check status box.','background','red');
            elseif isempty(ErrorFlag)
                set(handles.ErrorStatus,'vis','off');
            end
        end
    end
        
end
    
% --- Executes during object creation, after setting all properties.
function GeometryVisualization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GeometryVisualization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end
% Hint: place code in OpeningFcn to populate GeometryVisualization

function T=TableShowDataText
    T='Show Data';

%The data for each table entry is stored in an appdata structure.  The
%structure has the same number of elements as the data table has rows.  It
%is up to the user to ensure that the rows of the data tables remain
%consistent with the parent table.

%TableOpenClose is called in the selection callback
%TableDataName is used with getappdata to extract the table data
%TableShowDataText is called in the selection callbback to show text that
%is used.
end

function H=TableEditHandles(Description)
    C=get(gcf,'children');
    Panel=C(strcmpi(get(C,'tag'),'TableEdit'));
    Cp=get(Panel,'children');
    switch lower(Description)
        case 'panel'
            H=Panel;
        case 'axes'
            H=Cp(strcmpi(get(Cp,'type'),'axes'));
        case 'label'
            H=Cp(strcmpi(get(Cp,'tag'),'FeatureLabel'));
        case 'table'
            H=Cp(strcmpi(get(Cp,'type'),'uitable'));
        case 'sourcetable'
            F=C(strcmpi(get(C,'tag','DefineFeatures')));
            Fc=get(F,'children');
            H=cp(strcmpi(get(Cp,'tag'),'Features'));
        otherwise
            warning([Description 'Unknown handle requested.'])
                
    end
end        
                               
function T=TableDataName
    T='Qtables';
end

%function TableOpenClose(Action,SourceTableHandle, Index)
function TableOpenClose(Action, Index)
    Data=getappdata(gcf,TableDataName);
    %if exist('SourceTableHandle','var')
    %    setappdata(gcf,'SourceTableHandle',SourceTableHandle);
    %else
    %    SourceTableHandle=getappdata(gcf,'SourceTableHandle');
    %end
    FrameHandle=TableEditHandles('panel');
    %HList=get(FrameHandle,'children');
    LabelH=TableEditHandles('label');
    TableH=TableEditHandles('table');
    if strcmpi(Action,'open')
        Childs=get(gcf,'children');
        ChildVisState=get(Childs,'visible');
        setappdata(gcf,'ChildVisState',{Childs ChildVisState})
        set(Childs,'vis','off');
        set(FrameHandle,'userdata',Index);
        if Index > length(Data)
            Data=[0 0];
        else
            if isempty(Data{Index})
                Data=[ 0 0 ];
            else
                Data=Data{Index};
            end
        end
        TableData(:,2:3)=num2cell(Data);
        for I=1:length(TableData(:,1))
            TableData{I,1}=false;
        end
        set(TableH,'data',TableData);  
        set(LabelH,'string',sprintf('Feature %i',Index))
        TableGraph
        set(FrameHandle,'visible','on');
    elseif strcmpi(Action,'close')
        Index=get(FrameHandle,'userdata');
        TableData=get(TableH,'data');
        TableData=TableData(:,2:3);
        TableData=cell2mat(TableData);
        Data{Index}=TableData;
        setappdata(gcf,TableDataName,Data)
        C_States=getappdata(gcf,'ChildVisState');
        ChildHandles=C_States{1};
        ChildStates=C_States{2};
        for I=1:length(ChildHandles)
            set(ChildHandles(I),'vis',ChildStates{I});
        end
    elseif strcmpi(Action,'cancel')
        Index=get(FrameHandle,'userdata');
        C_States=getappdata(gcf,'ChildVisState');
        ChildHandles=C_States{1};
        ChildStates=C_States{2};
        for I=1:length(ChildHandles)
            set(ChildHandles(I),'vis',ChildStates{I});
        end
    end
end

% --- Executes on button press in TableAddRow.
function TableAddRow_Callback(hObject, eventdata, handles)
% hObject    handle to TableAddRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%TableH=get(get(hObject,'parent'),'children');
TableH=TableEditHandles('table');
Table=get(TableH,'data');
AddEndRow=true;
for I=length(Table(:,1)):-1:1
    if Table{I,1}
        Table{I,1}=false;
        AddEndRow=false;
        Table=[Table(1:I-1,:); { false [0] [0] }; Table(I:end,:)];
    end
end
if AddEndRow
    Table=[Table; { false [0] [0] }];
end    
set(TableH,'data',Table)
TableGraph(hObject)
end

% --- Executes on button press in TableDelRow.
function TableDelRow_Callback(hObject, eventdata, handles)
% hObject    handle to TableDelRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%TableH=get(get(hObject,'parent'),'children');
TableH=TableEditHandles('table');
Table=get(TableH,'data');
for I=length(Table(:,1)):-1:1
    if Table{I,1}
        Table=[Table(1:I-1,:); Table(I+1:end,:)];
    end
end
set(TableH,'data',Table)  
TableGraph(hObject)
end

% --- Executes on button press in TableClose.
function TableClose_Callback(hObject, eventdata, handles)
% hObject    handle to TableClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
T=get(TableEditHandles('table'),'data');
TimeValue=cell2mat(T(:,2));
if min(TimeValue(2:end)-TimeValue(1:end-1))<0
    msgbox('The time values must be monotonically increasing.','Information','modal')
else
    TableOpenClose('close')
    set(get(hObject,'parent'),'visible','off')
end
end

%function GraphTable (hObject)
%    TableH=TableEditHandles('table');
%    AxesH=TableEditHandles('axes');

% --- Executes on button press in TableGraph.
function TableGraph(hObject, eventdata, handles)
% hObject    handle to TableGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TableH=TableEditHandles('table');
AxesH=TableEditHandles('axes');
Table=get(TableH,'data');
NTable=cell2mat(Table(:,2:3));
plot(AxesH,NTable(:,1),NTable(:,2))
YLim=get(AxesH,'ylim');
if min(NTable(:,2))==YLim(1)
    YLim(1)=YLim(1)-(YLim(2)-YLim(1))*.05;
end
if max(NTable(:,2))==YLim(2)
    YLim(2)=YLim(2)+(YLim(2)-YLim(1))*.05;
end
set(AxesH,'ylim',YLim)
end

% --- Executes when entered data in editable cell(s) in TableTable.
function TableTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to TableTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
TableGraph(hObject)
end

% --- Executes when selected cell(s) is changed in features.
function features_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to features (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
  if not(isempty(eventdata.Indices))
    Row=eventdata.Indices(1);
    Col=eventdata.Indices(2);
    Table=get(hObject, 'Data');
    if Col==FTC('QVal') && strcmpi(Table{Row,FTC('QVal')},TableShowDataText)
        TempData=get(hObject,'data');
        set(hObject,'data',[])        % Clear selected cell hack by deleting 
        set(hObject,'data',TempData)  % data and then reinstating data.
        VisUpdateStatus(handles,true);
        TableOpenClose('open', Row)
%        TableOpenClose('open',hObject,Row)
    end
  end
end

function features_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to features (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
%Check to see if column with Q Type is being modified
VisUpdateStatus(handles, true)
Row=eventdata.Indices(1);
Col=eventdata.Indices(2);
%CellTableData=get(hObject,'userdata');
if Col==FTC('QType')
    %disp('changing Q Type')
    Table=get(hObject,'data');
    if strcmpi(eventdata.NewData,'Table')

        Table{Row,FTC('QVal')}=TableShowDataText;
%        CellTableData{Row}=[0 0];
    else
        Table{Row,FTC('QVal')}=[];
%        CellTableData{Row}=[];
    end
    set(hObject,'Data',Table);
 %   set(hObject,'userdata',CellTableData);
elseif Col==FTC('QType')
    if strcmpi(eventdata.PreviousData,TableShowDataText)
        Table{Row,FTC('QVal')}=TableShowDataText;
        set(hObject,'Data',Table);
    end
end
end

% --- Executes when entered data in editable cell(s) in ExtCondTable.
function ExtCondTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to ExtCondTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
    VisUpdateStatus(handles,true)
end

% --- Executes when selected object is changed in AnalysisType.
function AnalysisType_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in AnalysisType 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Chooser=get(hObject,'string');
    if strncmpi(Chooser,'static',6)
        set([handles.text5 handles.text4 handles.TimeStep handles.NumTimeSteps handles.totaltime],'enable','off');
    elseif strncmpi(Chooser,'transient',8)
        set([handles.text5 handles.text4 handles.TimeStep handles.NumTimeSteps handles.totaltime],'enable','on');
    end
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      FEATURES TABLE SPECIAL HANDLING          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A feature can include a Q vs. t table that requires special   %
% handling.  The data for those tables is stored as appdata and %
% is set/retreived with Data=getappdata(gcf, TableDataName) and %
% setappdata(gcf,TableDataName, Data).  As the features table   %
% updated, the programmer MUST modify the table to ensure that  %
% the table data remains synchronized to the features table.    %
% Thus far the following functions include logic to ensure that %
% synchronization: loadbutton_Callback,  addfeature_Callback,   %
% Initialize_Callback, DeleteFeature_Callback.                  %
%                                                               %
% The tables are coded with widgets that begin with "Table" in  %
% their tags.  The function FTC('') is used to ID colums in the %
% host table that the Q value data tables interact with and     %
% MUST be updated if host table (features) changes structure. A %
% handle to the source table is accessed by TableEditHandles()  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on selection change in StatusWindow.
function StatusWindow_Callback(hObject, eventdata, handles)
% hObject    handle to StatusWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StatusWindow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StatusWindow
end

% --- Executes during object creation, after setting all properties.
function StatusWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StatusWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function NumCol=FTC(ColDescr)
    switch lower(ColDescr)
        case 'check'
            NumCol=1;
        case 'desc'
            NumCol=2;
        case 'x1'
            NumCol=3;
        case 'x2'
            NumCol=6;
        case 'y1'
            NumCol=4;
        case 'y2'
            NumCol=7;
        case 'z1'
            NumCol=5;
        case 'z2'
            NumCol=8;
        case 'mat'
            NumCol=9;
        case 'qtype'
            NumCol=10;
        case 'qval'
            NumCol=11;
        case 'divx'
            NumCol=12;
        case 'divy'
            NumCol=13;
        case 'divz'
            NumCol=14;
        case 'numcols'
            NumCol=14;  %This is the maximum number of columns
        otherwise
            NumCol=nan;
    end
end

% --- Executes on button press in MoveUp.
function MoveUp_Callback(hObject, eventdata, handles)
% hObject    handle to MoveUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    TableData = get(handles.features,'Data');
    NumRows=length(TableData(:,1));
    QData=getappdata(handles.figure1,TableDataName);
    if length(QData)<NumRows
        QData{NumRows}=[];
    end
    MoveRows=find(cell2mat(TableData(:,FTC('check')))==true);
    if not(isempty(TableData)) && not(isempty(MoveRows))
        if min(MoveRows)==1
            AddStatusLine('Can''t move first row up','warning')
        else
            NewTable=TableData;
            NewQData=QData;
            for Irow=MoveRows
                NewTable(Irow-1,:)=TableData(Irow,   :);
                NewTable(Irow  ,:)=TableData(Irow-1, :);
                TableData=NewTable;
                NewQData(Irow-1)=QData(Irow);
                NewQData(Irow)  =QData(Irow-1);
                QData=NewQData;
            end
        end
    end
    set(handles.features,'Data',TableData)
    setappdata(handles.figure1,TableDataName,QData);

    VisUpdateStatus(handles,true);
end

% --- Executes on button press in MoveDown.
function MoveDown_Callback(hObject, eventdata, handles)
% hObject    handle to MoveDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    TableData = get(handles.features,'Data');
    NumRows=length(TableData(:,1));
    QData=getappdata(handles.figure1,TableDataName);
    if length(QData)<NumRows
        QData{NumRows}=[];
    end
    MoveRows=find(cell2mat(TableData(:,FTC('check')))==true);
    if not(isempty(TableData)) && not(isempty(MoveRows))
        if max(MoveRows)==length(TableData(:,1))
            AddStatusLine('Can''t move last row down','warning')
        else
            NewTable=TableData;
            NewQData=QData;
            for Irow=reshape(MoveRows,1,[])
                NewTable(Irow+1,:)=TableData(Irow,   :);
                NewTable(Irow  ,:)=TableData(Irow+1, :);
                TableData=NewTable;
                NewQData(Irow+1)=QData(Irow);
                NewQData(Irow)  =QData(Irow+1);
                QData=NewQData;
            end
        end
    end
    set(handles.features,'Data',TableData)
    setappdata(handles.figure1,TableDataName,QData);

    VisUpdateStatus(handles,true);
end

% --- Executes on button press in TableCancel.
% --- Executes on button press in TableClose.
function TableCancel_Callback(hObject, eventdata, handles)
% hObject    handle to TableClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
P=questdlg('Are you sure you want to discard changes to table data?','Confirmation','Yes','No','No');

if strcmpi(P,'Yes')
    TableOpenClose('cancel')
    set(get(hObject,'parent'),'visible','off')
end

% hObject    handle to TableCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on selection change in StressModel.
function StressModel_Callback(hObject, eventdata, handles)
% hObject    handle to StressModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StressModel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StressModel
end

% --- Executes during object creation, after setting all properties.
function StressModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StressModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in HelpButton.
function HelpButton_Callback(hObject, eventdata, handles)
% hObject    handle to HelpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Hf=dialog('WindowStyle','Normal','name','Help','units','normal');
    CloseCB=@(A,B,C)delete(Hf);
    U=uicontrol(Hf,'style','pushbutton','string','Close','Callback',CloseCB,'units','normal');
    E=get(U,'extent'); P=get(U,'posit');P(1)=0.5-E(3)/2;set(U,'posit',P);
    T=uicontrol(Hf,'style','edit','max',5,'unit','normal','posit',[0.05 P(2)+P(4)*2 0.90 1-0.05-(P(2)+P(4)*2)],...
                   'horiz','left','fontsize',10,'enable','inactive');
               
    
    HelpText={};
    HelpText{end+1}=['ARL ParaPower ' ARLParaPowerVersion ];
    HelpText{end+1}='';
    HelpText{end+1}='Build a model:';
    HelpText{end+1}='    Step 1';
    HelpText{end+1}='    Step 2';
    HelpText{end+1}='';
    HelpText{end+1}='While the model and results are saved with ".ppmodel" extension, they are generic MATLAB data files.';
    HelpText{end+1}='';
    HelpText{end+1}='Developer/Programmer Information';
    HelpText{end+1}='   Material Database';
    HelpText{end+1}='      The handle to the Materials Database figure is stored in userdata of the features table';
    HelpText{end+1}='';
    HelpText{end+1}='   Data can be extracted with D=ParaPowerGUI_V2(''GetResults'');';
    HelpText{end+1}='';
    HelpText{end+1}='   APPDATA Stored in Main Figure';
    HelpText{end+1}='      Qtables (derefernced by TableDataName()): Tabular data containing time variant Q values.';
    HelpText{end+1}='      Version: Version number of the GUI and code';
    HelpText{end+1}='      TestCaseModel: Input model definition';
    HelpText{end+1}='      MI: Model input which is TestCaseModel processed by FormModel.';
    HelpText{end+1}='      Results: Results from last analysis';
    HelpText{end+1}='      Initialized: TRUE if it''s not a new GUI';
    HelpText{end+1}='';
    HelpText{end+1}='   Time Variant Q';
    HelpText{end+1}='      The main interface to get/retrieve time variant Q values is TableOpenClose()';
    HelpText{end+1}='      The function TableEditHandles() is used to gain access to handles relevant for table handling';
    HelpText{end+1}='      The programmer MUST adjust the table data if the features table change!';
    HelpText{end+1}='';
    HelpText{end+1}='   Stress Models';
    HelpText{end+1}='';
    HelpText{end+1}='Contributors:';
    HelpText{end+1}='   Dr. Lauren Boteler (ARL)';
    HelpText{end+1}='   Dr. Michael Fish (ORAU)';
    HelpText{end+1}='   Dr. Steven Miner (USNA)';
    HelpText{end+1}='   Mr. Morris Berman (ARL)';
    HelpText{end+1}='   Mr. Michael Rego (Drexel)';
    HelpText{end+1}='   Mr. Michael Deckard (Texas A&M)';
    HelpText{end+1}='';  
    HelpText{end+1}='For additional informatoin contact Dr. Lauren Boteler (lauren.m.boteler.civ@mail.mil)';
    HelpText{end+1}='';
    HelpText{end+1}='DISTRIBUTION C';
    HelpText{end+1}=['Distribution authorized to U.S. Government agencies (premature dissemination) 12/12/2018. Other requests ' ...
                    'for this document shall be referred to US Army Research Laboratory, Power Conditioning Branch (RDRL-SED-P). '];
    HelpText{end+1}='';
    set(T,'string',HelpText)
    GUIEnable;
end

function GUIDisable(GUIHandle)
    CurObjects=getappdata(GUIHandle,'DisabledObjects');
    if isempty(CurObjects)
        ObjectsToChange=findobj(GUIHandle,'enable','on','-property','callback','type','uicontrol');
        ObjectsToChange=[ObjectsToChange; findobj(GUIHandle,'enable','on','-property','celleditcallback','type','uitable')];
        
        %ObjectsToChange=[ObjectsToChange; findobj(GUIHandle,'enable','on','type','uicontrol','style','popupmenu')];
        %ObjectsToChange=[ObjectsToChange; findobj(GUIHandle,'enable','on','type','uicontrol','style','checkbox')];
        setappdata(GUIHandle,'DisabledObjects', ObjectsToChange);
        set(ObjectsToChange,'enable','off')
        set(findobj(ObjectsToChange,'tag','HelpButton'),'enable','on');
    end
end

function GUIEnable(GUIHandle)
    if ~exist('GUIHandle','var')
        GUIHandle=[];
        Fi=findall(0,'type','figure');
        for I=1:length(Fi)
            if strncmpi(get(Fi(I),'name'),'ParaPowerGUI',length('ParaPowerGUI'))
                GUIHandle=Fi(I);
            end
        end
    end
    if ~isempty(GUIHandle)
        ObjectsToChange=getappdata(GUIHandle,'DisabledObjects');
        if ~isempty(ObjectsToChange)
            set(ObjectsToChange(isvalid(ObjectsToChange)),'enable','on')
            setappdata(GUIHandle,'DisabledObjects', []);
        end
    else
        disp('Cannot find an active ParaPowerGUI to enable.')
    end
end

% --- Executes during object creation, after setting all properties.
function ExtCondTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExtCondTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', cell(2,6));
end


% --- Executes on button press in ClearResultsButton.
function ClearResultsButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearResultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    P=questdlg('Are you sure you want to clear the current analysis results?','Confirmation','Yes','No','No');
    if strcmpi(P,'Yes')
        if isappdata(gcf,'Results')
           rmappdata(gcf,'Results');
           slider1_Callback(handles.slider1, eventdata, handles)
           AddStatusLine('Results cleared.')
        end
    end
end


% --- Executes on button press in MaxPlot.
function MaxPlot_Callback(hObject, eventdata, handles, Results)
% hObject    handle to MaxPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   if ~exist('Results')
       Results=getappdata(handles.figure1, 'Results');
   end
   if isempty(Results)
       AddStatusLine('No results available');
   else
       MI=Results.Model;
       if isfield(MI,'FeatureMatrix')
           TestCaseModel = getappdata(handles.figure1,'TestCaseModel');

           DoutT=[];
           DoutM=[];
           DoutS=[];
           Fs=unique(MI.FeatureMatrix(~isnan(MI.FeatureMatrix)));
           for Fi=1:length(Fs)
               Ftext{Fi}=MI.FeatureDescr{Fs(Fi)};
               Fmask=ismember(MI.FeatureMatrix,Fs(Fi));
               Fmask=repmat(Fmask,1,1,1,length(MI.GlobalTime));
               if ~isempty(Results.Tprint)
                    DoutT(:,1+Fi)=max(reshape(Results.Tprint(Fmask),[],length(MI.GlobalTime)),[],1);
               end
               if ~isempty(Results.MeltFrac)
                    DoutM(:,1+Fi)=max(reshape(Results.MeltFrac(Fmask),[],length(MI.GlobalTime)),[],1);
               end
               if ~isempty(Results.Stress)
                    DoutS(:,1+Fi)=max(reshape(Results.Stress(Fmask),[],length(MI.GlobalTime)),[],1);
               end
               FeatureMat{Fi}=TestCaseModel.Features(Fi).Matl;
           end
           PCMFeatures=[];
           for Fi=1:length(FeatureMat)
               if ~isempty(findstr(lower(MI.MatLib.GetMatName(FeatureMat{Fi}).Type),'pcm'))
                   PCMFeatures=[PCMFeatures Fi];
               end
           end
           if isempty(PCMFeatures)
               DoutM=[];
           end
           NumAx=0;
           if ~isempty(DoutT)
               DoutT(:,1)=MI.GlobalTime;
               NumAx=NumAx+1;
           end
           if ~isempty(DoutM)
               DoutM(:,1)=MI.GlobalTime;
               NumAx=NumAx+1;
           end
           if ~isempty(DoutS)
               DoutS(:,1)=MI.GlobalTime;
               NumAx=NumAx+1;
           end
           MaxTitle='Max Results';
           Figs=findobj('type','figure');
           FigTitles=get(Figs,'name');
           MaxResultsFig=find(strcmpi(FigTitles,MaxTitle));
           ThisAx=NumAx;
           if isempty(MaxResultsFig)
               set(figure,'name',MaxTitle')
           else
               figure(Figs(MaxResultsFig))
           end
           if ~isempty(DoutT)
               subplot(1,NumAx,ThisAx)
               plot(DoutT(:,1),DoutT(:,2:end));
               xlabel('Time')
               ylabel('Temperature')
               title('Max Temp in Feature')
               legend(Ftext)
               ThisAx=ThisAx-1;
           end
           if ~isempty(DoutM)
               subplot(1,NumAx,ThisAx)
               plot(DoutM(:,1),DoutM(:,PCMFeatures+1));
               legend(Ftext(PCMFeatures))
               xlabel('Time')
               ylabel('Melt Fraction')
               title('Max Melt Fraction in Feature')
               ThisAx=ThisAx-1;
           end
           if ~isempty(DoutS)
               subplot(1,NumAx,ThisAx)
               plot(DoutS(:,1),DoutS(:,2:end));
               xlabel('Time')
               ylabel('Stress')
               title('Max Stress in Feature')
               legend(Ftext)
               ThisAx=ThisAx-1;
           end
       else
           Dout(:,1)=MI.GlobalTime;
           scan_mats = find(strcmp(MI.MatLib.Type,'PCM'));  %Select only PCM materials
           scan_mask=ismember(MI.Model,scan_mats);
           scan_mask=repmat(scan_mask,1,1,1,length(MI.GlobalTime));
           Dout(:,2)=max(reshape(Results.Tprint,[],length(MI.GlobalTime)),[],1);
           %Dout(:,3)=max(Results.Stress,[],[1 2 3]);
           Dout(:,4)=max(reshape(Results.MeltFrac(scan_mask),[],length(MI.GlobalTime)),[],1);


           numplots = 1;
           figure(numplots)
           if isempty(scan_mats)
               SP=1;
           else
               SP=2;
           end
           subplot(1,SP,1)
           plot (Dout(:,1), Dout(:,2))
           xlabel('Time (s)')
           ylabel('Temperature')
           title('Max Temperature Across All Model')
           if SP==2
               subplot(1,SP,2)
               plot (Dout(:,1), Dout(:,4))
               xlabel('Time (s)')
               ylabel('Melt Fraction')
               title('Max Melt Fraction All PCM Materials')
           end
       end
       figure(handles.figure1)
   end

end
