function varargout = ThermalParameterV1(varargin)
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
function ZZZZZZ
% % % % % % 
% % % % % % % % % % --- Executes just before ThermalParameterV1 is made visible.
% % % % % % % % % function ThermalParameterV1_OpeningFcn(hObject, eventdata, handles, varargin)
% % % % % % % % % % This function has no output args, see OutputFcn.
% % % % % % % % % % hObject    handle to figure
% % % % % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % % % % % varargin   command line arguments to ThermalParameterV1 (see VARARGIN)
% % % % % % % % % % set(handles.tab4text,'enable','off')
% % % % % % % % % % Choose default command line output for ThermalParameterV1
% % % % % % % % % handles.output = hObject;
% % % % % % % % % % set(handles.loadprofilepop,'String',popdetails());
% % % % % % % % % handles.delta_t=0;
% % % % % % % % % handles.transteps=1;
% % % % % % % % % handles.TempResults=zeros(1,1);
% % % % % % % % % handles.StressResults=zeros(1,1);
% % % % % % % % % handles.removeencap=get(handles.removeencapradio,'value');
% % % % % % % % % set(handles.autoconstbaseradio,'enable','off')
% % % % % % % % % handles.basefiggroup=[handles.PCbaseradio, handles.autoconstbaseradio handles.basegeotable];
% % % % % % % % % handles.sysgeogroup=[handles.solutionstatic, handles.viewsystembutt, handles.savesysplot];
% % % % % % % % % handles.layerslicegroup=[handles.solutionstatic,handles.devmeshdensitystatic,handles.devmeshslider,handles.savelayerplot,handles.viewlayerbutt,handles.plotpop,handles.layerslicestatic];
% % % % % % % % % handles.constgroup=[handles.featconsttxt handles.addfeatconstbutt handles.removefeatconstbutt handles.featconsttable handles.sysconsttxt handles.addsysconstbutt handles.removesysconstbutt handles.sysconsttable];
% % % % % % % % % handles.bcgroup=[handles.featconsttxt handles.addfeatbcbutt handles.removefeatbcbutt handles.sysconsttxt handles.sysbcaddbutt handles.sysbcremovebutt handles.featbctable handles.sysbctable];
% % % % % % % % % handles.paragroup=[handles.featparatxt handles.addgeoparabutt handles.removegeoparabutt handles.sysparatxt handles.addassortparabutt handles.removeassortparabutt handles.matparatxt handles.addmatparabutt handles.removematparabutt handles.geoparatable handles.assortparatable handles.matparatable];
% % % % % % % % % handles.resultsgroup=[handles.dispmodeltxt handles.solutionpop handles.viewsolutionbutt handles.viewallresultsbutt handles.loopradio handles.highlightsolradio handles.removeencaptxt handles.removeencapradio handles.saveresultsbutt handles.plotresultsstatic handles.resultplotpop handles.saveresultplot handles.resultstable];
% % % % % % % % % set(handles.resultsgroup,'enable','off')
% % % % % % % % % set(handles.sysgeogroup,'enable','off')
% % % % % % % % % set(handles.basefiggroup,'enable','off')
% % % % % % % % % set(handles.bcgroup,'enable','off')
% % % % % % % % % set(handles.layerslicegroup,'enable','off')
% % % % % % % % % set(handles.paragroup,'enable','off')
% % % % % % % % % 
% % % % % % % % % set(handles.constgroup,'enable','off')
% % % % % % % % % set(handles.envtable,'enable','off');
% % % % % % % % % set(handles.layertable,'enable','off');
% % % % % % % % % % set(handles.runbutt,'enable','off');
% % % % % % % % % 
% % % % % % % % % % set(handles.basegeotable,'enable','off');
% % % % % % % % % % set(handles.envtable,'enable','off');
% % % % % % % % % 
% % % % % % % % % % set(handles.layout1numfeatstatic,'enable','off');
% % % % % % % % % % set(handles.layout1numfeatedit,'enable','off');
% % % % % % % % % % set(handles.layout1confbutt,'enable','off');
% % % % % % % % % % set(handles.layout1feattable,'enable','off');
% % % % % % % % % % set(handles.layout1geotable,'enable','off');
% % % % % % % % % % set(handles.layout1confquant,'enable','off');
% % % % % % % % % % set(handles.clearlayout1butt,'enable','off');
% % % % % % % % % % set(handles.layer1geotipstatic,'enable','off');
% % % % % % % % % % set(handles.saveprofbutt,'enable','off');
% % % % % % % % % % set(handles.saveprofedit,'enable','off');
% % % % % % % % % 
% % % % % % % % % % axes(handles.imagetl);
% % % % % % % % % % imshow('US_Army_logo_and_RDECOM.jpg');
% % % % % % % % % % axes(handles.imagebl)
% % % % % % % % % % imshow('arl_logo.png');
% % % % % % % % % handles.tabstatus=zeros(1,8);
% % % % % % % % % set(handles.tab9radio,'Value',0);
% % % % % % % % % set(handles.tab8radio,'Value',0);
% % % % % % % % % [handles.matprops,handles.matlist,handles.matcolors,handles.kond,handles.cte,handles.E,handles.nu,handles.rho,handles.spht]=matlibfun();                             %load material property matrix and material list from function               
% % % % % % % % % [handles.basernames,handles.layerrnames, handles.layercnames, handles.envrnames, handles.envcnames,handles.geornames,handles.featcnames,handles.geocnames, handles.layoutpop,handles.basecnames,handles.basePCcnames,handles.paracnames,handles.pararnames,handles.matparacnames,handles.matparatype,handles.bccnames,handles.bcrnames,...
% % % % % % % % %     handles.featbctype,handles.sysbctype,handles.geoparatype,handles.assortedparatype,handles.msm,handles.NA,handles.bcfeat,handles.proftemplate,handles.solutionpoptxt,handles.constcnames,handles.featconsttype,handles.sysconsttype,handles.resultsrnames,handles.resultpoptxt]= tables();
% % % % % % % % % handles.layoutpopactive=handles.layoutpop(2,1);
% % % % % % % % % set(handles.resultplotpop,'string',handles.resultpoptxt,'value',1)
% % % % % % % % % set(handles.basegeotable,'columneditable',true ,'columnformat',({'logical' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'}),'RowName',handles.basernames,'ColumnName',handles.basecnames);
% % % % % % % % % set(handles.envtable,'columnformat',{'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'},'RowName',handles.envrnames,'ColumnName',handles.envcnames,'columneditable',true);
% % % % % % % % % set(handles.layertable,'columneditable',[true true true],'columnformat',({handles.matlist' 'numeric' handles.layoutpopactive'}),'RowName',handles.layerrnames,'ColumnName',handles.layercnames); %pre-define only frist two columns as editable for layer table ie. materail and thickness
% % % % % % % % % set(handles.geoparatable,'columneditable',true,'columnformat',({handles.geoparatype handles.NA handles.NA 'numeric' 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName',handles.paracnames);
% % % % % % % % % handles.assortedpara=[handles.NA; handles.layerrnames; handles.envrnames]';
% % % % % % % % % set(handles.assortparatable,'columneditable',true,'columnformat',({handles.assortedparatype handles.assortedpara handles.assortedpara 'numeric' 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName',handles.paracnames);
% % % % % % % % % set(handles.matparatable,'columneditable',true,'columnformat',({handles.layerrnames' handles.matlist' ['N/A',handles.matparatype] 'numeric' 'numeric' 'numeric'}),'ColumnName',handles.matparacnames,'RowName',handles.pararnames);
% % % % % % % % % 
% % % % % % % % % set(handles.featbctable,'columneditable',true,'columnformat',({handles.featbctype handles.bcfeat handles.bcfeat 'numeric' 'numeric'}),'RowName',handles.bcrnames,'columnname',handles.bccnames);
% % % % % % % % % set(handles.sysbctable,'columneditable',true,'columnformat',({handles.sysbctype handles.bcfeat handles.bcfeat 'numeric' 'numeric'}),'RowName',handles.bcrnames,'columnname',handles.bccnames);
% % % % % % % % % set(handles.resultstable,'columneditable',false,'columnname',handles.resultsrnames);
% % % % % % % % % 
% % % % % % % % % set(handles.featconsttable,'columneditable',true,'columnformat',({handles.featconsttype handles.NA handles.NA 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName', handles.constcnames);
% % % % % % % % % set(handles.sysconsttable,'columneditable',true,'columnformat',({handles.sysconsttype handles.NA handles.NA 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName', handles.constcnames);
% % % % % % % % % 
% % % % % % % % % %----Initialize Layout Tabs
% % % % % % % % % for i=1:6
% % % % % % % % % %     if i==2
% % % % % % % % % %     else
% % % % % % % % %     n=num2str(i);
% % % % % % % % %     set(handles.(['tab',n,'radio']),'value',0);
% % % % % % % % %     set(handles.(['layout',n,'feattable']),'columneditable',true,'RowName',handles.geornames,'ColumnName',handles.featcnames,'enable','off');
% % % % % % % % %     set(handles.(['layout',n,'geotable']),'columneditable',[true true true true true true],'columnformat',({handles.matlist' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'}),'RowName',handles.geornames,'ColumnName',handles.geocnames,'enable','off');
% % % % % % % % %     handles.(['layout',n,'featdata'])=get(handles.(['layout',n,'feattable']),'data');
% % % % % % % % %     handles.(['layout',n,'geodata'])=get(handles.(['layout',n,'geotable']),'data');
% % % % % % % % %     set(handles.(['layout',n,'numfeatedit']),'enable','off');
% % % % % % % % %     set(handles.(['layout',n,'confbutt']),'enable','off')
% % % % % % % % %     set(handles.(['layout',n,'confquant']),'enable','off')
% % % % % % % % %     set(handles.(['clearlayout',n,'butt']),'enable','off')
% % % % % % % % % %     end
% % % % % % % % % % handles.layer1geodata=get(handles.layout1geotable,'data');
% % % % % % % % % end
% % % % % % % % % % handles.layer1featdata=get(handles.layout1geotable,'data');
% % % % % % % % % % handles.layer1geodata=get(handles.layout1geotable,'data');
% % % % % % % % % 
% % % % % % % % % handles.resultplotname=handles.resultpoptxt{1,1};
% % % % % % % % % 
% % % % % % % % % %% Tabs Code
% % % % % % % % % % Settings
% % % % % % % % % TabFontSize = 10;
% % % % % % % % % TabNames = {'Layout 1','Layout 2','Layout 3','Layout 4','Layout 5','Layout 6','Constraints','Boundary Cond.','Parameters','Groupings','Results'};
% % % % % % % % % % FigWidth = 0.265;
% % % % % % % % % % FigWidth = .625;                                                            % Width of the GUI window
% % % % % % % % % FigWidth = 0.74; 
% % % % % % % % % % handles.FigHeight=0.3;
% % % % % % % % % % Figure resize
% % % % % % % % % set(handles.SimpleOptimizedTab,'Units','normalized')
% % % % % % % % % pos = get(handles.SimpleOptimizedTab, 'Position');
% % % % % % % % % % pos(1)=1
% % % % % % % % % % pos(2)=1
% % % % % % % % % % pos(4)=1;
% % % % % % % % % % handles.pos=pos;
% % % % % % % % % set(handles.tab1Panel,'Units','normalized')
% % % % % % % % % % n='1'
% % % % % % % % % % pan1pos=[ .2    .2  0.5    0.5]
% % % % % % % % % %  set(handles.(['tab',n,'Panel']),'Position',pan1pos)
% % % % % % % % % % set(handles.SimpleOptimizedTab, 'Position', [pos(1) pos(2) FigWidth+0.035 pos(4)]) % [left up width height] Position on screen
% % % % % % % % % set(handles.SimpleOptimizedTab, 'Position', [pos(1) pos(2) FigWidth+0.035 pos(4)]) % [left up width height] Position on screen
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % % Tabs Execution
% % % % % % % % % handles = TabsFun(handles,TabFontSize,TabNames);
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % % Update handles structure
% % % % % % % % % guidata(hObject, handles);
% % % % % % % % % 
% % % % % % % UIWAIT makes ThermalParameterV1 wait for user response (see UIRESUME)
% % % % % % % uiwait(handles.SimpleOptimizedTab);
% % % % % % 
% % % % % % % --- TabsFun creates axes and text objects for tabs
% % % % % % function handles = TabsFun(handles,TabFontSize,TabNames)
% % % % % % 
% % % % % % % Set the colors indicating a selected/unselected tab
% % % % % % handles.selectedTabColor=get(handles.tab1Panel,'BackgroundColor');
% % % % % % handles.unselectedTabColor=handles.selectedTabColor-0.1;
% % % % % % 
% % % % % % % Create Tabs
% % % % % % TabsNumber = length(TabNames);                                              % determines the number of tabs from length of cell array
% % % % % % handles.TabsNumber = TabsNumber;
% % % % % % TabColor = handles.selectedTabColor;
% % % % % % % TabsNumber=TabsNumber-1
% % % % % % % handles.TabsNumber = TabsNumber;
% % % % % % %  TabNames=TabNames(1:end-1)
% % % % % % for i = 1:TabsNumber
% % % % % %     n = num2str(i);
% % % % % %     % Get text objects position
% % % % % %     set(handles.(['tab',n,'text']),'Units','normalized')
% % % % % %     pos=get(handles.(['tab',n,'text']),'Position');
% % % % % % % if i==7
% % % % % % %     pos(1)=pos(1)+0.025;
% % % % % % % end
% % % % % % % pos(1)-pos(2)
% % % % % %     % Create axes with callback function Tab Feautres
% % % % % %     handles.(['a',n]) = axes('Units','normalized',...
% % % % % %                     'Box','on',...
% % % % % %                     'XTick',[],...
% % % % % %                     'YTick',[],...
% % % % % %                     'Color',TabColor,...
% % % % % %                     'Position',[pos(1) pos(2) pos(3) pos(4)],...
% % % % % %                     'Tag',n,...
% % % % % %                     'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);
% % % % % % % %       'Position',[0.001+pos(1)+i/250-0.002 pos(2) pos(3)+0.02 pos(4)+0.01],...              
% % % % % % %  'Position',[pos(3)+0.05,pos(2)/2+pos(4)],...
% % % % % %     % Create text with callback function Tab text features
% % % % % %     handles.(['t',n]) = text('String',TabNames{i},...
% % % % % %                     'Units','normalized',...
% % % % % %                     'Position',[pos(3),pos(4)],...
% % % % % %                     'HorizontalAlignment','left',...
% % % % % %                     'VerticalAlignment','bottom',...
% % % % % %                     'Margin',.00001,...
% % % % % %                     'FontSize',TabFontSize,...
% % % % % %                     'Backgroundcolor',TabColor,...
% % % % % %                     'Tag',n,...
% % % % % %                     'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);
% % % % % % 
% % % % % %     TabColor = handles.unselectedTabColor;
% % % % % % end
% % % % % %             
% % % % % % % Manage panels (place them in the correct position and manage visibilities)
% % % % % % set(handles.tab1Panel,'Units','normalized');
% % % % % % pan1pos=get(handles.tab1Panel,'Position');                                  % retrieves position of panel 1, used to place all additonal panels
% % % % % % pan1pos(1,3)=0.58;
% % % % % % set(handles.(['tab','1','Panel']),'Position',pan1pos);
% % % % % % pan1pos=get(handles.tab1Panel,'Position'); 
% % % % % % % pan1pos(4)=handles.FigHeight;
% % % % % % % pan1pos=[ 0    0  0.5    0.5]
% % % % % % set(handles.tab1text,'Visible','off')
% % % % % % for i = 2:TabsNumber
% % % % % %     n = num2str(i);
% % % % % %     set(handles.(['tab',n,'Panel']),'Units','normalized')
% % % % % %     set(handles.(['tab',n,'Panel']),'Position',pan1pos)
% % % % % %     set(handles.(['tab',n,'Panel']),'Visible','off')
% % % % % %     set(handles.(['tab',n,'text']),'Visible','off')
% % % % % % end
% % % % % % 
% % % % % % % --- Callback function for clicking on tab
% % % % % % function ClickOnTab(hObject,~,handles)
% % % % % % m = str2double(get(hObject,'Tag'));
% % % % % % 
% % % % % % for i = 1:handles.TabsNumber
% % % % % %     n = num2str(i);
% % % % % %     if i == m
% % % % % %         set(handles.(['a',n]),'Color',handles.selectedTabColor)
% % % % % %         set(handles.(['t',n]),'BackgroundColor',handles.selectedTabColor)
% % % % % %         set(handles.(['tab',n,'Panel']),'Visible','on')
% % % % % %     else
% % % % % %         set(handles.(['a',n]),'Color',handles.unselectedTabColor)
% % % % % %         set(handles.(['t',n]),'BackgroundColor',handles.unselectedTabColor)
% % % % % %         set(handles.(['tab',n,'Panel']),'Visible','off')
% % % % % %     end
% % % % % % end
% % % % % % 
% % % % % % % --- Outputs from this function are returned to the command line.
% % % % % % function varargout = ThermalParameterV1_OutputFcn(hObject, eventdata, handles) 
% % % % % % % varargout  cell array for returning output args (see VARARGOUT);
% % % % % % % hObject    handle to figure
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Get default command line output from handles structure
% % % % % % varargout{1} = handles.output;
% % % % % % 
% % % % % % %----System Parameters Panel------------------------------------------------
% % % % % % % Number of Layers Edit Callback
% % % % % % function numlayersedit_Callback(hObject, eventdata, handles)
% % % % % % handles.NL=str2double(get(hObject,'string'));                               % pull entered data
% % % % % % guidata(hObject,handles)
% % % % % % % Temp Proc Edi Callback
% % % % % % function tprocedit_Callback(hObject, eventdata, handles)
% % % % % % handles.Tproc=str2double(get(hObject,'string'));                            % pull entered data
% % % % % % guidata(hObject,handles)
% % % % % % % Node Temp Edit Callback
% % % % % % function nodetempedit_Callback(hObject, eventdata, handles)
% % % % % % handles.T_init=str2double(get(hObject,'string'));                           % pull entered data
% % % % % % guidata(hObject,handles)
% % % % % % % Number of Layers Create
function numlayersedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Temp Proc Create
function tprocedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Node Temp Create
function nodetempedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% System Confirm Callback
function sysconfbutt_Callback(hObject, eventdata, handles)
if mod(handles.NL,1)~=0
     errordlg('The number of layers must be an integer.','Improper Entry','modal')
     return
end
if strcmp(get(hObject,'string'),'Update System')==1
    handles.layerdata=cell(handles.NL,length(handles.layercnames));          % update layerdata entries
    templayerdata=get(handles.layertable,'data');                           % retrive data from layer table
    [ld,~]=size(handles.layerdata);
    [lt,~]=size(templayerdata);
if ld<lt
    handles.layerdata=templayerdata(1:ld,:);
else
    handles.layerdata(1:lt,:)=templayerdata;
end
elseif  strcmp(get(hObject,'string'),'Confirm')==1
    set(hObject,'string','Update System')                                    % enables appropriate features that can now be edited     
    handles.layerdata=cell(handles.NL,length(handles.layercnames));          % update layerdata entries
    set(handles.PCbaseradio,'enable','on')
    handles.basedata=cell(1,5);
    handles.envdata=cell(2,6);
    set(handles.basegeotable,'enable','on','data',handles.basedata);
    set(handles.PCbaseradio,'enable','on','value',0)    
    set(handles.envtable,'data',handles.envdata);
end
                             
set(handles.basegeotable,'enable','on')
set(handles.envtable,'enable','on')
set(handles.layertable,'enable','on')

set(handles.layertable, 'RowName',handles.layerrnames(1:handles.NL,:),'ColumnName',handles.layercnames);    % layer table row and column names
set(handles.layertable,'data',handles.layerdata);                           % empty layer table
set(handles.plotpop,'Value',1)                                              % resets plot pop up menu to a vlaue of 1 or else if the index shortens matlab will become stuck on an index that now doesn't exist.
set(handles.plotpop,'string',handles.layerrnames(1:handles.NL,:))                                   % assigns plotpop up menu's text to that of all the included layers in a material stack up 
guidata(hObject,handles)
% System Confirm Button Create
function sysconfbutt_CreateFcn(hObject, eventdata, handles)

%----Run Simulation--------------------------------------------------------
% Run Button Callback
function runbutt_Callback(hObject, eventdata, handles)
set(handles.layerslicegroup,'enable','on')
set(handles.resultsgroup,'enable','off')
set(handles.sysgeogroup,'enable','on')
set(handles.resultsgroup,'enable','on')
[handles]=pubfeatbutt_Callback(hObject, eventdata, handles);
[handles]=dummylayoutcheckbutt_Callback(handles);
clear global                                                                % clear global variables defined by thermal function 
handles.TempResults=0;
handles.StressResults=0;
layerdata=get(handles.layertable,'data');                                   % retrieve data
[lb,~]=size(layerdata);                                                     % move to independent function
bmat=zeros(lb,1);                                                           % initialize bmat matrix
% basedata=get(handles.basegeotable,'data');
% if iscell(basedata)==1
%     basedata=cell2mat(basedata(2:end));
% else 
%     basedata=basedata(2:end)
% end
for iii=1:lb
for ii=1:length(handles.matlist)
if strcmp(layerdata(iii,1),handles.matlist(ii,1))==1                        % Compare material selection with material list and based on index assign bmat with material number
    bmat(iii,1)=ii;                                 
end
end
end
handles.bmat=bmat;                                                          % update into handles
% 

layerdata=cell2mat(layerdata(:,2));
[layerstack]=layerconfig(layerdata);
count=1;
count2=1;
count3=1;
for i=1:handles.NL
    if handles.layoutint(i,1)>0 && handles.layoutint(i,1)<99
        n=num2str(handles.layoutint(i,1));
geodata=get(handles.(['layout',n,'geotable']),'data');
[lg,~]=size(geodata);
featmat=zeros(lg,1);
for iii=1:lg
for ii=1:length(handles.matlist)                                            %move to independent function
if strcmp(geodata(iii,1),handles.matlist(ii,1))==1
    featmat(iii,1)=ii;
end
end
end
geodata=cell2mat(geodata(:,2:6));
featdata=get(handles.(['layout',num2str(handles.layoutint(i,1)),'feattable']),'data');
geofeat=get(handles.(['layout',num2str(handles.layoutint(i,1)),'geotable']),'rowname');
if iscell(featdata)==1
sumfeat=sum(cell2mat(featdata));
else
    sumfeat=sum((featdata));
end
[ln,~]=size(geofeat);
layoutnum=zeros(ln,1);
for ii=1:ln
    layoutnum(ii,1)=str2double(geofeat{ii,1}(9:end));
end
[x,y,z,X,Y] = featurecoordinates(layerstack,i,geodata,sumfeat,featmat,handles.layoutint(i,1),layoutnum);
xlayout(count:count+sumfeat-1,1:9)=x;
ylayout(count:count+sumfeat-1,1:4)=y;
zlayout(count:count+sumfeat-1,1:2)=z;
Xlayout(count:count+sumfeat-1,1:2)=X;
Ylayout(count:count+sumfeat-1,1:2)=Y;
count=count+sumfeat;
count3=count3+sumfeat;
layoutnum=layoutnum+1;
%     elseif handles.layoutint(i,1)==99
%         [bx,by,bz,bX,bY]=basecoordinates(i,layerstack,basedata);
%         xlayout(count,1:6)=bx;
%         ylayout(count,1:4)=by;
%         zlayout(i,1:2)=bz;
%         baselayers(count2,1)=i;                                             % saves row number in which base layers exist in original layer stack
%         baselayers(count2,2)=count3;                                        % saves row numbers in which base layers will be published to 
%         count=count+1
%         count2=count2+1;
%         count3=count3+1;
    elseif handles.layoutint(i,1)==0 || handles.layoutint(i,1)==99
%         disp 'her'
        xlayout(count,:)=[0 0 0 0 0 i bmat(i) 0 0];
        ylayout(count,1:4)=0;
        zlayout(count,1:2)=0;
        baselayers(count2,1)=i;                                             % saves row number in which base layers exist in original layer stack
        baselayers(count2,2)=count3;                                        % saves row numbers in which base layers will be published to 
        count=count+1;                                                      % count itterations could use more defining variable names
        count2=count2+1;
        count3=count3+1;
    end
end
basedata=get(handles.basegeotable,'data');

[lb,basetype]=size(basedata);
% pause
% basetype=lb;
basemat=zeros(lb,1);
for iii=1:lb
for ii=1:length(handles.matlist)
if strcmp(basedata(iii,1),handles.matlist(ii,1))==1
    basemat(iii,1)=ii;
%     count4=count4+1;
end
end
end
[lb,~]=size(baselayers);
% for i=1:length(baselayers)
if iscell(basedata)==1
    [~,bc]=size(basedata);
    if bc>2
        if basedata{1,1}==1
            basedata=cell2mat(basedata(:,4:5));
        else
            basedata=cell2mat(basedata(:,2:end));
        end
%     cntrfeat=cell2mat(basedata(1,1));
%     basedata=[cntrfeat basedata];
    else
        basedata=cell2mat(basedata);
    end
end
for i=1:lb
    row=baselayers(i,1);                                                    % layers number in which the z stack height needs to be pulled
    row2=baselayers(i,2);                                                   % row number in layout matrix in which base layer is published to 
[bx,by,bz,bX,bY] = basecoordinates(row,layerstack,basedata,xlayout,ylayout,Xlayout,Ylayout,basetype);
        xlayout(row2,1:6)=bx;
        ylayout(row2,1:4)=by;
        zlayout(row2,1:2)=bz;
%         pause
end
handles.xlayout=xlayout;
handles.ylayout=ylayout;
handles.zlayout=zlayout;
handles.bmat=bmat;
handles.layerstack=layerstack;
% Parametric variation
tic;
R3=1;
R4=0;
R7=1;
if get(handles.tab9radio,'Value')==1
handles.delta_t=0;
handles.transteps=1;

handles.geoparadata=get(handles.geoparatable,'data');

[data,choice,handles.geoparadata]=parameterpull(handles.geoparadata);
if choice==1
    return
end
set(handles.geoparatable,'data',data);

handles.assortparadata=get(handles.assortparatable,'data');
[data,choice,handles.assortparadata,]=parameterpull(handles.assortparadata);
if choice==1
    return
end
set(handles.assortparatable,'data',data);

handles.matparadata=get(handles.matparatable,'data');
[data,choice,handles.matparadata]=parameterpull(handles.matparadata);
if choice==1
    return
end
set(handles.matparatable,'data',data);

handles.paradata=[handles.geoparadata;handles.assortparadata;handles.matparadata];
handles.paradata=flipud(handles.paradata);
% % idx=find(cellfun('isempty',handles.paradata(:,1)));
% % for i=1:length(idx)
% %     handles.paradata(idx(i,1)-i+1)=[];
% % end
conparadata=handles.paradata(~cellfun('isempty',handles.paradata));
[rp,~]=size(conparadata);
rp=rp/6;
if isinteger(int8(rp))~=1
    errordlg(['A parameter has not been completely filled in.',newline,newline,'Remove or complete this parameter to continue.'],'Improper Entry','modal') 
    msg = 'Empty or incomplete parameter case.';
    error(msg)
end
handles.envdata=get(handles.envtable,'data');
handles.basestatus=get(handles.PCbaseradio,'Value');
handles.basedata=get(handles.basegeotable,'data');
[handles.geomaster,handles.envmaster,handles.georow,handles.envrow,handles.delta_t,handles.transteps,handles.bmatmaster,handles.matpropsmaster,handles.tranmin]...
    = ParameterMaster(handles.paradata,handles.envdata,handles.envcnames,handles.xlayout,handles.ylayout,handles.zlayout,handles.basestatus,handles.basedata,handles.bmat,handles.NL,handles.matlist,handles.matprops,handles.matparatype);
handles.Tproc=str2double(get(handles.tprocedit,'string'));
handles.T_init=str2double(get(handles.nodetempedit,'string'));
[ex,~]=size(handles.envmaster);
px=ex/2;
handles.px=px;
R1=1;
R2=handles.georow;
[handles.matrow,~]=size(handles.matprops);
Rm3=1;
Rm4=handles.matrow;
count1=1;

else
    handles.geomaster=[handles.xlayout handles.ylayout handles.zlayout];
    [handles.georow,~]=size(handles.geomaster);
    handles.envmaster=cell2mat(get(handles.envtable,'data'));
    handles.px=1;
    R1=1;
R2=handles.georow;
handles.matpropsmaster=handles.matprops;
[handles.matrow,~]=size(handles.matprops);
Rm3=1;
Rm4=handles.matrow;
count1=1;
end

if get(handles.tab7radio,'value')==1 || get(handles.tab8radio,'value')==1
    handles.holder=ones(4,1);
    handles.featconstdata=flipud(get(handles.featconsttable,'data'));
    handles.sysconstdata=get(handles.sysconsttable,'data');   
    handles.featbcdata=get(handles.featbctable,'data');
    handles.sysbcdata=get(handles.sysbctable,'data');
    const=[handles.sysconstdata;handles.featconstdata];

    constskinny=const(~cellfun('isempty', const));
    lc=length(constskinny);
    if floor(lc/4)~=lc/4
       errordlg(['A cell entry in the constraint table was ' newline...
           'left empty address this cell or remove the row'],'Incomplete Entry','Modal') 
       return
    end
    const=reshape(constskinny,lc/4,4);
    const(:,5)={0};
    BCdata=[handles.featbcdata;handles.sysbcdata];
    BCskinny=BCdata(~cellfun('isempty', BCdata));
    lp=length(BCskinny);
    if floor(lp/5)~=lp/5
       errordlg(['A cell entry in the boundary condition table was ' newline...
           'left empty address this cell or remove the row'],'Incomplete Entry','Modal') 
       return
    end
    BCdata=reshape(BCskinny,lp/5,5);
    Cond=[flipud(const); BCdata];
    [masterlayout,quar,quardetails,quarenv,envmaster] = ConditionCheck(Cond,handles.envcnames,handles.georow,handles.geomaster,handles.envmaster);
    masterlayout;
    [mr,~]=size(masterlayout);
    [gr,~]=size(handles.geomaster);
    if mr~=gr
        quardetails
    end   
    if isempty(masterlayout)==1
               errordlg(['Every trial was quarentined please address the published matrix' newline...
           'for detials on what drove this'],'Incomplete Entry','Modal') 
       return
    end
    handles.geomaster=masterlayout;
    handles.envmaster=envmaster;
    [lm,~]=size(masterlayout);
    handles.px=lm/handles.georow;
    handles.solutionpoptxt=cell(1,handles.px);
end
handles.resultstxt=cell(handles.px,1);
for i=1:handles.px
if i==1
R10=0;
else
R10=handles.transteps*(i-1)-1;
end
    handles.solutionpoptxt{1,i}=['Solution ' num2str(i)];
    if get(handles.tab9radio,'Value')==1 && sum(strcmp(handles.paradata(:,1),'Transient'))>0
        handles.resultstxt{i+R10,1}=['Sol.' num2str(i)];  
    else
         handles.resultstxt{i,1}=['Sol.' num2str(i)];   
    end   
handles.xlayout=handles.geomaster(R1:R2,1:9);
handles.ylayout=handles.geomaster(R1:R2,10:13);
handles.zlayout=handles.geomaster(R1:R2,14:15);
[handles.layerstack]=unique(handles.zlayout,'rows','stable'); 
handles.dz=handles.layerstack(:,1)';
if iscell(handles.envmaster)==1
    handles.envmaster=cell2mat(handles.envmaster);
end
handles.h=handles.envmaster(count1,:);
handles.Ta=handles.envmaster(count1+1,:);
handles.tempmatprops=handles.matpropsmaster(Rm3:Rm4,:);
[Temp,Stress,xgrid,ygrid,NR,NC,handles.ND]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init,handles.tempmatprops,handles.meshdensity);
TempMaster(i,1)=max(Temp(:));
StressMaster(i,1)=max(Stress(:));
if get(handles.tab9radio,'Value')==1 && sum(strcmp(handles.paradata(:,1),'Transient'))>0
timeresults(i,1)=handles.tranmin+(handles.delta_t*(i-1));
end
R1=R1+handles.georow;
R2=R2+handles.georow;
Rm3=Rm3+handles.matrow;
Rm4=Rm4+handles.matrow;
count1=count1+2;
R3=1;
R5=1;
R4=NR;
R6=NR;
if i==1
R8=NC;
R9=0;
else
R8=R7+NC-1;
R9=handles.transteps*(i-1);
end
% 
% end

        if get(handles.tab9radio,'Value')==1 && sum(strcmp(handles.paradata(:,1),'Transient'))>0
            
            for iiii=1:handles.transteps
                for ii=1:handles.NL
%                     Temp
%                     pause
    handles.TempResults(R5:R6,R7:R8)=Temp(R3:R4,1:NC,ii,iiii);
    handles.TempResults(R5,R8+1)=handles.tranmin+(handles.delta_t*(iiii-1));
    handles.StressResults(R5:R6,R7:R8)=Stress(R3:R4,1:NC,ii,iiii);
    handles.StressResults(R5,R8+1)=handles.tranmin+(handles.delta_t*(iiii-1));
    maxhold(ii,iiii+R9)=max(max(handles.TempResults(R5:R6,R7:R8)));
    stresshold(ii,iiii+R9)=max(max(handles.StressResults(R5:R6,R7:R8)));
%     handles.StressResults(R5:R6,R7:R8)=Stress(R3:R4,1:NC,ii);
    R5=R5+NR+1;
    R6=R6+NR+1;
                end
               timeresults(iiii+R9,1)=handles.tranmin+(handles.delta_t*(iiii-1));
%                TempMaster(i,1)=max(handles.TempResults(R5:R6,R7:R8)
%                StressMaster(i,1)
            end
        else
            for  ii=1:handles.NL
    handles.TempResults(R5:R6,R7:R8)=Temp(R3:R4,1:NC,ii);
    handles.StressResults(R5:R6,R7:R8)=Stress(R3:R4,1:NC,ii);
    R5=R5+NR+1;
    R6=R6+NR+1;
            end
        end
if get(handles.tab9radio,'Value')==1 && sum(strcmp(handles.paradata(:,1),'Transient'))>0
    if i==handles.px
    TempMaster=max(maxhold,[],1)';
    StressMaster=max(stresshold,[],1)';
    end
end
%     if ii==1
%         
%     end
%     pause
%             end
%         else
%             %     pause
%     handles.TempResults(R5:R6,R7:R8)=Temp(R3:R4,1:NC,ii);
%     handles.StressResults(R5:R6,R7:R8)=Stress(R3:R4,1:NC,ii);
%     R5=R5+NR+1;
%     R6=R6+NR+1;
%         end
% end


% R3=1;
% R5=1;
% R6=NR;
R7=R7+NC+1;



% R3=R3+NR+2;
% R4=R4+NR+2;
end
%   TempResults
% 
axes(handles.layerplot)
cla reset;
toplayer=strrep(get(handles.plotpop,'Value'),'Layer ','');
layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,xgrid,ygrid,toplayer,handles.ND)
handles.layerplothold=figure('visible','off');
layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,xgrid,ygrid,toplayer,handles.ND)
set(handles.solutionpop,'string',handles.solutionpoptxt,'value',1);
axes(handles.modelplot)
cla reset;
modelplot(handles.geomaster,handles.georow,handles.removeencap)
handles.sysplothold=figure('visible','off');
modelplot(handles.geomaster,handles.georow,handles.removeencap)
handles.TempMaster=TempMaster;
handles.StressMaster=StressMaster;
if get(handles.tab9radio,'Value')==1 && sum(strcmp(handles.paradata(:,1),'Transient'))>0
%     timeresults
    handles.resultsdata=[handles.TempMaster,handles.StressMaster,timeresults];
else
    handles.resultsdata=[handles.TempMaster,handles.StressMaster];  
end
set(handles.resultstable,'data',handles.resultsdata,'rowname',handles.resultstxt);
handles.highlightsol=get(handles.highlightsolradio,'value');
toplayer=strrep(get(handles.plotpop,'Value'),'Layer ','');
toggles=get(handles.loopradio,'value');
if toggles==1
    loop=handles.px;
%     solnum=1;
    solnum=get(handles.solutionpop,'value');
    viewall=0;
    solindex=1;
else 
    loop=1;
    solnum = get(handles.solutionpop,'value');
    solindex=solnum;
    viewall=1;
end
axes(handles.resultsplot)
cla reset; 
resultplot(toggles,handles.geomaster,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
handles.resultsplothold=figure('visible','off');
resultplot(toggles,handles.geomaster,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
toc;
guidata(hObject, handles);

% --- Executes on button press in loadprofilebutt.
function loadprofilebutt_Callback(hObject, eventdata, handles)
handles.geoparadata=get(handles.geoparatable,'data');                       % Get emptied tables
handles.assortparadata=get(handles.assortparatable,'data');
handles.matparadata=get(handles.matparatable,'data');
handles.featbcdata=get(handles.featbctable,'data');                         
handles.sysbcdata=get(handles.sysbctable,'data');
handles.featconstdata=get(handles.featconsttable,'data');                   
handles.sysconstdata=get(handles.sysconsttable,'data');
% handles.envdata=cell(2,6);                                                  %resets because a few lines down has envdata converted into a double could alleviate by better managment of env data
[handles.NL,handles.Tproc,handles.T_init,handles.h,handles.Ta,handles.layerthick,handles.matbylayer,handles.layerdata,handles.basegeo,handles.NLayouts,...
    handles.NCON,handles.NBC,handles.NP,handles.NG,handles.featdata,handles.CONdata,handles.BCdata,handles.paradata,handles.groupings,handles.results,...
    handles.tabstatus,handles.layoutfeatdata,cx,bx,px,gx,status]=ProfileLoad();   % Profile Load Function
if status==0
    return
end
clearguibutt_Callback(hObject, eventdata, handles)
% set(handles.runbutt,'enable','on');
set(handles.sysconfbutt,'string','Update System');
set(handles.envtable,'enable','on');
set(handles.layertable,'enable','on');
set(handles.runbutt,'enable','on');
for i=1:length(handles.tabstatus)       %temp hold for radio buttons that dont exist on layouts
    if i==10
    else
    set(handles.(['tab' num2str(i) 'radio']),'value',handles.tabstatus(1,i))
    end
end

tab1radio_Callback(hObject, eventdata, handles)
tab2radio_Callback(hObject, eventdata, handles)
tab3radio_Callback(hObject, eventdata, handles)
tab4radio_Callback(hObject, eventdata, handles)
tab5radio_Callback(hObject, eventdata, handles)
tab6radio_Callback(hObject, eventdata, handles)
tab7radio_Callback(hObject, eventdata, handles)
tab8radio_Callback(hObject, eventdata, handles)
tab9radio_Callback(hObject, eventdata, handles)

set(handles.numlayersedit,'string',handles.NL);                             % set num layers
set(handles.tprocedit,'string',handles.Tproc);                              % set process temp
set(handles.nodetempedit,'string',handles.T_init);                          % set initial node temp
count1=1;
count2=1;
for i=1:cx
    if find(strcmp(handles.featconsttype,handles.CONdata{i,1})==1)>0        % compares constriant data agianst feature constraints, if true add to feature constraint data 
    handles.featconstdata(count1,:)=handles.CONdata(i,:);                   % build feature constraint data matrix
    count1=count1+1;
    elseif find(strcmp(handles.sysconsttype,handles.CONdata{i,1})==1)>0     % compares constriant data types against system constraints 
        handles.sysconstdata(count2,:)=handles.CONdata(i,:);
        count2=count2+1;
    end
end
set(handles.featconsttable,'data',handles.featconstdata);                   % set tables
set(handles.sysconsttable,'data',handles.sysconstdata);
count1=1;                                                                   % reset counts
count2=1;
% handles.featbcdata=cell(1,5);
% handles.sysbcdata=cell(1,5);

for i=1:bx
    if find(strcmp(handles.featbctype,handles.BCdata{i,1})==1)>0            % compares bc data with feature boundary conditions
    handles.featbcdata(count1,:)=handles.BCdata(i,:);                       % if feature bc add to feature bc matrix
    count1=count1+1;
    elseif find(strcmp(handles.sysbctype,handles.BCdata{i,1})==1)>0         % same for bc system
        handles.sysbcdata(count2,:)=handles.BCdata(i,:);
        count2=count2+1;
    end
end
set(handles.featbctable,'data',handles.featbcdata);                         % set tables
set(handles.sysbctable,'data',handles.sysbcdata);

count1=1;                                                                   % reset counts
count2=1;
count3=1;
% [rp,cp]=size(handles.paradata);
% handles.geoparadata=cell(1,cp);
% handles.assortparadata=cell(1,cp);
for i=1:px
%     handles.paradata{i,1}
    if find(strcmp(handles.assortedparatype,handles.paradata{i,1})==1)>0    % if assorted parameter is found in column 1 row i publish to assort parameter martix
    handles.assortparadata(count1,:)=handles.paradata(i,:);
    count1=count1+1;
    elseif find(strcmp(handles.geoparatype,handles.paradata{i,1})==1)>0     % if geo/ feature parameter publish to geo para matrix
        handles.geoparadata(count2,:)=handles.paradata(i,:);
        count2=count2+1;
    elseif isnan(handles.paradata{i,1})==0
        handles.matparadata(count3,:)=handles.paradata(i,:);                % else... has to be material paramater, publish accordingly
        count3=count3+1;
    end
end
set(handles.geoparatable,'data',handles.geoparadata);                       % set tables
set(handles.assortparatable,'data',handles.assortparadata);
set(handles.matparatable,'data',handles.matparadata);
if isnan(handles.h(1,1))~=1
handles.envdata(1,:)=num2cell(handles.h);                                   % build env data matrix
else
    handles.envdata(1,:)=cell(1,6);
end
if isnan(handles.Ta(1,1))~=1
handles.envdata(2,:)=num2cell(handles.Ta);
else
    handles.envdata(2,:)=cell(1,6);
end
set(handles.envtable,'data',handles.envdata);                               % set env table with env data
if isnan(handles.layerdata{1,1})~=1
set(handles.layertable,'data',handles.layerdata(:,1:3));                    % set editable column of layer data
handles.layoutint=cell2mat(handles.layerdata(:,4));
layerrnames=handles.layerrnames(1:handles.NL);                              % update the needed number of layers
set(handles.plotpop,'Value',1);                                       % resets plot pop up menu to a vlaue of 1 or else if the index shortens matlab will become stuck on an index that now doesn't exist.
set(handles.plotpop,'string',layerrnames);                                 % assigns plotpop up menu's text to that of all the included layers in a material stack up 
end
% if isnan(handles.basegeo{1,1})~=1
%     pause
if length(handles.basegeo)<5
    set(handles.PCbaseradio,'value',1);
    set(handles.PCbaseradio,'enable','on');
    PCbaseradio_Callback(hObject, eventdata, handles)                       % internally clicks radio button to initiate the check on it's value. If 1 will change to border definition
end
set(handles.basegeotable,'enable','on');
set(handles.basegeotable,'data',handles.basegeo);                           % set base geometry table
% end
R1=1;
R2=0;
for i=1:handles.NLayouts                                                    % loop through layout tabs
    R2=R2+handles.layoutfeatdata(i,2);                                      % finds end row of layout i's data in matrix
    handles.n=num2str(i);                                                   % pulls tab number n 
    handles.(['layout',handles.n,'NF'])=handles.layoutfeatdata(i,1);        % assings number of features for tab n 
    set(handles.(['layout',handles.n,'numfeatedit']),'string',handles.layoutfeatdata(i,1),'enable','on'); % assigns number of features into edit box
    dummytabconfbutt_Callback(hObject, eventdata, handles)                  % actuates quanity publish into feat table
    set(handles.(['layout',num2str(i),'feattable']),'data',handles.layoutfeatdata(i,3:2+handles.layoutfeatdata(i,1))','enable','on'); % sets feat table
    rnames=handles.featdata(R1:R2,1);                                       % pulls row names
    tempdata=handles.featdata(R1:R2,2:7);                                   % pulls geometry feature data
    set(handles.(['layout',handles.n,'geotable']),'rowname',rnames,'data',tempdata,'enable','on') % publishes layout i's geometry data
    R1=R1+R2;                                                               % loop itteration for all layouts
    set(handles.(['layout',handles.n,'confbutt']),'enable','on')
    set(handles.(['layout',handles.n,'confquant']),'enable','on')
    set(handles.(['clearlayout',handles.n,'butt']),'enable','on')
end
if isnan(handles.layerdata{1,1})~=1
for i=1:handles.NL
    matlocation=strcmp(handles.matlist',handles.layerdata(i,1));            % Finds material location in material library matrix
matmatrix = matlocation*handles.matprops;                                   % Creats matrix with only values of selected material, all others are equal to zero
matrow=removeconstantrows(matmatrix);
for ii=4:9                                                                   %ittereations used between columns #:#
    handles.layerdata(i,ii)=num2cell(matrow(1,ii-3));                          %inputs material properties for the selected layer in columns #:#
end
end
set(handles.layertable,'data',handles.layerdata,'RowName',layerrnames,'ColumnName',handles.layercnames);
[handles]=pubfeatbutt_Callback(hObject, eventdata, handles);                               %publishes all feature types into parametric geometry and associated pop menues. 
end
if ~ispc
    disp('If Excel is not available, then profiles files will not be in Excel format and may lose functionality.')
end

guidata(hObject,handles)


%----Save Data-------------------------------------------------------------
% Save Profile Call Back
function saveprofbutt_Callback(hObject, eventdata, handles)
raw=cell(length(handles.proftemplate),11);
    raw(:,1)=handles.proftemplate;
    envdata=get(handles.envtable,'data');
    raw(4:5,2:7)=envdata;
    NL=get(handles.numlayersedit,'string');
    raw{1,2}=NL;
    NL=str2double(NL);
    Tproc=get(handles.tprocedit,'string');
    raw{2,2}=Tproc;
    T_init=get(handles.nodetempedit,'string');
    raw{3,2}=T_init;
    layerdata=get(handles.layertable,'data');
    raw(6,2:NL+1)=layerdata(:,2)';
    raw(7,2:NL+1)=layerdata(:,1)';
    raw(8,2:NL+1)=layerdata(:,3)';
    layertypecode=cell(NL,1);
    for i=1:NL
        for ii=1:6
       if strcmp(handles.layoutpop(ii,1),layerdata(i,3)')==1
           layertypecode(i,1)=handles.layoutpop(ii,2);
       end
        end
    end
    raw(9,2:NL+1)=layertypecode';
    basegeo=get(handles.basegeotable,'data');
   if iscell(basegeo)==0
       basegeo=num2cell(basegeo);
   end
[~,cb]=size(basegeo);
basegeo=[cb basegeo];
    raw(10,2:2+cb)=basegeo;
    tabstatus=zeros(1,10);
  for i=1:10
      if  i==10
      else
      tabstatus(1,i)=get(handles.(['tab' num2str(i) 'radio']),'value');
      if i==7 && tabstatus(1,i)==1
      handles.Constdata=[get(handles.featconsttable,'data');get(handles.sysconsttable,'data')];
      else     
      handles.Constdata=cell(1,4);
      end
      if i==8 && tabstatus(1,i)==1
      handles.BCdata=[get(handles.featbctable,'data');get(handles.sysbctable,'data')];
      else
      handles.BCdata=cell(1,5);
      end
      if i==9 && tabstatus(1,i)==1
      handles.paradata=[get(handles.geoparatable,'data');get(handles.assortparatable,'data')];
      else
      handles.paradata=cell(1,6);
      end
      if i==10 && tabstatus(1,i)==1
      handles.groupdata=cell(1,5);
      else
      handles.groupdata=cell(1,5);
      end
      end
  end
  [NConst,~]=size(handles.Constdata);
  [NBC,~]=size(handles.BCdata);
  [NP,~]=size(handles.paradata);
  [NG,~]=size(handles.groupdata);
  handles.results=cell(1,5);
  NLayouts=sum(tabstatus(1,1:6));
  raw(11,2:6)=num2cell([NLayouts,NConst,NBC,NP,NG]);
  raw(12,2:11)=num2cell(tabstatus);
  featdata=cell(NLayouts,10);
  geodata=cell(20,8);
  count=1;

  for i=1:NLayouts
     n=num2str(i);
    tempNF=str2double(get(handles.(['layout',n,'numfeatedit']),'string'));
    templaydata=get(handles.(['layout',n,'feattable']),'data');
    if iscell(templaydata)==1
    templaydata=cell2mat(templaydata); %%****
    end
    tempdata=[tempNF,sum(templaydata),templaydata'];
    [~,cd]=size(tempdata);
    templayoutgeodata=get(handles.(['layout',n,'geotable']),'data');   
    temprnames=get(handles.(['layout',n,'geotable']),'rowname');
[rg,~]=size(templayoutgeodata);
featdata(i,1:cd)=num2cell(tempdata);
geodata{count,1}=['Layout ',n,' Feat. Data'];
geodata(count:count+rg-1,2)=temprnames;
geodata(count:count+rg-1,3:8)=templayoutgeodata;
count=count+rg;
  end
  geodata(count:end,:)=[];
  [rg,~]=size(geodata);
  [rf,~]=size(featdata);
  raw(13:12+rf,2:11)=featdata;
  raw(13+rf:12+rf+rg,1:8)=geodata;
  row=13+rf+rg;
  raw(row,1)=handles.proftemplate(27,1);
  raw(row:row+NConst-1,2:5)=handles.Constdata;
  raw(row+1:row+NConst-1,1)=cell(NConst-1,1);
  row=row+NConst;
  raw(row,1)=handles.proftemplate(28,1);
  raw(row+1:row+NBC-1,1)=cell(NBC-1,1);
  raw(row:row+NBC-1,2:6)=handles.BCdata;
  row=row+NBC;
  raw(row,1)=handles.proftemplate(29,1);
  raw(row:row+NP-1,2:7)=handles.paradata;
  raw(row+1:row+NP-1,1)=cell(NP-1,1);
  row=row+NP;
  raw(row,1)=handles.proftemplate(30,1);
  raw(row,2:6)=handles.groupdata;
  row=row+NG;
  raw(row,1)=handles.proftemplate(31,1);
  raw(row,2:6)=handles.results;
  raw(row+1:end,:)=[];
[filename, pathname] = uiputfile('*.xlsx', 'Choose a file name');
if ischar(filename)==0;
    return
end
outname = fullfile(pathname, filename);
% handles.TempResults(R5:R6,R7:R8)=Temp(R3:R4,1:NC,ii);
%     handles.StressResults(R5:R6,R7:R8)=Stress(R3:R4,1:NC,ii);
status=zeros(1,3);
% xlswrite(outname, raw,'Module/Solution Information');
status(1,1)=xlswrite(outname,raw,1);
% xlswrite(outname,handles.TempResults,'Temperature Results'); 
status(1,2)=xlswrite(outname,handles.TempResults,'Temperature Results');
% xlswrite(outname,handles.StressResults,'Temperature Results');
status(1,3)=xlswrite(outname,handles.StressResults,'Stress Results');
resultsdata=get(handles.resultstable,'data');
resultsdata=num2cell(resultsdata);
if ~ispc
    disp('If Excel is not available, then profiles files will not be in Excel format and may lose functionality.')
end
if cellfun('isempty',resultsdata{1,1})==1
    return
else
[rd,~]=size(resultsdata);
resultsrnames=cell(rd,1);
temprnames=get(handles.resultstable,'rowname')
tempcnames=get(handles.resultstable,'columnname'); %%**
[rt,~]=size(temprnames);
resultsrnames(1:rt,1)=temprnames;
if rd==rt
resultsdata=[resultsrnames,resultsdata];
resultsdata=[[cell(1,1),tempcnames];resultsdata];
status(1,4)=xlswrite(outname,resultsdata,'Module Results');
end
end
% % if sum(status(1,:))~=4
% %    errordlg(['Unable to save propperly, please ensure' newline...
% %    'a unique file name was selected'],'Improper Entry','modal');
% % end

function ZZZZZZZ
% % % % % % % Save Results Callback
% % % % % % function saveresultsbutt_Callback(hObject, eventdata, handles)
% % % % % % saveprofbutt_Callback(hObject, eventdata, handles)                          % acts the same as save profile button
% % % % % % 
% % % % % % %----Profile Pop-Up--------------------------------------------------------
% % % % % % % Profile Pop Callback
% % % % % % % % % % % function loadprofilepop_Callback(hObject, eventdata, handles)
% % % % % % % % % % % % hObject    handle to loadprofilepop (see GCBO)
% % % % % % % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % % % % % % % Hints: contents = cellstr(get(hObject,'String')) returns loadprofilepop contents as cell array
% % % % % % % % % % % %        contents{get(hObject,'Value')} returns selected item from loadprofilepop
% % % % % % % % % % % 
% % % % % % % % % % % % Profile Pop Menu Create
% % % % % % % % % % % function loadprofilepop_CreateFcn(hObject, eventdata, handles)
% % % % % % % % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % % % % % % % %     set(hObject,'BackgroundColor','white');
% % % % % % % % % % % end
% % % % % % 
% % % % % % % --- Executes when entered data in editable cell(s) in layertable.
% % % % % % function layertable_CellEditCallback(hObject, eventdata, handles)
% % % % % % % hObject    handle to layertable (see GCBO)
% % % % % % % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
% % % % % % %	Indices: row and column indices of the cell(s) edited
% % % % % % %	PreviousData: previous data for the cell(s) edited
% % % % % % %	EditData: string(s) entered by the user
% % % % % % %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
% % % % % % %	Error: error string when failed to convert EditData to appropriate value for Data
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % handles.layerdata=get(handles.layertable,'data');                                      % retrieve current data about layers
% % % % % % matselect=handles.layerdata(eventdata.Indices(1,1));                        % retrieves the material selected from column 1 pop
% % % % % % matlocation=strcmp(handles.matlist',matselect);                              % finds material location in material library matrix
% % % % % % matmatrix = matlocation*handles.matprops;                                   % creats matrix with only values of selected material, all others are equal to zero
% % % % % % matrow=removeconstantrows(matmatrix);                                       % removes zero values        
% % % % % % rowselect=eventdata.Indices(1,1);
% % % % % % colselect=eventdata.Indices(1,2);
% % % % % % value=handles.layerdata(rowselect,colselect);
% % % % % % basecheck=strfind(handles.layerrnames(rowselect,1),'.');
% % % % % % n=strrep(handles.layerrnames(rowselect,1),'Layer ',''); %replaces layer list with string value of layer number
% % % % % % if colselect==1                                                             % check that cell selection has been made in column 1 for materials
% % % % % % for i=4:9                                                                   % ittereations used between columns #:#
% % % % % %     handles.layerdata(rowselect,i)=num2cell(matrow(1,i-3));    % inputs material properties for the selected layer in columns #:#
% % % % % % end
% % % % % % if cellfun('isempty',basecheck)==1
% % % % % % % handles.(['layer',n{1},'data'])(1,1)=matselect;
% % % % % % % data=handles.layer1data
% % % % % % %     set(handles.(['layer',n{1},'geotable']),'data',handles.(['layer',n{1},'data']));
% % % % % % end
% % % % % % end
% % % % % % if colselect==3 && strcmp(value{1,1}(1:4),'Base')==0
% % % % % %     n=value{1,1}(1,end);
% % % % % %     tempdata=get(handles.(['layout' n 'geotable']),'data');
% % % % % % %     if sum(sum(cellfun('isempty',tempdata)))
% % % % % % % [handles]=pubfeatbutt_Callback(hObject, eventdata, handles);                  %Organizes constraint, BC, and parameter tables to display the correct pop menues and content.  
% % % % % % end
% % % % % % % % if colselect==3 && strcmp(value{1,1}(1,1),'B')==1
% % % % % % % %     layouts=handles.layerdata(:,3);
% % % % % % % %     options={'Base U.D.','Base P.C'};
% % % % % % % %     find(strcmp(options,layouts)==1)
% % % % % % % % %     selecttype=value{1,1}(1,end-3:end);
% % % % % % % %     
% % % % % % % %     for i=1:length(layouts)
% % % % % % % %     layouts{i,1}=layouts{i,1}(1,end-3:end);
% % % % % % % %     end
% % % % % % % %     layouts
% % % % % % % % %     find(strcmp(allowable,geo)==1)
% % % % % % % %     find(strcmp(Value,layouts)==1)
% % % % % % % % end
% % % % % % set(handles.layertable,'data',handles.layerdata);                           %Publishes solution parameters into gui table
% % % % % % handles.layertablestatus=cellfun('isempty',handles.layerdata);
% % % % % % % if any(handles.envdatastatus(:))==0 && any(handles.layertablestatus(:))==0
% % % % % % %     set(handles.runbutt,'Enable','on');
% % % % % % % end
% % % % % % guidata(hObject,handles)
% % % % % % 
% --- Executes during object creation, after setting all properties.
function layout1feattable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layout1feattable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Data', cell(13,1));

% % % % % % % --- Executes during object deletion, before destroying properties.
% % % % % % function layout1feattable_DeleteFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to layout1geotable (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % --- Executes during object deletion, before destroying properties.
% % % % % % function layout1geotable_DeleteFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to layout1geotable (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
function basegeotable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basegeotable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.basedata=cell(1,5);
set(hObject,'Data', handles.basedata);
guidata(hObject,handles)

function ZZZZZZZZ
% % % % % % function layer1edit_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to layer1edit (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hints: get(hObject,'String') returns contents of layer1edit as text
% % % % % % %        str2double(get(hObject,'String')) returns contents of layer1edit as a double
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
% % % % % % function layer1edit_CreateFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to layer1edit (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    empty - handles not created until after all CreateFcns called
% % % % % % 
% % % % % % % Hint: edit controls usually have a white background on Windows.
% % % % % % %       See ISPC and COMPUTER.
% % % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % % %     set(hObject,'BackgroundColor','white');
% % % % % % end
% % % % % % 
% % % % % % 
% % % % % % 
% % % % % % function layer2edit_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to layer2edit (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hints: get(hObject,'String') returns contents of layer2edit as text
% % % % % % %        str2double(get(hObject,'String')) returns contents of layer2edit as a double
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
% % % % % % function layer2edit_CreateFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to layer2edit (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    empty - handles not created until after all CreateFcns called
% % % % % % 
% % % % % % % Hint: edit controls usually have a white background on Windows.
% % % % % % %       See ISPC and COMPUTER.
% % % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % % %     set(hObject,'BackgroundColor','white');
% % % % % % end
% % % % % % 
% % % % % % % function []=tabconf(n,NF,geornames)
% % % % % % % set(handles.layer1edit,'string','cat')
% % % % % % %     handles.(['layer',n,'rnames'])=geornames(2:NF);
% % % % % % % %     set(handles.(['layer',n,'feattable']),'ColumnName',handles.(['layer',n,'rnames'])(2:end))
% % % % % % %     set(handles.(['layer',n,'geotable']),'ColumnName',handles.(['layer',n,'rnames']))
% % % % % % % guidata(hObject,handles)
% % % % % %     
% % % % % %     
% % % % % %     
% % % % % % 
% % % % % % 
% % % % % % %     tabconf(n,handles.NF,handles.geornames)        
% % % % % % % % for i=1:2
% % % % % % % %   n=num2str(i);
% % % % % % % % if mod(handles.NF,1)~=0
% % % % % % % %      errordlg('The number of layers must be an integer.','Improper Entry','modal')
% % % % % % % %      return
% % % % % % % % end
% % % % % % % % end
% % % % % % 
% % % % % % 
% % % % % % % % % % % --- Executes on button press in dummytabmoveupbutt.
% % % % % % % % % % function dummytabmoveupbutt_Callback(hObject, eventdata, handles)
% % % % % % % % % % % hObject    handle to dummytabmoveupbutt (see GCBO)
% % % % % % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % % % % % 
% % % % % % % % % % 
% % % % % % % % % % % --- Executes on button press in dummytabmovedownbutt.
% % % % % % % % % % function dummytabmovedownbutt_Callback(hObject, eventdata, handles)
% % % % % % % % % % % hObject    handle to dummytabmovedownbutt (see GCBO)
% % % % % % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % %----Base Table------------------------------------------------------------
% % % % % % 
% % % % % % %----Base Table Cell Edit
% % % % % % function basegeotable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.basedata=(get(handles.basegeotable,'data'));                                     % pull data from base table
% % % % % % cellsel=eventdata.Indices;                                                  % determine the cell index that was selected
% % % % % % row=cellsel(1,1);                                                           % selected row
% % % % % % col=cellsel(1,2);                                                           % selected column
% % % % % % if iscell(handles.basedata)==0
% % % % % %     [dr,dc]=size(handles.basedata);
% % % % % %     handles.basedata=num2cell(handles.basedata);
% % % % % % end
% % % % % % value=cell2mat(handles.basedata(row,col));                                  % value of selected cell
% % % % % % 
% % % % % % radio=get(handles.PCbaseradio,'value');                                     % retrieves status of PC radio
% % % % % % handles.autobcradiostat=get(handles.autoconstbaseradio,'value');
% % % % % % if radio==0  && cell2mat(handles.basedata(1,1))==1                          % if radio is set to UD and center toggle is on 
% % % % % %     handles.basedata(:,2:3)=cell(1,2);                                      % add empty cells to col 2 and three, in the event that they were removed for PC
% % % % % %     handles.basedata(1,2:3)={'N/A','N/A'};                                  % turn col 2:3 to NA
% % % % % %     set(hObject,'columneditable', [true false false true true],'data',handles.basedata);    % publish to table
% % % % % % elseif radio==0 && cell2mat(handles.basedata(1,1))==0 && col==1             % if radio is on UD and center toggle is off and edit made to toggle cell
% % % % % %     handles.basedata(:,2:3)=cell(1,2);                                      % empty col 2:3
% % % % % %     set(hObject,'columneditable',[true true true true true],'data',handles.basedata) %update talble
% % % % % % end
% % % % % % if col>3 && value<=0 || isnan(value)==1                                     % if edit was made in len or wid col and is less than zero or not a num
% % % % % %     errordlg('Length and Width must be positive real values','Improper Entry','modal'); % error out because only positive real values are accepted
% % % % % %     handles.basedata(1,col)=cell(1,1);                                      % empty wrongful entry cell
% % % % % %     set(hObject,'data',handles.basedata);
% % % % % % end
% % % % % % if radio==1 && sum(cellfun('isempty',handles.basedata))==0   && handles.autobcradiostat==1  % if PC is enabled and all cells are filled and user selects to have bc radio enable automatically
% % % % % % [handles]=autobase(handles);
% % % % % % end
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % %----Automate Base Constraint Radio 
% % % % % % function autoconstbaseradio_Callback(hObject, eventdata, handles)
% % % % % % [handles]=autobase(handles);
% % % % % % guidata(hObject,handles)
% % % % % % %----Automate Base Constraint Add Function
% % % % % % function [handles]=autobase(handles)
% % % % % % % if radio==1 && sum(cellfun('isempty',handles.basedata))==0   && handles.autobcradiostat==1  % if PC is enabled and all cells are filled and user selects to have bc radio enable automatically
% % % % % %     set(handles.tab7radio,'value',1)                                        % turn on constraints tab
% % % % % %     handles.featconstdata=get(handles.featconsttable,'data');               % retrieve feat constraints data
% % % % % %     allowable=handles.featconsttype(1,6:7);                                 % allowable selections are Base Boarder Len and Wid
% % % % % %     [fr,~]=size(handles.featconstdata);                                     % find current size of contsraints 
% % % % % %     len=strcmp(allowable{1,1},handles.featconstdata(:,1));                  % compare if Base Boarder Length exists in constraint data
% % % % % %     wid=strcmp(allowable{1,2},handles.featconstdata(:,1));                  % compare BBW exists in constraint data
% % % % % %     if sum(len)>0                                                           % if BBL exists
% % % % % %         idx=find(len);                                                      % find index of entry 
% % % % % %         handles.featconstdata(idx,4)=handles.basedata(1,1);                 % publish value from base geo table as the constraint
% % % % % %         set(handles.featconsttable,'data',handles.featconstdata);           % set table
% % % % % %     else 
% % % % % %         row=find(sum(cellfun('isempty',handles.featconstdata),2)==4);
% % % % % %         if row>0
% % % % % %         handles.featconstdata(row(1,1),1:4)=[allowable{1,1}, 'System','N/A',handles.basedata(1,1)]; % add new row to end 
% % % % % %         else
% % % % % %         handles.featconstdata(end+1,1:4)=[allowable{1,1}, 'System','N/A',handles.basedata(1,1)]; % add new row to end 
% % % % % %         end
% % % % % %         set(handles.featconsttable,'data',handles.featconstdata);
% % % % % %     end
% % % % % %     if sum(wid)>0                                                           % see len section above
% % % % % %         idx=find(wid);
% % % % % %         handles.featconstdata(idx,4)=handles.basedata(1,2);
% % % % % %         set(handles.featconsttable,'data',handles.featconstdata);
% % % % % %     else 
% % % % % %         row=find(sum(cellfun('isempty',handles.featconstdata),2)==4);
% % % % % %         if row>0
% % % % % %         handles.featconstdata(row,1:4)=[allowable{1,2}, 'System','N/A',handles.basedata(1,2)];   
% % % % % %         else
% % % % % %         handles.featconstdata(end+1,1:4)=[allowable{1,2}, 'System','N/A',handles.basedata(1,2)];
% % % % % %         end
% % % % % %         set(handles.featconsttable,'data',handles.featconstdata);
% % % % % %     end
% % % % % % 
% % % % % % 
% % % % % % 
%----PC Base Radio Button Callback
function PCbaseradio_Callback(hObject, eventdata, handles)
tt=handles.layoutpopactive
if get(hObject,'Value')==1
    set(handles.autoconstbaseradio,'enable','on')
    set(handles.basegeotable,'data',cell(1,2),'columnname',handles.basePCcnames,'columnformat',{'numeric','numeric'},'columneditable',[true true]) %updates base table to have only two cells for len and wid
%     templayoutpop=[handles.layoutpop(1,1);handles.layoutpop(3:end,1)];      % base on PC selection layer table layout pop menu must be updated to only display P.C and layouts
if strcmp(handles.layoutpopactive,'Base U.D.')==1
    handles.layoutpopactive=handles.layoutpop(1,1);
else
    handles.layoutpopactive=[handles.layoutpop(1,1);handles.layoutpopactive(2:end,1)];   
end
    handles.layerdata=get(handles.layertable,'data');                       % retrive table data
    for i=1:handles.NL
        if strcmp(handles.layerdata{i,3},'Base U.D.')==1                    % compares is any cells contain UD setting when they shouldnt
            handles.layerdata(i,3)={'Base P.C.'};                           % updates any cell that does to PC
        end
    end
        set(handles.layertable,'columnformat',{handles.matlist','numeric',handles.layoutpopactive','numeric','numeric','numeric','numeric','numeric','numeric'},'data',handles.layerdata); % update table 
else
    set(handles.autoconstbaseradio,'enable','off')
    set(handles.basegeotable,'columnname',handles.basecnames,'columnformat',{'logical','numeric','numeric','numeric','numeric'},'columneditable',[true true true true true]) % sets base table to have five cells for UD input
    handles.basegeodata=get(handles.basegeotable,'data');                   % retrieves base geo data
    handles.basedata(:,2:5)=cell(1,4);                                      % empties col 2:5
    handles.basedata(1,1)={false};                                          % turns centered features toggle off
    set(handles.basegeotable,'data',handles.basedata)                       % updates table
    handles.layoutpopactive=[handles.layoutpop(2,1); handles.layoutpopactive(2:end,1)];                               % removes PC from acceptable selections in Layer layout pop menue
    handles.layerdata=get(handles.layertable,'data');                       % retrieves layer data
    for i=1:handles.NL
        if strcmp(handles.layerdata{i,3},'Base P.C.')==1                    % see PC above
            handles.layerdata(i,3)={'Base U.D.'};
        end
    end
        set(handles.layertable,'columnformat',{handles.matlist','numeric',handles.layoutpopactive','numeric','numeric','numeric','numeric','numeric','numeric'},'data',handles.layerdata);
end
guidata(hObject,handles)





% --- Executes on button press in tab9radio.
function tab9radio_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of tab9radio
handles.n='9';
dummytabradio_Callback(hObject,eventdata,handles);
value=get(handles.tab9radio,'value');
if value==1
    set(handles.paragroup,'enable','on')
else
    set(handles.paragroup,'enable','off')
end

function ZZZZZZ
% % % % % % % --- Executes during object creation, after setting all properties.
% % % % % % function popupmenu5_CreateFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to popupmenu5 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    empty - handles not created until after all CreateFcns called
% % % % % % 
% % % % % % % Hint: popupmenu controls usually have a white background on Windows.
% % % % % % %       See ISPC and COMPUTER.
% % % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % % %     set(hObject,'BackgroundColor','white');
% % % % % % end
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
% % % % % % function edit17_CreateFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to edit17 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    empty - handles not created until after all CreateFcns called
% % % % % % 
% % % % % % % Hint: edit controls usually have a white background on Windows.
% % % % % % %       See ISPC and COMPUTER.
% % % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % % %     set(hObject,'BackgroundColor','white');
% % % % % % end
% % % % % % 

% --- Executes on button press in tab8radio.
function tab8radio_Callback(hObject, eventdata, handles)
% hObject    handle to tab8radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.tab8status=get(hObject,'Value');
if handles.tab8status==1
    set(handles.bcgroup,'enable','on')
else
    set(handles.bcgroup,'enable','off')
end
guidata(hObject,handles)

function ZZZZZZ
% % % % % % % --- Executes on selection change in popupmenu7.
% % % % % % function popupmenu7_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to popupmenu7 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
% % % % % % %        contents{get(hObject,'Value')} returns selected item from popupmenu7
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
% % % % % % function popupmenu7_CreateFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to popupmenu7 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    empty - handles not created until after all CreateFcns called
% % % % % % 
% % % % % % % Hint: popupmenu controls usually have a white background on Windows.
% % % % % % %       See ISPC and COMPUTER.
% % % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % % %     set(hObject,'BackgroundColor','white');
% % % % % % end
% % % % % % 
% % % % % % 
% % % % % % 
% % % % % % function edit20_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to edit20 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hints: get(hObject,'String') returns contents of edit20 as text
% % % % % % %        str2double(get(hObject,'String')) returns contents of edit20 as a double
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
% % % % % % function edit20_CreateFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to edit20 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    empty - handles not created until after all CreateFcns called
% % % % % % 
% % % % % % % Hint: edit controls usually have a white background on Windows.
% % % % % % %       See ISPC and COMPUTER.
% % % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % % %     set(hObject,'BackgroundColor','white');
% % % % % % end
% % % % % % 
% % % % % % 
% % % % % % % --- Executes on button press in pushbutton31.
% % % % % % function pushbutton31_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to pushbutton31 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
function featbctable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featbctable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.featbccurrentCell=[1 1];
handles.featbcdata=cell(1,5);
set(hObject,'Data',handles.featbcdata);
guidata(hObject,handles)


function ZZZZZZ
% % % % % % % --- Executes on selection change in plotpop.
% % % % % % function plotpop_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to plotpop (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hints: contents = cellstr(get(hObject,'String')) returns plotpop contents as cell array
% % % % % % %        contents{get(hObject,'Value')} returns selected item from plotpop
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
function plotpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ZZZZZZ

% % % % % % % % % % --- Executes on button press in dummyparasweep.
% % % % % % % % % function dummyparasweep_Callback(hObject, eventdata, handles)
% % % % % % % % % % hObject    handle to dummyparasweep (see GCBO)
% % % % % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % % % % % % % % % handles.geoparadata=get(handles.geoparatable,'data');
% % % % % % % % % % % % % % emptygeo=cellfun('isempty',handles.geoparadata);
% % % % % % % % % % % % % % emptyrows=sum(emptygeo,2);
% % % % % % % % % % % % % % count=1;
% % % % % % % % % % % % % % for i=1:length(emptyrows)
% % % % % % % % % % % % % %    if emptyrows(i,1)>5
% % % % % % % % % % % % % %        handles.geoparadata(count,:)=[];
% % % % % % % % % % % % % %    else
% % % % % % % % % % % % % %        count=count+1;
% % % % % % % % % % % % % %    end
% % % % % % % % % % % % % % end
% % % % % % % % % % % % % % set(handles.geoparatable,'data',handles.geoparadata);
% % % % % % % % % % % % % % handles.assortparadata=get(handles.assortparatable,'data');
% % % % % % % % % % % % % % emptyassort=cellfun('isempty',handles.assortparadata);
% % % % % % % % % % % % % % emptyrows=sum(emptyassort,2);
% % % % % % % % % % % % % % count=1;
% % % % % % % % % % % % % % for i=1:length(emptyrows)
% % % % % % % % % % % % % %    if emptyrows(i,1)>5
% % % % % % % % % % % % % %        handles.assortparadata(count,:)=[];
% % % % % % % % % % % % % %    else
% % % % % % % % % % % % % %        count=count+1;
% % % % % % % % % % % % % %    end
% % % % % % % % % % % % % % end
% % % % % % % % % % % % % % set(handles.assortparatable,'data',handles.assortparadata);
% % % % % % % % % % % % % % handles.paradata=[handles.geoparadata;handles.assortparadata];
% % % % % % % % % % % % % % conparadata=handles.paradata(~cellfun('isempty',handles.paradata));
% % % % % % % % % % % % % % [rp,~]=size(conparadata);
% % % % % % % % % % % % % % rp=rp/6;
% % % % % % % % % % % % % % if isinteger(int8(rp))~=1
% % % % % % % % % % % % % %     errordlg(['A parameter has not been completely filled in.',newline,newline,'Remove or complete this parameter to continue.'],'Improper Entry','modal') 
% % % % % % % % % % % % % %     msg = 'Empty or incomplete parameter case.';
% % % % % % % % % % % % % %     error(msg)
% % % % % % % % % % % % % % end
% % % % % % % % % % % % % % handles.paradata=reshape(conparadata,rp,6);
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % x(~cellfun('isempty',x))  
% % % % % % % % % % % % % % % handles.paradata(~any(handles.paradata,2),:) = [];
% % % % % % % % % % % % % % % p=handles.paradata
% % % % % % % % % % % % % % % strcmp(p{2,1},'Layer Thickness')
% % % % % % % % % % % % % % handles.envdata=cell2mat(get(handles.envtable,'data'));
% % % % % % % % % % % % % % handles.basestatus=get(handles.PCbaseradio,'Value');
% % % % % % % % % % % % % % % handles.basedata=cell2mat(handles.basedata);
% % % % % % % % % % % % % % handles.basedata=get(handles.basegeotable,'data');
% % % % % % % % % % % % % % [handles.geomaster,handles.envmaster,handles.georow,handles.envrow,handles.delta_t,handles.transteps,handles.bmatmaster] = ParameterMaster(handles.paradata,handles.envdata,handles.envcnames,handles.xlayout,handles.ylayout,handles.zlayout,handles.basestatus,handles.basedata,handles.bmat,handles.NL);
% % % % % % % % % % e=handles.envmaster
% % % % % % % % % % gr=handles.georow
% % % % % % % % % % er=handles.envrow
% % % % % % % % % % disp('yes')
% % % % % % % % % 
% % % % % % % % % % % % pp=1;  
% % % % % % % % % % % % handles.geoparadata=get(handles.geoparatable,'data');
% % % % % % % % % % % %    handles.assortedparadata=get(handles.assortparatable,'data');
% % % % % % % % % % % %    [lg,~]=size(handles.geoparadata);
% % % % % % % % % % % %    [la,~]=size(handles.assortedparadata);
% % % % % % % % % % % % for ii=1:lg
% % % % % % % % % % % % paratype=strcmp(handles.geoparadata(ii,1),handles.geoparatype);
% % % % % % % % % % % % cell2mat(handles.geoparadata(ii,4));
% % % % % % % % % % % % min=cell2mat(handles.geoparadata(ii,4));
% % % % % % % % % % % % nsteps=cell2mat(handles.geoparadata(ii,5));
% % % % % % % % % % % % max=cell2mat(handles.geoparadata(ii,6));
% % % % % % % % % % % % range=linspace(min,max,nsteps);
% % % % % % % % % % % % [~,lr]=size(range);
% % % % % % % % % % % % handles.delta_t=0;
% % % % % % % % % % % % handles.transteps=1;
% % % % % % % % % % % %     if paratype(1,1)==1
% % % % % % % % % % % %         disp 'Position X'
% % % % % % % % % % % % xlayout=handles.xlayout;
% % % % % % % % % % % % lay=str2double(handles.geoparadata{pp,2}(2:2));
% % % % % % % % % % % % feat=str2double(handles.geoparadata{1,2}(end-3:end));
% % % % % % % % % % % % idx=find( xlayout(:,6)==lay);
% % % % % % % % % % % % idy=find( xlayout(:,9)==feat);
% % % % % % % % % % % % [xl,~]=size(idx);
% % % % % % % % % % % % [yl,~]=size(idy);
% % % % % % % % % % % % row=0;
% % % % % % % % % % % % for i=1:xl
% % % % % % % % % % % %     for iii=1:yl
% % % % % % % % % % % %      if idx(i,1)==idy(iii,1)
% % % % % % % % % % % %          row=idx(i,1);
% % % % % % % % % % % %          break
% % % % % % % % % % % %      end
% % % % % % % % % % % %     end
% % % % % % % % % % % % end
% % % % % % % % % % % % for iii=1:lr
% % % % % % % % % % % % xlayout(row,1:4)=xlayout(row,1:4)+range(1,iii);
% % % % % % % % % % % % handles.xlayout=xlayout;
% % % % % % % % % % % % dummyrunbutt_Callback(hObject, eventdata, handles)
% % % % % % % % % % % % end
% % % % % % % % % % % %     elseif paratype(1,2)==1
% % % % % % % % % % % %         disp 'Position Y'
% % % % % % % % % % % % 
% % % % % % % % % % % %     elseif paratype(1,3)==1
% % % % % % % % % % % %         disp 'Length'
% % % % % % % % % % % % 
% % % % % % % % % % % %     elseif paratype(1,4)==1
% % % % % % % % % % % %         disp 'Width'
% % % % % % % % % % % % 
% % % % % % % % % % % %     elseif paratype(1,5)==1
% % % % % % % % % % % %         disp 'Scale'
% % % % % % % % % % % % 
% % % % % % % % % % % %     end
% % % % % % % % % % % % end
% % % % % % % % % % % for ii=1:la  
% % % % % % % % % % %    if paratype(1,1)==1                                                   %transient selection
% % % % % % % % % % %          disp 'Transient'
% % % % % % % % % % %     hold=handles.paradata(ii,4:6);
% % % % % % % % % % %     [tranmin,transteps, tranmax]=deal(hold{:});
% % % % % % % % % % %     delta_t=(tranmax-tranmin)/transteps;
% % % % % % % % % % %     elseif paratype(1,2)==1
% % % % % % % % % % %         disp 'Layer Thickness'
% % % % % % % % % % %         delta_t=0;
% % % % % % % % % % %         transteps=1;
% % % % % % % % % % %     elseif paratype(1,3)==1
% % % % % % % % % % %         disp 'Environment'
% % % % % % % % % % %         delta_t=0;
% % % % % % % % % % %         transteps=1;
% % % % % % % % % % %    end
% % % % % % % % % % % end
% % % % % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % % % % % --- Executes on button press in dummyrunbutt.
% % % % % % % % % % function dummyrunbutt_Callback(hObject, eventdata, handles)
% % % % % % % % % % % hObject    handle to dummyrunbutt (see GCBO)
% % % % % % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % --- Executes on selection change in solutionpop.
% % % % % % function solutionpop_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to solutionpop (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hints: contents = cellstr(get(hObject,'String')) returns solutionpop contents as cell array
% % % % % % %        contents{get(hObject,'Value')} returns selected item from solutionpop
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
function solutionpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to solutionpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ZZZZZZ
% % % % % % function edit23_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to edit23 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hints: get(hObject,'String') returns contents of edit23 as text
% % % % % % %        str2double(get(hObject,'String')) returns contents of edit23 as a double
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
% % % % % % function edit23_CreateFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to edit23 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    empty - handles not created until after all CreateFcns called
% % % % % % 
% % % % % % % Hint: edit controls usually have a white background on Windows.
% % % % % % %       See ISPC and COMPUTER.
% % % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % % %     set(hObject,'BackgroundColor','white');
% % % % % % end
% % % % % % 
% % % % % % 
% % % % % % % --- Executes on button press in pushbutton45.
% % % % % % function pushbutton45_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to pushbutton45 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % 
% % % % % % % --- Executes on button press in pushbutton39.
% % % % % % function pushbutton39_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to pushbutton39 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % 
% % % % % % 
% % % % % % function edit21_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to edit21 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hints: get(hObject,'String') returns contents of edit21 as text
% % % % % % %        str2double(get(hObject,'String')) returns contents of edit21 as a double
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
% % % % % % function edit21_CreateFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to edit21 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    empty - handles not created until after all CreateFcns called
% % % % % % 
% % % % % % % Hint: edit controls usually have a white background on Windows.
% % % % % % %       See ISPC and COMPUTER.
% % % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % % %     set(hObject,'BackgroundColor','white');
% % % % % % end
% % % % % % 
% % % % % % 
% % % % % % % --- Executes on button press in pushbutton40.
% % % % % % function pushbutton40_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to pushbutton40 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % 
% % % % % % % --- Executes on button press in pushbutton41.
% % % % % % function pushbutton41_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to pushbutton41 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % 
% % % % % % % --- Executes on button press in radiobutton14.
% % % % % % function radiobutton14_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to radiobutton14 (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hint: get(hObject,'Value') returns toggle state of radiobutton14
% % % % % % 
% % % % % % 
% % % % % % % --- Executes on button press in pubfeatbutt.
function [handles] = pubfeatbutt_Callback(hObject, eventdata, handles)                  %Organizes constraint, BC, and parameter tables to display the correct pop menues and content. 
% Defined as a button so other areas of code can call and force and update
% of table definitions. 
set(handles.runbutt,'enable','on')
    count1=1;                                                                   % initilize count for publishing unique layout geometry parameters
    count=1;                                                                % initialize count for finding layers that have a layout used
    handles.layerdata=get(handles.layertable,'data');                       % retrieves layer data 
    handles.layerrnames=get(handles.layertable,'rowname');                  % retrives layer table row names ie layers used
    handles.layerdata=[handles.layerrnames handles.layerdata];              % combines layer info into one matrix for reference
    [ld,~]=size(handles.layerdata);                                         % finds rows and columns of layer data ie numlayers
    for i=1:ld                                                              %loop seeks to find layers that use layouts 
        templayoutname=handles.layerdata{i,4};                              % finds the layout designation for each layer                                        
       handles.layerdata{i,4}=[templayoutname(1,1) templayoutname(1,end)];  % removes all but first and last characters to leave B. or L# 
    if strcmp(templayoutname(1,1),'L')==1                                   % if the layer is designated by L# it is a layout geometry 
           layoutlayers(count,:)=handles.layerdata(i,:);                    % stores the layers numbers and corresponding layout for that layer in a matrix
           count=count+1;
    end
    end
    
    for i=1:handles.NLayouts                                                % itterates between the total number of unique layouts
        n=num2str(i);                                                       % defines n as the itteration or tab number 
    handles.(['layout' n 'featdata'])=get(handles.(['layout' n 'feattable']),'data'); % retrieves the layout feature data of current itterations tab
if iscell(handles.(['layout' n 'featdata']))==1
    handles.(['layout' n 'featdata'])=cell2mat(handles.(['layout' n 'featdata'])); %%*****
end

    handles.(['layout' n 'rnames'])=get(handles.(['layout' n 'feattable']),'rowname'); % retrieves row names of feature data
        [llay,~]=size(handles.(['layout' n 'featdata']));                   % finds rows and columns of feat data
    for ii=1:llay                                                           %loop seeks to find all feature vairations in all active layouts. itteratates through the number of unique features
for iii=1:handles.(['layout' n 'featdata'])(ii,1)                           % itterates through the qunaity of each unique feature
featnum=handles.(['layout' n 'rnames']){ii,1};                              % defines the feature number for layout, ie Feature 1, Feature 2....
    layoutgeopara{count1,1}=['L',n,' F ',featnum(1,end),'.', num2str(iii)]; % stores layout geometry paramerters as [Layout Number Feature Number]
        count1=count1+1;                                                    % itterates for next entry in layout geometry 
end
    end
    end
    [lx,~]=size(layoutlayers);                                              % finds total number of layers that use layouts
    [ly,~]=size(layoutgeopara);                                             % finds total number of unique layout geometries 
    count2=1;                                                               % initalizes count for congrigation of all geometry parameters in each layer
for i=1:lx                                                                  %loop seeks to define all layer and layout combinations for parametric selection. loops through all layers that use a layout as thier geometric input
        xtemp=layoutlayers{i,1};                                            % stores a temporary variable of layer number 
      for ii=1:ly                                                           % itterates through all possible geometry layouts that layer could have
            ytemp=layoutgeopara{ii,1};                                      % stores a temporary variable of the layout number and feature that this itteration is checking 
      if strcmp(layoutlayers{i,4},ytemp(1,1:2)) ==1                         % checks to see if this layout number is equal to the layout used on this itterations layer
          handles.featlist{count2,1}=['L',xtemp(1,end),'.',ytemp(1,2:end)];          % if so store the geometry parameters as Layer Number.Layout Number Feature Number
          count2=count2+1;                                                  % itterate for next solution
      end
      end
end
handles.constfeatlist=['System';handles.featlist];
handles.constlinkedfeatlist=[handles.featlist;'N/A'];
handles.constsyslist=['System';handles.layerrnames;handles.envcnames'];
handles.constlinkedsyslist=['N/A';handles.layerrnames;handles.envcnames'];

handles.bclinkedfeatlist=[handles.featlist','N/A'];
handles.bcsyslist=['System';handles.layerrnames;handles.envcnames']';
handles.bclinkedsyslist=[handles.layerrnames',handles.envcnames,'N/A'];

handles.parafeatlist=[handles.featlist ;'Base']';
handles.paralinkedgeofeatlist=[handles.featlist;handles.NA]';
handles.parasyslist=[handles.layerrnames; handles.envcnames';'System']';
handles.paralinkedsyslist=[handles.layerrnames; handles.envcnames';'System';handles.NA]';
handles.paramatlist=['System';handles.layerrnames; handles.featlist]';
    
set(handles.featconsttable,'columnformat',({handles.featconsttype,handles.constfeatlist',handles.constlinkedfeatlist','numeric'}));
set(handles.sysconsttable,'columnformat',({handles.sysconsttype,handles.constsyslist',handles.constlinkedsyslist','numeric'}));

set(handles.featbctable,'columnformat',({handles.featbctype,handles.featlist',handles.bclinkedfeatlist,'numeric','numeric','numeric'}),'columneditable',true);
set(handles.sysbctable,'columnformat',({handles.sysbctype,handles.bcsyslist, handles.bclinkedsyslist,'numeric','numeric','numeric'}),'columneditable',true);

set(handles.geoparatable,'columneditable',true,'columnformat',({handles.geoparatype handles.parafeatlist handles.paralinkedgeofeatlist 'numeric' 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName',handles.paracnames);
set(handles.assortparatable,'columneditable',true,'columnformat',({handles.assortedparatype handles.parasyslist handles.paralinkedsyslist 'numeric' 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName',handles.paracnames);
set(handles.matparatable,'columneditable',true,'columnformat',({handles.paramatlist handles.matlist' ['N/A',handles.matparatype] 'numeric' 'numeric' 'numeric'}),'ColumnName',handles.matparacnames,'RowName',handles.pararnames);
guidata(hObject,handles);


function ZZZZZZ
% % % % % % % --- Executes on button press in addfeatbcbutt.
% % % % % % function addfeatbcbutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to addfeatbcbutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % [handles.featbcdata]=addrow(handles.featbcdata);
% % % % % % set(handles.featbctable,'data',handles.featbcdata);
% % % % % % 
% % % % % % % --- Executes on button press in removefeatbcbutt.
% % % % % % function removefeatbcbutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to removefeatbcbutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % handles.featbcdata=get(handles.featbctable,'data'); %retrives data from assort parameter table
% % % % % % [handles.featbcdata]=removerow(handles.featbcdata,handles.featbccurrentCell); 
% % % % % % set(handles.featbctable,'data',handles.featbcdata)              % publish new matrix
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % % % % % --- Executes on button press in dummytabstatus.
% % % % % % % % % % function dummytabstatus_Callback(hObject, eventdata, handles)
% % % % % % % % % % % hObject    handle to dummytabstatus (see GCBO)
% % % % % % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % % % % % handles.tabstat=ones(1,10);
% % % % % % % % % % for i=1:length(handles.tabstatus)       %temp hold for radio buttons that dont exist on layouts
% % % % % % % % % %     if 2<i&&i<8||i>9
% % % % % % % % % %     else
% % % % % % % % % % %     handles.tabstat(1,i)=get(handles.(['tab' num2str(i) 'radio']),'value')
% % % % % % % % % % handles.tabstatus(1,i)=500;
% % % % % % % % % %     end
% % % % % % % % % % end
% % % % % % % % % % % dummy=handles.tabstatus
% % % % % % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % 
% % % % % % % --- If Enable == 'on', executes on mouse press in 5 pixel border.
% % % % % % % --- Otherwise, executes on mouse press in 5 pixel border or over dummytabstatus.
% % % % % % function dummytabstatus_ButtonDownFcn(hObject, eventdata, handles)
% % % % % % % hObject    handle to dummytabstatus (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % 
% % % % % % % --- Executes on button press in viewsolutionbutt.
% % % % % % function viewsolutionbutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to viewsolutionbutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % handles.highlightsol=get(handles.highlightsolradio,'value');
% % % % % % toplayer=strrep(get(handles.plotpop,'Value'),'Layer ','');
% % % % % % % if get(handles.loopradio,'value')
% % % % % % %     loop=handles.px;
% % % % % % %     solnum=1;
% % % % % % % else 
% % % % % %     loop=1;
% % % % % %     solnum = get(handles.solutionpop,'value');
% % % % % % % end
% % % % % % % for i=1:loop
% % % % % % set(handles.solutionstatic,'string',handles.solutionpoptxt(1,solnum));
% % % % % % R1=(handles.georow*(solnum-1))+1;
% % % % % % R2=handles.georow*solnum;
% % % % % % R3=2*solnum-1;
% % % % % % Rm3=(handles.matrow*(solnum-1))+1;
% % % % % % Rm4=handles.matrow*solnum;
% % % % % % handles.xlayout=handles.geomaster(R1:R2,1:9);
% % % % % % handles.ylayout=handles.geomaster(R1:R2,10:13);
% % % % % % handles.zlayout=handles.geomaster(R1:R2,14:15);
% % % % % % [handles.layerstack]=unique(handles.zlayout,'rows','stable'); 
% % % % % % handles.dz=handles.layerstack(:,1)';
% % % % % % handles.h=handles.envmaster(R3,:);
% % % % % % handles.Ta=handles.envmaster(R3+1,:);
% % % % % % handles.tempmatprops=handles.matpropsmaster(Rm3:Rm4,:);
% % % % % % % [Temp,Stress,xgrid,ygrid]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init);
% % % % % % [Temp,Stress,xgrid,ygrid,NR,NC,handles.ND]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init,handles.tempmatprops,handles.meshdensity);
% % % % % % axes(handles.layerplot)
% % % % % % cla reset; 
% % % % % % layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,xgrid,ygrid,toplayer,handles.ND)
% % % % % % % handles.layerplothold=figure('visible','off');
% % % % % % % layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,xgrid,ygrid,toplayer)
% % % % % % % guidata(hObject,handles)
% % % % % % axes(handles.modelplot)
% % % % % % cla reset;
% % % % % % tempmaster=handles.geomaster(R1:R2,:);
% % % % % % modelplot(tempmaster,handles.georow,handles.removeencap)
% % % % % % % handles.sysplothold=figure('visible','on');
% % % % % % % % b=handles.sysplothold
% % % % % % % modelplot(tempmaster,handles.georow,handles.removeencap)
% % % % % % % guidata(hObject,handles)
% % % % % % toggles=0;
% % % % % % viewall=0;
% % % % % % axes(handles.resultsplot)
% % % % % % cla reset; 
% % % % % % resultplot(toggles,handles.geomaster,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
% % % % % % % handles.resultsplothold=figure('visible','off');
% % % % % % % resultplot(toggles,handles.geomaster,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol)
% % % % % % % guidata(hObject,handles)
% % % % % % % x=1;
% % % % % % pause(0.01)
% % % % % % % solnum=solnum+1;
% % % % % % % end
% % % % % % guidata(hObject,handles)
% % % % % % % View Solution Butt Create
function viewsolutionbutt_CreateFcn(hObject, eventdata, handles)

% % % % % % % --- Executes on button press in loopradio.
% % % % % % function loopradio_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to loopradio (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hint: get(hObject,'Value') returns toggle state of loopradio
% % % % % % 
% % % % % % 
% % % % % % 
% % % % % % 
% --- Executes on button press in tab7radio.
function tab7radio_Callback(hObject, eventdata, handles)
% hObject    handle to tab7radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.tab7radio=get(hObject,'value');
if handles.tab7radio==1
    set(handles.constgroup,'enable','on')
   borderdata=get(handles.basegeotable,'data');
   [~,cb]=size(borderdata);
   if cb==2
       tempconst={'Base Border Length','System','N/A',borderdata(1,1);...
           'Base Border Width','System','N/A',borderdata(1,2)};
       set(handles.sysconsttable,'data',tempconst)
   end
else
        set(handles.constgroup,'enable','off')
end

function ZZZZZZ
% % % % % % % --- Executes on button press in addfeatconstbutt.
% % % % % % function addfeatconstbutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to addfeatconstbutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % % tempdata=get(handles.featconsttable,'data');
% % % % % % % x=handles.featconsttable
% % % % % % [handles.featconstdata]=addrow(handles.featconstdata);
% % % % % % set(handles.featconsttable,'data',handles.featconstdata);
% % % % % % 
% % % % % % % --- Executes on button press in removefeatconstbutt.
% % % % % % function removefeatconstbutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to removefeatconstbutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % handles.featconstdata=get(handles.featconsttable,'data'); %retrives data from assort parameter table
% % % % % % [handles.featconstdata]=removerow(handles.featconstdata,handles.featconstcurrentCell);                                      % build new matrix what is one row tall
% % % % % % set(handles.featconsttable,'data',handles.featconstdata)              % publish new matrix
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes on button press in addsysconstbutt.
% % % % % % function addsysconstbutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to addsysconstbutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % [handles.sysconstdata]=addrow(handles.sysconstdata);
% % % % % % set(handles.sysconsttable,'data',handles.sysconstdata);
% % % % % % 
% % % % % % % --- Executes on button press in removesysconstbutt.
% % % % % % function removesysconstbutt_Callback(hObject, eventdata, handles)
% % % % % % handles.sysconstdata=get(handles.sysconsttable,'data'); %retrives data from assort parameter table
% % % % % % [handles.sysconstdata]=removerow(handles.sysconstdata,handles.sysconstcurrentCell);
% % % % % % set(handles.sysconsttable,'data',handles.sysconstdata)              % publish new matrix
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes on button press in sysbcaddbutt.
% % % % % % function sysbcaddbutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to sysbcaddbutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % [handles.sysbcdata]=addrow(handles.sysbcdata);
% % % % % % set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % % 
% % % % % % % --- Executes on button press in sysbcremovebutt.
% % % % % % function sysbcremovebutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to sysbcremovebutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % handles.sysbcdata=get(handles.sysbctable,'data'); %retrives data from assort parameter table
% % % % % % [handles.sysbcdata]=removerow(handles.sysbcdata,handles.sysbccurrentCell); 
% % % % % % set(handles.sysbctable,'data',handles.sysbcdata)              % publish new matrix
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % 
% --- Executes during object creation, after setting all properties.
function featconsttable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featconsttable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.featconstcurrentCell=[1 1];
handles.featconstdata=cell(1,4);
set(hObject,'data',handles.featconstdata);
guidata(hObject,handles)

% % % % % % % --- Executes during object creation, after setting all properties.
function sysconsttable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sysconsttable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.sysconstcurrentCell=[1 1];
handles.sysconstdata=cell(1,4);
set(hObject,'data',handles.sysconstdata);
guidata(hObject,handles)

function ZZZZZZ
% % % % % % % --- Executes when entered data in editable cell(s) in featbctable.
% % % % % % function featbctable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.featbcdata=get(hObject,'data');  
% % % % % % cellsel=handles.featbccurrentCell;
% % % % % % content=handles.featbcdata{cellsel(1,1),1}; 
% % % % % % geo=handles.featbcdata(cellsel(1,1),cellsel(1,2));
% % % % % % if cellsel(1,2)==1
% % % % % %    handles.featbcdata(cellsel(1,1),2:5)=cell(1,4);
% % % % % %    set(handles.featbctable,'data',handles.featbcdata);
% % % % % % end
% % % % % % if cellsel(1,2)==2 
% % % % % % end
% % % % % % if cellsel(1,2)==3
% % % % % % end
% % % % % % if strcmp(handles.featbcdata{cellsel(1,1),2},handles.featbcdata{cellsel(1,1),3})==1
% % % % % %     errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
% % % % % %             'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
% % % % % %             'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
% % % % % %             handles.featbcdata(cellsel(1,1),3)={'N/A'};
% % % % % %     set(handles.featbctable,'data',handles.featbcdata);
% % % % % %     return
% % % % % % end
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes when entered data in editable cell(s) in sysbctable.
% % % % % % function sysbctable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.sysbcdata=get(hObject,'data'); 
% % % % % % cellsel=handles.sysbccurrentCell;
% % % % % % content=handles.sysbcdata{cellsel(1,1),1}; 
% % % % % % geo=handles.sysbcdata(cellsel(1,1),cellsel(1,2));
% % % % % % if cellsel(1,2)==1
% % % % % %    handles.sysbcdata(cellsel(1,1),2:5)=cell(1,4);
% % % % % %     if strcmp(content,'Layer Thickness Range')==1
% % % % % %          handles.sysbcdata(cellsel(1,1),3)={'N/A'};
% % % % % %    elseif strcmp(content,'Base Length Range')==1||strcmp(content,'Base Width Range')==1||strcmp(content,'Base L/W Range')==1  
% % % % % %        handles.sysbcdata(cellsel(1,1),2:3)={'System','N/A'};
% % % % % %    elseif strcmp(content,'Module Volume')==1
% % % % % %        handles.sysbcdata(cellsel(1,1),2:3)={'System','N/A'};
% % % % % %     end
% % % % % %    set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % % end
% % % % % % if cellsel(1,2)==2 
% % % % % %     if strcmp(content,'Layer Thickness Range')==1
% % % % % %     allowable=[handles.layerrnames];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['You must select a layer from the stack']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        handles.sysbcdata(cellsel(1,1),3)={'N/A'};
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end  
% % % % % %     elseif strcmp(content, 'Substrate Thickness Rat.')==1
% % % % % %     allowable=[handles.layerrnames];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['You must select the top layer of interest from the stack']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end
% % % % % %     elseif strcmp(content,'Conv. Coeff. (h) Range')==1||strcmp(content,'Ambient Temp. (Ta) Range')==1  
% % % % % %         allowable=[handles.envcnames, 'System'];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['An environmental parameter must be accompanied by' newline...
% % % % % %            ' a side geometry or system level selection.']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end  
% % % % % %        elseif strcmp(content,'Base Length Range')==1||strcmp(content,'Base Width Range')==1||strcmp(content,'Base L/W Range')==1  
% % % % % %         allowable={'System'};
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['Base boundary condition definitions must be' newline...
% % % % % %            'on the system level until **UD is implimented.']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end  
% % % % % %     elseif strcmp(content,'Module Volume')==1
% % % % % %     allowable={'System'};
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['Module Volume boundary condition must be system wide.']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end  
% % % % % %     end
% % % % % % end
% % % % % % if cellsel(1,2)==3
% % % % % %     if strcmp(content,'Layer Thickness Range')==1
% % % % % %     allowable={'N/A'};
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['Nothing can be associated with an layer thickness boundary condtion']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end  
% % % % % %     elseif strcmp(content, 'Substrate Thickness Rat.')==1
% % % % % %     allowable=[handles.layerrnames];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['You must select the substrate layer in the layer stack']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=cell(1,1);
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end
% % % % % %     elseif strcmp(content,'Conv. Coeff. (h) Range')==1||strcmp(content,'Ambient Temp. (Ta) Range')==1  
% % % % % %         allowable=[handles.envcnames, 'N/A'];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['An environmental parameter must be accompanied by' newline...
% % % % % %            ' a side geometry or be defined as an absolute dimension.']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=cell(1,1);
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end  
% % % % % %        elseif strcmp(content,'Base Length Range')==1||strcmp(content,'Base Width Range')==1||strcmp(content,'Base L/W Range')==1  
% % % % % %         allowable={'N/A'};
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['Base boundary conditions cannot have associations.']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end  
% % % % % %     elseif strcmp(content,'Module Volume')==1
% % % % % %     allowable={'N/A'};
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['Module Volume boundary conditions cannot have associations.']),'Boundary Condition Error','modal')
% % % % % %        handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %        return
% % % % % %        end  
% % % % % %     end
% % % % % % end
% % % % % % if strcmp(handles.sysbcdata{cellsel(1,1),2},handles.sysbcdata{cellsel(1,1),3})==1
% % % % % %     errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
% % % % % %             'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
% % % % % %             'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
% % % % % %             handles.sysbcdata(cellsel(1,1),3)=cell(1,1);
% % % % % %     set(handles.sysbctable,'data',handles.sysbcdata);
% % % % % %     return
% % % % % % end
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes when entered data in editable cell(s) in featconsttable.
% % % % % % function featconsttable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.featconstdata=get(hObject,'data');                                  % retrieves constraint feature table content
% % % % % % cellsel=handles.featconstcurrentCell;                                       % temp stores the selected cell within table
% % % % % % content=handles.featconstdata{cellsel(1,1),1};                              % stores column 1 of selected cell's row
% % % % % % geo=handles.featconstdata(cellsel(1,1),cellsel(1,2));                       % sotres the content of the selection
% % % % % % row=cellsel(1,1);
% % % % % % col=cellsel(1,2);
% % % % % % if cellsel(1,2)==1                                                          % if change was maded in column 1
% % % % % %    handles.featconstdata(cellsel(1,1),2:4)=cell(1,3);                       % erase any proceeding column data 
% % % % % %    allowableconst=handles.featconsttype(4:end);
% % % % % %    sum(find(strcmp(allowableconst,content)))
% % % % % %    if sum(find(strcmp(allowableconst,content)))>0
% % % % % %        handles.featconstdata(row,2:3)={'System','N/A'};
% % % % % %    end
% % % % % %     set(handles.featconsttable,'data',handles.featconstdata);                % set values to gui table
% % % % % % end
% % % % % % if cellsel(1,2)==2                                                          % if selection was maded in column 2
% % % % % %     allowableconst=handles.featconsttype(4:end);
% % % % % % if strcmp(geo,'System')==1
% % % % % %      if sum(find(strcmp(allowableconst,content)))<1
% % % % % %          errordlg('A feature selection must be made','Improper Entry','modal')
% % % % % %          handles.featconstdata(row,2)=cell(1,1);
% % % % % %      else
% % % % % %     handles.featconstdata(row,3)={'N/A'};
% % % % % %      end
% % % % % % elseif sum(find(strcmp(allowableconst,content)))>0
% % % % % %     handles.featconstdata(row,2:3)={'System','N/A'};
% % % % % %     errordlg('Any constraint related to a Base must be system wide','Improper Entry','modal')
% % % % % % end
% % % % % %  set(handles.featconsttable,'data',handles.featconstdata);
% % % % % % end
% % % % % % if cellsel(1,2)==3                                                          % if selection was maded in column 3
% % % % % %     if strcmp(handles.featconstdata(row,2),'System')==1
% % % % % %         errordlg('A system selection does not require a linked feature','Improper Entry','modal') 
% % % % % %         handles.featconstdata(row,3)={'N/A'};
% % % % % %         set(handles.featconsttable,'data',handles.featconstdata);
% % % % % %     end
% % % % % % end
% % % % % % if strcmp(handles.featconstdata{cellsel(1,1),2},handles.featconstdata{cellsel(1,1),3})==1
% % % % % %     errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
% % % % % %             'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
% % % % % %             'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
% % % % % %             handles.featconstdata(cellsel(1,1),3)=cell(1,1);                  % define cell that was attempted to be changed as N/A
% % % % % %     set(handles.featconsttable,'data',handles.featconstdata);               % update table 
% % % % % %     return
% % % % % % end
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes when entered data in editable cell(s) in sysconsttable.
% % % % % % function sysconsttable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.sysconstdata=get(hObject,'data');                                   % pulls content of system constraint table
% % % % % % cellsel=handles.sysconstcurrentCell;                                        % indicies of selected cell
% % % % % % content=handles.sysconstdata{cellsel(1,1),1};                               % content of col 1 from selected cell's row
% % % % % % geo=handles.sysconstdata(cellsel(1,1),cellsel(1,2));                        % content of selected cell
% % % % % % if cellsel(1,2)==1                                                          % if selection made in col 1
% % % % % %    handles.sysconstdata(cellsel(1,1),2:4)=cell(1,3);                        % empty all proceeding columns
% % % % % %    set(handles.sysconsttable,'data',handles.sysconstdata);                 % update
% % % % % % end
% % % % % % if cellsel(1,2)==2                                                          % selection made in col 2
% % % % % %     if strcmp(content,'Layer Thickness: Fixed')==1 
% % % % % %     allowable=[handles.layerrnames];                                        % allowable strings to be selected from pop
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['You must select a layer from the stack']),'Parameter Error','modal') % if not allowable string error out
% % % % % %        handles.sysconstdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);      % set entry to first allowable entry
% % % % % %        set(handles.sysconsttable,'data',handles.sysconstdata);              % update
% % % % % %        return
% % % % % %        end  
% % % % % %     elseif strcmp(content,'Conv. Coeff. (h) Fixed')==1||strcmp(content,'Ambient Temp. (Ta) Fixed')==1  
% % % % % %         allowable=[handles.envcnames, 'System'];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['An environmental parameter must be accompanied by' newline...
% % % % % %            ' a side geometry or system level selection.']),'Parameter Error','modal')
% % % % % %        handles.sysconstdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        set(handles.sysconsttable,'data',handles.sysconstdata);
% % % % % %        return
% % % % % %        end  
% % % % % %     end
% % % % % % end
% % % % % % if cellsel(1,2)==3                                                          % if selection made in col 3
% % % % % %      if strcmp(content,'Conv. Coeff. (h) Fixed')==1||strcmp(content,'Ambient Temp. (Ta) Fixed')==1
% % % % % %        allowable=[handles.envcnames, 'N/A'];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['An environmental parameter must be accompanied by' newline...
% % % % % %            'a side geometry selection or N/A to enable an absolute dimension.']),'Parameter Error','modal')
% % % % % %        handles.sysconstdata(cellsel(1,1),cellsel(1,2))=cell(1,1);           % sets col 3 to empty so user has to understand their intent
% % % % % %        set(handles.sysconsttable,'data',handles.sysconstdata);
% % % % % %        return
% % % % % %        end  
% % % % % %     elseif strcmp(content,'Layer Thickness: Fixed')==1
% % % % % %         allowable=[handles.layerrnames' 'N/A'];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['You must select a layer from the stack' newline...
% % % % % %            'or N/A to enable an absolute dimension.']),'Parameter Error','modal')
% % % % % %        handles.sysconstdata(cellsel(1,1),cellsel(1,2))=cell(1,1);
% % % % % %        set(handles.sysconsttable,'data',handles.sysconstdata);
% % % % % %        return
% % % % % %        end  
% % % % % %     end
% % % % % % end
% % % % % % if strcmp(handles.sysconstdata{cellsel(1,1),2},handles.sysconstdata{cellsel(1,1),3})==1
% % % % % %     errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
% % % % % %             'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
% % % % % %             'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
% % % % % %             handles.sysconstdata(cellsel(1,1),3)=cell(1,1);
% % % % % %     set(handles.sysconsttable,'data',handles.sysconstdata);
% % % % % %     return
% % % % % % end
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes when selected cell(s) is changed in featconsttable.
% % % % % % function featconsttable_CellSelectionCallback(hObject, eventdata, handles)
% % % % % % % hObject    handle to featconsttable (see GCBO)
% % % % % % % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
% % % % % % %	Indices: row and column indices of the cell(s) currently selecteds
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % handles.featconstcurrentCell=eventdata.Indices;
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes when selected cell(s) is changed in sysconsttable.
% % % % % % function sysconsttable_CellSelectionCallback(hObject, eventdata, handles)
% % % % % % % hObject    handle to sysconsttable (see GCBO)
% % % % % % % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
% % % % % % %	Indices: row and column indices of the cell(s) currently selecteds
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % handles.sysconstcurrentCell=eventdata.Indices;
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes when selected cell(s) is changed in featbctable.
% % % % % % function featbctable_CellSelectionCallback(hObject, eventdata, handles)
% % % % % % % hObject    handle to featbctable (see GCBO)
% % % % % % % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
% % % % % % %	Indices: row and column indices of the cell(s) currently selecteds
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % handles.featbccurrentCell=eventdata.Indices;
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes when selected cell(s) is changed in sysbctable.
% % % % % % function sysbctable_CellSelectionCallback(hObject, eventdata, handles)
% % % % % % % hObject    handle to sysbctable (see GCBO)
% % % % % % % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
% % % % % % %	Indices: row and column indices of the cell(s) currently selecteds
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % handles.sysbccurrentCell=eventdata.Indices;
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
function sysbctable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sysbctable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.sysbccurrentCell=[1 1];
handles.sysbcdata=cell(1,5);
set(hObject,'Data',handles.sysbcdata);
guidata(hObject,handles)

function ZZZZZZ
% % % % % % % --- Executes on button press in viewallresultsbutt.
% % % % % % function viewallresultsbutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to viewallresultsbutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % toplayer=strrep(get(handles.plotpop,'Value'),'Layer ','');
% % % % % % toggles=get(handles.loopradio,'value');
% % % % % % if toggles==1
% % % % % %     loop=handles.px;
% % % % % % %     solnum=1;
% % % % % %     solnum=get(handles.solutionpop,'value');
% % % % % %     viewall=0;
% % % % % %     solindex=1;
% % % % % % else 
% % % % % %     loop=1;
% % % % % %     solnum = get(handles.solutionpop,'value');
% % % % % %     solindex=solnum;
% % % % % %     viewall=1;
% % % % % % end
% % % % % % axes(handles.resultsplot)
% % % % % % cla reset; 
% % % % % % resultplot(toggles,handles.geomaster,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
% % % % % % % % axes(handles.resultsplothold)
% % % % % % % % cla reset; 
% % % % % % % % handles.resultsplothold=figure('visible','off');
% % % % % % % % resultplot(toggles,handles.geomaster,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
% % % % % % for i=1:loop
% % % % % %     set(handles.solutionstatic,'string',handles.solutionpoptxt(1,solindex));
% % % % % % R1=(handles.georow*(solindex-1))+1;
% % % % % % R2=handles.georow*solindex;
% % % % % % R3=2*solindex-1;
% % % % % % Rm3=(handles.matrow*(solindex-1))+1;
% % % % % % Rm4=handles.matrow*solindex;
% % % % % % handles.xlayout=handles.geomaster(R1:R2,1:9);
% % % % % % handles.ylayout=handles.geomaster(R1:R2,10:13);
% % % % % % handles.zlayout=handles.geomaster(R1:R2,14:15);
% % % % % % [handles.layerstack]=unique(handles.zlayout,'rows','stable'); 
% % % % % % handles.dz=handles.layerstack(:,1)';
% % % % % % handles.h=handles.envmaster(R3,:);
% % % % % % handles.Ta=handles.envmaster(R3+1,:);
% % % % % % handles.tempmatprops=handles.matpropsmaster(Rm3:Rm4,:);
% % % % % % [Temp,Stress,xgrid,ygrid,NR,NC,handles.ND]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init,handles.tempmatprops,handles.meshdensity);
% % % % % % % [Temp,Stress,xgrid,ygrid]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init);
% % % % % % axes(handles.layerplot)
% % % % % % cla reset; 
% % % % % % layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,xgrid,ygrid,toplayer,handles.ND)
% % % % % % axes(handles.modelplot)
% % % % % % cla reset;
% % % % % % tempmaster=handles.geomaster(R1:R2,:);
% % % % % % modelplot(tempmaster,handles.georow,handles.removeencap)
% % % % % % pause(0.01)
% % % % % % solindex=solindex+1;
% % % % % % if i==loop
% % % % % %     handles.layerplothold=figure('visible','off');
% % % % % %     layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,xgrid,ygrid,toplayer,handles.ND)
% % % % % %     handles.sysplothold=figure('visible','off');
% % % % % %     modelplot(tempmaster,handles.georow,handles.removeencap)
% % % % % % end
% % % % % % end
% % % % % % guidata(hObject,handles)
% % % % % % % --- Executes when entered data in editable cell(s) in resultstable.
% % % % % % function resultstable_CellEditCallback(hObject, eventdata, handles)
% % % % % % % hObject    handle to resultstable (see GCBO)
% % % % % % % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
% % % % % % %	Indices: row and column indices of the cell(s) edited
% % % % % % %	PreviousData: previous data for the cell(s) edited
% % % % % % %	EditData: string(s) entered by the user
% % % % % % %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
% % % % % % %	Error: error string when failed to convert EditData to appropriate value for Data
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
function resultstable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultstable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.resultsdata=cell(1,2);
set(hObject,'data',handles.resultsdata);
guidata(hObject,handles)

function ZZZZZZ
% % % % % % % --- Executes on selection change in resultplotpop.
% % % % % % function resultplotpop_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to resultplotpop (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % 
% % % % % % % Hints: contents = cellstr(get(hObject,'String')) returns resultplotpop contents as cell array
% % % % % % %        contents{get(hObject,'Value')} returns selected item from resultplotpop
% % % % % % handles.resultplotname=handles.resultpoptxt{get(hObject,'Value')};
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
function resultplotpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultplotpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% % % % % % % --- Executes on button press in clearguibutt.
function clearguibutt_Callback(hObject, eventdata, handles)
% hObject    handle to clearguibutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global
handles.TempResults=zeros(1,1);
handles.StressResults=zeros(1,1);
cla(handles.layerplot,'reset')
cla(handles.modelplot,'reset')
cla(handles.resultsplot,'reset')
set(handles.numlayersedit,'String','')
set(handles.tprocedit,'String','')
set(handles.nodetempedit,'String','')
set(handles.PCbaseradio,'value',0)
[handles.basernames,handles.layerrnames, handles.layercnames, handles.envrnames, handles.envcnames,handles.geornames,handles.featcnames,handles.geocnames, handles.layoutpop,handles.basecnames,handles.basePCcnames,handles.paracnames,handles.pararnames,handles.matparacnames,handles.matparatype,handles.bccnames,handles.bcrnames,...
    handles.featbctype,handles.sysbctype,handles.geoparatype,handles.assortedparatype,handles.msm,handles.NA,handles.bcfeat,handles.proftemplate,handles.solutionpoptxt,handles.constcnames,handles.featconsttype,handles.sysconsttype,handles.resultsrnames,handles.resultpoptxt]= tables();
set(handles.basegeotable,'columneditable',true ,'columnformat',({'logical' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'}),'RowName',handles.basernames,'ColumnName',handles.basecnames,'data',cell(1,5));
set(handles.envtable,'columnformat',{'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'},'RowName',handles.envrnames,'ColumnName',handles.envcnames,'columneditable',true,'data',cell(2,6));
set(handles.layertable,'columneditable',[true true true],'columnformat',({handles.matlist' 'numeric' handles.layoutpop(:,1)'}),'RowName',handles.layerrnames,'ColumnName',handles.layercnames,'data',cell(12,9)); %pre-define only frist two columns as editable for layer table ie. materail and thickness
handles.envdata=cell(1,6);
handles.geoparadata=cell(1,6);                                              % empty constraints, BC, and paramter matricies
handles.assortparadata=cell(1,6);
handles.matparadata=cell(1,6);
handles.featbcdata=cell(1,5);
handles.sysbcdata=cell(1,5);
handles.featconstdata=cell(1,4);
handles.sysconstdata=cell(1,4);
set(handles.geoparatable,'columneditable',true,'columnformat',({handles.geoparatype handles.NA handles.NA 'numeric' 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName',handles.paracnames,'data',handles.geoparadata);
set(handles.matparatable,'columneditable',true,'columnformat',({handles.layerrnames' handles.matlist' ['N/A',handles.matparatype] 'numeric' 'numeric' 'numeric'}),'ColumnName',handles.matparacnames,'RowName',handles.pararnames,'data',handles.matparadata);
handles.assortedpara=['N/A'; handles.layerrnames; handles.envrnames]';
set(handles.assortparatable,'columneditable',true,'columnformat',({handles.assortedparatype handles.assortedpara handles.assortedpara 'numeric' 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName',handles.paracnames,'data',handles.assortparadata);
set(handles.featbctable,'columneditable',true,'columnformat',({handles.featbctype handles.bcfeat handles.bcfeat 'numeric' 'numeric'}),'RowName',handles.bcrnames,'columnname',handles.bccnames,'data',handles.featbcdata);
set(handles.sysbctable,'columneditable',true,'columnformat',({handles.sysbctype handles.bcfeat handles.bcfeat 'numeric' 'numeric'}),'RowName',handles.bcrnames,'columnname',handles.bccnames,'data',handles.sysbcdata);
set(handles.resultstable,'columneditable',false,'columnname',handles.resultsrnames,'data',cell(1,2));
set(handles.loopradio,'value',0);

% set(handles.solutionstatic,'string',handles.solutionpoptxt(1,1),'value',1)

% set(handles.solutionpop,'value',1)
handles.highlightsol=0;
handles.removeencap=0;
set(handles.highlightsolradio,'Value',handles.highlightsol);
set(handles.removeencapradio,'value',handles.removeencap);
set(handles.resultplotpop,'string',handles.resultpoptxt,'value',1)
handles.resultplotname=handles.resultpoptxt{1,1};
set(handles.plotpop,'value',1)

set(handles.featconsttable,'columneditable',true,'columnformat',({handles.featconsttype handles.NA handles.NA 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName', handles.constcnames,'data',handles.featconstdata);
set(handles.sysconsttable,'columneditable',true,'columnformat',({handles.sysconsttype handles.NA handles.NA 'numeric' 'numeric'}),'RowName',handles.pararnames,'ColumnName', handles.constcnames,'data',handles.sysconstdata);

for i=1:6
n=num2str(i);
set(handles.(['layout',n,'numfeatedit']),'String','')
set(handles.(['tab',n,'radio']),'Value',0)
set(handles.(['layout',num2str(i),'feattable']),'columneditable',true,'RowName',handles.geornames,'ColumnName',handles.featcnames,'data',cell(12,6),'enable','off');
set(handles.(['layout',num2str(i),'geotable']),'columneditable',[true true true true true true],'columnformat',({handles.matlist' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'}),'RowName',handles.geornames,'ColumnName',handles.geocnames,'data',cell(6,12),'enable','off');
handles.(['layout',num2str(i),'featdata'])=get(handles.(['layout',num2str(i),'feattable']),'data');
handles.(['layout',num2str(i),'geodata'])=get(handles.(['layout',num2str(i),'geotable']),'data');
    set(handles.(['layout',n,'numfeatedit']),'enable','off');
    set(handles.(['layout',n,'confbutt']),'enable','off')
    set(handles.(['layout',n,'confquant']),'enable','off')
    set(handles.(['clearlayout',n,'butt']),'enable','off')
end
for i=7:9
    n=num2str(i);
    set(handles.(['tab',n,'radio']),'Value',0)
end
set(handles.paragroup,'enable','off')
set(handles.bcgroup,'enable','off')
set(handles.constgroup,'enable','off')
set(handles.resultsgroup,'enable','off')
guidata(hObject,handles)

%%----GeoParaTable--------------------------------------------------------
% % % % % % 
% % % % % % % Create GeoParaTable
function geoparatable_CreateFcn(hObject, eventdata, handles)
handles.geoparadata=cell(1,6);                                              % pre-define data as empty cell 1,6
set(hObject,'Data', handles.geoparadata);                                   % update table
handles.parageocurrentCell=[1 1];                                           % pre-define selection within table as 1,1
guidata(hObject,handles);                                                   % update handles

function ZZZZZZ
% % % % % % % Cell Edit GeoParaTable
% % % % % % function geoparatable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.geoparadata=get(hObject,'data');                                     % retrieve current data about layers
% % % % % % cellsel=eventdata.Indices;                                                  % determines the indicies of the selected cell
% % % % % % contentsel=handles.geoparadata(cellsel(1,1),cellsel(1,2));                  % saves the content of the selected cell
% % % % % % if cellsel(1,2)==1                                                          % if change was made in column 1
% % % % % %     handles.geoparadata(cellsel(1,1),2:6)=cell(1,5);                        % empty all proceeding columns 
% % % % % % end
% % % % % % if cellsel(1,2)==2                                                          % if change was made in column 2
% % % % % %    if strcmp('Base', contentsel)==1 && strcmp(handles.geoparadata(cellsel(1,1),1),'Heat Gen.')==1 % if selection changed col 2 to 'Base' and it was defined as a Heat gen layer 
% % % % % %        errordlg(['Heat generation must be assigned to a feature'],'Improper Entry','modal') % error out because heat generation cannot be assigened to all base layers **UD need up 
% % % % % %        handles.geoparadata(cellsel(1,1),2)=cell(1,1);                       %empties that selected cell for the user to retry.
% % % % % %    end
% % % % % % end
% % % % % % if cellsel(1,2)==3                                                          % if change was made in column 2
% % % % % %     if strcmp(handles.geoparadata(cellsel(1,1),2),handles.geoparadata(cellsel(1,1),3))==1 % if both column 2 and column 3 have been selected as the same feature
% % % % % %         errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
% % % % % %             'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
% % % % % %             'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
% % % % % %         handles.geoparadata(cellsel(1,1),3)=cell(1,1);                        % empty col 3
% % % % % %     end
% % % % % % end
% % % % % % if strcmp(handles.geoparadata(cellsel(1,1),2),'Base')==1         % if Base is selected from column 2
% % % % % % %     if cellsel(1,2)==3 
% % % % % % %     errordlg(['A base geometry cannot have associated features until **UD is implimented'],'Improper Entry','modal') % awaiting **UD to have any other selection than N/A
% % % % % % %     end
% % % % % % %     handles.geoparadata(cellsel(1,1),3)={'N/A'};                            % set column three to N/A by default. This is unidirectional 
% % % % % % end
% % % % % % if cellsel(1,2)==5                                                          % selection made in column 5
% % % % % %     data=cell2mat(handles.geoparadata(cellsel(1,1),cellsel(1,2)));          % convert selection into numeric value
% % % % % %     if floor(data)~=data || data<=0                                         % verify step input is positive intenger, error out if not
% % % % % %              handles.geoparadata(cellsel(1,1),cellsel(1,2))=cell(1,1); 
% % % % % %              errordlg('The number of steps must be a positive integer.','Improper Entry','modal')
% % % % % %     end
% % % % % % end
% % % % % % set(handles.geoparatable,'data',handles.geoparadata);
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % matlocation=strcmp(handles.matlist',matselect);                              % finds material location in material library matrix
% % % % % % % matmatrix = matlocation*handles.matprops;                                   % creats matrix with only values of selected material, all others are equal to zero
% % % % % % % matrow=removeconstantrows(matmatrix);                                       % removes zero values        
% % % % % % % rowselect=eventdata.Indices(1,1);
% % % % % % % colselect=eventdata.Indices(1,2);
% % % % % % % basecheck=strfind(handles.layerrnames(rowselect,1),'.');
% % % % % % % n=strrep(handles.layerrnames(rowselect,1),'Layer ',''); %replaces layer list with string value of layer number
% % % % % % % if colselect==1                                                             % check that cell selection has been made in column 1 for materials
% % % % % % % for i=4:9                                                                   % ittereations used between columns #:#
% % % % % % %     handles.layerdata(rowselect,i)=num2cell(matrow(1,i-3));    % inputs material properties for the selected layer in columns #:#
% % % % % % % end
% % % % % % 
% % % % % % % Cell Select GeoParaTable
% % % % % % function geoparatable_CellSelectionCallback(hObject, eventdata, handles)
% % % % % % handles.parageocurrentCell=eventdata.Indices;
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % Add Row GeoParaTable
% % % % % % function addgeoparabutt_Callback(hObject, eventdata, handles)  
% % % % % % [handles.geoparadata]=addrow(handles.geoparadata);
% % % % % % set(handles.geoparatable,'data',handles.geoparadata);
% % % % % % 
% % % % % % % Remove Row GeoParaTable
% % % % % % function removegeoparabutt_Callback(hObject, eventdata, handles)
% % % % % % handles.geoparadata=get(handles.geoparatable,'data');                       %retrives data from assort parameter table
% % % % % % [handles.geoparadata]=removerow(handles.geoparadata,handles.parageocurrentCell);
% % % % % % set(handles.geoparatable,'data',handles.geoparadata)                    % publish new matrix
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % %%----AssortParaTable------------------------------------------------------
% % % % % % 
% Create AssortParaTable
function assortparatable_CreateFcn(hObject, eventdata, handles)
handles.assortparadata=cell(1,6);
set(hObject,'Data', handles.assortparadata);
handles.paraassortcurrentCell=[1,1];
guidata(hObject,handles);

function ZZZZZZ
% % % % % % % Cell Select AssortParaTable
% % % % % % function assortparatable_CellSelectionCallback(hObject, eventdata, handles)
% % % % % % handles.paraassortcurrentCell=eventdata.Indices;
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % Cell Edit AssortParaTable
% % % % % % function assortparatable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.assortparadata=get(handles.assortparatable,'data');                 % retrieve data from assort para table (system parameters)
% % % % % % cellsel=handles.paraassortcurrentCell;                                      % retrieves indices of selected cell
% % % % % %     content=handles.assortparadata{cellsel(1,1),1};                         % retrieves parameter from col 1 in selected row
% % % % % %     geo=handles.assortparadata(cellsel(1,1),cellsel(1,2));                  % returns selected cell data
% % % % % %     if cellsel(1,2)==1                                                      % if selection was made in column 1
% % % % % %          handles.assortparadata(cellsel(1,1),2:6)=cell(1,5);                % erase all proceeding data        
% % % % % %     end
% % % % % %     if strcmp('Transient',content)==1                                       % if selected row is a transient parameter
% % % % % %        handles.assortparadata(cellsel(1,1),2)={'System'};                   % set geometry column to system
% % % % % %        if cellsel(1,2)==2                                                   % if change was made in geometry column error out setting back to system
% % % % % %             errordlg(['Transient parameters can only be evaulated at a system level'],'Improper Entry','modal')
% % % % % %        end
% % % % % %        handles.assortparadata(cellsel(1,1),3)={'N/A'};                      % set assocaited to N/A
% % % % % %        if cellsel(1,2)==3                                                   % error out if atempt is to change associated column
% % % % % %             errordlg(['There are no associations permited with a transient parameter'],'Improper Entry','modal') 
% % % % % %        end
% % % % % %     end
% % % % % % if cellsel(1,2)==2                                                          % if change is made in geometry column
% % % % % %     if strcmp(content,'Layer Thickness')==1                                 % if layer thickness parameter is selected
% % % % % %     allowable=[handles.layerrnames];                                        % allowable selections from drop down include layer names
% % % % % %        if find(strcmp(allowable,geo)==1)>0                                  % if selection is not in allowable list error out
% % % % % %        else
% % % % % %        errordlg((['You must select a layer from the stack']),'Parameter Error','modal')
% % % % % %        handles.assortparadata(cellsel(1,1),cellsel(1,2))=allowable(1,1);    % set selection to first allowable selection 
% % % % % %        end  
% % % % % %     elseif strcmp(content,'Conv. Coeff. (h)')==1||strcmp(content,'Ambient Temp. (Ta)')==1  % same procedure as for layer thickness but for ENV parameters
% % % % % %     allowable=[handles.envcnames, 'System'];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['An environmental parameter must be accompanied by' newline...
% % % % % %            ' a side geometry or system level selection.']),'Parameter Error','modal')
% % % % % %        handles.assortparadata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
% % % % % %        end  
% % % % % %     end
% % % % % % elseif cellsel(1,2)==3                                                      % if change is made in associated column
% % % % % %      if strcmp(content,'Conv. Coeff. (h)')==1||strcmp(content,'Ambient Temp. (Ta)')==1  % check allowable ENV strings
% % % % % %        allowable=[handles.envcnames, 'N/A'];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['An environmental parameter must be accompanied by' newline...
% % % % % %            'a side geometry selection or N/A to enable an absolute dimension.']),'Parameter Error','modal')
% % % % % %        handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
% % % % % %        end  
% % % % % %     elseif strcmp(content,'Layer Thickness')==1                             % check allowable layer thickness selections for associated column
% % % % % %         allowable=[handles.layerrnames' 'N/A'];
% % % % % %        if find(strcmp(allowable,geo)==1)>0
% % % % % %        else
% % % % % %        errordlg((['You must select a layer from the stack' newline...
% % % % % %            'or N/A to enable an absolute dimension.']),'Parameter Error','modal')
% % % % % %        handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
% % % % % %        end  
% % % % % %     end
% % % % % % end
% % % % % %  if cellsel(1,2)==4 && strcmp(content,'Transient')==1 && cell2mat(geo)<0    % if transient and min is less than zero error out
% % % % % %      errordlg((['A transient analysis must have positive time']),'Parameter Error','modal')  
% % % % % %      handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
% % % % % %  end
% % % % % % if strcmp(content,'Transient')==1 && cellfun('isempty',handles.assortparadata(cellsel(1,1),4))==0 ... 
% % % % % %         &&cellfun('isempty',handles.assortparadata(cellsel(1,1),6))==0 ...
% % % % % %         && cell2mat(handles.assortparadata(cellsel(1,1),4))>cell2mat(handles.assortparadata(cellsel(1,1),6)) % if transient and both min and max cells have data check if min is greater than max
% % % % % %     
% % % % % %      errordlg((['Transient bounds must be entered in inceasing order']),'Parameter Error','modal')  % if true error out and empty cells
% % % % % %      handles.assortparadata(cellsel(1,1),[4 6])=cell(1,2);
% % % % % % end
% % % % % %   if cellsel(1,2)==5 && cell2mat(geo)~=floor(cell2mat(geo)) || cellsel(1,2)==5 && cell2mat(geo)<=0  % if change is made in steps verify it is a positive integer
% % % % % %      errordlg((['There must be a positive integer number of steps']),'Parameter Error','modal') 
% % % % % %           handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
% % % % % %   end
% % % % % %  if cellsel(1,2)==6 && strcmp(content,'Transient')==1 && cell2mat(geo)<0    % if change is made in max for transient parameter verify value is positive
% % % % % %      errordlg((['A transient analysis must have positive time']),'Parameter Error','modal') 
% % % % % %           handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
% % % % % %  end
% % % % % % if strcmp(handles.assortparadata{cellsel(1,1),2},handles.assortparadata{cellsel(1,1),3})==1
% % % % % %     errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
% % % % % %             'to the selected geometry. Set the layer' newline...      % absolute dim functionality by selecting the associted feature as N/A
% % % % % %             'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
% % % % % %             handles.assortparadata(cellsel(1,1),3)=cell(1,1);
% % % % % % end
% % % % % %     set(handles.assortparatable,'data',handles.assortparadata);
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % % Add Row AssortParaTable
% % % % % % function addassortparabutt_Callback(hObject, eventdata, handles)
% % % % % % [handles.assortparadata]=addrow(handles.assortparadata);                    % addrow function
% % % % % % set(handles.assortparatable,'data',handles.assortparadata);                 % update table
% % % % % %     
% % % % % % % Remove Row AssortParaTable
% % % % % % function removeassortparabutt_Callback(hObject, eventdata, handles)
% % % % % % handles.assortparadata=get(handles.assortparatable,'data'); %retrives data from assort parameter table
% % % % % % [handles.assortparadata]=removerow(handles.assortparadata,handles.paraassortcurrentCell); % remove row function
% % % % % % set(handles.assortparatable,'data',handles.assortparadata)                  % update table
% % % % % % guidata(hObject,handles)                                                    % update handles
% % % % % % 
% % % % % % %%---MatParaTable----------------------------------------------------------
% % % % % % 
% % % % % % % Create MatParaTable
function matparatable_CreateFcn(hObject, eventdata, handles)
handles.matparadata=cell(1,6);                                              % define og data as empty cell array 
set(hObject,'data',handles.matparadata)                                     % set table 
handles.matparacurrentCell=[1 1];                                           % define og selected cell as 1,1
guidata(hObject,handles)                                                    % update

function ZZZZZZ
% % % % % % % Cell Edit MatParaTable
% % % % % % function matparatable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.matparadata=get(handles.matparatable,'data');                       % retrieve current data about layers                              
% % % % % % cellsel=eventdata.Indices;                                                  % determines the indicies of the selected cell
% % % % % % row=cellsel(1,1);
% % % % % % col=cellsel(1,2);
% % % % % % contentsel=handles.matparadata(cellsel(1,1),cellsel(1,2));                  % saves the content of the selected cell
% % % % % % % sysrange=cellfun('isempty',handles.matparadata(row,4:6));
% % % % % % if cellsel(1,2)==1                                                          % if change was made in column 1
% % % % % %     handles.matparadata(cellsel(1,1),2:6)=cell(1,5);                        % empty all proceeding columns 
% % % % % %     if isnan(str2double(contentsel{1,1}(1,end)))==0
% % % % % %         handles.matparadata(row,3)={'N/A'};
% % % % % %         handles.matparadata(row,4:6)={0 1 0};
% % % % % %     end
% % % % % % end
% % % % % % if cellsel(1,2)==2                                                          % if change was made in column 2
% % % % % % end
% % % % % % if cellsel(1,2)==3                                                          % if change was made in column 2
% % % % % %    if strcmp('System',handles.matparadata(row,1))==1 && strcmp('N/A',contentsel)==1
% % % % % %    errordlg(['A system wide material change represents a change in that' newline...
% % % % % %        'material''s property, select a material property to vary.'],'Improper Entry','modal') % awaiting **UD to have any other selection than N/A 
% % % % % %    handles.matparadata(row,col)=handles.matparatype(1,1);
% % % % % % elseif strcmp(contentsel,'N/A')==0 && isnan(str2double(handles.matparadata{row,1}(1,end)))==0
% % % % % %     errordlg(['Changes to an individual feature''s material properties is not permitted.' newline...
% % % % % %          'The feature''s material will only vary to the selected material.'],'Improper Entry','modal') % awaiting **UD to have any other selection than N/A
% % % % % %          handles.matparadata(row,col)={'N/A'};
% % % % % %    end
% % % % % % end
% % % % % % if cellsel(1,2)==4||cellsel(1,2)==5||cellsel(1,2)==6                                                          % if change was made in columns 4,5, or 6
% % % % % % data=cell2mat(contentsel);                                                  % find numerical data
% % % % % %     if isnan(str2double(handles.matparadata{row,1}(1,end)))==0              % check if feature or layer was selected from drop down for material
% % % % % %         errordlg('Edits cannot be made to Min, Steps, or Max when a feature is selected','Improper Entry','modal')  % read error 
% % % % % %         handles.matparadata(row,4:6)={0 1 0};                               % assign to correct default values
% % % % % %     end
% % % % % %     if floor(data)~=data && cellsel(1,2)==5 || cellsel(1,2)==5 && data<=0                               % verify for system wide edit that only integers are entered in steps column  
% % % % % %         errordlg('The number of steps must be a positive integer.','Improper Entry','modal')
% % % % % %         handles.matparadata(row,col)=cell(1,1);
% % % % % %     end
% % % % % % end
% % % % % %     if strcmp(handles.matparadata(row,1),'System')==1 && sum(cellfun('isempty',handles.matparadata(row,:)))==0 % if all entries have been filled in for a material property change check it is within bounds
% % % % % %         minallow=0;                                                         % no material property can be less than zero
% % % % % %         maxallow=inf;                                                       % max material property limit is inf
% % % % % %         [handles.matparadata] = checkbounds(handles.matlist,handles.matparadata,row,handles.matparatype,handles.matprops,minallow,maxallow); %check bounds function
% % % % % %     end
% % % % % % set(handles.matparatable,'data',handles.matparadata);                       % update table
% % % % % % guidata(hObject,handles)                                                    % update handles
% % % % % % 
% % % % % % % Cell Select MatParaTable
% % % % % % function matparatable_CellSelectionCallback(hObject, eventdata, handles)
% % % % % % handles.matparacurrentCell=eventdata.Indices;                               % save selected cell indicies when a click is made in table
% % % % % % guidata(hObject,handles)                                                    % update handles
% % % % % % 
% % % % % % % Add Row MatParaTable
% % % % % % function addmatparabutt_Callback(hObject, eventdata, handles)
% % % % % % [handles.matparadata]=addrow(handles.matparadata);                          % add row function
% % % % % % set(handles.matparatable,'data',handles.matparadata);                       % update table
% % % % % % 
% % % % % % % Remove Row MatParaTable
% % % % % % function removematparabutt_Callback(hObject, eventdata, handles)
% % % % % % handles.matparadata=get(handles.matparatable,'data'); % retrives data from assort parameter table
% % % % % % [handles.matparadata]=removerow(handles.matparadata,handles.matparacurrentCell); % remove row function
% % % % % % set(handles.matparatable,'data',handles.matparadata)                        % update table
% % % % % % guidata(hObject,handles)                                                    % update tables
% % % % % % 
% % % % % % %----Close App Callback----------------------------------------------------
% % % % % % function closebutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to closebutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % %     set(handles.(['tab1text']),'Visible','off')
% % % % % % % set(handles.tab1text,'enable','off')
% % % % % % % % set(handles.tab1text,'visible','off')
% % % % % % % set(handles.(['a1']),'visible','off')
% % % % % % % set(handles.layout1numfeatstatic,'visible','on')
% % % % % % % disp 'yes'6
% % % % % % %     set(handles.(['tab',n,'Panel']),'Units','normalized')
% % % % % % %     set(handles.(['tab',n,'Panel']),'Position',pan1pos)
% % % % % % %     set(handles.(['tab',n,'Panel']),'Visible','off')
% % % % % % %     set(handles.(['tab',n,'text']),'Visible','off')
% % % % % % clear all;close all;clc
% % % % % % 
% % % % % % 
% % % % % % %----Remove Encapsulent Layer From Plot Radio
% % % % % % function removeencapradio_Callback(hObject, eventdata, handles)
% % % % % % handles.removeencap=get(handles.removeencapradio,'value');
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % %----Highlight Solution Radio Buttion
% % % % % % function highlightsolradio_Callback(hObject, eventdata, handles)
% % % % % % handles.highlightsol=get(hObject,'Value');
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % %----Save Image of Plots---------------------------------------------------
% % % % % % %---- Save Results Plot Image
% % % % % % function saveresultplot_Callback(hObject, eventdata, handles)
% % % % % % saveimage(handles.resultsplothold)                               % hidden plot is used to guarentee centered and even figure. Pulling Axes directly
% % % % % % 
% % % % % % %----Save Layer Plot Image
% % % % % % function savelayerplot_Callback(hObject, eventdata, handles)
% % % % % % saveimage(handles.layerplothold);                                % select hidden figure of layer plot as current axes
% % % % % % 
% % % % % % %----Save Sys Plot Image
% % % % % % function savesysplot_Callback(hObject, eventdata, handles)
% % % % % % saveimage(handles.sysplothold);                                   % select hidden figure of system plot as current axes 
% % % % % % 
% % % % % % 
% % % % % % %----Mesh------------------------------------------------------------------
% % % % % % %----Mesh Slider Callback
% % % % % % function devmeshslider_Callback(hObject, eventdata, handles)
% % % % % % temp=floor(get(hObject,'Value'));
% % % % % % if temp==2
% % % % % %     handles.meshdensity=3;                                                  % internal slider values go from 1-3, adjustments made for 1,3,5 
% % % % % % elseif temp==3
% % % % % %     handles.meshdensity=5;
% % % % % % else
% % % % % %     handles.meshdensity=1;
% % % % % % end
% % % % % % meshdensitytxt=['Device Mesh' newline 'Density:' num2str(handles.meshdensity)]; % update text
% % % % % % set(handles.devmeshdensitystatic,'String',meshdensitytxt);                  % set text
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % %----Mesh Slider Create 
function devmeshslider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
handles.meshdensity=3;                                                      % default resolution
set(hObject,'Value',2);                                                     % set default value
set(hObject,'Min',1);                                                       % set range min 
set(hObject,'Max',3);                                                       % set range max
set(hObject,'SliderStep',[0.5 1]);                                          % set step size for [arrow, slider] 
guidata(hObject,handles)

%----Mesh Static Create
function devmeshdensitystatic_CreateFcn(hObject, eventdata, handles)


function ZZZZZZ
% % % % % % %----View System Button Callback
% % % % % % function viewsystembutt_Callback(hObject, eventdata, handles)
% % % % % % if strcmp(get(handles.viewsystembutt,'string'),'Preview System')==1
% % % % % %     runbutt_Callback(hObject, eventdata, handles)
% % % % % % elseif get(handles.tab9radio,'value')==1
% % % % % %     viewsolutionbutt_Callback(hObject, eventdata, handles)
% % % % % % else
% % % % % %     runbutt_Callback(hObject, eventdata, handles)
% % % % % % end
% % % % % % 
% % % % % % %----View Layer Button Callback
% % % % % % function viewlayerbutt_Callback(hObject, eventdata, handles)
% % % % % % % hObject    handle to viewlayerbutt (see GCBO)
% % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % if strcmp(get(handles.viewsystembutt,'string'),'Preview Layer')==1
% % % % % %     runbutt_Callback(hObject, eventdata, handles)
% % % % % % elseif get(handles.tab9radio,'value')==1
% % % % % %     viewsolutionbutt_Callback(hObject, eventdata, handles)
% % % % % % else
% % % % % %     runbutt_Callback(hObject, eventdata, handles)
% % % % % % end
% % % % % % 
% % % % % % 
% % % % % % 
%----Tab Radio----
% Layout 1 Radio
function tab1radio_Callback(hObject, eventdata, handles)
handles.n='1';
[handles]=dummytabradio_Callback(hObject, eventdata, handles);
% Layout 2 Radio
function tab2radio_Callback(hObject, eventdata, handles)
handles.n='2';
[handles]=dummytabradio_Callback(hObject, eventdata, handles);
% Layout 3 Radio
function tab3radio_Callback(hObject, eventdata, handles)
handles.n='3';
[handles]=dummytabradio_Callback(hObject, eventdata, handles);
% Layout 4 Radio
function tab4radio_Callback(hObject, eventdata, handles)
handles.n='4';
[handles]=dummytabradio_Callback(hObject, eventdata, handles);
% Layout 5 Radio
function tab5radio_Callback(hObject, eventdata, handles)
handles.n='5';
[handles]=dummytabradio_Callback(hObject, eventdata, handles);
% Layout 6 Radio
function tab6radio_Callback(hObject, eventdata, handles)
handles.n='6';
[handles]=dummytabradio_Callback(hObject, eventdata, handles);

function ZZZZZZ

% % % % % % %----Confirm Feat Buttons
% % % % % % %----Layout 1 Confirm Button Callback
% % % % % % function layout1confbutt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='1';
% % % % % % dummytabconfbutt_Callback(hObject, eventdata, handles)
% % % % % % %----Layout 2 Confirm Button Callback
% % % % % % function layout2confbutt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='2';
% % % % % % dummytabconfbutt_Callback(hObject, eventdata, handles)
% % % % % % %----Layout 3 Confirm Button Callback
% % % % % % function layout3confbutt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='3';
% % % % % % dummytabconfbutt_Callback(hObject, eventdata, handles)
% % % % % % %----Layout 4 Confirm Button Callback
% % % % % % function layout4confbutt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='4';
% % % % % % dummytabconfbutt_Callback(hObject, eventdata, handles)
% % % % % % %----Layout 5 Confirm Button Callback
% % % % % % function layout5confbutt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='5';
% % % % % % dummytabconfbutt_Callback(hObject, eventdata, handles)
% % % % % % %----Layout 6 Confirm Button Callback
% % % % % % function layout6confbutt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='6';
% % % % % % dummytabconfbutt_Callback(hObject, eventdata, handles)
% % % % % % 
% % % % % % 
% % % % % % %----Confrim Quantity----
% % % % % % % Layout 1 Confirm Quantity Butt Callback
% % % % % % function layout1confquant_Callback(hObject, eventdata, handles)
% % % % % % handles.n='1';
% % % % % % dummyquantitybutt_Callback(hObject, eventdata, handles)
% % % % % % % Layout 2 Confirm Quantity Butt Callback
% % % % % % function layout2confquant_Callback(hObject, eventdata, handles)
% % % % % % handles.n='2';
% % % % % % dummyquantitybutt_Callback(hObject, eventdata, handles)
% % % % % % % Layout 3 Confirm Quantity Butt Callback
% % % % % % function layout3confquant_Callback(hObject, eventdata, handles)
% % % % % % handles.n='3';
% % % % % % dummyquantitybutt_Callback(hObject, eventdata, handles)
% % % % % % % Layout 4 Confirm Quantity Butt Callback
% % % % % % function layout4confquant_Callback(hObject, eventdata, handles)
% % % % % % handles.n='4';
% % % % % % dummyquantitybutt_Callback(hObject, eventdata, handles)
% % % % % % % Layout 5 Confirm Quantity Butt Callback
% % % % % % function layout5confquant_Callback(hObject, eventdata, handles)
% % % % % % handles.n='5';
% % % % % % dummyquantitybutt_Callback(hObject, eventdata, handles)
% % % % % % % Layout 6 Confirm Quantity Butt Callback
% % % % % % function layout6confquant_Callback(hObject, eventdata, handles)
% % % % % % handles.n='6';
% % % % % % dummyquantitybutt_Callback(hObject, eventdata, handles)
% % % % % % 
% % % % % % %----Layout Tabs----------------------------------------------------------
% % % % % % %----Layout Tables----
% % % % % % %----Layout Geo Table Edit----
% % % % % % % Copy Data Between Identical Features
% % % % % % function [geodata]=layoutgeotable(geodata,rnames,cellsel)
% % % % % % row=cellsel(1,1);                                                           % finds selected row
% % % % % % col=cellsel(1,2);                                                           % finds selected column
% % % % % % value=geodata(row,col);                                                     % retrieves the value of selected cell
% % % % % % feats=length(rnames);                                                       % finds number of features in layout
% % % % % % for i=1:feats
% % % % % % featnums(i,:)=strrep(rnames{i,1},'Feature ','');                            % removes leading Feature text from row names
% % % % % % end
% % % % % % featnums=str2num(featnums(:,1));                                            % removes trailing .# from feature numbers
% % % % % % featgroup=find(featnums==str2num(rnames{row,1}(1,end-2)));                  % finds the rows that correlate to the feature selected 
% % % % % % if col==1||col>3
% % % % % %     geodata(featgroup,col)=value;                                           % if update was made in any of the non-unique rows, update to follow the change
% % % % % % end
% % % % % % % Edit Made To Geo Table
% % % % % % function dummylayoutgeotableedit(handles,cellsel)
% % % % % % handles.(['layout' handles.n 'geodata'])=get(handles.(['layout' handles.n 'geotable']),'data');
% % % % % % handles.(['layout' handles.n 'rnames'])=get(handles.(['layout' handles.n 'geotable']),'rowname');
% % % % % % [handles.(['layout' handles.n 'geodata'])]=layoutgeotable(handles.(['layout' handles.n 'geodata']),handles.(['layout' handles.n 'rnames']),cellsel);
% % % % % % set(handles.(['layout' handles.n 'geotable']),'data',handles.(['layout' handles.n 'geodata']));
% % % % % % 
% % % % % % % Layout 1 Geo Table Edit
% % % % % % function layout1geotable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.n='1';
% % % % % % cellsel=eventdata.Indices;
% % % % % % dummylayoutgeotableedit(handles,cellsel)
% % % % % % %----Layout 2 GeoTable Cell Edit Callback
% % % % % % function layout2geotable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.n='2';
% % % % % % cellsel=eventdata.Indices;
% % % % % % dummylayoutgeotableedit(handles,cellsel)
% % % % % % % Layout 3 Geo Table Edit
% % % % % % function layout3geotable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.n='3';
% % % % % % cellsel=eventdata.Indices;
% % % % % % dummylayoutgeotableedit(handles,cellsel)
% % % % % % % Layout 4 Geo Table Edit
% % % % % % function layout4geotable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.n='4';
% % % % % % cellsel=eventdata.Indices;
% % % % % % dummylayoutgeotableedit(handles,cellsel)
% % % % % % % Layout 5 Geo Table Edit
% % % % % % function layout5geotable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.n='5';
% % % % % % cellsel=eventdata.Indices;
% % % % % % dummylayoutgeotableedit(handles,cellsel)
% % % % % % % Layout 6 Geo Table Edit
% % % % % % function layout6geotable_CellEditCallback(hObject, eventdata, handles)
% % % % % % handles.n='6';
% % % % % % cellsel=eventdata.Indices;
% % % % % % dummylayoutgeotableedit(handles,cellsel)
% % % % % % 
% % % % % % %----Layout 1 Geo Table Cell Select
% % % % % % function layout1geotable_CellSelectionCallback(hObject, eventdata, handles)
% % % % % % 
% % % % % % 
% % % % % % 
% % % % % % % Layout 1 NF Edit Callback
% % % % % % function layout1numfeatedit_Callback(hObject, eventdata, handles)
% % % % % % % Layout 2 NF Edit Callback
% % % % % % function layout2numfeatedit_Callback(hObject, eventdata, handles)
% % % % % % % Layout 3 NF Edit Callback
% % % % % % function layout3numfeatedit_Callback(hObject, eventdata, handles)
% % % % % % % Layout 4 NF Edit Callback
% % % % % % function layout4numfeatedit_Callback(hObject, eventdata, handles)
% % % % % % % Layout 5 NF Edit Callback
% % % % % % function layout5numfeatedit_Callback(hObject, eventdata, handles)
% % % % % % % Layout 6 NF Edit Callback
% % % % % % function layout6numfeatedit_Callback(hObject, eventdata, handles)
% % % % % % 
% % % % % % function clearlayoutbutt(n,featdata,geodata)
% % % % % % set(handles.(['tab' n 'radio']),'value',0)
% % % % % % 
% % % % % % %----Clear Layout Buttons----
% % % % % % function [handles]=clearlayoutdummy(handles)
% % % % % % n=handles.n;
% % % % % % tempfeatdata=cell(12,1);
% % % % % % tempgeodata=cell(12,6);
% % % % % % set(handles.(['tab',n,'radio']),'value',0);
% % % % % % set(handles.(['layout',n,'feattable']),'columneditable',true,'RowName',handles.geornames,'ColumnName',handles.featcnames,'data',tempfeatdata,'enable','off');
% % % % % % set(handles.(['layout',n,'geotable']),'columneditable',[true true true true true true],'columnformat',({handles.matlist' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'}),'RowName',handles.geornames,'ColumnName',handles.geocnames,'data',tempgeodata,'enable','off');
% % % % % % set(handles.(['layout',n,'numfeatedit']),'string',[],'enable','off');
% % % % % % set(handles.(['layout',n,'confbutt']),'enable','off')
% % % % % % set(handles.(['layout',n,'confquant']),'enable','off')
% % % % % % set(handles.(['clearlayout',n,'butt']),'enable','off')
% % % % % % handles.(['layout',n,'featdata'])=tempfeatdata;
% % % % % % handles.(['layout',n,'geodata'])=tempgeodata;
% % % % % % idx=find(strcmp(handles.layoutpopactive,(['Layout ' n])));                  % finds indices of layout to be removed
% % % % % % for i=1:length(idx)
% % % % % % handles.layoutpopactive(idx(i,1)-i+1)=[];                                   % removes empty rows and shifts the indexing if mutiple are found. 
% % % % % % end
% % % % % % set(handles.layertable,'columnformat',({handles.matlist' 'numeric' handles.layoutpopactive'})); %pre-define only frist two columns as editable for layer table ie. materail and thickness
% % % % % % % guidata(handles)
% % % % % % 
% % % % % % %----Clear Layout 1 Button Callback
% % % % % % function clearlayout1butt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='1';
% % % % % % [handles]=clearlayoutdummy(handles);
% % % % % % %----Clear Layout 1 Button Callback
% % % % % % function clearlayout2butt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='2';
% % % % % % [handles]=clearlayoutdummy(handles);
% % % % % % %----Clear Layout 3 Button Callback
% % % % % % function clearlayout3butt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='3';
% % % % % % [handles]=clearlayoutdummy(handles);
% % % % % % %----Clear Layout 4 Button Callback
% % % % % % function clearlayout4butt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='4';
% % % % % % [handles]=clearlayoutdummy(handles);
% % % % % % %----Clear Layout 5 Button Callback
% % % % % % function clearlayout5butt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='5';
% % % % % % [handles]=clearlayoutdummy(handles);
% % % % % % %----Clear Layout 6 Button Callback
% % % % % % function clearlayout6butt_Callback(hObject, eventdata, handles)
% % % % % % handles.n='6';
% % % % % % [handles]=clearlayoutdummy(handles);
% % % % % % 
% % % % % % 
% % % % % % %----Layout Create Functions----
% % % % % % %----Layout 1 Geo Table Create
function layout1geotable_CreateFcn(hObject, eventdata, handles)
set(hObject,'Data', cell(12,6));
%----Layout 1 NF Edit Create
function layout1numfeatedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%----Layout 2 NF Edit Create
function layout2numfeatedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%----Layout 3 NF Edit Create
function layout3numfeatedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%----Layout 4 NF Edit Create
function layout4numfeatedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%----Layout 5 NF Edit Create
% --- Executes during object creation, after setting all properties.
function layout5numfeatedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%----Layout 6 NF Edit Create
% --- Executes during object creation, after setting all properties.
function layout6numfeatedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% % % % % % %----Layout 1 Feature Tabel Cell Edit
% % % % % % function layout1feattable_CellEditCallback(hObject, eventdata, handles)
% % % % % % 
% % % % % % %----Dummy Layout Buttons--------------------------------------------------
% % % % % % %----Dummy Tab Radio
function [handles]=dummytabradio_Callback(hObject, eventdata, handles)
if str2double(handles.n)<7
for i=1:6
if get(handles.(['tab' num2str(i) 'radio']),'value')==1
handles.tabstatus(1,i)=1;
end
end
n=handles.n;
value=get(handles.(['tab',n,'radio']),'value');
if value==1
set(handles.(['layout',n,'numfeatedit']),'enable','on');
set(handles.(['layout',n,'confbutt']),'enable','on')
set(handles.(['clearlayout',n,'butt']),'enable','on')
handles.layoutpopactive=[handles.layoutpopactive(:,1); handles.layoutpop(str2double(n)+2,1)]; % updates layout pop
set(handles.layertable,'columnformat',({handles.matlist' 'numeric' handles.layoutpopactive'})); %pre-define only frist two columns as editable for layer table ie. materail and thickness
else
set(handles.(['layout',n,'feattable']),'enable','off');                     % turn off all layout panel features
set(handles.(['layout',n,'geotable']),'enable','off');
set(handles.(['layout',n,'numfeatedit']),'enable','off');
set(handles.(['layout',n,'confbutt']),'enable','off')
set(handles.(['layout',n,'confquant']),'enable','off')
idx=find(strcmp(handles.layoutpopactive,(['Layout ' n])));                  % finds indices of layout to be removed
for i=1:length(idx)
handles.layoutpopactive(idx(i,1)-i+1)=[];                                   % removes empty rows and shifts the indexing if mutiple are found. 
end
set(handles.layertable,'columnformat',({handles.matlist' 'numeric' handles.layoutpopactive'})); %pre-define only frist two columns as editable for layer table ie. materail and thickness
end

handles.NLayouts=sum(handles.tabstatus);

if str2double(handles.n)==9                                              % checks to see if radio button has been selected on tab 10 ie parameter tab
[handles] =pubfeatbutt_Callback(hObject, eventdata, handles);
disp 'n=9999'
end
end
guidata(hObject,handles)

%----Dummy Layout Check Callback
function [handles]=dummylayoutcheckbutt_Callback(handles)
handles.layerdata=get(handles.layertable,'data');
count=1;
layoutcmp=zeros(handles.NL);
for i=1:handles.NL
    for ii=1:handles.NL
layoutcmp(count,i)=strcmp(char(handles.layerdata(ii,3)), handles.layoutpop(i,1));
count=count+1;
    end
    count=1;
end
handles.baseindex=[0 99 1:12]';
for i=1:handles.NL
   layoutcheck=find(layoutcmp(:,i)==1);
   for ii=1:length(layoutcheck)
      handles.layoutint(layoutcheck(ii,1),1)= handles.baseindex(i,1);
   end
end 

%---- Dummy Tab Confirm Button Callback
function dummytabconfbutt_Callback(hObject, eventdata, handles)
set(handles.(['layout',handles.n,'geotable']),'enable','off');
handles.NF=str2double(get(handles.(['layout',handles.n,'numfeatedit']),'string'));
if mod(handles.NF,1)~=0
     errordlg('The number of features must be an integer.','Improper Entry','modal')
     return
end
tempdata=get(handles.(['layout',handles.n,'feattable']),'data');
if handles.NF<length(tempdata)
    tempdata=tempdata(1:handles.NF,:);
elseif handles.NF>length(tempdata)
    tempdata=[tempdata;cell(12-length(tempdata),1)];
end
set(handles.(['layout',handles.n,'feattable']),'RowName',handles.geornames(1:handles.NF),'data',tempdata(1:handles.NF,:),'columneditable',true,'columnformat',{'numeric'},'enable','on');;
set(handles.(['layout',handles.n,'confbutt']),'enable','on')
set(handles.(['layout',handles.n,'confquant']),'enable','on')
guidata(hObject,handles)

function ZZZZZZ
% % % % % % %----Dummy Quantity Button Callback
% % % % % % function dummyquantitybutt_Callback(hObject, eventdata, handles)
% % % % % % handles.NF=str2double(get(handles.(['layout',handles.n,'numfeatedit']),'String'));                                                                % Features that have a different quantity in the paramter panel than the geometry table.
% % % % % % ORG=2;                                                                      % Starting point of first selection                                                                                                           % Turns features that are not included into neg 1
% % % % % % Q=(get(handles.(['layout',handles.n,'feattable']),'data'));
% % % % % % if iscell(Q)==1
% % % % % %     Q=cell2mat(Q);
% % % % % % end
% % % % % % if all(Q)==0 || sum(isnan(Q))>0
% % % % % %      errordlg(['There must be a positive integer of all features.' newline 'Remove any that are unused.'],'Improper Entry','modal')
% % % % % %      return
% % % % % % end
% % % % % % Q=[Q;zeros(12-length(Q),1)]; 
% % % % % % temprnames=get(handles.(['layout',handles.n,'geotable']),'rowname');
% % % % % % tempdata=get(handles.(['layout',handles.n,'geotable']),'data');
% % % % % % 
% % % % % % if strcmp(temprnames{1,1},'Feature 1.1')==1                                 % temporarily removes .1 entries on all features so they can be called correctly
% % % % % %     [lt,~]=size(temprnames);
% % % % % %     for i=1:lt
% % % % % %         temprnames(i,1)={temprnames{i,1}(1:9)};
% % % % % %     end
% % % % % % end
% % % % % % geomat=([temprnames(1:end,1), tempdata(1:end,:)]);
% % % % % % for i=1:handles.NF
% % % % % % rnumbs=str2double(strrep(geomat(:,1),'Feature ',''));
% % % % % % hits=zeros(12,1);     
% % % % % %         for ii=1:12
% % % % % %         hits(ii,1)=sum(rnumbs(:) == ii);
% % % % % %         end
% % % % % % diff=Q-hits;                                                                % Features that have a different quantity in the paramter panel than the geometry table.
% % % % % % Q2=[0;Q];                                                                   % Starting point of first selection                                               
% % % % % % adjhits=hits-1;                                                             %                                         
% % % % % %                                                      % Adds zero for itteration purposes, otherwise regions could potentially go negative
% % % % % %     if diff(i,1)>0
% % % % % %        blank=cell(diff(i,1),7);                                             % Creates blank matrix for new entries
% % % % % %        blank(:,1)={['Feature ',num2str(i)]};                                % Defines first column with required Feature #n
% % % % % %         R1=ORG+sum(Q2(1:i,1))+adjhits(i);                                   % Region 1 finds the area that is to be shifted down to make room for the extra features
% % % % % %         [R2,~]=size(geomat);                                                % Region 2 finds the end of the table
% % % % % %         R3= sum(Q2(1:i+1,1))+1;                                             % Region 3 finds destination cell of R1:R2
% % % % % %         R4=R3+R2-R1;                                                        % Region 4 finds the end of the destination range
% % % % % %         geomat(R3:R4,:)=geomat(R1:R2,:);                                    % Updates the geomat with shifted cells
% % % % % %         geomat(R1:R3-1,:)=blank;                                            % Removes any cells that are after the desired region
% % % % % %     end   
% % % % % % if diff(i,1)<0                                                              % remove additional features from geo table
% % % % % % hits=[0;hits];
% % % % % %        R5=sum(hits(1:i+1,1))+1 ;                                            % Region 5 finds the area that is to be shifted up to consume the extra features
% % % % % %        [R6,~]=size(geomat) ;                                                % Region 6 finds the end of the table
% % % % % %        R7=R5+diff(i);                                                       % Region 7 finds destination cell of R5:R6
% % % % % %        R8=R6-R5+R7;                                                        % Region 8 finds the end of the destination range
% % % % % %        geomat(R7:R8,:)=geomat(R5:R6,:);                                     % Updates the geomat with shifted cells
% % % % % %        if R5>R6
% % % % % %        else
% % % % % %        geomat(R8+1:end,:)=[];                                                 % Removes any cells that are after the desired region
% % % % % %        end
% % % % % % end
% % % % % % end 
% % % % % % geomat(sum(Q2)+1:end,:)=[];
% % % % % % [lg,~]=size(geomat);
% % % % % % count=1;
% % % % % % tempgeomat=cell(lg,1);
% % % % % % for i=1:lg                                                                   % adds nessesary 0.1 destinction to feature numbers. 
% % % % % %     tempgeomat{i,1}=[geomat{i,1},'.', num2str(count)];
% % % % % %     count=count+1;
% % % % % %     if i==lg
% % % % % %         break
% % % % % %     elseif strcmp(geomat{i,1}, geomat{i+1,1})==0
% % % % % %     count=1;    
% % % % % %     end
% % % % % % end
% % % % % % geomat(:,1)=tempgeomat;
% % % % % % set(handles.(['layout',handles.n,'geotable']),'RowName',geomat(:,1),'data',geomat(:,2:end),'enable','on');
% % % % % % guidata(hObject,handles)
% % % % % % 
% % % % % % 
% % % % % % % --- Executes during object creation, after setting all properties.
function pararadiotxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pararadiotxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called