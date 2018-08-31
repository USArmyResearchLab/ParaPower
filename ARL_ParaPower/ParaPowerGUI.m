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
                   'gui_OpeningFcn', @ParaPowerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ParaPowerGUI_OutputFcn, ...
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

% --- Executes just before ParaPower V1.1 is made visible.
function ParaPowerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ThermalParameterV1 (see VARARGIN)
% set(handles.tab4text,'enable','off')
% Choose default command line output for ThermalParameterV1

set(hObject,'Name','ParaPower V1.1')
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
set(handles.resultplotpop,'enable','on')                                    %makes choosing output graph type selectable before running a simulation
set(handles.devmeshdensitystatic,'enable','on')
set(handles.devmeshslider,'enable','on')
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
% set(handles.SimpleOptimizedTab,'Units','normalized')
pos = get(handles.SimpleOptimizedTab, 'Position');
% pos(1)=1
% pos(2)=1
% pos(4)=1;
% handles.pos=pos;
% set(handles.tab1Panel,'Units','normalized')
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
%     set(handles.(['tab',n,'text']),'Units','normalized')
    pos=get(handles.(['tab',n,'text']),'Position');
% if i==7
%     pos(1)=pos(1)+0.025;
% end
% pos(1)-pos(2)
    % Create axes with callback function Tab Feautres
    handles.(['a',n]) = axes(...'Units','normalized',...
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
                   ... 'Units','normalized',...
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
% set(handles.tab1Panel,'Units','normalized');
pan1pos=get(handles.tab1Panel,'Position');                                  % retrieves position of panel 1, used to place all additonal panels
pan1pos(3)=0.58;
tab1pos=get(handles.tab1text,'position');
tab11pos=get(handles.tab11text,'position');
pan1pos(1)=tab1pos(1);
pan1pos(3)=tab11pos(1)+tab11pos(3)-tab1pos(1);

% set(handles.(['tab','1','Panel']),'Position',pan1pos);
pan1pos=get(handles.tab1Panel,'Position'); 
% pan1pos(4)=handles.FigHeight;
% pan1pos=[ 0    0  0.5    0.5]
set(handles.tab1text,'Visible','off')
for i = 2:TabsNumber
    n = num2str(i);
%     set(handles.(['tab',n,'Panel']),'Units','normalized')
%     set(handles.(['tab',n,'Panel']),'Position',pan1pos)
    set(handles.(['tab',n,'Panel']),'Visible','off')
    set(handles.(['tab',n,'text']),'Visible','off')
end

% --- Outputs from this function are returned to the command line.
function varargout = ParaPowerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function runbutt_Callback(hObject, eventdata, handles)
%executes whenever the run button is pressed, as well as a few other
%occations. Evaluates the inputs into ParaPower and displays their results

%turn off or on GUI interactivity
set(handles.layerslicegroup,'enable','on')
% set(handles.resultsgroup,'enable','off')
set(handles.sysgeogroup,'enable','on')
set(handles.resultsgroup,'enable','on')

%initialize variables
handles.NL=str2double(get(handles.numlayersedit,'string'));
[handles]=pubfeatbutt_Callback(hObject, eventdata, handles);                %handles def: struct variable with many fields containint most variables in this program
[handles]=dummylayoutcheckbutt_Callback(handles);
handles.TempResults=0;                                                      %handles.TempResults def: TBD
handles.StressResults=0;                                                    %handles.StressResults def: TBD, but should be similar to handles.TempResults
% layerdata=get(handles.layertable,'data');                                 % retrieve data from layer table from GUI. layerdata def: cell array of the table in the Layer Parameters section of the GUI, in the order presented in the GUI
% [lb,~]=size(handles.layertable.Data);                                     % lb is the number of layers
handles.bmat=zeros(handles.NL,1);                                           % initialize handles.bmat matrix (defined below), size is number of layers
for iii=1:handles.NL
    for ii=1:length(handles.matlist)
        if strcmp(handles.layertable.Data(iii,1),handles.matlist(ii,1))==1  % populate handles.bmat with the index of the materiallist that each layer is composed of
            handles.bmat(iii,1)=ii;                                         %handles.bmat def: column vector, each row corresponds to a layer, with the first row being the first layer. The value matches the index inside handles.matlist of that layer's material 
        end
    end
end
% layerdata=cell2mat(layerdata(:,2));                                       %creates a vector of layer thicknesses
[handles.layerstack]=layerconfig(cell2mat(handles.layertable.Data(:,2)));   %handles.layerstack def: vector of z offsets starting from the bottom of the system, one entry for each layer
LayoutRowPointer=1;                                                         %LayoutRowPointer def: pointer for rows for xlayout and variants, scalar, used in assigning values to xlayout matrix and variants
BaseLayerRowPointer=1;                                                      %BaseLayerRowPointer def: same as layout_row_pointer (see above) but for the baselayer variable
BaseLayerCount=1;                                                           %BaseLayerCount def: keeps track of the number of base layers in the simulated area

%%
%initialize layer dependent variables: location of features and layers,
%number of features, size and location of base
handles.xlayout = [];
handles.ylayout = [];
handles.zlayout = [];
for i=1:handles.NL
    if handles.layoutint(i,1)>0 && handles.layoutint(i,1)<99                %determine if a layout is used for each layer, and what number layout it is
        n=num2str(handles.layoutint(i,1));                                  %handles.layoutint def: cell vector holds the number of the layout used for each layer, starting with the first layer. n def: see handles.layoutint def, but is an integer
        geodata=get(handles.(['layout',n,'geotable']),'data');              %gets the geometry(?) data for the layout used
        [lg,~]=size(geodata);                                               %gets the number of features on the layout
        featmat=zeros(lg,1);                                                %initialize a feature material variable
        for iii=1:lg
            for ii=1:length(handles.matlist)                                %move to independent function
                if strcmp(geodata(iii,1),handles.matlist(ii,1))==1          %consider change to find function
                    featmat(iii,1)=ii;                                      %featmat def: same concept as handles.bmat, makes a vector of indexes for material list that points to the material that each feature is made out of
                end
            end
        end
        layoutgeodata=cell2mat(geodata(:,2:6));                                   %geodata def: all info from the features of a layer minus their materials, converted into a regular array
%         layoutgeodata(5) = cell2mat(geodata(:,6));
        featdata=get(handles.(['layout',num2str(handles.layoutint(i,1)),'feattable']),'data');      %featdata def: get the quantity of each feature?
        geofeat=get(handles.(['layout',num2str(handles.layoutint(i,1)),'geotable']),'rowname');     %geofeat def: get the names of the features in a layer e.g Feature 2.1
        if iscell(featdata)==1
            sumfeat=sum(cell2mat(featdata));
        else
            sumfeat=sum((featdata));
        end                                                                 %get the total number of features in a layer
        [ln,~]=size(geofeat);
        layoutnum=zeros(ln,1);
        for ii=1:ln
            layoutnum(ii,1)=str2double(geofeat{ii,1}(9:end));               %gets the number of each feature, e.g. 2.1, won't work if the names of the features gets changed
        end
        [x,y,z] = featurecoordinates(handles.layerstack,i,layoutgeodata,sumfeat,featmat,handles.layoutint(i,1),layoutnum); %creates sets of coordinates for each feature
        handles.xlayout(LayoutRowPointer:LayoutRowPointer+sumfeat-1,1:9)=x; %handles.xlayout def: each row is a feature or base layer, first 4 columns are the x beginning and end coordinates for the feature, listed twice. The rest of the columns are material properties(?)
        handles.ylayout(LayoutRowPointer:LayoutRowPointer+sumfeat-1,1:4)=y; %handles.ylayout def: see handles.xlayout def, but with y beggining and end coordinates
        handles.zlayout(LayoutRowPointer:LayoutRowPointer+sumfeat-1,1:2)=z; %handles.zlayout def: see handles.xlayout def, buth with z beggining and end coordinates
        LayoutRowPointer=LayoutRowPointer+sumfeat;                                                
        BaseLayerCount=BaseLayerCount+sumfeat;
%         layoutnum=layoutnum+1;

    elseif handles.layoutint(i,1)==0 || handles.layoutint(i,1)==99
        %         disp 'her'
        handles.xlayout(LayoutRowPointer,:)=[0 0 0 0 0 i handles.bmat(i) 0 0];
        handles.ylayout(LayoutRowPointer,1:4)=0;
        handles.zlayout(LayoutRowPointer,1:2)=0;
        baselayers(BaseLayerRowPointer,1)=i;                                             % saves row number in which base layers exist in original layer stack
        baselayers(BaseLayerRowPointer,2)=BaseLayerCount;                                        % saves row numbers in which base layers will be published to
        LayoutRowPointer=LayoutRowPointer+1;                                                      % count itterations could use more defining variable names
        BaseLayerRowPointer=BaseLayerRowPointer+1;
        BaseLayerCount=BaseLayerCount+1;
    end
end
basedata=get(handles.basegeotable,'data');                                  %basedata def: vector of data that is in the Base Geometry tab.

[~,basetype]=size(basedata);                                               %lb def: number of rows in the base geometry table. unknown if this can be greater than one by definition



handles.georow = LayoutRowPointer - 1;                                     %handles.georow def: total number of features and base layers in simulated system

%basetype def: size of the number of columns in the base geometry table. method of determining what mode of base geometry definitions is used.
% basemat=zeros(lb,1);
% for iii=1:lb
%     for ii=1:length(handles.matlist)
%         if strcmp(basedata(iii,1),handles.matlist(ii,1))==1
%             basemat(iii,1)=ii;
% 
%         end
%     end
% end

%determine how the base geometry location will be defined

%new basedata def: code below changes basedata to be only the information
%that contains the useful dimension values, depending on how the geometry
%is defined, see above code and PCbaseradio_Callback

% [lb,~]=size(baselayers);
if iscell(basedata)==1
%     [~,bc]=size(basedata);
    if basetype>2
        if basedata{1,1}==1
            basedata=cell2mat(basedata(:,4:5));
        else
            basedata=cell2mat(basedata(:,2:end));
        end
    else
        basedata=cell2mat(basedata);
    end
end


basecheck = exist('baselayers','var');
if basecheck
    for i=1:size(baselayers)
        row=baselayers(i,1);                                                    % layers number in which the z stack height needs to be pulled
        row2=baselayers(i,2);                                                   % row number in layout matrix in which base layer is published to
        [baseX,baseY,baseZ] = basecoordinates(row,handles.layerstack,basedata,handles.xlayout,handles.ylayout,basetype); %defines the x,y,and z coordinates for each base layer
        handles.xlayout(row2,1:6)=baseX;
        handles.ylayout(row2,1:4)=baseY;
        handles.zlayout(row2,1:2)=baseZ;
    end
end

%% Parametric variation
tic;

if get(handles.tab9radio,'Value')==1                                        %checks if parametric study is active
    handles.delta_t=0;
    handles.transteps=1;
    
    handles.geoparadata=get(handles.geoparatable,'data');                   %handles.geoparadata def: the table from the feature parameters from the parameter tab
    
    [data,choice,handles.geoparadata]=parameterpull(handles.geoparadata);   %handles.geoparadata gets truncated here if there is empty data
    if choice==1
        return
    end
    set(handles.geoparatable,'data',data);                                  %geoparatable is all data from old geoparadata
    
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
    
    handles.paradata=[handles.geoparadata;handles.assortparadata;handles.matparadata];  %handles.paradata def: all finalized data from the parameters tab
    handles.paradata=flipud(handles.paradata);
    conparadata=handles.paradata(~isempty(handles.paradata));
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
    %come back to analyze this one, along with the ex variable
    [handles.feature_layout_master,handles.envmaster,handles.envrow,handles.delta_t,handles.transteps,handles.bmatmaster,handles.matpropsmaster,handles.tranmin]...
        = ParameterMaster(handles.paradata,handles.envdata,handles.envcnames,handles.xlayout,handles.ylayout,handles.zlayout,handles.basestatus,handles.basedata,handles.bmat,handles.NL,handles.matlist,handles.matprops,handles.matparatype);
    handles.Tproc=str2double(get(handles.tprocedit,'string'));
    handles.T_init=str2double(get(handles.nodetempedit,'string'));
    [ex,~]=size(handles.envmaster);
    px=ex/2;
handles.px=px;
    
else
    %if parametric study is not active:
    handles.feature_layout_master=[handles.xlayout handles.ylayout handles.zlayout];
%     [handles.georow,~]=size(handles.feature_layout_master);
    handles.envmaster=cell2mat(get(handles.envtable,'data'));
    handles.px=1;
    handles.matpropsmaster=handles.matprops;
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
    [masterlayout,quar,quardetails,quarenv,envmaster] = ConditionCheck(Cond,handles.envcnames,handles.georow,handles.feature_layout_master,handles.envmaster);
    [mr,~]=size(masterlayout);
    [gr,~]=size(handles.feature_layout_master);
    if mr~=gr
        quardetails
    end
    if isempty(masterlayout)==1
        errordlg(['Every trial was quarentined please address the published matrix' newline...
            'for detials on what drove this'],'Incomplete Entry','Modal')
        return
    end
    handles.feature_layout_master=masterlayout;
    handles.envmaster=envmaster;
    [lm,~]=size(masterlayout);
    handles.px=lm/handles.georow;
    handles.solutionpoptxt=cell(1,handles.px);
end
handles.resultstxt=cell(handles.px,1);

R7=1;
R1=1;
R2=handles.georow;
[handles.matrow,~]=size(handles.matprops);
Rm3=1;
Rm4=handles.matrow;
count1=1;

for i=1:handles.px
    R10=handles.transteps*i-handles.transteps+1;
    handles.solutionpoptxt{1,i}=['Solution ' num2str(i)];
    if get(handles.tab9radio,'Value')==1 && sum(strcmp(handles.paradata(:,1),'Transient'))>0
        handles.resultstxt{R10,1}=['Sol.' num2str(i)];                      %sets up text to differentiate different solutions in the solution table for transient solutions
    else
        handles.resultstxt{i,1}=['Sol.' num2str(i)];
    end
    handles.xlayout=handles.feature_layout_master(R1:R2,1:9);
    handles.ylayout=handles.feature_layout_master(R1:R2,10:13);
    handles.zlayout=handles.feature_layout_master(R1:R2,14:15);
    [handles.layerstack]=unique(handles.zlayout,'rows','stable');
    handles.dz=handles.layerstack(:,1)';
    if iscell(handles.envmaster)==1
        handles.envmaster=cell2mat(handles.envmaster);
    end
    handles.h=handles.envmaster(count1,:);
    handles.Ta=handles.envmaster(count1+1,:);
    handles.tempmatprops=handles.matpropsmaster(Rm3:Rm4,:);
    [Temp,Stress,handles.xgrid,handles.ygrid,NR,NC,handles.ND,handles.NL,handles.xlayout,handles.ylayout]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init,handles.tempmatprops,handles.meshdensity);
    TempMaster(i,1)=max(Temp(:));
    StressMaster(i,1)=max(Stress(:));
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
    
    if get(handles.tab9radio,'Value')==1 && sum(strcmp(handles.paradata(:,1),'Transient'))>0
        
        for iiii=1:handles.transteps
            for ii=1:handles.NL
                handles.TempResults(R5:R6,R7:R8)=Temp(R3:R4,1:NC,ii,iiii);
                handles.TempResults(R5,R8+1)=handles.tranmin+(handles.delta_t*(iiii-1));
                handles.StressResults(R5:R6,R7:R8)=Stress(R3:R4,1:NC,ii,iiii);
                handles.StressResults(R5,R8+1)=handles.tranmin+(handles.delta_t*(iiii-1));
                maxhold(ii,iiii+R9)=max(max(handles.TempResults(R5:R6,R7:R8)));
                stresshold(ii,iiii+R9)=max(max(handles.StressResults(R5:R6,R7:R8)));
                R5=R5+NR+1;
                R6=R6+NR+1;
            end
            timeresults(iiii+R9,1)=handles.tranmin+(handles.delta_t*(iiii-1));
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

    R7=R7+NC+1;
    

