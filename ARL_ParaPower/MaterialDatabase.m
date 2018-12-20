function varargout = MaterialDatabase(varargin)
% MATERIALDATABASE MATLAB code for MaterialDatabase.fig
%      MATERIALDATABASE, by itself, creates a new MATERIALDATABASE or raises the existing
%      singleton*.
%
%      H = MATERIALDATABASE returns the handle to a new MATERIALDATABASE or the handle to
%      the existing singleton*.
%
%      MATERIALDATABASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATERIALDATABASE.M with the given input arguments.
%
%      MATERIALDATABASE('Property','Value',...) creates a new MATERIALDATABASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MaterialDatabase_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MaterialDatabase_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MaterialDatabase

% Last Modified by GUIDE v2.5 11-Dec-2018 11:53:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MaterialDatabase_OpeningFcn, ...
                   'gui_OutputFcn',  @MaterialDatabase_OutputFcn, ...
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


% --- Executes just before MaterialDatabase is made visible.
function MaterialDatabase_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MaterialDatabase (see VARARGIN)

% Choose default command line output for MaterialDatabase
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MaterialDatabase wait for user response (see UIRESUME)
% uiwait(handles.MatDbaseFigure);

set(handles.MatDatabaseGroup,'vis','on')
set(handles.ErrorPanel,'vis','off')
NewWindow=not(isappdata(handles.MatDbaseFigure,'ExistingFigure'));
if NewWindow
    DefFname='DefaultMaterials';
    if exist([DefFname '.mat'],'file')==2
        load(DefFname,'MatDbase')
        set(handles.MatTable,'Data',MatDbase);
        GUIColNames=get(handles.MatTable,'columnname');
        PopulateMatLib(handles.MatTable);
        setappdata(handles.MatDbaseFigure,'ExistingFigure',true);
    else
        disp(['No default material database loaded. (' DefFname '.mat)'])
        %PopulateMatLib(handles, MatDbase, GUIColNames);
    end
end
GUIColNames=strtrim(get(handles.MatTable,'columnname'));
set(handles.SortByMenu,'string',GUIColNames,'value',2)

%Set delete column width
CW=get(handles.MatTable,'columnwidth');
CW{1}=30;
set(handles.MatTable,'columnwidth',CW)


% --- Outputs from this function are returned to the command line.
function varargout = MaterialDatabase_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in MatClose.
function MatClose_Callback(hObject, eventdata, handles)
% hObject    handle to MatClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.MatDbaseFigure,'windowstyle','normal');
MatDbase=get(handles.MatTable,'Data');
Mats=strtrim(MatDbase(:,2));
Mats=Mats(~strcmp(Mats,''));
ErrorText={};
strleft=@(S,n) S(1:min(n,length(S)));

if length(Mats)==length(unique(upper(Mats)))
    PopulateMatLib(handles.MatTable);
else
    ErrorText{end+1}='Duplicate material name.  All material names must be unique.';
end

if length(ErrorText) > 0 
    TempTxt='';
    for I=1:length(ErrorText)
        TempTxt=[TempTxt char(10) ErrorText{I}];
    end
    ShowError(TempTxt)
    if handles.modal
        set(handles.MatDbaseFigure,'windowstyle','modal');
    else
        set(handles.MatDbaseFigure,'windowstyle','normal');
    end        
else
    set(handles.MatDbaseFigure,'visible','off')
    %set(handles.MatDbaseFigure,'windowstyle','normal');
    uiresume
end
  
% --- Executes on button press in ErrorOKButton.
function ErrorOKButton_Callback(hObject, eventdata, handles)
% hObject    handle to ErrorOKButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ErrorPanel,'vis','off')



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DeleteIBCButton.
function DeleteIBCButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteIBCButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MatDbase=get(handles.MatTable,'Data');
GUIColNames=get(handles.MatTable,'columnname');
TypeCol=find(strcmpi(GUIColNames,'Type'));
ToRetain=find(not(strcmpi(MatDbase(:,TypeCol),'IBC')));
YES='Yes';
Response=questdlg('Are you sure want to delete all IBCs?','Confirm',YES,'No','No');
if strcmpi(Response,YES)
    MatDbase=MatDbase(ToRetain,:);
    set(handles.MatTable,'Data',MatDbase);
end
    

