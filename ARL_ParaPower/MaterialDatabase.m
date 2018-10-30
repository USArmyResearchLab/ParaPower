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

% Last Modified by GUIDE v2.5 29-Oct-2018 23:51:30

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
set(handles.MatDbaseFigure,'windowstyle','modal');
set(handles.MatDatabaseGroup,'vis','on')
set(handles.ErrorPanel,'vis','off')
DefFname='DefaultMaterials';
if exist([DefFname '.mat'],'file')==2
    load(DefFname,'MatDbase')
    set(handles.MatTable,'Data',MatDbase);
    GUIColNames=get(handles.MatTable,'columnname');
    PopulateMatLib(handles, MatDbase, GUIColNames);
else
    disp(['No default material database loaded. (' DefFname '.mat)'])
    PopulateMatLib(handles, MatDbase, GUIColNames);
end

% --- Outputs from this function are returned to the command line.
function varargout = MaterialDatabase_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function index=GetMatPropIndex(Prop)
%Returns the index number for the specified material property\
    Prop=strtrim(Prop);
    Pl=length(Prop);
    strleft=@(S,n) S(1:min(n,length(S)));
	switch lower(Prop)
		case strleft('cte',Pl)
			index=2;
		case strleft('k_s',Pl)
			index=1;
		case strleft('e',Pl)
			index=3;
		case strleft('nu',Pl)
			index=4;
		case strleft('dens_s',Pl)
			index=5;
		case strleft('cp_s',Pl)
			index=6;
		case strleft('pcm',Pl)
			index=7;
		case strleft('k_l',Pl)
			index=8;
		case strleft('dens_l',Pl)
			index=9;
		case strleft('cp_l',Pl)
			index=10;
		case strleft('lw',Pl)
			index=11;
		case strleft('tmelt',Pl)
			index=12;
		case strleft('color',Pl)
			index=13;
        case strleft('h_ibc',Pl)
            index=1;
        case strleft('t_ibc',Pl)
            index=2;
		case strleft('ibcnum',Pl)
			index=3;
		case strleft('matnum',Pl)
			index=14;
		case strleft('material',Pl)
			index=0;
		case strleft('pcm',Pl)
			index=[];
		case strleft('ibc',Pl)
			index=[];
		case strleft('nummatprops',Pl)
			index=14;  %This needs to be adjusted each time the number of properties changes
		case strleft('numibcprops',Pl)
			index=3;  %This needs to be adjusted each time the number of properties changes
        otherwise
			error(['Material property "' Prop '" not known.']);
			index=GetMatPropIndex;
    end
    
	
% --- Executes on button press in MatClose.
function MatClose_Callback(hObject, eventdata, handles)
% hObject    handle to MatClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MatDbase=get(handles.MatTable,'Data');
Mats=stripmsb(MatDbase(:,1));
Mats=Mats(~strcmp(Mats,''));
ErrorText={};
strleft=@(S,n) S(1:min(n,length(S)));

if length(Mats)==length(unique(upper(Mats)))
	GUIColNames=get(handles.MatTable,'columnname');
    PopulateMatLib(handles, MatDbase, GUIColNames);
else
    ErrorText{end+1}='Duplicate material name.  All material names must be unique.';
end

if length(ErrorText) > 0 
    TempTxt='';
    for I=1:length(ErrorText)
        TempTxt=[TempTxt char(10) ErrorText{I}];
    end
    set(handles.ErrorMsg,'string',TempTxt)
    set(handles.ErrorPanel,'vis','on');
else
    set(handles.MatDbaseFigure,'visible','off')
    %set(handles.MatDbaseFigure,'windowstyle','normal');
    uiresume
end
  

function Str=stripmsb(Str)
    if iscell(Str)
        for I=1:length(Str)
            Stemp=Str{I};
            l=min(find(Stemp~=' '));
            r=max(find(Stemp~=' '));
            Stemp=Stemp(l:r);
            Str{I}=Stemp;
        end
	else
        l=min(find(Str~=' '));
        r=max(find(Str~=' '));
        Str=Str(l:r);
    end  

% --- Executes on button press in ErrorOKButton.
function ErrorOKButton_Callback(hObject, eventdata, handles)
% hObject    handle to ErrorOKButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ErrorPanel,'vis','off')



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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
IsIBCCol=find(strcmpi(GUIColNames,'IBC'));
IBCs=find(cell2mat(MatDbase(:,IsIBCCol)));
for i=IBCs'
    MatDbase(i,:)=MatDbase(end,:);