end
%% Output Results   
%TempResults
%
% time_result = tic;
axes(handles.layerplot)
cla reset;
toplayer=get(handles.plotpop,'Value');
layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,handles.xgrid,handles.ygrid,toplayer,handles.ND)
% handles.layerplothold=figure('visible','off');
% layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,handles.xgrid,handles.ygrid,toplayer,handles.ND)
set(handles.solutionpop,'string',handles.solutionpoptxt,'value',1);
axes(handles.modelplot)
cla reset;
modelplot(handles.feature_layout_master,handles.georow,handles.removeencap,handles.matcolors,handles.dz)
% handles.sysplothold=figure('visible','off');
% modelplot(handles.feature_layout_master,handles.georow,handles.removeencap,handles.matcolors)
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
toplayer=get(handles.plotpop,'Value');
toggles=get(handles.loopradio,'value');
if toggles==1
    loop=handles.px;
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
resultplot(toggles,handles.feature_layout_master,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
handles.resultsplothold=figure('visible','off');
resultplot(toggles,handles.feature_layout_master,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
% result_time = toc(time_result)
toc;
guidata(hObject, handles);
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
clear all;
close all;
clc

% --- Executes on button press in pubfeatbutt.


% --- Executes during object creation, after setting all properties.
function layout1confbutt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layout1confbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Number of Layers Create
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
elseif handles.NL < 0
    errordlg('The number of layers must be positive.','Improper Entry','modal')
    return
end
if strcmp(get(hObject,'string'),'Update System')==1
    handles.layerdata=cell(handles.NL,length(handles.layercnames));          % update layerdata entries
    templayerdata=get(handles.layertable,'data');                           % retrive data from layer table
    [ld,~]=size(handles.layerdata);
    [lt,~]=size(handles.layerrnames);
if ld<lt
    handles.layerdata=templayerdata(1:ld,:);
    handles.layerrnames(ld+1:end) = [];
else
    handles.layerdata(1:lt,:)=templayerdata;
    if lt<ld
    for i = lt+1:ld
        handles.layerrnames(i,:)= cellstr(cat(2,'Layer ',num2str(handles.NL-(ld-i))));
    end
    end
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

function layout2confbutt_Callback(hObject, eventdata, handles)
handles.n='2';
dummytabconfbutt_Callback(hObject, eventdata, handles)

function clearlayout2butt_Callback(hObject, eventdata, handles)
handles.n='2';
[handles]=clearlayoutdummy(handles);

% Layout 2 NF Edit Callback
function layout2numfeatedit_Callback(hObject, eventdata, handles)

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
set(handles.resultplotpop,'enable','on')
handles.xlayout = [];
handles.ylayout = [];
handles.zlayout = [];

if handles.NL < size(handles.layerrnames)
    handles.layerrnames(handles.NL+1:end) = [];
else
    if size(handles.layerrnames) < handles.NL
        for i = size(handles.layerrnames)+1:handles.NL
            handles.layerrnames(i,:)= cellstr(cat(2,'Layer ',num2str(i)));
        end
    end
end

% set(handles.runbutt,'enable','on');
set(handles.sysconfbutt,'string','Update System');
set(handles.PCbaseradio,'enable','on');
set(handles.envtable,'enable','on');
set(handles.layertable,'enable','on');
set(handles.runbutt,'enable','on');
for i=1:length(handles.tabstatus)       %temp hold for radio buttons that dont exist on layouts
    if i==10
    else
    set(handles.(['tab' num2str(i) 'radio']),'value',handles.tabstatus(1,i))
    end
end

tab1radio_Callback(hObject, eventdata, handles);
handles = guidata(hObject);
tab2radio_Callback(hObject, eventdata, handles);
handles = guidata(hObject);
tab3radio_Callback(hObject, eventdata, handles);
handles = guidata(hObject);
tab4radio_Callback(hObject, eventdata, handles);
handles = guidata(hObject);
tab5radio_Callback(hObject, eventdata, handles);
handles = guidata(hObject);
tab6radio_Callback(hObject, eventdata, handles);
handles = guidata(hObject);
tab7radio_Callback(hObject, eventdata, handles);
tab8radio_Callback(hObject, eventdata, handles);
tab9radio_Callback(hObject, eventdata, handles);

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
    R2=R1+handles.layoutfeatdata(i,2)-1;                                      % finds end row of layout i's data in matrix
    handles.n=num2str(i);                                                   % pulls tab number n 
    handles.(['layout',handles.n,'NF'])=handles.layoutfeatdata(i,1);        % assings number of features for tab n 
    set(handles.(['layout',handles.n,'numfeatedit']),'string',handles.layoutfeatdata(i,1),'enable','on'); % assigns number of features into edit box
    dummytabconfbutt_Callback(hObject, eventdata, handles)                  % actuates quanity publish into feat table
    set(handles.(['layout',num2str(i),'feattable']),'data',handles.layoutfeatdata(i,3:2+handles.layoutfeatdata(i,1))','enable','on'); % sets feat table
    rnames=handles.featdata(R1:R2,1);                                       % pulls row names
    tempdata=handles.featdata(R1:R2,2:7);                                   % pulls geometry feature data
    set(handles.(['layout',handles.n,'geotable']),'rowname',rnames,'data',tempdata,'enable','on') % publishes layout i's geometry data
    R1=R1+handles.layoutfeatdata(i,2);                                                               % loop itteration for all layouts
    set(handles.(['layout',handles.n,'confbutt']),'enable','on')
    set(handles.(['layout',handles.n,'confquant']),'enable','on')
    set(handles.(['clearlayout',handles.n,'butt']),'enable','on')
end
if isnan(handles.layerdata{1,1})~=1
for i=1:handles.NL
    matlocation=strcmp(handles.matlist',handles.layerdata(i,1));            % Finds material location in material library matrix
matmatrix = matlocation*handles.matprops;                                   % Creats matrix with only values of selected material, all others are equal to zero
% matrow=removeconstantrows(matmatrix);
matrow = matmatrix;
for ii=4:9                                                                   %ittereations used between columns #:#
    handles.layerdata(i,ii)=num2cell(matrow(1,ii-3));                          %inputs material properties for the selected layer in columns #:#
end
end
set(handles.layertable,'data',handles.layerdata,'RowName',layerrnames,'ColumnName',handles.layercnames);
[handles]=pubfeatbutt_Callback(hObject, eventdata, handles);                               %publishes all feature types into parametric geometry and associated pop menues. 
end
guidata(hObject,handles)

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
if ischar(filename)==0
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
if cellfun('isempty',resultsdata(1,1))==1
    return
else
[rd,~]=size(resultsdata);
resultsrnames=cell(rd,1);
temprnames=get(handles.resultstable,'rowname');
tempcnames=get(handles.resultstable,'columnname'); %%**
[rt,~]=size(temprnames);
resultsrnames(1:rt,1)=cellstr(temprnames);
if rd==rt
resultsdata=[resultsrnames,resultsdata];
resultsdata=[[cell(1,1),cellstr(tempcnames')];resultsdata];
status(1,4)=xlswrite(outname,resultsdata,'Module Results');
end
end
% % if sum(status(1,:))~=4
% %    errordlg(['Unable to save propperly, please ensure' newline...
% %    'a unique file name was selected'],'Improper Entry','modal');
% % end

% --- Executes during object creation, after setting all properties.
function layout1feattable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layout1feattable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Data', cell(13,1));

% --- Executes during object creation, after setting all properties.
function basegeotable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basegeotable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.basedata=cell(1,5);
set(hObject,'Data', handles.basedata);
guidata(hObject,handles)

%----PC Base Radio Button Callback
function PCbaseradio_Callback(hObject, eventdata, handles)
% tt=handles.layoutpopactive
if get(hObject,'Value')==1
    set(handles.autoconstbaseradio,'enable','on')
    set(handles.basegeotable,'data',cell(1,2),'columnname',handles.basePCcnames,'columnformat',{'numeric','numeric'},'columneditable',[true true]) %updates base table to have only two cells for len and wid
%     templayoutpop=[handles.layoutpop(1,1);handles.layoutpop(3:end,1)];      % base on PC selection layer table layout pop menu must be updated to only display P.C and layouts
    handles.layoutpopactive=[handles.layoutpop(1,1);handles.layoutpopactive(2:end,1)];   
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



% --- Executes during object creation, after setting all properties.
function featbctable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featbctable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.featbccurrentCell=[1 1];
handles.featbcdata=cell(1,5);
set(hObject,'Data',handles.featbcdata);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function plotpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function solutionpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to solutionpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pubfeatbutt.
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
       if isempty(handles.layerdata{i,4})
           errordlg('One or more layers has an undefined layout','Layout Error','nonmodal')
       end
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

% --- Executes on button press in viewsolutionbutt.
function viewsolutionbutt_Callback(hObject, eventdata, handles)
% hObject    handle to viewsolutionbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% handles.highlightsol=get(handles.highlightsolradio,'value');
toplayer=get(handles.plotpop,'Value');
% if get(handles.loopradio,'value')
%     loop=handles.px;
%     solnum=1;
% else 
    loop=1;
    solnum = get(handles.solutionpop,'value');
% end
% for i=1:loop
set(handles.solutionstatic,'string',handles.solutionpoptxt(1,solnum));
R1=(handles.georow*(solnum-1))+1;
R2=handles.georow*solnum;
% R3=2*solnum-1;
% Rm3=(handles.matrow*(solnum-1))+1;
% Rm4=handles.matrow*solnum;
handles.xlayout=handles.feature_layout_master(R1:R2,1:9);
handles.ylayout=handles.feature_layout_master(R1:R2,10:13);
handles.zlayout=handles.feature_layout_master(R1:R2,14:15);
% [handles.layerstack]=unique(handles.zlayout,'rows','stable'); 
% handles.dz=handles.layerstack(:,1)';
% handles.h=handles.envmaster(R3,:);
% handles.Ta=handles.envmaster(R3+1,:);
% handles.tempmatprops=handles.matpropsmaster(Rm3:Rm4,:);
% [Temp,Stress,handles.xgrid,handles.ygrid]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init);
% [Temp,Stress,handles.xgrid,handles.ygrid,NR,NC,handles.ND]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init,handles.tempmatprops,handles.meshdensity);
% 
[~,~,~,~,handles.xgrid,handles.ygrid,handles.ND]=Spacing(handles.xlayout,handles.ylayout,handles.meshdensity);
axes(handles.layerplot)
cla reset; 
layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,handles.xgrid,handles.ygrid,toplayer,handles.ND)

% handles.layerplothold=figure('visible','off');
% layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,handles.xgrid,handles.ygrid,toplayer)
% guidata(hObject,handles)

axes(handles.modelplot)
cla reset;
tempmaster=handles.feature_layout_master(R1:R2,:);
modelplot(tempmaster,handles.georow,handles.removeencap,handles.matcolors)

% handles.sysplothold=figure('visible','on');
% % b=handles.sysplothold
% modelplot(tempmaster,handles.georow,handles.removeencap)
% guidata(hObject,handles)
toggles=0;
viewall=0;
axes(handles.resultsplot)
cla reset; 
resultplot(toggles,handles.feature_layout_master,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
% handles.resultsplothold=figure('visible','off');
% resultplot(toggles,handles.feature_layout_master,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol)
% guidata(hObject,handles)
% x=1;
pause(0.01)
% solnum=solnum+1;
% end
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function featconsttable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featconsttable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.featconstcurrentCell=[1 1];
handles.featconstdata=cell(1,4);
set(hObject,'data',handles.featconstdata);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function sysconsttable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sysconsttable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.sysconstcurrentCell=[1 1];
handles.sysconstdata=cell(1,4);
set(hObject,'data',handles.sysconstdata);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function sysbctable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sysbctable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.sysbccurrentCell=[1 1];
handles.sysbcdata=cell(1,5);
set(hObject,'Data',handles.sysbcdata);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function resultstable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultstable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.resultsdata=cell(1,2);
set(hObject,'data',handles.resultsdata);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function resultplotpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultplotpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in clearguibutt.
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

% Create GeoParaTable
function geoparatable_CreateFcn(hObject, eventdata, handles)
handles.geoparadata=cell(1,6);                                              % pre-define data as empty cell 1,6
set(hObject,'Data', handles.geoparadata);                                   % update table
handles.parageocurrentCell=[1 1];                                           % pre-define selection within table as 1,1
guidata(hObject,handles);                                                   % update handles

% Create AssortParaTable
function assortparatable_CreateFcn(hObject, eventdata, handles)
handles.assortparadata=cell(1,6);
set(hObject,'Data', handles.assortparadata);
handles.paraassortcurrentCell=[1,1];
guidata(hObject,handles);

% Create MatParaTable
function matparatable_CreateFcn(hObject, eventdata, handles)
handles.matparadata=cell(1,6);                                              % define og data as empty cell array 
set(hObject,'data',handles.matparadata)                                     % set table 
handles.matparacurrentCell=[1 1];                                           % define og selected cell as 1,1
guidata(hObject,handles)                                                    % update

%----Mesh Slider Create 
function devmeshslider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
handles.meshdensity=3;                                                      % default resolution
set(hObject,'Value',2);                                                     % set default value
set(hObject,'Min',1);                                                       % set range min 
set(hObject,'Max',41);                                                       % set range max
set(hObject,'SliderStep',[hObject.Min/(hObject.Max-hObject.Min) 1]);                                          % set step size for [arrow, slider] 
guidata(hObject,handles)

%----Mesh Static Create
function devmeshdensitystatic_CreateFcn(hObject, eventdata, handles)

%----Tab Radio----
% Layout 1 Radio
function tab1radio_Callback(hObject, eventdata, handles)
handles.n='1';
dummytabradio_Callback(hObject, eventdata, handles);
% Layout 2 Radio
function tab2radio_Callback(hObject, eventdata, handles)
handles.n='2';
dummytabradio_Callback(hObject, eventdata, handles);
% Layout 3 Radio
function tab3radio_Callback(hObject, eventdata, handles)
handles.n='3';
dummytabradio_Callback(hObject, eventdata, handles);
% Layout 4 Radio
function tab4radio_Callback(hObject, eventdata, handles)
handles.n='4';
dummytabradio_Callback(hObject, eventdata, handles);
% Layout 5 Radio
function tab5radio_Callback(hObject, eventdata, handles)
handles.n='5';
dummytabradio_Callback(hObject, eventdata, handles);
% Layout 6 Radio
function tab6radio_Callback(hObject, eventdata, handles)
handles.n='6';
dummytabradio_Callback(hObject, eventdata, handles);
% --- Executes on button press in tab7radio.
function tab7radio_Callback(hObject, eventdata, handles)
% hObject    handle to tab7radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=get(hObject,'value');
if value==1
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




%----Layout 1 Geo Table Create
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

%----Dummy Layout Buttons--------------------------------------------------
%----Dummy Tab Radio
function dummytabradio_Callback(hObject, eventdata, handles)

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
if ~any(strcmp(handles.layoutpopactive,(['Layout ' n])))
handles.layoutpopactive=[handles.layoutpopactive(:,1); handles.layoutpop(str2double(n)+2,1)]; % updates layout pop
set(handles.layertable,'columnformat',({handles.matlist' 'numeric' handles.layoutpopactive'})); %pre-define only frist two columns as editable for layer table ie. materail and thickness
end
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

handles.NLayouts=sum(handles.tabstatus(1,1:6));

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
for i=1:size(handles.layoutpop,1)
    for ii=1:handles.NL
layoutcmp(count,i)=strcmp(char(handles.layerdata(ii,3)), handles.layoutpop(i,1));
count=count+1;
    end
    count=1;
end
handles.baseindex=[0 99 1:12]';
for i=1:handles.NL
   layoutcheck=find(layoutcmp(i,:)==1);
%    for ii=1:length(layoutcheck)
      handles.layoutint(i,1)= handles.baseindex(layoutcheck,1);
%    end
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
    tempdata=tempdata(1:handles.NF,:);%(:,1:handles.NF);
elseif handles.NF>length(tempdata)
    tempdata=[tempdata;cell(12-length(tempdata),1)];
end
set(handles.(['layout',handles.n,'feattable']),'RowName',handles.geornames(1:handles.NF),'data',tempdata(1:handles.NF,:),'columneditable',true,'columnformat',{'numeric'},'enable','on');
set(handles.(['layout',handles.n,'confbutt']),'enable','on')
set(handles.(['layout',handles.n,'confquant']),'enable','on')
guidata(hObject,handles)

% View Solution Butt Create
function viewsolutionbutt_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pararadiotxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pararadiotxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object deletion, before destroying properties.
function layout1feattable_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to layout1geotable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object deletion, before destroying properties.
function layout1geotable_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to layout1geotable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----Confrim Quantity----
% Layout 1 Confirm Quantity Butt Callback
function layout1confquant_Callback(hObject, eventdata, handles)
handles.n='1';
dummyquantitybutt_Callback(hObject, eventdata, handles)
% Layout 2 Confirm Quantity Butt Callback
function layout2confquant_Callback(hObject, eventdata, handles)
handles.n='2';
dummyquantitybutt_Callback(hObject, eventdata, handles)
% Layout 3 Confirm Quantity Butt Callback
function layout3confquant_Callback(hObject, eventdata, handles)
handles.n='3';
dummyquantitybutt_Callback(hObject, eventdata, handles)
% Layout 4 Confirm Quantity Butt Callback
function layout4confquant_Callback(hObject, eventdata, handles)
handles.n='4';
dummyquantitybutt_Callback(hObject, eventdata, handles)
% Layout 5 Confirm Quantity Butt Callback
function layout5confquant_Callback(hObject, eventdata, handles)
handles.n='5';
dummyquantitybutt_Callback(hObject, eventdata, handles)
% Layout 6 Confirm Quantity Butt Callback
function layout6confquant_Callback(hObject, eventdata, handles)
handles.n='6';
dummyquantitybutt_Callback(hObject, eventdata, handles)

% Add Row AssortParaTable
function addassortparabutt_Callback(hObject, eventdata, handles)
[handles.assortparadata]=addrow(handles.assortparadata);                    % addrow function
set(handles.assortparatable,'data',handles.assortparadata);                 % update table
    

% --- Executes on button press in addfeatbcbutt.
function addfeatbcbutt_Callback(hObject, eventdata, handles)
% hObject    handle to addfeatbcbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.featbcdata]=addrow(handles.featbcdata);
set(handles.featbctable,'data',handles.featbcdata);


function tprocedit_Callback(hObject, eventdata, handles)
handles.Tproc=str2double(get(hObject,'string'));                            % pull entered data
guidata(hObject,handles)

function nodetempedit_Callback(hObject, eventdata, handles)
handles.T_init=str2double(get(hObject,'string'));                           % pull entered data
guidata(hObject,handles)

%----Automate Base Constraint Radio 
function autoconstbaseradio_Callback(hObject, eventdata, handles)
[handles]=autobase(handles);
guidata(hObject,handles)

%----Dummy Quantity Button Callback
function dummyquantitybutt_Callback(hObject, eventdata, handles)
handles.NF=str2double(get(handles.(['layout',handles.n,'numfeatedit']),'String'));                                                                % Features that have a different quantity in the paramter panel than the geometry table.
ORG=2;                                                                      % Starting point of first selection                                                                                                           % Turns features that are not included into neg 1
Q=(get(handles.(['layout',handles.n,'feattable']),'data'));
if iscell(Q)==1
    Q=cell2mat(Q);
end
if all(Q)==0 || sum(isnan(Q))>0
     errordlg(['There must be a positive integer of all features.' newline 'Remove any that are unused.'],'Improper Entry','modal')
     return
end
Q=[Q;zeros(12-length(Q),1)]; 
temprnames=get(handles.(['layout',handles.n,'geotable']),'rowname');
tempdata=get(handles.(['layout',handles.n,'geotable']),'data');

if strcmp(temprnames{1,1},'Feature 1.1')==1                                 % temporarily removes .1 entries on all features so they can be called correctly
    [lt,~]=size(temprnames);
    for i=1:lt
        temprnames(i,1)={temprnames{i,1}(1:9)};
    end
end
geomat=([temprnames(1:size(tempdata(:,:),1),1), tempdata(1:end,:)]);
for i=1:handles.NF
rnumbs=str2double(strrep(geomat(:,1),'Feature ',''));
hits=zeros(12,1);     
        for ii=1:12
        hits(ii,1)=sum(rnumbs(:) == ii);
        end
diff=Q-hits;                                                                % Features that have a different quantity in the paramter panel than the geometry table.
Q2=[0;Q];                                                                   % Starting point of first selection                                               
adjhits=hits-1;                                                             %                                         
                                                     % Adds zero for itteration purposes, otherwise regions could potentially go negative
    if diff(i,1)>0
       blank=cell(diff(i,1),7);                                             % Creates blank matrix for new entries
       blank(:,1)={['Feature ',num2str(i)]};                                % Defines first column with required Feature #n
        R1=ORG+sum(Q2(1:i,1))+adjhits(i);                                   % Region 1 finds the area that is to be shifted down to make room for the extra features
        [R2,~]=size(geomat);                                                % Region 2 finds the end of the table
        R3= sum(Q2(1:i+1,1))+1;                                             % Region 3 finds destination cell of R1:R2
        R4=R3+R2-R1;                                                        % Region 4 finds the end of the destination range
        geomat(R3:R4,:)=geomat(R1:R2,:);                                    % Updates the geomat with shifted cells
        geomat(R1:R3-1,:)=blank;                                            % Removes any cells that are after the desired region
    end   
if diff(i,1)<0                                                              % remove additional features from geo table
hits=[0;hits];
       R5=sum(hits(1:i+1,1))+1 ;                                            % Region 5 finds the area that is to be shifted up to consume the extra features
       [R6,~]=size(geomat) ;                                                % Region 6 finds the end of the table
       R7=R5+diff(i);                                                       % Region 7 finds destination cell of R5:R6
       R8=R6-R5+R7;                                                        % Region 8 finds the end of the destination range
       geomat(R7:R8,:)=geomat(R5:R6,:);                                     % Updates the geomat with shifted cells
       if R5>R6
       else
       geomat(R8+1:end,:)=[];                                                 % Removes any cells that are after the desired region
       end
end
end 
geomat(sum(Q2)+1:end,:)=[];
[lg,~]=size(geomat);
count=1;
tempgeomat=cell(lg,1);
for i=1:lg                                                                   % adds nessesary 0.1 destinction to feature numbers. 
    tempgeomat{i,1}=[geomat{i,1},'.', num2str(count)];
    count=count+1;
    if i==lg
        break
    elseif strcmp(geomat{i,1}, geomat{i+1,1})==0
    count=1;    
    end
end
geomat(:,1)=tempgeomat;
set(handles.(['layout',handles.n,'geotable']),'RowName',geomat(:,1),'data',geomat(:,2:end),'enable','on');
guidata(hObject,handles)

%----Save Sys Plot Image
function savesysplot_Callback(hObject, eventdata, handles)
saveimage(handles.sysplothold);                                   % select hidden figure of system plot as current axes 

%----View System Button Callback
function viewsystembutt_Callback(hObject, eventdata, handles)
if strcmp(get(handles.viewsystembutt,'string'),'Preview System')==1
    runbutt_Callback(hObject, eventdata, handles)
elseif get(handles.tab9radio,'value')==1
    viewsolutionbutt_Callback(hObject, eventdata, handles)
else
    runbutt_Callback(hObject, eventdata, handles)
end

% --- Executes on selection change in plotpop.
function plotpop_Callback(hObject, eventdata, handles)
% hObject    handle to plotpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotpop

%----View Layer Button Callback
function viewlayerbutt_Callback(hObject, eventdata, handles)
% hObject    handle to viewlayerbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.viewsystembutt,'string'),'Preview Layer')==1
    runbutt_Callback(hObject, eventdata, handles)
elseif get(handles.tab9radio,'value')==1
    viewsolutionbutt_Callback(hObject, eventdata, handles)
else
    runbutt_Callback(hObject, eventdata, handles)
end

%----Save Layer Plot Image
function savelayerplot_Callback(hObject, eventdata, handles)
saveimage(handles.layerplothold);                                % select hidden figure of layer plot as current axes


%----Mesh Slider Callback
function devmeshslider_Callback(hObject, eventdata, handles)
temp=floor(get(hObject,'Value'));
handles.meshdensity = 1+(temp-1)*2;
% if temp==2
%     handles.meshdensity=3;                                                  % internal slider values go from 1-3, adjustments made for 1,3,5 
% elseif temp==3
%     handles.meshdensity=5;
% else
%     handles.meshdensity=1;
% end
meshdensitytxt=['Device Mesh ' 'Density:' num2str(handles.meshdensity)]; % update text
set(handles.devmeshdensitystatic,'String',meshdensitytxt);                  % set text
guidata(hObject,handles)

%----Layout 1 Confirm Button Callback
function layout1confbutt_Callback(hObject, eventdata, handles)
handles.n='1';
dummytabconfbutt_Callback(hObject, eventdata, handles)

% Layout 1 NF Edit Callback
function layout1numfeatedit_Callback(hObject, eventdata, handles)

%----Clear Layout 1 Button Callback
function clearlayout1butt_Callback(hObject, eventdata, handles)
handles.n='1';
[handles]=clearlayoutdummy(handles);

% Add Row GeoParaTable
function addgeoparabutt_Callback(hObject, eventdata, handles)  
[handles.geoparadata]=addrow(handles.geoparadata);
set(handles.geoparatable,'data',handles.geoparadata);

% Remove Row GeoParaTable
function removegeoparabutt_Callback(hObject, eventdata, handles)
handles.geoparadata=get(handles.geoparatable,'data');                       %retrives data from assort parameter table
[handles.geoparadata]=removerow(handles.geoparadata,handles.parageocurrentCell);
set(handles.geoparatable,'data',handles.geoparadata)                    % publish new matrix
guidata(hObject,handles)

% Remove Row AssortParaTable
function removeassortparabutt_Callback(hObject, eventdata, handles)
handles.assortparadata=get(handles.assortparatable,'data'); %retrives data from assort parameter table
[handles.assortparadata]=removerow(handles.assortparadata,handles.paraassortcurrentCell); % remove row function
set(handles.assortparatable,'data',handles.assortparadata)                  % update table
guidata(hObject,handles)                                                    % update handles

% Add Row MatParaTable
function addmatparabutt_Callback(hObject, eventdata, handles)
[handles.matparadata]=addrow(handles.matparadata);                          % add row function
set(handles.matparatable,'data',handles.matparadata);                       % update table

% --- Executes on button press in addfeatconstbutt.
function addfeatconstbutt_Callback(hObject, eventdata, handles)
% hObject    handle to addfeatconstbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% tempdata=get(handles.featconsttable,'data');
% x=handles.featconsttable
[handles.featconstdata]=addrow(handles.featconstdata);
set(handles.featconsttable,'data',handles.featconstdata);

% --- Executes on button press in removefeatconstbutt.
function removefeatconstbutt_Callback(hObject, eventdata, handles)
% hObject    handle to removefeatconstbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.featconstdata=get(handles.featconsttable,'data'); %retrives data from assort parameter table
[handles.featconstdata]=removerow(handles.featconstdata,handles.featconstcurrentCell);                                      % build new matrix what is one row tall
set(handles.featconsttable,'data',handles.featconstdata)              % publish new matrix
guidata(hObject,handles)

% --- Executes on button press in addsysconstbutt.
function addsysconstbutt_Callback(hObject, eventdata, handles)
% hObject    handle to addsysconstbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.sysconstdata]=addrow(handles.sysconstdata);
set(handles.sysconsttable,'data',handles.sysconstdata);