% ToRetain=find(not(cell2mat(MatDbase(:,IsIBCCol))));
% YES='Yes';
% Response=questdlg('Are you sure want to delete all checked materials?','Confirm',YES,'No','No');
% if strcmpi(Response,YES)
% %     for i=IBCs'
% %         MatDbase(i,:)=MatDbase(end,:);
% %     end
%     MatDbase=MatDbase(ToRetain,:);
%     set(handles.MatTable,'Data',MatDbase);
% end
%     
% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldpathname=get(handles.loadbutton,'userdata');
[fname,pathname]=uigetfile([oldpathname '*.mat'],'Load Material Database');
if fname ~= 0
    set(handles.loadbutton,'userdata',pathname);
    load([pathname fname],'MatDbase');  
    MatDbase=SetNaNData(MatDbase);
    set(handles.MatTable,'Data',MatDbase);
end

% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldpathname=get(handles.loadbutton,'userdata');
[fname,pathname]=uiputfile([oldpathname '*.mat'],'Save Material Database');
if fname ~= 0
    set(handles.loadbutton,'userdata',pathname);
    MatLib=PopulateMatLib(handles.MatTable);
    MatDbase=get(handles.MatTable,'Data');  
    README={'"MatDbase" is inserted directly into the table data (internal use)'; ...
            '"MatLib" stored in userdata and used in FormModel (external use).'};
    save([pathname fname],'MatDbase','MatLib','README');
end

% --- Executes when user attempts to close MatDbaseFigure.
function MatDbaseFigure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MatDbaseFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
MatClose_Callback(hObject, eventdata, handles)
set(hObject,'visible','off');

function Output=GetMatCol(ColName,ReturnField)
    if not(exist('ReturnField','var'))
        ReturnField=false;
    end
    switch lower(ColName)
        case 'material'
            C=2;
            field='Material';
        case 'type'
            C=3;
            field='Type';
        case 'cte'
            C=4;
            field='cte';
        case 'e'
            C=5;
            field='e';
        case 'nu'
            C=6;
            field='nu';
        case 'k'
            C=7;
            field='k';
        case 'k_s'
            C=7;
            field='k';
        case 'rho'
            C=8;
            field='rho';
        case 'dens_s'
            field='rho';
            C=8;
        case 'cp'
            C=9;
            field='cp';
        case 'cp_s'
            C=9;
            field='cp';
        case 'k_l'
            C=10;
            field='k_l';
        case 'rho_l'
            C=11;
            field='rho_l';
        case 'dens_l'
            C=11;
            field='rho_l';
        case 'cp_l'
            C=12;
            field='cp_l';
        case 'lf'
            C=13;
            field='lf';
        case 'lw'
            C=13;
            field='lf';
        case 'tmelt'
            C=14;
            field='tmelt';
        case 'h_ibc'
            C=15;
            field='h_ibc';
        case 't_ibc'
            C=16;
            field='T_ibc';
        case 'del'
            C=0;
            field='';
        otherwise
            warning(['Unknown column label "' ColName '"' ]); 
            C='';
    end
    if ReturnField
        Output=field;
    else
        Output=C;
    end
    
function MatDbaseHandle=ExtractMatLib(MatDbaseHandle, MatLib)
    FieldNames=fieldnames(MatLib);
    handles=guihandles(MatDbaseHandle);
    Table=get(handles.MatTable,'data');
    Table=Table(1,:);
    NumMats=[];
    for Fi=1:length(FieldNames)
        %fprintf('Setting %s...',FieldNames{Fi});
        if strcmp('TypeList',FieldNames(Fi))
            TypeList=get(handles.MatTable,'columnformat');
            TypeList{GetMatCol('type')}=reshape(MatLib.TypeList,1,[]);
            set(handles.MatTable,'columnformat',TypeList);
        elseif isempty(GetMatCol(FieldNames{Fi}))
            warning(['Unknown field name "' FieldNames(Fi) '" in MatLib.']);
        else
            NumMatsThisParm=length(getfield(MatLib,FieldNames{Fi}));
            MatDbaseCol=GetMatCol(FieldNames{Fi});
            if isempty(NumMats)
                NumMats=NumMatsThisParm;
            elseif NumMats ~= NumMatsThisParm
                warning(['All material parameters must exist for all materials.  Parameter "' FieldNames(Fi) '" only has ' num2str(NumMatsThisParm) ' parameters.']);
            end
            if isnumeric(Table{1,MatDbaseCol})
                Table(1:NumMats,MatDbaseCol)=num2cell(MatLib.(FieldNames{Fi}));
            else
                Table(1:NumMats,MatDbaseCol)=MatLib.(FieldNames{Fi});
            end
            %fprintf('column %2.0d\n',GetMatCol(FieldNames{Fi}))
        end
    end
    Table(:,1)={false};
    set(handles.MatTable,'data',Table);
    setappdata(MatDbaseHandle,'Materials',MatLib)

