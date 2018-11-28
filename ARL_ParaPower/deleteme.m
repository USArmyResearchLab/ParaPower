function varargout = deleteme(varargin)
% DELETEME MATLAB code for deleteme.fig
%      DELETEME, by itself, creates a new DELETEME or raises the existing
%      singleton*.
%
%      H = DELETEME returns the handle to a new DELETEME or the handle to
%      the existing singleton*.
%
%      DELETEME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELETEME.M with the given input arguments.
%
%      DELETEME('Property','Value',...) creates a new DELETEME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before deleteme_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to deleteme_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help deleteme

% Last Modified by GUIDE v2.5 27-Nov-2018 12:57:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @deleteme_OpeningFcn, ...
                   'gui_OutputFcn',  @deleteme_OutputFcn, ...
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


% --- Executes just before deleteme is made visible.
function deleteme_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to deleteme (see VARARGIN)

% Choose default command line output for deleteme
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes deleteme wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = deleteme_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

%Check to see if column with Q Type is being modified
Row=eventdata.Indices(1);
Col=eventdata.Indices(2);
%CellTableData=get(hObject,'userdata');
if Col==4
    %disp('changing Q Type')
    Table=get(hObject,'data');
    if strcmpi(eventdata.NewData,'Table')
        Table{Row,5}=TableShowDataText;
%        CellTableData{Row}=[0 0];
    else
        Table{Row,5}=[];
%        CellTableData{Row}=[];
    end
    set(hObject,'Data',Table);
 %   set(hObject,'userdata',CellTableData);
elseif Col==5
    if strcmpi(eventdata.PreviousData,TableShowDataText)
        Table{Row,5}=TableShowDataText;
        set(hObject,'Data',Table);
    end
end


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if not(isempty(eventdata.Indices))
    Row=eventdata.Indices(1);
    Col=eventdata.Indices(2);
    Table=get(hObject, 'Data');
    if Col==5 && strcmpi(Table{Row,5},TableShowDataText)
        TempData=get(hObject,'data');
        set(hObject,'data',[])
        set(hObject,'data',TempData)
        TableOpenClose('open',hObject,Row)
    end
end

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

function T=TableDataName
    T='Qtables';
    
function OutHandle=TableGetEditFrame(SourceTableHandle)
    Children=get(get(SourceTableHandle,'parent'),'children');
    i=find(strcmpi(get(Children,'tag'),'TableEdit'));
    OutHandle=Children(i);

function TableOpenClose(Action,SourceTableHandle, Index)
    Data=getappdata(gcf,TableDataName);
    if exist('SourceTableHandle','var')
        setappdata(gcf,'SourceTableHandle',SourceTableHandle);
    else
        SourceTableHandle=getappdata(gcf,'SourceTableHandle');
    end
    FrameHandle=TableGetEditFrame(SourceTableHandle);
    HList=get(FrameHandle,'children');
    LabelH=HList(find(strcmpi(get(HList,'tag'),'FeatureLabel')));
    TableH=HList(find(strcmpi(get(HList,'type'),'uitable')));
    if strcmpi(Action,'open')
        Childs=get(get(SourceTableHandle,'parent'),'children');
        ChildVisState=get(Childs,'visible');
        setappdata(gcf,'ChildVisState',{Childs ChildVisState})
        set(Childs,'vis','off');
        set(FrameHandle,'userdata',Index);
        if Index > length(Data)
            Data=[0 0];
        else
            if isempty(Data{Index});
                Data=[ 0 0 ];
            else
                Data=Data{Index};
            end
        end
        TableData(:,2:3)=num2cell(Data);
        for I=1:length(TableData(:,1));
            TableData{I,1}=false;
        end
        set(TableH,'data',TableData);  
        set(LabelH,'string',sprintf('Feature %i',Index))
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
    end
    
% --- Executes on button press in TableAddRow.
function TableAddRow_Callback(hObject, eventdata, handles)
% hObject    handle to TableAddRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TableH=get(get(hObject,'parent'),'children');
TableH=TableH(find(strcmpi(get(TableH,'type'),'uitable')));
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
TableGraph_Callback(hObject)

% --- Executes on button press in TableDelRow.
function TableDelRow_Callback(hObject, eventdata, handles)
% hObject    handle to TableDelRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TableH=get(get(hObject,'parent'),'children');
TableH=TableH(find(strcmpi(get(TableH,'type'),'uitable')));
Table=get(TableH,'data');
for I=length(Table(:,1)):-1:1
    if Table{I,1}
        Table=[Table(1:I-1,:); Table(I+1:end,:)];
    end
end
set(TableH,'data',Table)  
TableGraph_Callback(hObject)

% --- Executes on button press in TableClose.
function TableClose_Callback(hObject, eventdata, handles)
% hObject    handle to TableClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TableOpenClose('close')
set(get(hObject,'parent'),'visible','off')

function GraphTable (hObject)
    TableH=get(get(hObject,'parent'),'children');
    AxesH=TableH(find(strcmpi(get(TableH,'type'),'axes')));
    

% --- Executes on button press in TableGraph.
function TableGraph(hObject, eventdata, handles)
% hObject    handle to TableGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TableH=get(get(hObject,'parent'),'children');
AxesH=TableH(find(strcmpi(get(TableH,'type'),'axes')));
TableH=TableH(find(strcmpi(get(TableH,'type'),'uitable')));
Table=get(TableH,'data');
NTable=cell2mat(Table(:,2:3));
plot(AxesH,NTable(:,1),NTable(:,2))


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
TableGraph_Callback(hObject)