% --- Executes on button press in removesysconstbutt.
function removesysconstbutt_Callback(hObject, eventdata, handles)
handles.sysconstdata=get(handles.sysconsttable,'data'); %retrives data from assort parameter table
[handles.sysconstdata]=removerow(handles.sysconstdata,handles.sysconstcurrentCell);
set(handles.sysconsttable,'data',handles.sysconstdata)              % publish new matrix
guidata(hObject,handles)

%----Remove Encapsulent Layer From Plot Radio
function removeencapradio_Callback(hObject, eventdata, handles)
handles.removeencap=get(handles.removeencapradio,'value');
guidata(hObject,handles)

% --- Executes on selection change in solutionpop.
function solutionpop_Callback(hObject, eventdata, handles)
% hObject    handle to solutionpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in loopradio.
function loopradio_Callback(hObject, eventdata, handles)
% hObject    handle to loopradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in viewallresultsbutt.
function viewallresultsbutt_Callback(hObject, eventdata, handles)
% hObject    handle to viewallresultsbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toplayer=get(handles.plotpop,'Value');
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
resultplot(toggles,handles.feature_layout_master,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
% % axes(handles.resultsplothold)
% % cla reset; 
% % handles.resultsplothold=figure('visible','off');
% % resultplot(toggles,handles.feature_layout_master,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
for i=1:loop
    set(handles.solutionstatic,'string',handles.solutionpoptxt(1,solindex));
R1=(handles.georow*(solindex-1))+1;
R2=handles.georow*solindex;
R3=2*solindex-1;
Rm3=(handles.matrow*(solindex-1))+1;
Rm4=handles.matrow*solindex;
handles.xlayout=handles.feature_layout_master(R1:R2,1:9);
handles.ylayout=handles.feature_layout_master(R1:R2,10:13);
handles.zlayout=handles.feature_layout_master(R1:R2,14:15);
[handles.layerstack]=unique(handles.zlayout,'rows','stable'); 
handles.dz=handles.layerstack(:,1)';
handles.h=handles.envmaster(R3,:);
handles.Ta=handles.envmaster(R3+1,:);
handles.tempmatprops=handles.matpropsmaster(Rm3:Rm4,:);
[Temp,Stress,handles.xgrid,handles.ygrid,NR,NC,handles.ND]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init,handles.tempmatprops,handles.meshdensity);
% [Temp,Stress,handles.xgrid,handles.ygrid]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init);
axes(handles.layerplot)
cla reset; 
layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,handles.xgrid,handles.ygrid,toplayer,handles.ND)
axes(handles.modelplot)
cla reset;
tempmaster=handles.feature_layout_master(R1:R2,:);
modelplot(tempmaster,handles.georow,handles.removeencap,handles.matcolors)
pause(0.01)
solindex=solindex+1;
if i==loop
    handles.layerplothold=figure('visible','off');
    layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,handles.xgrid,handles.ygrid,toplayer,handles.ND)
    handles.sysplothold=figure('visible','off');
    modelplot(tempmaster,handles.georow,handles.removeencap,handles.matcolors)
