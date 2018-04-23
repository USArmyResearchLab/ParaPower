function varargout = Thermal2(varargin)
% THERMAL2 MATLAB code for Thermal2.fig
%      THERMAL2, by itself, creates a new THERMAL2 or raises the existing
%      singleton*.
%
%      H = THERMAL2 returns the handle to a new THERMAL2 or the handle to
%      the existing singleton*.
%
%      THERMAL2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THERMAL2.M with the given input arguments.
%
%      THERMAL2('Property','Value',...) creates a new THERMAL2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Thermal2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Thermal2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Thermal2

% Last Modified by GUIDE v2.5 11-May-2017 09:43:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Thermal2_OpeningFcn, ...
                   'gui_OutputFcn',  @Thermal2_OutputFcn, ...
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


% --- Executes just before Thermal2 is made visible.
function Thermal2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
 
 
% varargin   command line arguments to Thermal2 (see VARARGIN)

% Choose default command line output for Thermal2
handles.output = hObject;
clc
handles.iiii=0;
handles.layerdata=get(handles.layertable,'data');                           %initialize layer data matrix
handles.envdata=get(handles.envtable,'data');                               %inililize environment data matrix
handles.layertablestatus=cellfun('isempty',handles.layerdata);               %initilaize status variable for if there is content in all data cells
handles.envdatastatus=cellfun('isempty',handles.envdata);                   %initilaize status variable for if there is content in all data cells
set(handles.unidevsizeradio,'Enable','off');                                %Turns off all features excluding system parameters, profiles, and app close
set(handles.unidevthickradio,'Enable','off');
set(handles.unipadthickradio,'Enable','off');
set(handles.concpadradio,'Enable','off');
set(handles.unipadsizeradio,'Enable','off');
set(handles.devtable,'Enable','off');
set(handles.padtable,'Enable','off');
set(handles.addpadbutt,'Enable','off');
set(handles.pubgridbutt,'Enable','off');
set(handles.layerpop,'Enable','off');
set(handles.multimatbutt,'Enable','off');
set(handles.layertable,'Enable','off');
set(handles.envtable,'Enable','off');
% set(handles.loadprofilebutt,'Enable','off');
% set(handles.profilepop,'Enable','off');
set(handles.saveprofilebutt,'Enable','off');
set(handles.runbutt,'Enable','off');
[handles.matprops,handles.matlist]=matlibfun();                             %load material property matrix and material list from function               
handles.matlist=handles.matlist';
set(handles.layertable,'columneditable',[true true],'columnformat',({handles.matlist})); %pre-define only frist two columns as editable for layer table ie. materail and thickness
guidata(hObject, handles);                                                  %update handles structure, allows for any handles. variable to be referenced from other features.

% --- Outputs from this function are returned to the command line.
function varargout = Thermal2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
varargout{1} = handles.output;


function numlayers_Callback(hObject, eventdata, handles)
% handles.numlayers=str2double(get(hObject,'String'));                        %returns contents of numlayers as a double (Number of Layers)
% guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function numlayers_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tproc_Callback(hObject, eventdata, handles)
% handles.tproc=str2double(get(hObject,'String'));                            % returns contents of tproc as a double (Processing Temperature)
% guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function tproc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function numdev_Callback(hObject, eventdata, handles)
% handles.numdev=str2double(get(hObject,'String'));                            %returns contents of numdev as a double (Number of Devices)
% guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function numdev_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in runbutt.
function runbutt_Callback(hObject, eventdata, handles)
% hObject    handle to runbutt (see GCBO)
handles.numdev=str2double(get(handles.numdev,'String'));
handles.devdata=(get(handles.devtable,'data'));
handles.paddata=(get(handles.padtable,'data'));
axes(handles.gridplot)
 chipplacement(handles.numdev,handles.devdata,handles.paddata);
% --- Executes on button press in saveprofilebutt.
function saveprofilebutt_Callback(hObject, eventdata, handles)
% hObject    handle to saveprofilebutt (see GCBO)
 
