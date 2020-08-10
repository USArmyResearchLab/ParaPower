%This M files executes the set of validation test cases for ParaPower
%The test cases to run exist as shortcuts/links in the Validation/Cases
%directory.  The actual file should exist in the Validation/CasesHold
%directory.  

%The first time a case is run, a file is generated with the name
%CASENAME_Results.ppmodel.  This file holds both the model definition as a
%the results of the analysis at the time.

%The file can be loaded into the GUI using the "load profile" GUI button.
%The model will be loaded, but no the results.  

clearvars -EXCEPT TestCaseWildCard

addpath('..');  %include above directory which contains the parapower code
CaseDir='Cases';  %Update this to include the directory that will hold the case files.

if exist('TestCaseWildCard')
    disp(['Only running casing meeting the following wildcard (TestCaseWildCard): ' TestCaseWildCard])
else
    disp('TestCaseWildCard variable doesn''t exist, running all testcases.')
    TestCaseWildCard='g*';
end
TestCasesFspec=[CaseDir '/' TestCaseWildCard ];
TestCasesFspec=strrep(TestCasesFspec,'**','*');

testcasefiles=dir([TestCasesFspec '.ppmodel']);
if ispc
    testcasefiles=[testcasefiles dir([TestCasesFspec '.lnk'])];
end

Compare=[];
WinHandle=[];
     
for Icase=1:length(testcasefiles)
    
    CaseName=char(testcasefiles(Icase).name);
    if ispc && strcmpi(CaseName(end-3:end),'.lnk')
      [path,name,ext]=fileparts(getTargetFromLink([testcasefiles(Icase).folder '\' CaseName]));
      CaseName=[name ext];
      testcasefiles(Icase).folder=path;
    end
    %CaseName=CaseName(1:end-2);
    
    if isempty(str2num(CaseName(1))) 
        fprintf('Executing test case %s...\n',CaseName)
        addpath(testcasefiles(Icase).folder);
        if ishandle(WinHandle)
            delete(WinHandle)
        else
           delete(findall(0,'tag','figure1'));
        end
        WinHandle=ParaPowerGUI_V2;
        Handles=guidata(WinHandle);
        hObject=Handles.loadbutton;
        EventData=[];
        ParaPowerGUI_V2('loadbutton_Callback',hObject,EventData,Handles,CaseName);
        Handles=guidata(WinHandle);
        tic
        ParaPowerGUI_V2('RunAnalysis_Callback',hObject,EventData,Handles);
        ExecTime=toc;
        Results=getappdata(WinHandle,'Results');
        rmpath(testcasefiles(Icase).folder)
        CaseExists=true;
    else
        fprintf('Can''t execute ''%s''. Name cannot start with a number.\n',CaseName)
        CaseExists=false;
    end
    
    if CaseExists
        if length(Results)>1
            Results=Results(1)
        end
        %[Tprnt, T_in, MeltFrac,MeltFrac_in]=S1(GlobalTimeOrig(1:end));  %Compute states at times in ComputeTime (S1 must be called with 1 arg in 2017b)
        NewResults.Tprnt   =Results.getState('Thermal');
        NewResults.MeltFrac=Results.getState('MeltFrac');%cat(4, MeltFrac_in , MeltFrac);
        MI=Results.Model;
        %MI.GlobalTime = GlobalTimeOrig; %Reassemble MI's global time to match initialization and computed states.
        Fi=1; %Could be used to mask for features; (Tprnt would be Tprnt(Mask)
        NewResults.DoutT(:,1+Fi)=max(reshape(NewResults.Tprnt,[],length(MI.GlobalTime)),[],1);
        NewResults.DoutM(:,1+Fi)=max(reshape(NewResults.Tprnt,[],length(MI.GlobalTime)),[],1);
        NewResults.DoutT(:,1)=MI.GlobalTime;
        NewResults.DoutM(:,1)=MI.GlobalTime;
%        ExecTime=toc;
        NewResults.ExecTime=ExecTime;
        NewResults.DateTime=datetime;
        NewResults.Desc=CaseName(1:max(find(CaseName=='.'))-1); %TestCaseModel.Desc;
        NewResults.Computer=computer();
        NewResults.Matlab=ver('matlab');
        name=NewResults.Desc;
        if exist([testcasefiles(Icase).folder '/' name '.ppmodel'],'file')
            
            ResultsFile=[testcasefiles(Icase).folder '/' name, '_Results.ppmodel'];
            ResultsFile = strrep(ResultsFile,'\','/');
            % check to see if benchmark exists
            if ~exist(ResultsFile,'file')
                ResultsFile=strrep(ResultsFile,'/Cases/','/CasesHold/');
            end         
            if exist(ResultsFile,'file')
                OldResults=load(ResultsFile,'-mat');
                if ~isfield(OldResults,'NewResults')
                    disp([ResultsFile ' uses older version of stored results file.  ''Results'' variable is now named ''NewResults''.'])
                    OldResults=OldResults.('Results');
                else
                    OldResults=OldResults.('NewResults');
                end
                Compare{Icase}.Desc=NewResults.Desc;
                Compare{Icase}.DeltaTime=NewResults.ExecTime / OldResults.ExecTime;
                Compare{Icase}.GlobalTime=MI.GlobalTime;
                DoFList={'Tprnt' 'MeltFrac'};
                try
                    if size(NewResults.Tprnt) == size(OldResults.Tprnt)
                        for Idof=1:length(DoFList)
                            if isfield(NewResults,DoFList{Idof})
                                Compare{Icase}.DOFdesc{Idof}=DoFList{Idof};
                                Compare{Icase}.DOFdelt{Idof}=OldResults.(DoFList{Idof}) - NewResults.(DoFList{Idof});
                            end
                        end
                        DoFList={'DoutT' 'DoutM'};
                        for Idof=1:length(DoFList)
                            if isfield(NewResults,DoFList{Idof})
                                Compare{Icase}.DOFdesc{end+1}=DoFList{Idof};
                                Compare{Icase}.DOFdelt{end+1}=OldResults.(DoFList{Idof}) - NewResults.(DoFList{Idof});
                            end
                        end
                    else
                        Compare{Icase}.DOFdesc={'N/A'};
                        Compare{Icase}.DOFdelt=[];
                        disp(['Saved case does not match current case for ' NewResults.Desc ]);
                    end
                catch ME
                    Compare{Icase}=[];
                    Compare{Icase}.Desc='';
                    Compare{Icase}.DOFdelt={[]};
                    Compare{Icase}.DOFdesc={''};
                    disp('Previous data comparison impossible')
                end
            else
                fprintf('Results file not found.  A new one will be created (%s)\n', ResultsFile);
                TestCaseModel=Results.Case;
                save (ResultsFile,'-mat','NewResults', 'TestCaseModel')
            end
        else
            disp('Results file not requested.')
        end
        
       fprintf('Complete.\n')
                                           
       if length(testcasefiles)==Icase
           figure(2);clf; pause(.001)
           StateN=length(MI.GlobalTime);
           subplot(1,2,1);
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',MI.GlobalTime(end), StateN,length(NewResults.Tprnt(1,1,1,:))),MI ...
           ,'state', NewResults.Tprnt(:,:,:,StateN) ...
           ,'scaletitle', 'Temperature' ...
           )       
           subplot(1,2,2);
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',MI.GlobalTime(end), StateN,length(NewResults.MeltFrac(1,1,1,:))),MI ...
           ,'state', NewResults.MeltFrac(:,:,:,StateN) ...
           ,'scaletitle', 'Melt Fraction' ...
           )       
       end
       %figure(3);clf; pause(.001)
       %Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Tprnt(1,1,1,:))),[0 0 0 ],{MI.X MI.Y MI.Z}, MI.Model, MeltFrac(:,:,:,StateN),'Melt Fraction')                                
       %disp('Press key to continue.');pause
    end