function MatLib=PopulateMatLib(MatTableHandle)

    if not(exist('MatTableHandle','var'))
        F=MaterialDatabase;
        MatLib=getappdata(F,'Materials');
        delete(F)
    else
        F=get(get(MatTableHandle,'parent'),'parent');
        GUIColNames=get(MatTableHandle,'columnname');
        MatDbase=get(MatTableHandle,'data');
        GUIColNames=strip(GUIColNames); %Remove extra spaces from the names of the GUI columns
        MatCol=find(strcmpi(GUIColNames,'Material')); %Determine which column holds the name
        TypCol=find(strcmpi(GUIColNames,'Type'));
        AvailMats=find(not(strcmpi('',MatDbase(:,MatCol)))); %List of populated materials
        MatDbase=MatDbase(AvailMats,:);
        MatLib=[];

        for Col=1:length(GUIColNames)
            ColName=lower(strtrim(GUIColNames{Col}));
            FindSpace=strfind(ColName,' ');
            if ~isempty(FindSpace)
                ColName=ColName(1:FindSpace-1);
            end
            ColNum=GetMatCol(ColName);
            if ColNum>0
                if ischar(MatDbase{1,ColNum})
                    MatLib=setfield(MatLib,GetMatCol(ColName,true),MatDbase(:,ColNum));
                elseif isnumeric(MatDbase{1,ColNum})
                    MatLib=setfield(MatLib,GetMatCol(ColName,true),cell2mat(MatDbase(:,ColNum)));
                else
                    warning('Unknown field type.')
                end
            end
        end
        TypeList=get(MatTableHandle,'columnformat');
        TypeList=TypeList{GetMatCol('type')};
        MatLib.TypeList=TypeList';
        setappdata(F,'Materials',MatLib);
    end


