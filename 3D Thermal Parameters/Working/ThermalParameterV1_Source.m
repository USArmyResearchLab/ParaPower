

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

% UIWAIT makes ThermalParameterV1 wait for user response (see UIRESUME)
% uiwait(handles.SimpleOptimizedTab);

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
pan1pos(1,3)=0.58;
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

% --- Callback function for clicking on tab
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

%----System Parameters Panel------------------------------------------------

% Temp Proc Edi Callback
% Node Temp Edit Callback
%----Run Simulation--------------------------------------------------------
% Run Button Callback

%----Save Data-------------------------------------------------------------


%----Profile Pop-Up--------------------------------------------------------
% Profile Pop Callback
% % % % % function loadprofilepop_Callback(hObject, eventdata, handles)
% % % % % % hObject    handle to loadprofilepop (see GCBO)
% % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % Hints: contents = cellstr(get(hObject,'String')) returns loadprofilepop contents as cell array
% % % % % %        contents{get(hObject,'Value')} returns selected item from loadprofilepop
% % % % % 
% % % % % % Profile Pop Menu Create
% % % % % function loadprofilepop_CreateFcn(hObject, eventdata, handles)
% % % % % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
% % % % %     set(hObject,'BackgroundColor','white');
% % % % % end


% --- Executes during object creation, after setting all properties.
function layer1edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function layer2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% function []=tabconf(n,NF,geornames)
% set(handles.layer1edit,'string','cat')
%     handles.(['layer',n,'rnames'])=geornames(2:NF);
% %     set(handles.(['layer',n,'feattable']),'ColumnName',handles.(['layer',n,'rnames'])(2:end))
%     set(handles.(['layer',n,'geotable']),'ColumnName',handles.(['layer',n,'rnames']))
% guidata(hObject,handles)
    
    
    


%     tabconf(n,handles.NF,handles.geornames)        
% % for i=1:2
% %   n=num2str(i);
% % if mod(handles.NF,1)~=0
% %      errordlg('The number of layers must be an integer.','Improper Entry','modal')
% %      return
% % end
% % end


% % % % % --- Executes on button press in dummytabmoveupbutt.
% % % % function dummytabmoveupbutt_Callback(hObject, eventdata, handles)
% % % % % hObject    handle to dummytabmoveupbutt (see GCBO)
% % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % handles    structure with handles and user data (see GUIDATA)
% % % % 
% % % % 
% % % % % --- Executes on button press in dummytabmovedownbutt.
% % % % function dummytabmovedownbutt_Callback(hObject, eventdata, handles)
% % % % % hObject    handle to dummytabmovedownbutt (see GCBO)
% % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % handles    structure with handles and user data (see GUIDATA)

%----Base Table------------------------------------------------------------


%----Automate Base Constraint Add Function
function [handles]=autobase(handles)
% if radio==1 && sum(cellfun('isempty',handles.basedata))==0   && handles.autobcradiostat==1  % if PC is enabled and all cells are filled and user selects to have bc radio enable automatically
    set(handles.tab7radio,'value',1)                                        % turn on constraints tab
    handles.featconstdata=get(handles.featconsttable,'data');               % retrieve feat constraints data
    allowable=handles.featconsttype(1,6:7);                                 % allowable selections are Base Boarder Len and Wid
    [fr,~]=size(handles.featconstdata);                                     % find current size of contsraints 
    len=strcmp(allowable{1,1},handles.featconstdata(:,1));                  % compare if Base Boarder Length exists in constraint data
    wid=strcmp(allowable{1,2},handles.featconstdata(:,1));                  % compare BBW exists in constraint data
    if sum(len)>0                                                           % if BBL exists
        idx=find(len);                                                      % find index of entry 
        handles.featconstdata(idx,4)=handles.basedata(1,1);                 % publish value from base geo table as the constraint
        set(handles.featconsttable,'data',handles.featconstdata);           % set table
    else 
        row=find(sum(cellfun('isempty',handles.featconstdata),2)==4);
        if row>0
        handles.featconstdata(row(1,1),1:4)=[allowable{1,1}, 'System','N/A',handles.basedata(1,1)]; % add new row to end 
        else
        handles.featconstdata(end+1,1:4)=[allowable{1,1}, 'System','N/A',handles.basedata(1,1)]; % add new row to end 
        end
        set(handles.featconsttable,'data',handles.featconstdata);
    end
    if sum(wid)>0                                                           % see len section above
        idx=find(wid);
        handles.featconstdata(idx,4)=handles.basedata(1,2);
        set(handles.featconsttable,'data',handles.featconstdata);
    else 
        row=find(sum(cellfun('isempty',handles.featconstdata),2)==4);
        if row>0
        handles.featconstdata(row,1:4)=[allowable{1,2}, 'System','N/A',handles.basedata(1,2)];   
        else
        handles.featconstdata(end+1,1:4)=[allowable{1,2}, 'System','N/A',handles.basedata(1,2)];
        end
        set(handles.featconsttable,'data',handles.featconstdata);
    end








% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Only_To_Collapse_Comments
% % % % --- Executes on button press in dummyparasweep.
% % % function dummyparasweep_Callback(hObject, eventdata, handles)
% % % % hObject    handle to dummyparasweep (see GCBO)
% % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % % % handles.geoparadata=get(handles.geoparatable,'data');
% % % % % % % % emptygeo=cellfun('isempty',handles.geoparadata);
% % % % % % % % emptyrows=sum(emptygeo,2);
% % % % % % % % count=1;
% % % % % % % % for i=1:length(emptyrows)
% % % % % % % %    if emptyrows(i,1)>5
% % % % % % % %        handles.geoparadata(count,:)=[];
% % % % % % % %    else
% % % % % % % %        count=count+1;
% % % % % % % %    end
% % % % % % % % end
% % % % % % % % set(handles.geoparatable,'data',handles.geoparadata);
% % % % % % % % handles.assortparadata=get(handles.assortparatable,'data');
% % % % % % % % emptyassort=cellfun('isempty',handles.assortparadata);
% % % % % % % % emptyrows=sum(emptyassort,2);
% % % % % % % % count=1;
% % % % % % % % for i=1:length(emptyrows)
% % % % % % % %    if emptyrows(i,1)>5
% % % % % % % %        handles.assortparadata(count,:)=[];
% % % % % % % %    else
% % % % % % % %        count=count+1;
% % % % % % % %    end
% % % % % % % % end
% % % % % % % % set(handles.assortparatable,'data',handles.assortparadata);
% % % % % % % % handles.paradata=[handles.geoparadata;handles.assortparadata];
% % % % % % % % conparadata=handles.paradata(~cellfun('isempty',handles.paradata));
% % % % % % % % [rp,~]=size(conparadata);
% % % % % % % % rp=rp/6;
% % % % % % % % if isinteger(int8(rp))~=1
% % % % % % % %     errordlg(['A parameter has not been completely filled in.',newline,newline,'Remove or complete this parameter to continue.'],'Improper Entry','modal') 
% % % % % % % %     msg = 'Empty or incomplete parameter case.';
% % % % % % % %     error(msg)
% % % % % % % % end
% % % % % % % % handles.paradata=reshape(conparadata,rp,6);
% % % % % % % % 
% % % % % % % % % % x(~cellfun('isempty',x))  
% % % % % % % % % handles.paradata(~any(handles.paradata,2),:) = [];
% % % % % % % % % p=handles.paradata
% % % % % % % % % strcmp(p{2,1},'Layer Thickness')
% % % % % % % % handles.envdata=cell2mat(get(handles.envtable,'data'));
% % % % % % % % handles.basestatus=get(handles.PCbaseradio,'Value');
% % % % % % % % % handles.basedata=cell2mat(handles.basedata);
% % % % % % % % handles.basedata=get(handles.basegeotable,'data');
% % % % % % % % [handles.geomaster,handles.envmaster,handles.georow,handles.envrow,handles.delta_t,handles.transteps,handles.bmatmaster] = ParameterMaster(handles.paradata,handles.envdata,handles.envcnames,handles.xlayout,handles.ylayout,handles.zlayout,handles.basestatus,handles.basedata,handles.bmat,handles.NL);
% % % % e=handles.envmaster
% % % % gr=handles.georow
% % % % er=handles.envrow
% % % % disp('yes')
% % % 
% % % % % % pp=1;  
% % % % % % handles.geoparadata=get(handles.geoparatable,'data');
% % % % % %    handles.assortedparadata=get(handles.assortparatable,'data');
% % % % % %    [lg,~]=size(handles.geoparadata);
% % % % % %    [la,~]=size(handles.assortedparadata);
% % % % % % for ii=1:lg
% % % % % % paratype=strcmp(handles.geoparadata(ii,1),handles.geoparatype);
% % % % % % cell2mat(handles.geoparadata(ii,4));
% % % % % % min=cell2mat(handles.geoparadata(ii,4));
% % % % % % nsteps=cell2mat(handles.geoparadata(ii,5));
% % % % % % max=cell2mat(handles.geoparadata(ii,6));
% % % % % % range=linspace(min,max,nsteps);
% % % % % % [~,lr]=size(range);
% % % % % % handles.delta_t=0;
% % % % % % handles.transteps=1;
% % % % % %     if paratype(1,1)==1
% % % % % %         disp 'Position X'
% % % % % % xlayout=handles.xlayout;
% % % % % % lay=str2double(handles.geoparadata{pp,2}(2:2));
% % % % % % feat=str2double(handles.geoparadata{1,2}(end-3:end));
% % % % % % idx=find( xlayout(:,6)==lay);
% % % % % % idy=find( xlayout(:,9)==feat);
% % % % % % [xl,~]=size(idx);
% % % % % % [yl,~]=size(idy);
% % % % % % row=0;
% % % % % % for i=1:xl
% % % % % %     for iii=1:yl
% % % % % %      if idx(i,1)==idy(iii,1)
% % % % % %          row=idx(i,1);
% % % % % %          break
% % % % % %      end
% % % % % %     end
% % % % % % end
% % % % % % for iii=1:lr
% % % % % % xlayout(row,1:4)=xlayout(row,1:4)+range(1,iii);
% % % % % % handles.xlayout=xlayout;
% % % % % % dummyrunbutt_Callback(hObject, eventdata, handles)
% % % % % % end
% % % % % %     elseif paratype(1,2)==1
% % % % % %         disp 'Position Y'
% % % % % % 
% % % % % %     elseif paratype(1,3)==1
% % % % % %         disp 'Length'
% % % % % % 
% % % % % %     elseif paratype(1,4)==1
% % % % % %         disp 'Width'
% % % % % % 
% % % % % %     elseif paratype(1,5)==1
% % % % % %         disp 'Scale'
% % % % % % 
% % % % % %     end
% % % % % % end
% % % % % for ii=1:la  
% % % % %    if paratype(1,1)==1                                                   %transient selection
% % % % %          disp 'Transient'
% % % % %     hold=handles.paradata(ii,4:6);
% % % % %     [tranmin,transteps, tranmax]=deal(hold{:});
% % % % %     delta_t=(tranmax-tranmin)/transteps;
% % % % %     elseif paratype(1,2)==1
% % % % %         disp 'Layer Thickness'
% % % % %         delta_t=0;
% % % % %         transteps=1;
% % % % %     elseif paratype(1,3)==1
% % % % %         disp 'Environment'
% % % % %         delta_t=0;
% % % % %         transteps=1;
% % % % %    end
% % % % % end
% % % guidata(hObject,handles)