end
DOFDesc={};
CaseDesc={};
for I=1:length(Compare)
    if ~isempty(Compare{I}.Desc)
        CaseDesc{I}=Compare{I}.Desc;
        for J=1:length(Compare{I}.DOFdelt)
            if size(Compare{I}.DOFdelt{J}(:))==2
                PlotCompare(I,J)=sum((Compare{I}.DOFdelt{J}(:)).^2);
            else
                PlotCompare(I,J)=sum((Compare{I}.DOFdelt{J}(:,2)).^2);
            end
            DOFDesc{J}=Compare{I}.DOFdesc{J};
            DeltaTime(I)=Compare{I}.DeltaTime;
        end
    end
end
figure(10);
clf
NumCols=2;
NumRows=ceil((1+length(DOFDesc))/NumCols);
for I=1:length(DOFDesc)
    subplot(NumRows,NumCols,I+1)
    barh(PlotCompare(:,I));
    set(gca,'yticklabel',strrep(CaseDesc,'_',' '))
    xlabel('Sum[RMS(Cur-Canon)]')
    title(DOFDesc{I})
    set(gca,'xscal','log')
end
if exist('DeltaTime','var')
     subplot(NumRows,NumCols,1)
    barh(DeltaTime)
    set(gca,'yticklabel',strrep(CaseDesc,'_',' '))
    title('Wall Time (Current/Canon)')
    xlabel('time (s)')
end
