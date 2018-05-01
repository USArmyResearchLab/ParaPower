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
handles.highlightsol=get(handles.highlightsolradio,'value');
toplayer=strrep(get(handles.plotpop,'Value'),'Layer ','');
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
R3=2*solnum-1;
Rm3=(handles.matrow*(solnum-1))+1;
Rm4=handles.matrow*solnum;
handles.xlayout=handles.geomaster(R1:R2,1:9);
handles.ylayout=handles.geomaster(R1:R2,10:13);
handles.zlayout=handles.geomaster(R1:R2,14:15);
[handles.layerstack]=unique(handles.zlayout,'rows','stable'); 
handles.dz=handles.layerstack(:,1)';
handles.h=handles.envmaster(R3,:);
handles.Ta=handles.envmaster(R3+1,:);
handles.tempmatprops=handles.matpropsmaster(Rm3:Rm4,:);
% [Temp,Stress,xgrid,ygrid]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init);
[Temp,Stress,xgrid,ygrid,NR,NC,handles.ND]=ParaPower(handles.xlayout,handles.ylayout,handles.dz,handles.NL,handles.bmat,handles.h,handles.Ta,handles.Tproc,handles.delta_t,handles.transteps,handles.T_init,handles.tempmatprops,handles.meshdensity);
axes(handles.layerplot)
cla reset; 
layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,xgrid,ygrid,toplayer,handles.ND)
% handles.layerplothold=figure('visible','off');
% layerplot(handles.xlayout,handles.ylayout,handles.zlayout,handles.matcolors,xgrid,ygrid,toplayer)
% guidata(hObject,handles)
axes(handles.modelplot)
cla reset;
tempmaster=handles.geomaster(R1:R2,:);
modelplot(tempmaster,handles.georow,handles.removeencap)
% handles.sysplothold=figure('visible','on');
% % b=handles.sysplothold
% modelplot(tempmaster,handles.georow,handles.removeencap)
% guidata(hObject,handles)
toggles=0;
viewall=0;
axes(handles.resultsplot)
cla reset; 
resultplot(toggles,handles.geomaster,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol,handles.resultsdata)
% handles.resultsplothold=figure('visible','off');
% resultplot(toggles,handles.geomaster,handles.georow,handles.TempMaster,handles.StressMaster,solnum,viewall,handles.resultplotname,handles.highlightsol)
% guidata(hObject,handles)
% x=1;
pause(0.01)
% solnum=solnum+1;
% end
guidata(hObject,handles)

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
set(hObject,'Max',3);                                                       % set range max
set(hObject,'SliderStep',[0.5 1]);                                          % set step size for [arrow, slider] 
guidata(hObject,handles)

%----Mesh Static Create
function devmeshdensitystatic_CreateFcn(hObject, eventdata, handles)

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