% --- Executes on button press in helpbutton.
function helpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Text={};
Text{end+1}='This Material database is designed to work with ARL ParaPower.' ;
Text{end+1}='When first called, it creates a dialog box.  When closed it turns';
Text{end+1}='the dialog box invisible, but it still exists in memory so that the';
Text{end+1}='material data can be extracted from it.';
Text{end+1}='';
Text{end+1}='On first call the following form should be used:';
Text{end+1}='   F=MaterialDatabase;';
Text{end+1}='To make the dialog box modal (which is desired when running';
Text{end+1}='ARL ParaPower use';
Text{end+1}='   set(F,''windowsstyle'',''modal'')';
Text{end+1}='To return the dialog box to non-modal normal behavior use:';
Text{end+1}='   set(F,''windowsstyle'',''normal'')';
Text{end+1}='';
Text{end+1}='To extract data from the database:';
Text{end+1}='    Materials=getappdata(F,''Materials'');';
Text{end+1}='    Materials is a stucture whose fields are the same as MatLibFun';
Text{end+1}='    output with the exception that matprops includes material number.';
Text{end+1}='';
Text{end+1}='When the database first loads it attempts to load a file named';
Text{end+1}='DefaultMaterials.mat.  If that files doesn''t exist, then the';
Text{end+1}='database starts out empty.  The file can be created using the';
Text{end+1}='''Save'' button.  To completely eliminate the GUI use delete(F).';
Text{end+1}='';
Text{end+1}='To programmatically pull the material database use P=MaterialDatabase(''PopulateMatLib'')';
Text{end+1}='';


TextOutput='';
for I=1:length(Text)
    TextOutput=[TextOutput Text{I}  char(10)];
end
msgbox(TextOutput,'Help','modal');

% --- Executes on button press in DelChkButton.
function DelChkButton_Callback(hObject, eventdata, handles)
% hObject    handle to DelChkButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MatDbase=get(handles.MatTable,'Data');
GUIColNames=get(handles.MatTable,'columnname');
IsIBCCol=find(strcmpi(GUIColNames,'Del'));
ToRetain=find(not(cell2mat(MatDbase(:,IsIBCCol))));
YES='Yes';
Response=questdlg('Are you sure want to delete all checked materials?','Confirm',YES,'No','No');
if strcmpi(Response,YES)
%     for i=IBCs'
%         MatDbase(i,:)=MatDbase(end,:);
%     end
    if isempty(ToRetain)
        ToRetain=length(MatDbase(:,1))+1;
        InsertRowButton_Callback(hObject, eventdata, handles)
        MatDbase=get(handles.MatTable,'Data');
    end
    MatDbase=MatDbase(ToRetain,:);
    set(handles.MatTable,'Data',MatDbase);
end
    


% --- Executes on button press in InsertRowButton.
function InsertRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to InsertRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MatDbase=get(handles.MatTable,'Data');
NewRow=MatDbase(1,:);
for I=1:length(NewRow)
    switch class(NewRow{I})
        case 'double'
            NewRow{I}=[];
        case 'logical'
            NewRow{I}=false;
        case 'char'
            NewRow{I}='';
        otherwise
            NewRow{I}=[];
    end
            
end
MatDbase(end+1,:)=NewRow;
set(handles.MatTable,'Data',MatDbase);

% --- Executes on button press in SortButton.
function SortButton_Callback(hObject, eventdata, handles)
% hObject    handle to SortButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    MatDbase=get(handles.MatTable,'Data');
    Key=get(handles.SortByMenu,'value');
    KeyField=MatDbase(:,Key);
    OrigLength=length(KeyField);
    if not(ischar(KeyField{1}))
        KeyField=cell2mat(KeyField);
    end
    if OrigLength==length(KeyField)
        [Field,Order]=sort(KeyField);
        if all(Order'==[1:length(Order)])
            Order=[length(Order):-1:1];
        end
        MatDbase=MatDbase(Order,:);
        set(handles.MatTable,'data',MatDbase);
    else
        msgbox('Sort failed because some fields in sorted column are empty.','Information');
    end

function Out=MatTypes(Action, Value)

    MatTypes={'Solid'; 'PCM'; 'IBC'};
    switch lower(Action)
        case 'enumerate'
            Out=MatTypes;
        case 'typecol'
            Out=3;
        case 'usedcols'
            switch lower(Value)
                case 'pcm'
                    Out=[4:14];
                case 'solid'
                    Out=[4:9];
                case 'ibc'
                    Out=[15 16];
                otherwise
                    error(['Unknown material type "' Value '"'])
            end
            Out = [1 2 3 Out];
        otherwise
            error(['Unknown Action "' Action '"'])
    end

function ShowError(ErrorText)
    handles=guidata(gcf);
    set(handles.ErrorPanel,'vis','on')
    %set(handles.ErrorMsg,'string','Single Line Text')
    %SingleLineExtent=get(handles.ErrorMsg,'extent');
    set(handles.ErrorMsg,'string',ErrorText)
    %Extent=get(handles.ErrorMsg,'extent');
    %P=get(handles.ErrorPanel,'posit');
    %set(handles.ErrorPanel,'posit',[P(1) P(2) P(3) Extent(2)+7*SingleLineExtent(4)]);

function Data=SetNaNData (Data)

    ErrorText='';
    TypeCol=MatTypes('TypeCol');
    for MatNum=1:length(Data(:,1))
        NewData=Data{MatNum, TypeCol};
        if isempty(find(strcmpi(NewData,MatTypes('enumerate')),1))
            ErrorText=[ErrorText char(10) ['Unknown material type "' NewData '"']];
        else
            ColsToKeep=MatTypes('UsedCols',NewData);
            for Ci=4:length(Data(1,:))
                if isempty(find(Ci==ColsToKeep,1))
                    Data(MatNum,Ci)={nan};
                else
                    if isempty(Data(MatNum, Ci))
                        Data(MatNum,Ci)={0};
                    end
                end
            end
        end
    end
    if not(isempty(ErrorText))
        ShowError(ErrorText)
    end


% --- Executes when entered data in editable cell(s) in MatTable.
function MatTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to MatTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
    MatNum=eventdata.Indices(1);
    PrpNum=eventdata.Indices(2);
    NewData=eventdata.NewData;
    
    if PrpNum==3
        if isempty(find(strcmpi(NewData,MatTypes('enumerate'))))
            error(['Unknown material type "' NewData '"'])
        else
            ColsToKeep=MatTypes('UsedCols',NewData);
            Data=get(hObject,'data');
            for Ci=4:length(Data(1,:))
                if isempty(find(Ci==ColsToKeep,1))
                    Data(MatNum,Ci)={nan};
                else
                    Data(MatNum,Ci)={0};
                end
            end
            set(hObject,'data',Data);
        end
    elseif isnan(eventdata.PreviousData)
        Data=get(hObject,'data');
        Data(MatNum,PrpNum)={eventdata.PreviousData};
        set(hObject,'data',Data)
        ShowError('Parameter is not used in this material type.')
    end
            


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
P=questdlg('Are you sure you want to discard changes to material data?','Confirmation','Yes','No','No');

if strcmpi(P,'Yes')
    set(handles.MatDbaseFigure,'visible','off')
    %set(handles.MatDbaseFigure,'windowstyle','normal');
    uiresume    
end