end
end
guidata(hObject,handles)

% --- Executes on selection change in resultplotpop.
function resultplotpop_Callback(hObject, eventdata, handles)
% hObject    handle to resultplotpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns resultplotpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from resultplotpop
handles.resultplotname=handles.resultpoptxt{get(hObject,'Value')};
guidata(hObject,handles)

% Save Results Callback
function saveresultsbutt_Callback(hObject, eventdata, handles)
saveprofbutt_Callback(hObject, eventdata, handles)                          % acts the same as save profile button

%----Highlight Solution Radio Buttion
function highlightsolradio_Callback(hObject, eventdata, handles)
handles.highlightsol=get(hObject,'Value');
guidata(hObject,handles)

%---- Save Results Plot Image
function saveresultplot_Callback(hObject, eventdata, handles)
saveimage(handles.resultsplothold)                               % hidden plot is used to guarentee centered and even figure. Pulling Axes directly

%----Layout 3 Confirm Button Callback
function layout3confbutt_Callback(hObject, eventdata, handles)
handles.n='3';
dummytabconfbutt_Callback(hObject, eventdata, handles)

% Layout 3 NF Edit Callback
function layout3numfeatedit_Callback(hObject, eventdata, handles)


%----Clear Layout 3 Button Callback
function clearlayout3butt_Callback(hObject, eventdata, handles)
handles.n='3';
[handles]=clearlayoutdummy(handles);

