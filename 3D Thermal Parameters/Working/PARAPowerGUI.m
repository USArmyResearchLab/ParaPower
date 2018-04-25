function varargout = ParaPowerGUI(varargin)
%{    
    HOW TO CREATE A NEW TAB
    1. Create or copy PANEL and TEXT objects in GUI
    2. Rename tag of PANEL to "tabNPanel" and TEXT for "tabNtext", where N
    - is a sequential number. 
    Example: tab3Panel, tab3text, tab4Panel, tab4text etc.  
    3. Add to Tab Code - Settings in m-file of GUI a name of. the tab to
    TabNames variable
    Version: 1.0
    First created: January 18, 2016
    Last modified: January 18, 2016
    Author: WFAToolbox (http://wfatoolbox.com)
%}

% Begin initialization cde - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ThermalParameterV1_OpeningFcn, ...
                   'gui_OutputFcn',  @ThermalParameterV1_OutputFcn, ...
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

% --- Executes just before ThermalParameterV1 is made visible.
function ThermalParameterV1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ThermalParameterV1 (see VARARGIN)
% set(handles.tab4text,'enable','off')
% Choose default command line output for ThermalParameterV1
handles.output = hObject;
% set(handles.loadprofilepop,'String',popdetails());
handles.delta_t=0;
handles.transteps=1;
handles.TempResults=zeros(1,1);
handles.StressResults=zeros(1,1);
handles.removeencap=get(handles.removeencapradio,'value');
set(handles.autoconstbaseradio,'enable','off')
handles.basefiggroup=[handles.PCbaseradio, handles.autoconstbaseradio handles.basegeotable];
handles.sysgeogroup=[handles.solutionstatic, handles.viewsystembutt, handles.savesysplot];
handles.layerslicegroup=[handles.solutionstatic,handles.devmeshdensitystatic,handles.devmeshslider,handles.savelayerplot,handles.viewlayerbutt,handles.plotpop,handles.layerslicestatic];
handles.constgroup=[handles.featconsttxt handles.addfeatconstbutt handles.removefeatconstbutt handles.featconsttable handles.sysconsttxt handles.addsysconstbutt handles.removesysconstbutt handles.sysconsttable];
handles.bcgroup=[handles.featconsttxt handles.addfeatbcbutt handles.removefeatbcbutt handles.sysconsttxt handles.sysbcaddbutt handles.sysbcremovebutt handles.featbctable handles.sysbctable];
handles.paragroup=[handles.featparatxt handles.addgeoparabutt handles.removegeoparabutt handles.sysparatxt handles.addassortparabutt handles.removeassortparabutt handles.matparatxt handles.addmatparabutt handles.removematparabutt handles.geoparatable handles.assortparatable handles.matparatable];
handles.resultsgroup=[handles.dispmodeltxt handles.solutionpop handles.viewsolutionbutt handles.viewallresultsbutt handles.loopradio handles.highlightsolradio handles.removeencaptxt handles.removeencapradio handles.saveresultsbutt handles.plotresultsstatic handles.resultplotpop handles.saveresultplot handles.resultstable];
set(handles.resultsgroup,'enable','off')
set(handles.sysgeogroup,'enable','off')
set(handles.basefiggroup,'enable','off')
set(handles.bcgroup,'enable','off')
set(handles.layerslicegroup,'enable','off')
set(handles.paragroup,'enable','off')

set(handles.constgroup,'enable','off')
set(handles.envtable,'enable','off');
set(handles.layertable,'enable','off');
% set(handles.runbutt,'enable','off');

% set(handles.basegeotable,'enable','off');
% set(handles.envtable,'enable','off');

% set(handles.layout1numfeatstatic,'enable','off');
% set(handles.layout1numfeatedit,'enable','off');
% set(handles.layout1confbutt,'enable','off');
% set(handles.layout1feattable,'enable','off');
% set(handles.layout1geotable,'enable','off');
% set(handles.layout1confquant,'enable','off');
% set(handles.clearlayout1butt,'enable','off');
% set(handles.layer1geotipstatic,'enable','off');
% set(handles.saveprofbutt,'enable','off');
% set(handles.saveprofedit,'enable','off');

% axes(handles.imagetl);
% imshow('US_Army_logo_and_RDECOM.jpg');
% axes(handles.imagebl)
% imshow('arl_logo.jpg');
handles.tabstatus=zeros(1,8);
set(handles.tab9radio,'Value',0);
set(handles.tab8radio,'Value',0);
[handles.matprops,handles.matlist,handles.matcolors,handles.kond,handles.cte,handles.E,handles.nu,handles.rho,handles.spht]=matlibfun();                             %load material property matrix and material list from function               
[handles.basernames,handles.layerrnames, handles.layercnames, handles.envrnames, handles.envcnames,handles.geornames,handles.featcnames,handles.geocnames, handles.layoutpop,handles.basecnames,handles.basePCcnames,handles.paracnames,handles.pararnames,handles.matparacnames,handles.matparatype,handles.bccnames,handles.bcrnames,...
    handles.featbctype,handles.sysbctype,handles.geoparatype,handles.assortedparatype,handles.msm,handles.NA,handles.bcfeat,handles.proftemplate,handles.solutionpoptxt,handles.constcnames,handles.featconsttype,handles.sysconsttype,handles.resultsrnames,handles.resultpoptxt]= tables();
handles.layoutpopactive=handles.layoutpop(2,1);
set(handles.resultplotpop,'string',handles.resultpoptxt,'value',1)
set(handles.basegeotable,'columneditable',true ,'columnformat',({'logical' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'}),'RowName',handles.basernames,'ColumnName',handles.basecnames);
set(handles.envtable,'columnformat',{'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'},'RowName',handles.envrnames,'ColumnName',handles.envcnames,'columneditable',true);
set(handles.layertable,'columneditable',[true true true],'columnformat',({handles.matlist' 'numeric' handles.layoutpopactive'}),'RowName',handles.layerrnames,'ColumnName',handles.layercnames); %pre-define only frist two columns as editable for layer table ie. materail and thickness
set(handles.geoparatable,'columneditable',true,'columnformat',({handles.geoparatype handles.NA handles.NA 'numeric' 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName',handles.paracnames);
handles.assortedpara=[handles.NA; handles.layerrnames; handles.envrnames]';
set(handles.assortparatable,'columneditable',true,'columnformat',({handles.assortedparatype handles.assortedpara handles.assortedpara 'numeric' 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName',handles.paracnames);
set(handles.matparatable,'columneditable',true,'columnformat',({handles.layerrnames' handles.matlist' ['N/A',handles.matparatype] 'numeric' 'numeric' 'numeric'}),'ColumnName',handles.matparacnames,'RowName',handles.pararnames);

set(handles.featbctable,'columneditable',true,'columnformat',({handles.featbctype handles.bcfeat handles.bcfeat 'numeric' 'numeric'}),'RowName',handles.bcrnames,'columnname',handles.bccnames);
set(handles.sysbctable,'columneditable',true,'columnformat',({handles.sysbctype handles.bcfeat handles.bcfeat 'numeric' 'numeric'}),'RowName',handles.bcrnames,'columnname',handles.bccnames);
set(handles.resultstable,'columneditable',false,'columnname',handles.resultsrnames);

set(handles.featconsttable,'columneditable',true,'columnformat',({handles.featconsttype handles.NA handles.NA 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName', handles.constcnames);
set(handles.sysconsttable,'columneditable',true,'columnformat',({handles.sysconsttype handles.NA handles.NA 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName', handles.constcnames);

%----Initialize Layout Tabs
for i=1:6
%     if i==2
%     else
    n=num2str(i);
    set(handles.(['tab',n,'radio']),'value',0);
    set(handles.(['layout',n,'feattable']),'columneditable',true,'RowName',handles.geornames,'ColumnName',handles.featcnames,'enable','off');
    set(handles.(['layout',n,'geotable']),'columneditable',[true true true true true true],'columnformat',({handles.matlist' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'}),'RowName',handles.geornames,'ColumnName',handles.geocnames,'enable','off');
    handles.(['layout',n,'featdata'])=get(handles.(['layout',n,'feattable']),'data');
    handles.(['layout',n,'geodata'])=get(handles.(['layout',n,'geotable']),'data');
    set(handles.(['layout',n,'numfeatedit']),'enable','off');
    set(handles.(['layout',n,'confbutt']),'enable','off')
    set(handles.(['layout',n,'confquant']),'enable','off')
    set(handles.(['clearlayout',n,'butt']),'enable','off')
%     end
% handles.layer1geodata=get(handles.layout1geotable,'data');
end
% handles.layer1featdata=get(handles.layout1geotable,'data');
% handles.layer1geodata=get(handles.layout1geotable,'data');

handles.resultplotname=handles.resultpoptxt{1,1};

%% Tabs Code
% Settings
TabFontSize = 10;
TabNames = {'Layout 1','Layout 2','Layout 3','Layout 4','Layout 5','Layout 6','Constraints','Boundary Cond.','Parameters','Groupings','Results'};
% FigWidth = 0.265;
% FigWidth = .625;                                                            % Width of the GUI window
FigWidth = 0.74; 
% handles.FigHeight=0.3;
% Figure resize
set(handles.SimpleOptimizedTab,'Units','normalized')
pos = get(handles.SimpleOptimizedTab, 'Position');
% pos(1)=1
% pos(2)=1
% pos(4)=1;
% handles.pos=pos;
set(handles.tab1Panel,'Units','normalized')
% n='1'
% pan1pos=[ .2    .2  0.5    0.5]
%  set(handles.(['tab',n,'Panel']),'Position',pan1pos)
% set(handles.SimpleOptimizedTab, 'Position', [pos(1) pos(2) FigWidth+0.035 pos(4)]) % [left up width height] Position on screen
set(handles.SimpleOptimizedTab, 'Position', [pos(1) pos(2) FigWidth+0.035 pos(4)]) % [left up width height] Position on screen


% Tabs Execution
handles = TabsFun(handles,TabFontSize,TabNames);


% Update handles structure
guidata(hObject, handles);

% --- TabsFun creates axes and text objects for tabs
function handles = TabsFun(handles,TabFontSize,TabNames)

% Set the colors indicating a selected/unselected tab
handles.selectedTabColor=get(handles.tab1Panel,'BackgroundColor');
handles.unselectedTabColor=handles.selectedTabColor-0.1;

% Create Tabs
TabsNumber = length(TabNames);                                              % determines the number of tabs from length of cell array
handles.TabsNumber = TabsNumber;
TabColor = handles.selectedTabColor;
% TabsNumber=TabsNumber-1
% handles.TabsNumber = TabsNumber;
%  TabNames=TabNames(1:end-1)
for i = 1:TabsNumber
    n = num2str(i);
    % Get text objects position
    set(handles.(['tab',n,'text']),'Units','normalized')
    pos=get(handles.(['tab',n,'text']),'Position');
% if i==7
%     pos(1)=pos(1)+0.025;
% end
% pos(1)-pos(2)
    % Create axes with callback function Tab Feautres
    handles.(['a',n]) = axes('Units','normalized',...
                    'Box','on',...
                    'XTick',[],...
                    'YTick',[],...
                    'Color',TabColor,...
                    'Position',[pos(1) pos(2) pos(3) pos(4)],...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);
% %       'Position',[0.001+pos(1)+i/250-0.002 pos(2) pos(3)+0.02 pos(4)+0.01],...              
%  'Position',[pos(3)+0.05,pos(2)/2+pos(4)],...
    % Create text with callback function Tab text features
    handles.(['t',n]) = text('String',TabNames{i},...
                    'Units','normalized',...
                    'Position',[pos(3),pos(4)],...
                    'HorizontalAlignment','left',...
                    'VerticalAlignment','bottom',...
                    'Margin',.00001,...
                    'FontSize',TabFontSize,...
                    'Backgroundcolor',TabColor,...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);

    TabColor = handles.unselectedTabColor;
end
            
% Manage panels (place them in the correct position and manage visibilities)
set(handles.tab1Panel,'Units','normalized');
pan1pos=get(handles.tab1Panel,'Position');                                  % retrieves position of panel 1, used to place all additonal panels
pan1pos(3)=0.58;
tab1pos=get(handles.tab1text,'position');
tab11pos=get(handles.tab11text,'position');
pan1pos(1)=tab1pos(1);
pan1pos(3)=tab11pos(1)+tab11pos(3)-tab1pos(1);

set(handles.(['tab','1','Panel']),'Position',pan1pos);
pan1pos=get(handles.tab1Panel,'Position'); 
% pan1pos(4)=handles.FigHeight;
% pan1pos=[ 0    0  0.5    0.5]
set(handles.tab1text,'Visible','off')
for i = 2:TabsNumber
    n = num2str(i);
    set(handles.(['tab',n,'Panel']),'Units','normalized')
    set(handles.(['tab',n,'Panel']),'Position',pan1pos)
    set(handles.(['tab',n,'Panel']),'Visible','off')
    set(handles.(['tab',n,'text']),'Visible','off')
end

function ClickOnTab(hObject,~,handles)
m = str2double(get(hObject,'Tag'));

for i = 1:handles.TabsNumber
    n = num2str(i);
    if i == m
        set(handles.(['a',n]),'Color',handles.selectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.selectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','on')
    else
        set(handles.(['a',n]),'Color',handles.unselectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.unselectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','off')
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = ThermalParameterV1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function imaget1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imaget1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate imaget1
 axes(hObject)
 imshow('arl_logo.png');

% --- Executes during object creation, after setting all properties.
function imageb1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate imageb1
 axes(hObject)
 imshow('US_Army_logo_and_RDECOM.jpg');

% --- Executes during object Creation, before destroying properties.
function tab1Panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tab1Panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes during object Creation, before destroying properties.

% --- Executes during object Creation, before destroying properties.
function tab1Panel_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to tab1Panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes during object Creation, before destroying properties.

%----Close App Callback----------------------------------------------------
function closebutt_Callback(hObject, eventdata, handles)
% hObject    handle to closebutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%     set(handles.(['tab1text']),'Visible','off')
% set(handles.tab1text,'enable','off')
% % set(handles.tab1text,'visible','off')
% set(handles.(['a1']),'visible','off')
% set(handles.layout1numfeatstatic,'visible','on')
% disp 'yes'6
%     set(handles.(['tab',n,'Panel']),'Units','normalized')
%     set(handles.(['tab',n,'Panel']),'Position',pan1pos)
%     set(handles.(['tab',n,'Panel']),'Visible','off')
%     set(handles.(['tab',n,'text']),'Visible','off')
clear all;close all;clc