end
set(handles.MatTable,'Data',MatDbase);
    
% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,path]=uigetfile('*.mat','Load Material Database');
if fname ~= 0
    load([path fname],'MatDbase');  
    set(handles.MatTable,'Data',MatDbase);
end

% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,path]=uiputfile('*.mat','Save Material Database');
if fname ~= 0
    MatDbase=get(handles.MatTable,'Data');  
    save([path fname],'MatDbase');
end

% --- Executes when user attempts to close MatDbaseFigure.
function MatDbaseFigure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MatDbaseFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
MatClose_Callback(hObject, eventdata, handles)
set(hObject,'visible','off');

function MatLib=PopulateMatLib(handles, MatDbase, GUIColNames)

	IBCNum=0;
	MatNum=0;
    GUIColNames=strip(GUIColNames);
	IsIBCCol=find(strcmpi(GUIColNames,'IBC'));
    AvailMats=find(not(strcmpi('',MatDbase(:,1))));
    MatDbase=MatDbase(AvailMats,:);
	Mats=find(not(cell2mat(MatDbase(:,IsIBCCol))));
	IBCs=find(cell2mat(MatDbase(:,IsIBCCol)));
	matprops=NaN*ones(length(Mats),GetMatPropIndex('NumMatProps'));
	IBCprops=NaN*ones(length(IBCs),GetMatPropIndex('NumIBCProps'));
    IBClist=[];
    if not(isempty(Mats))
        for Imat=Mats'
            MatNum=find(Imat==Mats);
            for Icol=1:length(GUIColNames)
                if not(isempty(MatDbase{Imat,Icol}))
                    ColTitle=GUIColNames{Icol};
                    spaceI=findstr(ColTitle,' ');
                    if not(isempty(spaceI))
                        ColTitle=ColTitle(1:spaceI);
                    end
                    PropIndex=GetMatPropIndex(ColTitle);
                    if PropIndex==0
                        matlist{MatNum}=MatDbase{Imat,Icol};
                        matprops(MatNum,GetMatPropIndex('matnum'))=MatNum;
                    elseif not(isempty(PropIndex))
                        matprops(MatNum,PropIndex)=MatDbase{Imat,Icol};
                    end
                end
            end
        end
    end
    if not(isempty(IBCs))
        for Iibc=IBCs'
            IBCNum=find(Iibc==IBCs);
            for Icol=[1 find(strcmpi(GUIColNames,'H_ibc')) find(strcmpi(GUIColNames,'T_ibc'))]
                if not(isempty(MatDbase{Iibc,Icol}))
                    ColTitle=GUIColNames{Icol};
                    spaceI=findstr(ColTitle,' ');
                    if not(isempty(spaceI))
                        ColTitle=ColTitle(1:spaceI);
                    end
                    PropIndex=GetMatPropIndex(ColTitle);
                    if PropIndex==0
                        IBClist{IBCNum}=MatDbase{Iibc,Icol};
                        IBCprops(IBCNum,GetMatPropIndex('ibcnum'))=-IBCNum;
                    elseif not(isempty(PropIndex))
                         IBCprops(IBCNum,PropIndex)=MatDbase{Iibc,Icol};
                    end
                    
                    %if PropIndex~=0 && not(isempty(PropIndex))
                    %    IBCprops(IBCNum,GetMatPropIndex(strleft(GUIColNames(Icol),4)))=MatDbase{Imat,Icol};
                    %end
                end
            end
        end
    end
	
    MatLib.matprops=matprops;
    MatLib.matlist=matlist;
    MatLib.matcolors=[];
    MatLib.kond=matprops(:,GetMatPropIndex('k_s'));
    MatLib.cte=matprops(:,GetMatPropIndex('cte'));
    MatLib.E=matprops(:,GetMatPropIndex('E'));
    MatLib.nu=matprops(:,GetMatPropIndex('nu'));
    MatLib.rho=matprops(:,GetMatPropIndex('dens_s'));
    MatLib.spht=matprops(:,GetMatPropIndex('cp_s'));
    MatLib.ibcprops=IBCprops;
    MatLib.ibclist=IBClist;
    setappdata(handles.output,'Materials',MatLib);


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
Text{end+1}='It is called using the following command:';
Text{end+1}='   F=MaterialDatabase;';
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
Text{end+1}='If properties are added to the materials, the ''GetMatPropIndex''';
Text{end+1}='to be updated.';

TextOutput='';
for I=1:length(Text)
    TextOutput=[TextOutput Text{I}  char(10)];
end
msgbox(TextOutput,'Help','modal');
