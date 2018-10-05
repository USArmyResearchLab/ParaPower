%This M files executes the set of validation test cases for ParaPower

addpath('..');  %include above directory which contains the parapower code
testcasefiles=dir('Cases\*.m');

for Icase=1:length(testcasefiles)
    
    CaseName=char(testcasefiles(Icase).name);
    CaseName=CaseName(1:end-2);
    
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
    
        MI=FormModel(TestCaseModel, true);
        disp('Press key to continue.');pause

        disp('Analysis starting...')

        [Tprnt, Stress, MeltFrac]=ParaPowerThermal(MI.NL,MI.NR,MI.NC, ...
                                               MI.h,MI.Ta, ...
                                               MI.X,MI.Y,MI.Z, ...
                                               MI.Tproc, ...
                                               MI.Model,MI.Q, ...
                                               MI.DeltaT,MI.Tsteps,MI.Tinit,MI.matprops);
       Visualize([0 0 0 ],{MI.X MI.Y MI.Z}, MI.Model, Tprnt(:,:,:,end))                                
       disp('Press key to continue.');pause
    end
end










