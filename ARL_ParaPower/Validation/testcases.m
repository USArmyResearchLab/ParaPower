%This M files executes the set of validation test cases for ParaPower

addpath('..');  %include above directory which contains the parapower code
testcasefiles=dir('Cases\*.m');
fprintf('\n')
figure(1);clf
figure(2);clf
drawnow

for Icase=1:length(testcasefiles)
    
    CaseName=char(testcasefiles(Icase).name);
    CaseName=CaseName(1:end-2);
    clear TestCaseModel
    
    if isempty(str2num(CaseName(1)))
        fprintf('Executing test case %s...\n',CaseName)
        VarsOrig=who;
        addpath(testcasefiles(Icase).folder);
        eval([CaseName])
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
        MI=FormModel(TestCaseModel);
        Visualize ('Model Input', MI, 'modelgeom','ShowQ')
        pause(.001)
        fprintf('Analysis executing...')


        GlobalTime=[0:MI.Tsteps-1]*MI.DeltaT;  %Since there is global time vector, construct one here.
        [Tprnt, Stress, MeltFrac]=ParaPowerThermal(MI.NL,MI.NR,MI.NC, ...
                                               MI.h,MI.Ta, ...
                                               MI.X,MI.Y,MI.Z, ...
                                               MI.Tproc, ...
                                               MI.Model,MI.Q, ...
                                               MI.DeltaT,MI.Tsteps,MI.Tinit,MI.matprops);
       fprintf('Complete.\n')
                                           
       figure(2);clf; pause(.001)
       StateN=length(GlobalTime);
       Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Tprnt(1,1,1,:))),MI ...
       ,'state', Tprnt(:,:,:,StateN) ...
       ,'scaletitle', 'Temperature' ...
       )                                
       %figure(3);clf; pause(.001)
       %Visualize(sprintf('t=%1.2f ms, State: %i of %i',StateN*MI.DeltaT*1000, StateN,length(Tprnt(1,1,1,:))),[0 0 0 ],{MI.X MI.Y MI.Z}, MI.Model, MeltFrac(:,:,:,StateN),'Melt Fraction')                                
       disp('Press key to continue.');pause
    end
end