% % % % % --- Executes on button press in dummyrunbutt.
% % % % function dummyrunbutt_Callback(hObject, eventdata, handles)
% % % % % hObject    handle to dummyrunbutt (see GCBO)
% % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % handles    structure with handles and user data (see GUIDATA)


% Hints: contents = cellstr(get(hObject,'String')) returns solutionpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from solutionpop



% --- Executes during object creation, after setting all properties.dummyla
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% % % % % --- Executes on button press in dummytabstatus.
% % % % function dummytabstatus_Callback(hObject, eventdata, handles)
% % % % % hObject    handle to dummytabstatus (see GCBO)
% % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % handles    structure with handles and user data (see GUIDATA)
% % % % handles.tabstat=ones(1,10);
% % % % for i=1:length(handles.tabstatus)       %temp hold for radio buttons that dont exist on layouts
% % % %     if 2<i&&i<8||i>9
% % % %     else
% % % % %     handles.tabstat(1,i)=get(handles.(['tab' num2str(i) 'radio']),'value')
% % % % handles.tabstatus(1,i)=500;
% % % %     end
% % % % end
% % % % % dummy=handles.tabstatus
% % % % guidata(hObject,handles)

%%----GeoParaTable--------------------------------------------------------

% matlocation=strcmp(handles.matlist',matselect);                              % finds material location in material library matrix
% matmatrix = matlocation*handles.matprops;                                   % creats matrix with only values of selected material, all others are equal to zero
% matrow=removeconstantrows(matmatrix);                                       % removes zero values        
% rowselect=eventdata.Indices(1,1);
% colselect=eventdata.Indices(1,2);
% basecheck=strfind(handles.layerrnames(rowselect,1),'.');
% n=strrep(handles.layerrnames(rowselect,1),'Layer ',''); %replaces layer list with string value of layer number
% if colselect==1                                                             % check that cell selection has been made in column 1 for materials
% for i=4:9                                                                   % ittereations used between columns #:#
%     handles.layerdata(rowselect,i)=num2cell(matrow(1,i-3));    % inputs material properties for the selected layer in columns #:#
% end


%%----AssortParaTable------------------------------------------------------





%%---MatParaTable----------------------------------------------------------




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



%----Save Image of Plots---------------------------------------------------




%----Mesh------------------------------------------------------------------








%----Confirm Feat Buttons
%----Layout 2 Confirm Button Callback






%----Layout Tabs----------------------------------------------------------
%----Layout Tables----
%----Layout Geo Table Edit----
% Copy Data Between Identical Features




function clearlayoutbutt(n,featdata,geodata)
set(handles.(['tab' n 'radio']),'value',0)

%----Clear Layout Buttons----
function [handles]=clearlayoutdummy(handles)
n=handles.n;
tempfeatdata=cell(12,1);
tempgeodata=cell(12,6);
set(handles.(['tab',n,'radio']),'value',0);
set(handles.(['layout',n,'feattable']),'columneditable',true,'RowName',handles.geornames,'ColumnName',handles.featcnames,'data',tempfeatdata,'enable','off');
set(handles.(['layout',n,'geotable']),'columneditable',[true true true true true true],'columnformat',({handles.matlist' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric'}),'RowName',handles.geornames,'ColumnName',handles.geocnames,'data',tempgeodata,'enable','off');
set(handles.(['layout',n,'numfeatedit']),'string',[],'enable','off');
set(handles.(['layout',n,'confbutt']),'enable','off')
set(handles.(['layout',n,'confquant']),'enable','off')
set(handles.(['clearlayout',n,'butt']),'enable','off')
handles.(['layout',n,'featdata'])=tempfeatdata;
handles.(['layout',n,'geodata'])=tempgeodata;
idx=find(strcmp(handles.layoutpopactive,(['Layout ' n])));                  % finds indices of layout to be removed
for i=1:length(idx)
handles.layoutpopactive(idx(i,1)-i+1)=[];                                   % removes empty rows and shifts the indexing if mutiple are found. 
end
set(handles.layertable,'columnformat',({handles.matlist' 'numeric' handles.layoutpopactive'})); %pre-define only frist two columns as editable for layer table ie. materail and thickness
% guidata(handles)


%----Layout 4 Confirm Button Callback

    