%----Layout 6 Confirm Button Callback
function layout6confbutt_Callback(hObject, eventdata, handles)
handles.n='6';
dummytabconfbutt_Callback(hObject, eventdata, handles)

% Layout 6 NF Edit Callback
function layout6numfeatedit_Callback(hObject, eventdata, handles)

%----Clear Layout 6 Button Callback
function clearlayout6butt_Callback(hObject, eventdata, handles)
handles.n='6';
[handles]=clearlayoutdummy(handles);

%----Layout 5 Confirm Button Callback
function layout5confbutt_Callback(hObject, eventdata, handles)
handles.n='5';
dummytabconfbutt_Callback(hObject, eventdata, handles)

% Layout 5 NF Edit Callback
function layout5numfeatedit_Callback(hObject, eventdata, handles)


%----Clear Layout 5 Button Callback
function clearlayout5butt_Callback(hObject, eventdata, handles)
handles.n='5';
[handles]=clearlayoutdummy(handles);

function layout4confbutt_Callback(hObject, eventdata, handles)
handles.n='4';
dummytabconfbutt_Callback(hObject, eventdata, handles)

% Layout 4 NF Edit Callback
function layout4numfeatedit_Callback(hObject, eventdata, handles)
%----Clear Layout 1 Button Callback
%----Clear Layout 4 Button Callback
function clearlayout4butt_Callback(hObject, eventdata, handles)
handles.n='4';
[handles]=clearlayoutdummy(handles);


%----Layout Create Functions----

% --- Executes on button press in removefeatbcbutt.
function removefeatbcbutt_Callback(hObject, eventdata, handles)
% hObject    handle to removefeatbcbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.featbcdata=get(handles.featbctable,'data'); %retrives data from assort parameter table
[handles.featbcdata]=removerow(handles.featbcdata,handles.featbccurrentCell); 
set(handles.featbctable,'data',handles.featbcdata)              % publish new matrix
guidata(hObject,handles)

% --- Executes on button press in sysbcaddbutt.
function sysbcaddbutt_Callback(hObject, eventdata, handles)
% hObject    handle to sysbcaddbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.sysbcdata]=addrow(handles.sysbcdata);
set(handles.sysbctable,'data',handles.sysbcdata);


% --- Executes on button press in sysbcremovebutt.
function sysbcremovebutt_Callback(hObject, eventdata, handles)
% hObject    handle to sysbcremovebutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sysbcdata=get(handles.sysbctable,'data'); %retrives data from assort parameter table
[handles.sysbcdata]=removerow(handles.sysbcdata,handles.sysbccurrentCell); 
set(handles.sysbctable,'data',handles.sysbcdata)              % publish new matrix
guidata(hObject,handles)