% --- Executes on selection change in profilepop.
function profilepop_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function profilepop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in loadprofilebutt.
function loadprofilebutt_Callback(hObject, eventdata, handles)
profilelist=cellstr(get(handles.profilepop,'String')); % returns matlist contents as cell array
profileselect=profilelist(get(handles.profilepop,'Value')); % returns selected profile name 
[profilelist,numlayers,NR,NC,h,kond,dx,dy,dz,Ta,cte,E,nu,Tproc,MatList,devdata,paddata,numdev,layerthick,multimatlayers] = ThermalProfiles(profileselect); %Calls existing thermal analysis profile 
set(handles.numlayers,'string',numlayers);
set(handles.numdev,'string',numdev);
set(handles.tproc,'string',Tproc);
set(handles.devtable,'data',devdata);
set(handles.padtable,'data',paddata);
handles.layerdata=get(handles.layertable,'data');
handles.layerdata=cell(length(layerthick),6);
handles.layerdata(:,1)=MatList;
handles.layerdata(:,2)=num2cell(layerthick)';
handles.envdata(1,:)=num2cell(h);
handles.envdata(2,:)=num2cell(Ta);
set(handles.envtable,'data',handles.envdata);
[handles.devrnames,handles.devcnames,handles.padrnames,handles.padcnames,handles.layerrnames, layercnames,handles.layerpoptext, envrnames, envcnames]...
    =tabledetails(numdev,numlayers);
set(handles.devtable, 'RowName',handles.devrnames,'ColumnName',handles.devcnames,'ColumnEditable',true);
set(handles.padtable, 'RowName',handles.padrnames,'ColumnName',handles.padcnames,'ColumnEditable',true);
set(handles.layertable, 'RowName',handles.layerrnames,'ColumnName',layercnames);
set(handles.envtable, 'RowName',envrnames,'ColumnName',envcnames);
set(handles.devtable,'enable','on');
set(handles.padtable,'enable','on');
set(handles.layertable,'enable','on');
handles.multimatlayers=multimatlayers;
[handles.multimatindex y] = ind2sub(size(handles.multimatlayers),find(handles.multimatlayers==1));
% handles.layerdata(handles.multimatindex+2:end+1,1:end)=handles.layerdata(handles.multimatindex+1:end,1:end);
% handles.layerdata(handles.multimatindex:handles.multimatindex+1,:)=({[]});
c=length(handles.multimatindex);
d=0;
for i=1:numlayers+c
    matlocation=strcmp(handles.matlist,handles.layerdata(i,1));                              %Finds material location in material library matrix
matmatrix = matlocation*handles.matprops;                                      %Creats matrix with only values of selected materail, all others are equal to zero
matrow=removeconstantrows(matmatrix); 
for ii=3:6                                                                   %ittereations used between columns #:#
    handles.layerdata(i,ii)=num2cell(matrow(1,ii-2));                          %inputs material properties for the selected layer in columns #:#
end
end
set(handles.layertable,'data',handles.layerdata);                                        %Publishes solution parameters into gui table

for i=1:c
    ii=0.1;
    handles.layerrnames(handles.multimatindex(i,1)+2:end+1,1:end)=handles.layerrnames(handles.multimatindex(i,1)+1:end,1:end);
    s=handles.multimatindex(i,1);
    for z=1:2
    x=cell(1);
    x{1,1}=['Layer ' num2str(s+ii)];
    handles.layerrnames(s-1+z+d,1)=x;
    ii=ii+0.1;
    end
    d=d+1;
end
set(handles.layerpop,'String',handles.layerrnames);
set(handles.layertable,'data',handles.layerdata,'RowName', handles.layerrnames);
set(handles.runbutt,'enable','on');

% --- Executes on button press in concpadradio.
function concpadradio_Callback(hObject, eventdata, handles)
if  get(hObject,'Value')==0                                                 %if concentric pad radio button is off allow for all pad columns in table to be editable
    set(handles.padtable,'ColumnEditable',true);
end
if get(hObject,'Value')==1
    handles.paddata(:,1)=handles.devdata(:,1);                              %if concentric pad radio button is selected X,Y-Coor. will be determined from X,Y-Coor. of respective devices
    handles.paddata(:,2)=handles.devdata(:,2);
    set(handles.padtable,'data',handles.paddata,'ColumnEditable',[false false]); %restrict X,Y-Coor of pads to be edited
