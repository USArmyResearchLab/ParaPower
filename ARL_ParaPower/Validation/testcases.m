%This M files executes the set of validation test cases for ParaPower
clear

addpath('..');  %include above directory which contains the parapower code
CaseDir='Cases';  %Update this to include the directory that will hold the case files.

testcasefiles=dir([CaseDir '/*.m']);
if ispc
    testcasefiles=[testcasefiles dir([CaseDir '/*.lnk'])];
end

fprintf('\n')
figure(1);clf
figure(2);clf
drawnow

load('DefaultMaterials.mat')
OrigMatLib=MatLib;
clear MatLib

Compare=[];
     
for Icase=1:length(testcasefiles)
    
    CaseName=char(testcasefiles(Icase).name);
    if ispc && strcmpi(CaseName(end-3:end),'.lnk')
      [path,name,ext]=fileparts(getTargetFromLink([testcasefiles(Icase).folder '\' CaseName]));
      CaseName=[name ext];
      testcasefiles(Icase).folder=path;
    end
    CaseName=CaseName(1:end-2);
    clear TestCaseModel MFILE
    
    if isempty(str2num(CaseName(1))) 
        fprintf('Executing test case %s...\n',CaseName)
        VarsOrig=who;
        addpath(testcasefiles(Icase).folder);
        eval(CaseName)
        rmpath(testcasefiles(Icase).folder)
        CaseExists=true;
    else
        fprintf('Can''t execute ''%s''. Name cannot start with a number.\n',CaseName)
        CaseExists=false;
    end
    
    if CaseExists
        %Erase all newly created variables in the test case M file
        VarsNew=who;
        VarsOrig=[VarsOrig; 'VarsOrig'; 'TestCaseModel'; 'VarsNew'; 'Vi'; 'MFILE'];
        for Vi=1:length(VarsNew)
            if isempty(cell2mat(regexp(VarsOrig,['^' VarsNew{Vi} '$'])))
    %            fprintf('Clearing %s\n',VarsNew{Vi});
                clear (VarsNew{Vi})
    %        else
    %            fprintf('Leaving %s\n',VarsNew{Vi});
            end
        end
        clear VarsOrig VarsNew
    
        %Material Properties
        if isfield(TestCaseModel,'MatLib')
            MatLib=TestCaseModel.MatLib;
        else
            disp('Adding default materials from the material database to the model')
            TestCaseModel.MatLib=OrigMatLib;
            %return
        end        
        MI=FormModel(TestCaseModel);
        if length(testcasefiles)==Icase
            figure(1);clf; figure(2);clf; figure(1)
            Visualize ('Model Input', MI, 'modelgeom','ShowQ')
        end
        fprintf('Analysis executing...')


        tic;
        GlobalTimeOrig=MI.GlobalTime;
        MI.GlobalTime=GlobalTimeOrig(1);  %Setup initialization
        S1=scPPT('MI',MI); %Initialize object
        setup(S1,[]);
        [Tprnt, T_in, MeltFrac,MeltFrac_in]=S1(GlobalTimeOrig(2:end));  %Compute states at times in ComputeTime (S1 must be called with 1 arg in 2017b)
        Results.Tprnt   =cat(4, T_in        , Tprnt  );
        Results.MeltFrac=cat(4, MeltFrac_in , MeltFrac);
        MI.GlobalTime = GlobalTimeOrig; %Reassemble MI's global time to match initialization and computed states.
        Fi=1; %Could be used to mask for features; (Tprnt would be Tprnt(Mask)
        Results.DoutT(:,1+Fi)=max(reshape(Results.Tprnt,[],length(MI.GlobalTime)),[],1);
        Results.DoutM(:,1+Fi)=max(reshape(Results.Tprnt,[],length(MI.GlobalTime)),[],1);
        Results.DoutT(:,1)=MI.GlobalTime;
        Results.DoutM(:,1)=MI.GlobalTime;
        ExecTime=toc;
        Results.ExecTime=ExecTime;
        Results.DateTime=datetime;
        Results.Desc=TestCaseModel.Desc;
        Results.Computer=computer();
        Results.Matlab=ver('matlab');
        if exist([MFILE '.m'],'file')
            ResultsFile=[MFILE, '_Results.mat'];
            if exist(ResultsFile,'file')
                NewResults=Results;
                load(ResultsFile);
                OldResults=Results;
                Results=NewResults;
                Compare{Icase}.Desc=TestCaseModel.Desc;
                Compare{Icase}.DeltaTime=OldResults.ExecTime - NewResults.ExecTime;
                Compare{Icase}.GlobalTime=MI.GlobalTime;
                DoFList={'Tprnt' 'MeltFrac'};
                try
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
                    Results=NewResults;
                catch
                    Compare{Icase}=[];
                    disp('Previous data comparison impossible')
                end
            else
                fprintf('Results file not found.  A new one will be created (%s)\n', ResultsFile);
                save (ResultsFile,'Results')
            end
        else
            disp('Results file not requested.')
        end
        
       fprintf('Complete.\n')
                                           
       if length(testcasefiles)==Icase
           figure(2);clf; pause(.001)
           StateN=length(MI.GlobalTime);
           subplot(1,2,1);
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',MI.GlobalTime(end), StateN,length(Results.Tprnt(1,1,1,:))),MI ...
           ,'state', Results.Tprnt(:,:,:,StateN) ...
           ,'scaletitle', 'Temperature' ...
           )       
           subplot(1,2,2);
           Visualize(sprintf('t=%1.2f ms, State: %i of %i',MI.GlobalTime(end), StateN,length(Results.MeltFrac(1,1,1,:))),MI ...
           ,'state', Results.MeltFrac(:,:,:,StateN) ...
           ,'scaletitle', '% Solid' ...
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
    CaseDesc{I}=Compare{I}.Desc;
    for J=1:length(Compare{1}.DOFdelt)
        if size(Compare{I}.DOFdelt{J}(:))==2
            PlotCompare(I,J)=sum((Compare{I}.DOFdelt{J}(:)).^2);
        else
            PlotCompare(I,J)=sum((Compare{I}.DOFdelt{J}(:,2)).^2);
        end
        DOFDesc{J}=Compare{I}.DOFdesc{J};
        DeltaTime(I)=Compare{I}.DeltaTime;
    end
end
figure(10);
for I=1:length(DOFDesc)
    subplot(1+length(DOFDesc),1,I+1)
    bar(PlotCompare(:,I));
    set(gca,'xticklabel',strrep(CaseDesc,'_',' '))
    title(DOFDesc{I})
    set(gca,'yscal','log')
end
subplot(1+length(DOFDesc),1,1)
bar(DeltaTime)
set(gca,'xticklabel',strrep(CaseDesc,'_',' '))
title('Delta Wall Time')
ylabel('time (s)')