%----Layout 2 GeoTable Cell Edit Callback
function layout2geotable_CellEditCallback(hObject, eventdata, handles)
handles.n='2';
cellsel=eventdata.Indices;
dummylayoutgeotableedit(handles,cellsel)

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
handles.layerdata=get(handles.layertable,'data');                                      % retrieve current data about layers
matselect=handles.layerdata(eventdata.Indices(1,1));                        % retrieves the material selected from column 1 pop
matlocation=strcmp(handles.matlist',matselect);                              % finds material location in material library matrix
matmatrix = matlocation*handles.matprops;                                   % creats matrix with only values of selected material, all others are equal to zero
% matrow=removeconstantrows(matmatrix);                                       % removes zero values        
rowselect=eventdata.Indices(1,1);
colselect=eventdata.Indices(1,2);
value=handles.layerdata(rowselect,colselect);
basecheck=strfind(handles.layerrnames(rowselect,1),'.');
n=strrep(handles.layerrnames(rowselect,1),'Layer ',''); %replaces layer list with string value of layer number
if colselect==1                                                             % check that cell selection has been made in column 1 for materials
for i=4:9                                                                   % ittereations used between columns #:#
    handles.layerdata(rowselect,i)=num2cell(matmatrix(1,i-3));    % inputs material properties for the selected layer in columns #:#
end
if cellfun('isempty',basecheck)==1
% handles.(['layer',n{1},'data'])(1,1)=matselect;
% data=handles.layer1data
%     set(handles.(['layer',n{1},'geotable']),'data',handles.(['layer',n{1},'data']));
end
end
if colselect==3 && strcmp(value{1,1}(1:4),'Base')==0
    n=value{1,1}(1,end);
    tempdata=get(handles.(['layout' n 'geotable']),'data');
%     if sum(sum(cellfun('isempty',tempdata)))
% [handles]=pubfeatbutt_Callback(hObject, eventdata, handles);                  %Organizes constraint, BC, and parameter tables to display the correct pop menues and content.  
end
% % if colselect==3 && strcmp(value{1,1}(1,1),'B')==1
% %     layouts=handles.layerdata(:,3);
% %     options={'Base U.D.','Base P.C'};
% %     find(strcmp(options,layouts)==1)
% % %     selecttype=value{1,1}(1,end-3:end);
% %     
% %     for i=1:length(layouts)
% %     layouts{i,1}=layouts{i,1}(1,end-3:end);
% %     end
% %     layouts
% % %     find(strcmp(allowable,geo)==1)
% %     find(strcmp(Value,layouts)==1)
% % end
set(handles.layertable,'data',handles.layerdata);                           %Publishes solution parameters into gui table
handles.layertablestatus=cellfun('isempty',handles.layerdata);
% if any(handles.envdatastatus(:))==0 && any(handles.layertablestatus(:))==0
%     set(handles.runbutt,'Enable','on');
% end
guidata(hObject,handles)

%----Base Table Cell Edit
function basegeotable_CellEditCallback(hObject, eventdata, handles)
handles.basedata=(get(handles.basegeotable,'data'));                                     % pull data from base table
cellsel=eventdata.Indices;                                                  % determine the cell index that was selected
row=cellsel(1,1);                                                           % selected row
col=cellsel(1,2);                                                           % selected column
if iscell(handles.basedata)==0
    [dr,dc]=size(handles.basedata);
    handles.basedata=num2cell(handles.basedata);
end
value=cell2mat(handles.basedata(row,col));                                  % value of selected cell

radio=get(handles.PCbaseradio,'value');                                     % retrieves status of PC radio
handles.autobcradiostat=get(handles.autoconstbaseradio,'value');
if radio==0  && cell2mat(handles.basedata(1,1))==1                          % if radio is set to UD and center toggle is on 
    handles.basedata(:,2:3)=cell(1,2);                                      % add empty cells to col 2 and three, in the event that they were removed for PC
    handles.basedata(1,2:3)={'N/A','N/A'};                                  % turn col 2:3 to NA
    set(hObject,'columneditable', [true false false true true],'data',handles.basedata);    % publish to table
elseif radio==0 && cell2mat(handles.basedata(1,1))==0 && col==1             % if radio is on UD and center toggle is off and edit made to toggle cell
    handles.basedata(:,2:3)=cell(1,2);                                      % empty col 2:3
    set(hObject,'columneditable',[true true true true true],'data',handles.basedata) %update talble
end
if col>3 && value<=0 || isnan(value)==1                                     % if edit was made in len or wid col and is less than zero or not a num
    errordlg('Length and Width must be positive real values','Improper Entry','modal'); % error out because only positive real values are accepted
    handles.basedata(1,col)=cell(1,1);                                      % empty wrongful entry cell
    set(hObject,'data',handles.basedata);
end
if radio==1 && sum(cellfun('isempty',handles.basedata))==0   && handles.autobcradiostat==1  % if PC is enabled and all cells are filled and user selects to have bc radio enable automatically
[handles]=autobase(handles);
end
guidata(hObject,handles)

%----Layout 1 Feature Tabel Cell Edit
function layout1feattable_CellEditCallback(hObject, eventdata, handles)

% Layout 1 Geo Table Edit
function layout1geotable_CellEditCallback(hObject, eventdata, handles)
handles.n='1';
cellsel=eventdata.Indices;
dummylayoutgeotableedit(handles,cellsel)

% Cell Edit GeoParaTable
function geoparatable_CellEditCallback(hObject, eventdata, handles)
handles.geoparadata=get(hObject,'data');                                     % retrieve current data about layers
cellsel=eventdata.Indices;                                                  % determines the indicies of the selected cell
contentsel=handles.geoparadata(cellsel(1,1),cellsel(1,2));                  % saves the content of the selected cell
if cellsel(1,2)==1                                                          % if change was made in column 1
    handles.geoparadata(cellsel(1,1),2:6)=cell(1,5);                        % empty all proceeding columns 
end
if cellsel(1,2)==2                                                          % if change was made in column 2
   if strcmp('Base', contentsel)==1 && strcmp(handles.geoparadata(cellsel(1,1),1),'Heat Gen.')==1 % if selection changed col 2 to 'Base' and it was defined as a Heat gen layer 
       errordlg(['Heat generation must be assigned to a feature'],'Improper Entry','modal') % error out because heat generation cannot be assigened to all base layers **UD need up 
       handles.geoparadata(cellsel(1,1),2)=cell(1,1);                       %empties that selected cell for the user to retry.
   end
end
if cellsel(1,2)==3                                                          % if change was made in column 2
    if strcmp(handles.geoparadata(cellsel(1,1),2),handles.geoparadata(cellsel(1,1),3))==1 % if both column 2 and column 3 have been selected as the same feature
        errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
            'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
            'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
        handles.geoparadata(cellsel(1,1),3)=cell(1,1);                        % empty col 3
    end
end
if strcmp(handles.geoparadata(cellsel(1,1),2),'Base')==1         % if Base is selected from column 2
%     if cellsel(1,2)==3 
%     errordlg(['A base geometry cannot have associated features until **UD is implimented'],'Improper Entry','modal') % awaiting **UD to have any other selection than N/A
%     end
%     handles.geoparadata(cellsel(1,1),3)={'N/A'};                            % set column three to N/A by default. This is unidirectional 
end
if cellsel(1,2)==5                                                          % selection made in column 5
    data=cell2mat(handles.geoparadata(cellsel(1,1),cellsel(1,2)));          % convert selection into numeric value
    if floor(data)~=data || data<=0                                         % verify step input is positive intenger, error out if not
             handles.geoparadata(cellsel(1,1),cellsel(1,2))=cell(1,1); 
             errordlg('The number of steps must be a positive integer.','Improper Entry','modal')
    end
end
set(handles.geoparatable,'data',handles.geoparadata);
guidata(hObject,handles)

% Cell Select AssortParaTable
function assortparatable_CellSelectionCallback(hObject, eventdata, handles)
handles.paraassortcurrentCell=eventdata.Indices;
guidata(hObject,handles)

% Cell Edit MatParaTable
function matparatable_CellEditCallback(hObject, eventdata, handles)
handles.matparadata=get(handles.matparatable,'data');                       % retrieve current data about layers                              
cellsel=eventdata.Indices;                                                  % determines the indicies of the selected cell
row=cellsel(1,1);
col=cellsel(1,2);
contentsel=handles.matparadata(cellsel(1,1),cellsel(1,2));                  % saves the content of the selected cell
% sysrange=cellfun('isempty',handles.matparadata(row,4:6));
if cellsel(1,2)==1                                                          % if change was made in column 1
    handles.matparadata(cellsel(1,1),2:6)=cell(1,5);                        % empty all proceeding columns 
    if isnan(str2double(contentsel{1,1}(1,end)))==0
        handles.matparadata(row,3)={'N/A'};
        handles.matparadata(row,4:6)={0 1 0};
    end
end
if cellsel(1,2)==2                                                          % if change was made in column 2
end
if cellsel(1,2)==3                                                          % if change was made in column 2
   if strcmp('System',handles.matparadata(row,1))==1 && strcmp('N/A',contentsel)==1
   errordlg(['A system wide material change represents a change in that' newline...
       'material''s property, select a material property to vary.'],'Improper Entry','modal') % awaiting **UD to have any other selection than N/A 
   handles.matparadata(row,col)=handles.matparatype(1,1);
elseif strcmp(contentsel,'N/A')==0 && isnan(str2double(handles.matparadata{row,1}(1,end)))==0
    errordlg(['Changes to an individual feature''s material properties is not permitted.' newline...
         'The feature''s material will only vary to the selected material.'],'Improper Entry','modal') % awaiting **UD to have any other selection than N/A
         handles.matparadata(row,col)={'N/A'};
   end
end
if cellsel(1,2)==4||cellsel(1,2)==5||cellsel(1,2)==6                                                          % if change was made in columns 4,5, or 6
data=cell2mat(contentsel);                                                  % find numerical data
    if isnan(str2double(handles.matparadata{row,1}(1,end)))==0              % check if feature or layer was selected from drop down for material
        errordlg('Edits cannot be made to Min, Steps, or Max when a feature is selected','Improper Entry','modal')  % read error 
        handles.matparadata(row,4:6)={0 1 0};                               % assign to correct default values
    end
    if floor(data)~=data && cellsel(1,2)==5 || cellsel(1,2)==5 && data<=0                               % verify for system wide edit that only integers are entered in steps column  
        errordlg('The number of steps must be a positive integer.','Improper Entry','modal')
        handles.matparadata(row,col)=cell(1,1);
    end
end
    if strcmp(handles.matparadata(row,1),'System')==1 && sum(cellfun('isempty',handles.matparadata(row,:)))==0 % if all entries have been filled in for a material property change check it is within bounds
        minallow=0;                                                         % no material property can be less than zero
        maxallow=inf;                                                       % max material property limit is inf
        [handles.matparadata] = checkbounds(handles.matlist,handles.matparadata,row,handles.matparatype,handles.matprops,minallow,maxallow); %check bounds function
    end
set(handles.matparatable,'data',handles.matparadata);                       % update table
guidata(hObject,handles)                                                    % update handles

% --- Executes when entered data in editable cell(s) in featconsttable.
function featconsttable_CellEditCallback(hObject, eventdata, handles)
handles.featconstdata=get(hObject,'data');                                  % retrieves constraint feature table content
cellsel=handles.featconstcurrentCell;                                       % temp stores the selected cell within table
content=handles.featconstdata{cellsel(1,1),1};                              % stores column 1 of selected cell's row
geo=handles.featconstdata(cellsel(1,1),cellsel(1,2));                       % sotres the content of the selection
row=cellsel(1,1);
col=cellsel(1,2);
if cellsel(1,2)==1                                                          % if change was maded in column 1
   handles.featconstdata(cellsel(1,1),2:4)=cell(1,3);                       % erase any proceeding column data 
   allowableconst=handles.featconsttype(4:end);
   sum(find(strcmp(allowableconst,content)));
   if sum(find(strcmp(allowableconst,content)))>0
       handles.featconstdata(row,2:3)={'System','N/A'};
   end
    set(handles.featconsttable,'data',handles.featconstdata);                % set values to gui table
end
if cellsel(1,2)==2                                                          % if selection was maded in column 2
    allowableconst=handles.featconsttype(4:end);
if strcmp(geo,'System')==1
     if sum(find(strcmp(allowableconst,content)))<1
         errordlg('A feature selection must be made','Improper Entry','modal')
         handles.featconstdata(row,2)=cell(1,1);
     else
    handles.featconstdata(row,3)={'N/A'};
     end
elseif sum(find(strcmp(allowableconst,content)))>0
    handles.featconstdata(row,2:3)={'System','N/A'};
    errordlg('Any constraint related to a Base must be system wide','Improper Entry','modal')
end
 set(handles.featconsttable,'data',handles.featconstdata);
end
if cellsel(1,2)==3                                                          % if selection was maded in column 3
    if strcmp(handles.featconstdata(row,2),'System')==1
        errordlg('A system selection does not require a linked feature','Improper Entry','modal') 
        handles.featconstdata(row,3)={'N/A'};
        set(handles.featconsttable,'data',handles.featconstdata);
    end
end
if strcmp(handles.featconstdata{cellsel(1,1),2},handles.featconstdata{cellsel(1,1),3})==1
    errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
            'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
            'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
            handles.featconstdata(cellsel(1,1),3)=cell(1,1);                  % define cell that was attempted to be changed as N/A
    set(handles.featconsttable,'data',handles.featconstdata);               % update table 
    return
end
guidata(hObject,handles)

% Cell Edit AssortParaTable
function assortparatable_CellEditCallback(hObject, eventdata, handles)
handles.assortparadata=get(handles.assortparatable,'data');                 % retrieve data from assort para table (system parameters)
cellsel=handles.paraassortcurrentCell;                                      % retrieves indices of selected cell
    content=handles.assortparadata{cellsel(1,1),1};                         % retrieves parameter from col 1 in selected row
    geo=handles.assortparadata(cellsel(1,1),cellsel(1,2));                  % returns selected cell data
    if cellsel(1,2)==1                                                      % if selection was made in column 1
         handles.assortparadata(cellsel(1,1),2:6)=cell(1,5);                % erase all proceeding data        
    end
    if strcmp('Transient',content)==1                                       % if selected row is a transient parameter
       handles.assortparadata(cellsel(1,1),2)={'System'};                   % set geometry column to system
       if cellsel(1,2)==2                                                   % if change was made in geometry column error out setting back to system
            errordlg('Transient parameters can only be evaulated at a system level','Improper Entry','modal')
       end
       handles.assortparadata(cellsel(1,1),3)={'N/A'};                      % set assocaited to N/A
       if cellsel(1,2)==3                                                   % error out if atempt is to change associated column
            errordlg('There are no associations permited with a transient parameter','Improper Entry','modal') 
       end
    end
if cellsel(1,2)==2                                                          % if change is made in geometry column
    if strcmp(content,'Layer Thickness')==1                                 % if layer thickness parameter is selected
    allowable=[handles.layerrnames];                                        % allowable selections from drop down include layer names
       if find(strcmp(allowable,geo)==1)>0                                  % if selection is not in allowable list error out
       else
       errordlg((['You must select a layer from the stack']),'Parameter Error','modal')
       handles.assortparadata(cellsel(1,1),cellsel(1,2))=allowable(1,1);    % set selection to first allowable selection 
       end  
    elseif strcmp(content,'Conv. Coeff. (h)')==1||strcmp(content,'Ambient Temp. (Ta)')==1  % same procedure as for layer thickness but for ENV parameters
    allowable=[handles.envcnames, 'System'];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['An environmental parameter must be accompanied by' newline...
           ' a side geometry or system level selection.']),'Parameter Error','modal')
       handles.assortparadata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       end  
    end
