%Get ParaPower Window
function GetPPResults(CaseNum)
    ParaPowerName='ParaPowerGUI_V2';
    Figs=findall(0,'type','figure');
    Names=char(get(Figs,'name'));
    Names=cellstr(Names(:,1:length(ParaPowerName)));
    ParaPower=Figs(strcmp(Names,ParaPowerName));
    if isempty(ParaPower)
        disp(['No current ' ParaPowerName ' window open.'])
    else
        if isappdata(ParaPower,'Results')
            Results=getappdata(ParaPower,'Results');
            fprintf('Results for %i cases are included. Only Case 1 is being returned.\n',length(Results));
            Results=Results(1);
            States=Results.listStates;
            for I=1:length(States)
                assignin('base',States{I},Results.getState(States{I}))
            end
            assignin('base','Model',Results.Model)
                
        else
            disp('No Results available.')
        end
    end