end
guidata(hObject,handles)                                                    %update handles
% --- Executes on button press in unidevthickradio.
function unidevthickradio_Callback(hObject, eventdata, handles)
if  get(hObject,'Value')==1                                                 %if uniform device thickness radio button is on set all devices equal to value in row 1
    handles.devdata(:,3)=handles.devdata(1,3);                              
    set(handles.devtable,'data',handles.devdata);                           %publish updated data
end
guidata(hObject,handles)                                                    %update handles
% --- Executes on button press in unipadsizeradio.
function unipadsizeradio_Callback(hObject, eventdata, handles)
if  get(hObject,'Value')==1                                                 %if uniform pad size radio button is on set all pad length and width equal to value in row 1
    disp('yes')
    handles.paddata(:,4)=handles.paddata(1,4);   
    handles.paddata(:,5)=handles.paddata(1,5);                              
    set(handles.padtable,'data',handles.paddata);                           %publish updated data
end
guidata(hObject,handles) 

% --- Executes on button press in unidevsizeradio.
function unidevsizeradio_Callback(hObject, eventdata, handles)
if  get(hObject,'Value')==1                                                 %if uniform device size radio button is on set all device length and width equal to value in row 1
    handles.devdata(:,4)=handles.devdata(1,4);   
    handles.devdata(:,5)=handles.devdata(1,5);                              
    set(handles.devtable,'data',handles.devdata);                           %publish updated data
end
guidata(hObject,handles) 

function unipadthickradio_Callback(hObject, eventdata, handles)
if  get(hObject,'Value')==1                                                 %if uniform pad thickness radio button is on set all pads equal to value in row 1
    handles.paddata(:,3)=handles.paddata(1,3);                              
    set(handles.padtable,'data',handles.paddata);                           %publish updated data
end
guidata(hObject,handles) 

% --- Executes on button press in pubgridbutt.
function pubgridbutt_Callback(hObject, eventdata, handles)
set(handles.layerpop,'Enable','on');
set(handles.multimatbutt,'Enable','on');
set(handles.layertable,'Enable','on');
set(handles.envtable,'Enable','on');
set(handles.envtable,'ColumnEditable',true);
guidata(hObject,handles);

% --- Executes on button press in sysconfbutt.
function sysconfbutt_Callback(hObject, eventdata, handles)
% hObject    handle to sysconfbutt (see GCBO) 
if  strcmp(get(handles.sysconfbutt,'String'),'Publish')==1;
%     handles.chipdata=get(handles.chiptable,'data')
%     handles.chipdata=cell2mat(handles.chipdata);
%     handles.paddata=get(handles.padtable,'data');
%     handles.paddata=cell2mat(handles.paddata)
%     pad=handles.paddata
%     chip=handles.chipdata
%     cla(handles.chipplot,'reset')
%     axes(handles.chipplot)
%     chipplacement(handles.numchips,handles.chipdata,handles.paddata);
% set(handles.chippush,'String','Confirm');
else
[handles.devrnames,handles.devcnames,handles.padrnames,handles.padcnames,handles.layerrnames, layercnames,handles.layerpoptext, envrnames, envcnames]...
    =tabledetails(handles.numdev,handles.numlayers);
set(handles.devtable, 'RowName',handles.devrnames,'ColumnName',handles.devcnames,'ColumnEditable',true);
set(handles.padtable, 'RowName',handles.padrnames,'ColumnName',handles.padcnames,'ColumnEditable',true);
set(handles.layertable, 'RowName',handles.layerrnames,'ColumnName',layercnames);
set(handles.envtable, 'RowName',envrnames,'ColumnName',envcnames);
handles.devdata=cell(length(handles.devrnames),length(handles.devcnames));
handles.paddata=cell(length(handles.padrnames),length(handles.padcnames));
handles.layerdata=cell(handles.numlayers,length(layercnames));
handles.envdata=cell(length(envrnames),length(envcnames));
% handles.matlist=handles.matlist';
% handles.layertext=layertext(handles.numlayers);                             %define the text used to fill pop up menu based on the number of layers entered
set(handles.layerpop,'String',handles.layerpoptext(:,:));                  %load layer names into layer table based on how many layers have been entered