elseif cellsel(1,2)==3                                                      % if change is made in associated column
     if strcmp(content,'Conv. Coeff. (h)')==1||strcmp(content,'Ambient Temp. (Ta)')==1  % check allowable ENV strings
       allowable=[handles.envcnames, 'N/A'];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['An environmental parameter must be accompanied by' newline...
           'a side geometry selection or N/A to enable an absolute dimension.']),'Parameter Error','modal')
       handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
       end  
    elseif strcmp(content,'Layer Thickness')==1                             % check allowable layer thickness selections for associated column
        allowable=[handles.layerrnames' 'N/A'];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['You must select a layer from the stack' newline...
           'or N/A to enable an absolute dimension.']),'Parameter Error','modal')
       handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
       end  
    end
end
 if cellsel(1,2)==4 && strcmp(content,'Transient')==1 && cell2mat(geo)<0    % if transient and min is less than zero error out
     errordlg(('A transient analysis must have positive time'),'Parameter Error','modal')  
     handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
 end
if strcmp(content,'Transient')==1 && cellfun('isempty',handles.assortparadata(cellsel(1,1),4))==0 ... 
        &&cellfun('isempty',handles.assortparadata(cellsel(1,1),6))==0 ...
        && cell2mat(handles.assortparadata(cellsel(1,1),4))>cell2mat(handles.assortparadata(cellsel(1,1),6)) % if transient and both min and max cells have data check if min is greater than max
    
     errordlg(('Transient bounds must be entered in inceasing order'),'Parameter Error','modal')  % if true error out and empty cells
     handles.assortparadata(cellsel(1,1),[4 6])=cell(1,2);
end
  if cellsel(1,2)==5 && cell2mat(geo)~=floor(cell2mat(geo)) || cellsel(1,2)==5 && cell2mat(geo)<=0  % if change is made in steps verify it is a positive integer
     errordlg(('There must be a positive integer number of steps'),'Parameter Error','modal') 
          handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
  end
 if cellsel(1,2)==6 && strcmp(content,'Transient')==1 && cell2mat(geo)<0    % if change is made in max for transient parameter verify value is positive
     errordlg(('A transient analysis must have positive time'),'Parameter Error','modal') 
          handles.assortparadata(cellsel(1,1),cellsel(1,2))=cell(1,1);
 end
if strcmp(handles.assortparadata{cellsel(1,1),2},handles.assortparadata{cellsel(1,1),3})==1
    errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
            'to the selected geometry. Set the layer' newline...      % absolute dim functionality by selecting the associted feature as N/A
            'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
            handles.assortparadata(cellsel(1,1),3)=cell(1,1);
end
    set(handles.assortparatable,'data',handles.assortparadata);
guidata(hObject,handles)

% --- Executes when entered data in editable cell(s) in sysconsttable.
function sysconsttable_CellEditCallback(hObject, eventdata, handles)
handles.sysconstdata=get(hObject,'data');                                   % pulls content of system constraint table
cellsel=handles.sysconstcurrentCell;                                        % indicies of selected cell
content=handles.sysconstdata{cellsel(1,1),1};                               % content of col 1 from selected cell's row
geo=handles.sysconstdata(cellsel(1,1),cellsel(1,2));                        % content of selected cell
if cellsel(1,2)==1                                                          % if selection made in col 1
   handles.sysconstdata(cellsel(1,1),2:4)=cell(1,3);                        % empty all proceeding columns
   set(handles.sysconsttable,'data',handles.sysconstdata);                 % update
end
if cellsel(1,2)==2                                                          % selection made in col 2
    if strcmp(content,'Layer Thickness: Fixed')==1 
    allowable=[handles.layerrnames];                                        % allowable strings to be selected from pop
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg(('You must select a layer from the stack'),'Parameter Error','modal') % if not allowable string error out
       handles.sysconstdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);      % set entry to first allowable entry
       set(handles.sysconsttable,'data',handles.sysconstdata);              % update
       return
       end  
    elseif strcmp(content,'Conv. Coeff. (h) Fixed')==1||strcmp(content,'Ambient Temp. (Ta) Fixed')==1  
        allowable=[handles.envcnames, 'System'];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['An environmental parameter must be accompanied by' newline...
           ' a side geometry or system level selection.']),'Parameter Error','modal')
       handles.sysconstdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       set(handles.sysconsttable,'data',handles.sysconstdata);
       return
       end  
    end
end
if cellsel(1,2)==3                                                          % if selection made in col 3
     if strcmp(content,'Conv. Coeff. (h) Fixed')==1||strcmp(content,'Ambient Temp. (Ta) Fixed')==1
       allowable=[handles.envcnames, 'N/A'];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['An environmental parameter must be accompanied by' newline...
           'a side geometry selection or N/A to enable an absolute dimension.']),'Parameter Error','modal')
       handles.sysconstdata(cellsel(1,1),cellsel(1,2))=cell(1,1);           % sets col 3 to empty so user has to understand their intent
       set(handles.sysconsttable,'data',handles.sysconstdata);
       return
       end  
    elseif strcmp(content,'Layer Thickness: Fixed')==1
        allowable=[handles.layerrnames' 'N/A'];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['You must select a layer from the stack' newline...
           'or N/A to enable an absolute dimension.']),'Parameter Error','modal')
       handles.sysconstdata(cellsel(1,1),cellsel(1,2))=cell(1,1);
       set(handles.sysconsttable,'data',handles.sysconstdata);
       return
       end  
    end
end
if strcmp(handles.sysconstdata{cellsel(1,1),2},handles.sysconstdata{cellsel(1,1),3})==1
    errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
            'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
            'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
            handles.sysconstdata(cellsel(1,1),3)=cell(1,1);
    set(handles.sysconsttable,'data',handles.sysconstdata);
    return
end
guidata(hObject,handles)

