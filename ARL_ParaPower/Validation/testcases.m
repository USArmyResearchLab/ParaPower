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

MatF=MaterialDatabase('nonmodal');
Mats=getappdata(MatF,'Materials');

close(MatF)
     
for Icase=1:length(testcasefiles)
    
    CaseName=char(testcasefiles(Icase).name);
    if ispc && strcmpi(CaseName(end-3:end),'.lnk')
      [path,name,ext]=fileparts(getTargetFromLink([testcasefiles(Icase).folder '\' CaseName]));
      CaseName=[name ext];
      testcasefiles(Icase).folder=path;
    end
    CaseName=CaseName(1:end-2);
    clear TestCaseModel 
    
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
        VarsOrig=[VarsOrig; 'VarsOrig'; 'TestCaseModel'; 'VarsNew'; 'Vi'];
        for Vi=1:length(VarsNew)
            if isempty(cell2mat(regexp(VarsOrig,['^' VarsNew{Vi} '$'])))
    %            fprintf('Clearing %s\n',VarsNew{Vi});
                clear (VarsNew{Vi})
    %        else
    %            fprintf('Leaving %s\n',VarsNew{Vi});
            end
        end
        clear VarsOrig VarsNew
    
        figure(1);clf; figure(2);clf; figure(1)
        %Material Properties
        if isfield(TestCaseModel,'MatLib')
            MatLib=TestCaseModel.MatLib;
            TestCaseModel.Version='V2.0';
        else
            disp('Adding default materials from the material database to the model')
            TestCaseModel.MatLib=Mats;
            TestCaseModel.Version='V2.0';
            %return
        end        
        MI=FormModel(TestCaseModel);
        Visualize ('Model Input', MI, 'modelgeom','ShowQ')
        pause(.001)
        fprintf('Analysis executing...')


        tic;
        %[Tprnt, MI, MeltFrac]=ParaPowerThermal(MI);
        S1=scPPT;
        S1.MI=MI;
        [~]=S1();
        Tprnt=cat(4,S1.T_in,S1.Tres);
        MeltFrac=cat(4,S1.PH_in,S1.PHres);
        toc;
        
        
       fprintf('Complete.\n')
                                           
       figure(2);clf; pause(.001)
       StateN=length(MI.GlobalTime);
       Visualize(sprintf('t=%1.2f ms, State: %i of %i',MI.GlobalTime(end), StateN,length(Tprnt(1,1,1,:))),MI ...
       ,'state', Tprnt(:,:,:,StateN) ...
       ,'scaletitle', 'Temperature' ...
       )                                
       %figure(3);clf; pause(.001)
       %Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Tprnt(1,1,1,:))),[0 0 0 ],{MI.X MI.Y MI.Z}, MI.Model, MeltFrac(:,:,:,StateN),'Melt Fraction')                                
       %disp('Press key to continue.');pause
    end
end