set(handles.devtable,'data',handles.devdata);                               %empty all data tables
set(handles.padtable,'data',handles.paddata); 
set(handles.layertable,'data',handles.layerdata);
set(handles.envtable,'data',handles.envdata);
set(handles.devtable,'Enable','on');                                        %turn on device layout features 
set(handles.padtable,'Enable','on');
set(handles.unidevsizeradio,'Enable','on');
set(handles.unidevthickradio,'Enable','on');
set(handles.unipadthickradio,'Enable','on');
set(handles.concpadradio,'Enable','on');
set(handles.unipadsizeradio,'Enable','on');
set(handles.addpadbutt,'Enable','on');
set(handles.pubgridbutt,'Enable','on');
set(handles.sysconfbutt,'String','Update System');
guidata(hObject,handles)
end
guidata(hObject,handles)

% --- Executes on selection change in layerpop.
function layerpop_Callback(hObject, eventdata, handles)
% hObject    handle to layerpop (see GCBO)
layerlist = cellstr(get(handles.layerpop,'String')); % returns layerpop contents as cell array
handles.layerselect=layerlist{get(handles.layerpop,'Value')}; %return selection from layerpop
layerselectAdj=strrep(handles.layerselect,'Layer ',''); %replaces layer list with string value of layer number
handles.selectedvalue=str2num(layerselectAdj);% selectedvalue=str2num(layerselectAdj{1,1}); %Layer number from selection
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function layerpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layerpop (see GCBO)
 
 

% Hint: popupmenu controls usually have a white background on Windows.
 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in multimatbutt.
function multimatbutt_Callback(hObject, eventdata, handles)                          %Publishes solution parameters into gui table
layercellselect=cellstr(handles.layerrnames{get(handles.layerpop,'Value')});             %return selection from layerpop                                 
handles.layerdata=get(handles.layertable,'data');
handles.layerrnames=get(handles.layertable,'RowName');
layerlocation=strcmp(layercellselect{1,1},handles.layerrnames) ;           %compares layer selection with table to deterime location of match
[handles.layerindex y] = ind2sub(size(layerlocation),find(layerlocation==1)); %returns index location of the selected layer
% sam=handles.layerindex
% y
handles.layerdata(handles.layerindex+2:end+1,1:end)=handles.layerdata(handles.layerindex+1:end,1:end);
handles.layerdata(handles.layerindex:handles.layerindex+1,:)=({[]});
handles.layerrnames(handles.layerindex+2:end+1,1:end)=handles.layerrnames(handles.layerindex+1:end,1:end);
ii=0.1;
    for i=1:2
        x=cell(1);
        x{1,1}=['Layer ' num2str(handles.selectedvalue+ii)]
        handles.layerrnames(handles.layerindex-1+i,1)=x
        ii=ii+0.1;
        if i==2
            handles.iiii=handles.iiii+1;
        end
    end
%    p=handles.layerindex
%    c=handles.layerrnames
set(handles.layerpop,'String',handles.layerrnames);
set(handles.layertable,'data',handles.layerdata,'RowName', handles.layerrnames);
guidata(hObject,handles)


function devtable_CellEditCallback(hObject, eventdata, handles)
handles.devdata=get(handles.devtable,'data');
if get(handles.unidevthickradio,'Value')==1
    handles.devdata(:,3)=handles.devdata(1,3);
    set(handles.devtable,'data',handles.devdata);
end
if get(handles.unidevsizeradio,'Value')==1
    handles.devdata(:,4)=handles.devdata(1,4);
    handles.devdata(:,5)=handles.devdata(1,5);
    set(handles.devtable,'data',handles.devdata);
end
if get(handles.concpadradio,'Value')==1
    handles.paddata(:,1)=handles.devdata(:,1);
    handles.paddata(:,2)=handles.devdata(:,2);
    set(handles.padtable,'data',handles.paddata,'ColumnEditable',[false false]);
end
guidata(hObject,handles)