% --- Executes when entered data in editable cell(s) in resultstable.
function resultstable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to resultstable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% Layout 3 Geo Table Edit
function layout3geotable_CellEditCallback(hObject, eventdata, handles)
handles.n='3';
cellsel=eventdata.Indices;
dummylayoutgeotableedit(handles,cellsel)
% Layout 4 Geo Table Edit
function layout4geotable_CellEditCallback(hObject, eventdata, handles)
handles.n='4';
cellsel=eventdata.Indices;
dummylayoutgeotableedit(handles,cellsel)
% Layout 5 Geo Table Edit
function layout5geotable_CellEditCallback(hObject, eventdata, handles)
handles.n='5';
cellsel=eventdata.Indices;
dummylayoutgeotableedit(handles,cellsel)
% Layout 6 Geo Table Edit
function layout6geotable_CellEditCallback(hObject, eventdata, handles)
handles.n='6';
cellsel=eventdata.Indices;
dummylayoutgeotableedit(handles,cellsel)

% --- Executes when entered data in editable cell(s) in featbctable.
function featbctable_CellEditCallback(hObject, eventdata, handles)
handles.featbcdata=get(hObject,'data');  
cellsel=handles.featbccurrentCell;
content=handles.featbcdata{cellsel(1,1),1}; 
geo=handles.featbcdata(cellsel(1,1),cellsel(1,2));
if cellsel(1,2)==1
   handles.featbcdata(cellsel(1,1),2:5)=cell(1,4);
   set(handles.featbctable,'data',handles.featbcdata);
end
if cellsel(1,2)==2 
end
if cellsel(1,2)==3
end
if strcmp(handles.featbcdata{cellsel(1,1),2},handles.featbcdata{cellsel(1,1),3})==1
    errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
            'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
            'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
            handles.featbcdata(cellsel(1,1),3)={'N/A'};
    set(handles.featbctable,'data',handles.featbcdata);
    return
end
guidata(hObject,handles)


% --- Executes when entered data in editable cell(s) in sysbctable.
function sysbctable_CellEditCallback(hObject, eventdata, handles)
handles.sysbcdata=get(hObject,'data'); 
cellsel=handles.sysbccurrentCell;
content=handles.sysbcdata{cellsel(1,1),1}; 
geo=handles.sysbcdata(cellsel(1,1),cellsel(1,2));
if cellsel(1,2)==1
   handles.sysbcdata(cellsel(1,1),2:5)=cell(1,4);
    if strcmp(content,'Layer Thickness Range')==1
         handles.sysbcdata(cellsel(1,1),3)={'N/A'};
   elseif strcmp(content,'Base Length Range')==1||strcmp(content,'Base Width Range')==1||strcmp(content,'Base L/W Range')==1  
       handles.sysbcdata(cellsel(1,1),2:3)={'System','N/A'};
   elseif strcmp(content,'Module Volume')==1
       handles.sysbcdata(cellsel(1,1),2:3)={'System','N/A'};
    end
   set(handles.sysbctable,'data',handles.sysbcdata);
end
if cellsel(1,2)==2 
    if strcmp(content,'Layer Thickness Range')==1
    allowable=[handles.layerrnames];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg(('You must select a layer from the stack'),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       handles.sysbcdata(cellsel(1,1),3)={'N/A'};
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end  
    elseif strcmp(content, 'Substrate Thickness Rat.')==1
    allowable=[handles.layerrnames];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg(('You must select the top layer of interest from the stack'),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end
    elseif strcmp(content,'Conv. Coeff. (h) Range')==1||strcmp(content,'Ambient Temp. (Ta) Range')==1  
        allowable=[handles.envcnames, 'System'];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['An environmental parameter must be accompanied by' newline...
           ' a side geometry or system level selection.']),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end  
       elseif strcmp(content,'Base Length Range')==1||strcmp(content,'Base Width Range')==1||strcmp(content,'Base L/W Range')==1  
        allowable={'System'};
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['Base boundary condition definitions must be' newline...
           'on the system level until **UD is implimented.']),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end  
    elseif strcmp(content,'Module Volume')==1
    allowable={'System'};
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg(('Module Volume boundary condition must be system wide.'),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end  
    end
end
if cellsel(1,2)==3
    if strcmp(content,'Layer Thickness Range')==1
    allowable={'N/A'};
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['Nothing can be associated with an layer thickness boundary condtion']),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end  
    elseif strcmp(content, 'Substrate Thickness Rat.')==1
    allowable=[handles.layerrnames];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg(('You must select the substrate layer in the layer stack'),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=cell(1,1);
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end
    elseif strcmp(content,'Conv. Coeff. (h) Range')==1||strcmp(content,'Ambient Temp. (Ta) Range')==1  
        allowable=[handles.envcnames, 'N/A'];
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg((['An environmental parameter must be accompanied by' newline...
           ' a side geometry or be defined as an absolute dimension.']),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=cell(1,1);
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end  
       elseif strcmp(content,'Base Length Range')==1||strcmp(content,'Base Width Range')==1||strcmp(content,'Base L/W Range')==1  
        allowable={'N/A'};
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg(('Base boundary conditions cannot have associations.'),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end  
    elseif strcmp(content,'Module Volume')==1
    allowable={'N/A'};
       if find(strcmp(allowable,geo)==1)>0
       else
       errordlg(('Module Volume boundary conditions cannot have associations.'),'Boundary Condition Error','modal')
       handles.sysbcdata(cellsel(1,1),cellsel(1,2))=allowable(1,1);
       set(handles.sysbctable,'data',handles.sysbcdata);
       return
       end  
    end
end
if strcmp(handles.sysbcdata{cellsel(1,1),2},handles.sysbcdata{cellsel(1,1),3})==1
    errordlg(['An associated geometry cannot be identical' newline...   %error out because if the user wants a feature to drive itself they must use the 
            'to the selected geometry. It has been changed' newline...      % absolute dim functionality by selecting the associted feature as N/A
            'to "N/A" so it can be treated as an absolute dimension'],'Improper Entry','modal') 
            handles.sysbcdata(cellsel(1,1),3)=cell(1,1);
    set(handles.sysbctable,'data',handles.sysbcdata);
    return
end
guidata(hObject,handles)

%----Layout 1 Geo Table Cell Select
function layout1geotable_CellSelectionCallback(hObject, eventdata, handles)

% Cell Select GeoParaTable
function geoparatable_CellSelectionCallback(hObject, eventdata, handles)
handles.parageocurrentCell=eventdata.Indices;
guidata(hObject,handles)

% Cell Select MatParaTable
function matparatable_CellSelectionCallback(hObject, eventdata, handles)
handles.matparacurrentCell=eventdata.Indices;                               % save selected cell indicies when a click is made in table
guidata(hObject,handles)                                                    % update handles

% --- Executes when selected cell(s) is changed in sysconsttable.
function sysconsttable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to sysconsttable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.sysconstcurrentCell=eventdata.Indices;
guidata(hObject,handles)

% --- Executes when selected cell(s) is changed in featbctable.
function featbctable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to featbctable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.featbccurrentCell=eventdata.Indices;
guidata(hObject,handles)

% --- Executes when selected cell(s) is changed in sysbctable.
function sysbctable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to sysbctable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.sysbccurrentCell=eventdata.Indices;
guidata(hObject,handles)

% Remove Row MatParaTable
function removematparabutt_Callback(hObject, eventdata, handles)
handles.matparadata=get(handles.matparatable,'data'); % retrives data from assort parameter table
[handles.matparadata]=removerow(handles.matparadata,handles.matparacurrentCell); % remove row function
set(handles.matparatable,'data',handles.matparadata)                        % update table
guidata(hObject,handles)                                                    % update tables

% --- Executes when selected cell(s) is changed in featconsttable.
function featconsttable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to featconsttable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.featconstcurrentCell=eventdata.Indices;
guidata(hObject,handles)


function dummylayoutgeotableedit(handles,cellsel)
handles.(['layout' handles.n 'geodata'])=get(handles.(['layout' handles.n 'geotable']),'data');
handles.(['layout' handles.n 'rnames'])=get(handles.(['layout' handles.n 'geotable']),'rowname');
[handles.(['layout' handles.n 'geodata'])]=layoutgeotable(handles.(['layout' handles.n 'geodata']),handles.(['layout' handles.n 'rnames']),cellsel);
set(handles.(['layout' handles.n 'geotable']),'data',handles.(['layout' handles.n 'geodata']));

function [geodata]=layoutgeotable(geodata,rnames,cellsel)
row=cellsel(1,1);                                                           % finds selected row
col=cellsel(1,2);                                                           % finds selected column
value=geodata(row,col);                                                     % retrieves the value of selected cell
feats=length(rnames);                                                       % finds number of features in layout
for i=1:feats
featnums(i,:)=strrep(rnames{i,1},'Feature ','');                            % removes leading Feature text from row names
end
featnums=str2num(featnums(:,1));                                            % removes trailing .# from feature numbers
featgroup=find(featnums==str2num(rnames{row,1}(1,end-2)));                  % finds the rows that correlate to the feature selected 
if col==1||col>3
    geodata(featgroup,col)=value;                                           % if update was made in any of the non-unique rows, update to follow the change
end
% Edit Made To Geo Table

% Number of Layers Edit Callback
function numlayersedit_Callback(hObject, eventdata, handles)
handles.NL=str2double(get(hObject,'string'));                               % pull entered data
guidata(hObject,handles)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function layertable_CellSelectionCallback(hObject, eventdata, handles)


% --- Executes when SimpleOptimizedTab is resized.
function SimpleOptimizedTab_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to SimpleOptimizedTab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos = handles.uipanel82.Position;
set(handles.uipanel81,'Units','character');
limits = get(handles.uipanel81,'Position');
val1 = get(handles.slider3,'Value');
val2 = get(handles.slider2,'Value');
set(handles.uipanel82,'Position',[-val2*(pos(3)-limits(3)) -val1*(pos(4)-limits(4)) pos(3:4)])
set(handles.uipanel81,'Units','normalized');
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos = handles.uipanel82.Position;
set(handles.uipanel81,'Units','character');
limits = get(handles.uipanel81,'Position');
val1 = get(handles.slider3,'Value');
val2 = get(handles.slider2,'Value');
set(handles.uipanel82,'Position',[-val2*(pos(3)-limits(3)) -val1*(pos(4)-limits(4)) pos(3:4)])
set(handles.uipanel81,'Units','normalized');
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