function padtable_CellEditCallback(hObject, eventdata, handles)
% handles.devdata=get(handles.devtable,'data');
handles.paddata=get(handles.padtable,'data');
if get(handles.unipadthickradio,'Value')==1
    handles.paddata(:,3)=handles.paddata(1,3);
    set(handles.padtable,'data',handles.paddata);
end
if get(handles.unipadsizeradio,'Value')==1
    handles.paddata(:,4)=handles.paddata(1,4);
    handles.paddata(:,5)=handles.paddata(1,5);
    set(handles.padtable,'data',handles.paddata);
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function envtable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to envtable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(hObject,'Data', cell(2,6), 'RowName', {'h', 'Ta'}, 'ColumnName', {'Left', 'Right', 'Front','Back','Top','Bottom'},'ColumnWidth',{45 45 45 45 45 45});
%     set(handles.envtable,'ColumnEditable',true);

% --- Executes on button press in addpadbutt.
function addpadbutt_Callback(hObject, eventdata, handles)
% hObject    handle to addpadbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function layertable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layertable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(hObject, 'Data', cell(2,6));
% set(hObject, 'RowName', {'h', 'Ta'}, 'ColumnName', {'Left', 'Right', 'Front','Back','Top','Bottom'},'ColumnWidth',{45 45 45 45 45 45});
% strcmp(handles.layerdata(1,1
% t = hObject;
% s = sprintf('UITable tooltip line 1\nUITable tooltip line 2');
% t.TooltipString = s;

% --- Executes on button press in closebutt.
function closebutt_Callback(hObject, eventdata, handles)
clear all;close all;clc


% --- Executes when selected cell(s) is changed in layertable.
function layertable_CellSelectionCallback(hObject, eventdata, handles)

% --- Executes when entered data in editable cell(s) in layertable.
function layertable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to layertable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
handles.layerdata=get(hObject,'data');
matselect=handles.layerdata(eventdata.Indices(1,1));
matlocation=strcmp(handles.matlist,matselect);                              %Finds material location in material library matrix
matmatrix = matlocation*handles.matprops;                                      %Creats matrix with only values of selected materail, all others are equal to zero
matrow=removeconstantrows(matmatrix);          
if eventdata.Indices(1,2)==1 %Check that cell selection has been made in column 1 for materials
for i=3:6                                                                   %ittereations used between columns #:#
    handles.layerdata(eventdata.Indices(1,1),i)=num2cell(matrow(1,i-2));                          %inputs material properties for the selected layer in columns #:#
end
end
set(handles.layertable,'data',handles.layerdata);                                        %Publishes solution parameters into gui table
handles.layertablestatus=cellfun('isempty',handles.layerdata)
if any(handles.envdatastatus(:))==0 && any(handles.layertablestatus(:))==0
    set(handles.runbutt,'Enable','on');
end
guidata(hObject,handles)


% --- Executes when entered data in editable cell(s) in envtable.
function envtable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to envtable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
% handles.envdata=get(handles.hObject,'data');
% disp(handles.envdata)
% guidata(hObject,handles)
handles.envdata=get(handles.envtable,'data');
handles.envdatastatus=cellfun('isempty',handles.envdata);
if any(handles.envdatastatus(:))==0 && any(handles.layertablestatus(:))==0
    set(handles.runbutt,'Enable','on');
end
guidata(hObject,handles)

% --- Executes when selected cell(s) is changed in envtable.
function envtable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to envtable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% handles.envdata=get(handles.envtable,'data');
% guidata(hObject,handles)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over concpadradio.
function concpadradio_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to concpadradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if  get(hObject,'Value')==0                                                 %if concentric pad radio button is off allow for all pad columns in table to be editable
    set(handles.padtable,'ColumnEditable',true);
    disp('no')
else
    disp('yes')
    handles.paddata(:,1)=handles.devdata(:,1);                              %if concentric pad radio button is selected X,Y-Coor. will be determined from X,Y-Coor. of respective devices
    handles.paddata(:,2)=handles.devdata(:,2);
    set(handles.padtable,'data',handles.paddata,'ColumnEditable',[false false]); %restrict X,Y-Coor of pads to be edited
end
guidata(hObject,handles)                                                    %update handles
