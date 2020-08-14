classdef PostProcessResults_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        PPPP                            matlab.ui.Figure
        LoadCurrentResultsButton        matlab.ui.control.Button
        PlotButton                      matlab.ui.control.Button
        DependentVariableDropDownLabel  matlab.ui.control.Label
        DependentVariableDropDown       matlab.ui.control.DropDown
        IndependentVariableDropDownLabel  matlab.ui.control.Label
        IndependentVariableDropDown     matlab.ui.control.DropDown
        ListBoxLabel                    matlab.ui.control.Label
        ListBoxTemplate                 matlab.ui.control.ListBox
        FileLoadButton                  matlab.ui.control.Button
        StatusBox                       matlab.ui.control.ListBox
        LogoSpace                       matlab.ui.control.UIAxes
        ClosePlotWindowsButton          matlab.ui.control.Button
        FeatureListBox                  matlab.ui.control.ListBox
        MaxoverFeaturesCheckBox         matlab.ui.control.CheckBox
    end

    
    properties (Access = private)
        Results % Description
        ParaPower % Description
        PlotWindows = []% Description
        AvailStates
    end
    
    properties (Constant)
        %AvailStates={'Max Temperature' 'Min Melt Frac'};
        %AvailStates={'Max Temperature' }; %Removed until it can be limited to PCM only
        ParaPowerName='ParaPowerGUI_V2';
    end
    
    methods (Access = private)
        
        % findobj locates all objs in app.PPPP that have tag "varLB"
        function results = getvarbox(app, VarName)
            LBh=findobj(app.PPPP, 'tag', 'VarLB');
            LB=[];
            for I=1:length(LBh)
                % retrieve info from UserData (info related to obj)
                U=LBh(I).UserData;
                if strcmpi(U{2},VarName)
                    LB=LBh(I);
                    LBi=U{1};
                end
            end
            if ~isempty(LB)
                LBL=findobj(app.PPPP,'tag','VarLBL','userdata',LBi);
            end
            % end with results to plot
            results=[LB LBL];
        end
        
        function PopulateFeatures(app)
            template_resultsobj = app.Results(1);
            FeatureList = template_resultsobj.Model.FeatureDescr;
            NumVars = length(FeatureList);
            for feature = 1:NumVars
                FeatureName{feature} = FeatureList{feature};
            end
            FeatureValue = [1:NumVars];
            app.FeatureListBox.Items = FeatureName;
            app.FeatureListBox.ItemsData = FeatureValue;
        end
        
        function results = PopulateResults(app)
            % save PPResults (obj) in lResults 
            lResults=app.Results;
             figure(app.PPPP)
             % number of variables = first column
             % PPResults.Model.Descriptor
             NumVars=length(app.Results(1).Model.Descriptor(:,1));
             % iterate through each variable
             for Vi=1:NumVars
                 % variable name = 1st column PPResults.Model.Descriptor
                 % (str)
                 VarName{Vi}=lResults(1).Model.Descriptor{Vi,1};
                 VarVals{Vi}={};
                 % iterate through each model configuration
                 for Ri=1:length(lResults)
                     % variable value = 2nd column PPResults.Model.Descriptor
                     % (scalar that is input by user, e.g. one value from vector)
                     DataValue=lResults(Ri).Model.Descriptor{Vi,2};
                     if ~ischar(DataValue)
                         DataValue=num2str(DataValue);
                     end
                     SC=strcmp(VarVals{Vi},DataValue);
                     if isempty(SC) | SC==0
                         VarVals{Vi}{end+1}=DataValue;
                     end
                 end
             end
             % TC 08-03-2020
             % append "Time" independent variable to every model,
             % regardless of input parameters
             VarName{end+1} = 'Time';
             VarVals{end+1} = lResults(1).Model.GlobalTime;
        
        % GUI formatting
             P=app.ListBoxTemplate.Position;
             Pl=app.ListBoxLabel.Position;
             app.ListBoxTemplate.Visible=false;
             app.ListBoxLabel.Visible=false;
             Wdth=P(3)*1.05;
             Hgt=P(4)*1.05;
             Xpos=Pl(1);
             Ypos=Pl(2);
             NumInRow=4;
             delete(findobj(app.PPPP,'tag','VarLB'));
             delete(findobj(app.PPPP,'tag','VarLBL'));
             for I=1:NumVars
                 TagNum=num2str(I);
                 % VarLB = list box
                 % VarLBL = list box label
                 % create each list box, add title
                 UI=uilistbox(app.PPPP,'items',VarVals{I},'tag',['VarLB'],'user',{I VarName{I}},'position',[Xpos Ypos-(Pl(2)-P(2)) P(3) P(4)],'MultiSelect',true);
                 UIt=uieditfield(app.PPPP,'value',VarName{I},'tag',['VarLBL'],'user',I,'position',[Xpos Ypos P(3) Pl(4)],'enable',true);
                 RestoreUIt=@(A,B)set(UIt,'value',VarName{I});
                 UIt.ValueChangedFcn=RestoreUIt;
                 %set(UIt,'ValueChangedFcn',UItRestore);
                 Xpos=Xpos+Wdth;
                 if mod(I,NumInRow)==0
                     Ypos=Ypos-Hgt-Pl(4) ;
                     Xpos=Pl(1);
                 end
             end
             
             % populate dependent variables with the min and max available
             % states
             raw_states = lResults.StatesAvail;
             states_avail = {};
             for state = 1:length(raw_states)
                 current_state = raw_states(state);
                 % check to see that the state actually exists
                 if any(size(lResults(1).getState(current_state)))
                     
                     if strcmpi(char(current_state),'Thermal')
                         current_state_str = 'Temperature';
                     else
                         current_state_str = char(current_state);
                     end
                     states_avail{end+1} = append('Max ',current_state_str);
                     states_avail{end+1} = append('Min ',current_state_str);
                 end

             end
             %states_avail_test = cell2mat(states_avail)
             app.AvailStates = states_avail;
             
             app.IndependentVariableDropDown.Items=VarName;
             app.DependentVariableDropDown.Items=app.AvailStates;
             IndependentVariableDropDownValueChanged(app);
             app.IndependentVariableDropDown.Enable=true;
             app.DependentVariableDropDown.Enable=true;
             
        end
        
        % obtain dependent variable only over the features selected
        function masked_state = getFeatureMask(app, results_index, full_state)
           
           % get ppresults obj. (maybe parameter?)
           template_resultsobj = app.Results(results_index);
           % get user-selected features from FeatureListBox
           selected_features = get(app.FeatureListBox,'value');
           if app.MaxoverFeaturesCheckBox.Value == false
               masked_state = full_state;
           else
               % get full feature matrix (3D, no time)
               feature_matrix = template_resultsobj.Model.FeatureMatrix;
               % expand feature matrix along time dimension (4D)
               time = length(template_resultsobj.Model.GlobalTime);
               feature_matrix_full = repmat(feature_matrix,[1 1 1 time]);
               % initialize matrix, same size as temp/melt frac state
               masked_state = nan(size(full_state));
               % loop through each feature to create mask
               % extract only temps/melt fracs from user-selected features
               for feature = 1:length(selected_features)
                   current_feature = selected_features(feature);
                   current_feature_mask = (current_feature==feature_matrix_full);
                   masked_state(current_feature_mask) = full_state(current_feature_mask);
               end
               
           end
           
        end
        
        function max_reshaped_state = get_minmaxstate (app,results,index,state,minmax,time)
            if time==1
                full_state = results(index).getState(state);
                masked_state = app.getFeatureMask(index,full_state);
                reshaped_state = reshape(masked_state,[],length(results(index).Model.GlobalTime));
                if strcmp(minmax,'Max')
                    max_reshaped_state = max(reshaped_state,[],1);
                else
                    max_reshaped_state = min(reshaped_state,[],1);
                end
            else
                full_state = results(index).getState(state);
                masked_state = app.getFeatureMask(index,full_state);
                if strcmp(minmax,'Max')
                    max_reshaped_state=max(masked_state(:));
                else
                    max_reshaped_state=min(masked_state(:));
                end
            end
        end
        
        function results = AddStatusLine(app,StatusText, Flag)
            if ~exist('Flag')
                Flag=[];
            end
            CurItems=app.StatusBox.Items;
            app.StatusBox.Items={' '};
            app.StatusBox.Items=[StatusText CurItems];
            app.StatusBox.ItemsData=[1:length(CurItems)+1];
            app.StatusBox.Value=1;
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.ListBoxTemplate.Visible=false;
            app.ListBoxLabel.Visible=false;
            app.IndependentVariableDropDown.Enable=false;
            app.DependentVariableDropDown.Enable=false;
            app.FeatureListBox.Enable = false;
            app.FeatureListBox.Visible = false;
            app.MaxoverFeaturesCheckBox.Visible = false;
            app.StatusBox.Items={};
            
            %Display Logo
            BkgColor=app.PPPP.Color;
            Logo=imread('CCDC_RGB_Positive_RLB.lg.png','backgrou',BkgColor);
            image(app.LogoSpace,Logo);
            app.LogoSpace.Visible=false;
            Tx=text(app.LogoSpace,0,0,'ParaPower','unit','normal','fontsize',16,'horiz','center');
            E=get(Tx,'extent');
            Tx.Position=[0.5 -1*E(4)*0.30];
            %Tx2=text(app.LogoSpace,0.5,1,'ARL ParaPower','unit','normal','fontsize',14,'horiz','center','Verticalalignment','bottom')
        end

        % Button pushed function: LoadCurrentResultsButton
        function LoadCurrentResultsButtonPushed(app, event)
             app.AddStatusLine('Loading results from current ParaPower instance...')
             %Get ParaPower Window
             Figs=findall(0,'type','figure');
             Names=char(get(Figs,'name'));
             Names=cellstr(Names(:,1:length(app.ParaPowerName)));
             app.ParaPower=Figs(strcmp(Names,app.ParaPowerName));
             if isempty(app.ParaPower)
                 app.AddStatusLine(['No current ' app.ParaPowerName ' window open.'])
                 return
             end
             figure(app.PPPP)
             if isappdata(app.ParaPower,'Results')
                 app.Results=getappdata(app.ParaPower,'Results');
             else
                 app.AddStatusLine('No Results available.')
                 return
             end
             app.PopulateResults;
             app.PopulateFeatures;
             app.FeatureListBox.Visible = true;
             app.MaxoverFeaturesCheckBox.Visible = true;
        end

        % Value changed function: IndependentVariableDropDown
        function IndependentVariableDropDownValueChanged(app, event)
            %Value is the text of the independent variable.  should be able to have it match other.
            value = app.IndependentVariableDropDown.Value;
            set(findobj(app.PPPP,'tag','VarLB'),'enable',true);
            set(findobj(app.PPPP,'tag','VarLBL'),'enable',true);
            % if time selected as independent, all list boxes enabled
            % otherwise, gray out the selected box
            if ~strcmpi(value,'Time')
                VarBlock = app.getvarbox(value);
                set(VarBlock,'enable',false)
            end
        end

        % Button pushed function: FileLoadButton
        function FileLoadButtonPushed(app, event)
            if isempty(app.FileLoadButton.UserData)
                OldPath='';
            else
                OldPath=app.FileLoadButton.UserData;
            end
            [filename, pathname]= uigetfile({'*.ppmodel' 'Models'; '*.*' 'All Files'},'',OldPath);
            if filename~=0
                app.FileLoadButton.UserData=pathname;
                app.AddStatusLine(['Loading ' pathname filename '...'])
                L=load([pathname filename],'-mat');
                if isfield(L,'Results')
                    if length(L.Results)>1
                        app.Results=L.Results;
                        app.PopulateResults;
                        app.PopulateFeatures;
                        app.FeatureListBox.Visible = true;
                        app.MaxoverFeaturesCheckBox.Visible = true;
                        OldName=app.PPPP.Name;
                        Colon=find(OldName==':', 1 );
                        if ~isempty(Colon)
                            OldName=OldName(1:Colon-1);
                        end
                        app.PPPP.Name=[OldName ': ' filename];
                    else
                        app.AddStatusLine('File contains only 1 result set.')
                    end
                else
                    app.AddStatusLine('No Results in file')
                end
            else
                app.AddStatusLine('No file selected.')
            end


        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            lResults = app.Results;
            VarBxH = findobj(app.PPPP,'tag','VarLB');
            Independent = app.IndependentVariableDropDown.Value;
            time_flag = 0;
            max_time = lResults(1).Model.GlobalTime(end);
            max_results = 1;

            if strcmpi(Independent,'Time')
                for I = 2:length(lResults)
                    current_max_time = lResults(I).Model.GlobalTime(end);
                    if current_max_time > max_time
                        max_time = current_max_time;
                        max_results = I;
                    end
                end
                IndepAxis_max = lResults(max_results).Model.GlobalTime;
                XLabel = 'Time (seconds)';
                time_flag = 1;
            else
                % get ind. var. name and value by looking for obj that is
                % disabled
                IndepVar=get(findobj(VarBxH,'enable',false),'userdata');
                % IndepAxis is matrix with doubles
                % IndepAxisC is cell with strings
                IndepAxisC=get(findobj(VarBxH,'enable',false),'Items');
                for I=1:length(IndepAxisC)
                    IndepAxis{I}=str2double(IndepAxisC{I});
                end
                IndepAxis=cell2mat(IndepAxis);
                XLabel=IndepVar{2};
            end
            
            VarBxH=findobj(VarBxH,'enable',true);
            
            NumCurves=1;
            % Curves = {Var1_Val1 Var2_Val1 Var3_Val1
            %          Var1_Val1 Var2_Val1 Var3_Val2
            %          Var1_Val1 Var2_Val2 Var3_Val1
            %          Var1_Val1 Var2_Val2 Var3_Val2 }
            % CurveName = Names of curves corresponding to rows above (only includes vars that have multiple values)
            % Curves contains the dependent variable permutations that need
            % to be plotted (each row is one curve, each column is a
            % descriptor)
            Curves={};
            CurveName={};
            VarPosit=[];
            for I=1:length(VarBxH)
                NamePosit=get(VarBxH(I),'user');
                VarName=NamePosit{2};
                VarPosit(end+1)=NamePosit{1};
                VarVals=get(VarBxH(I),'value');
                Curves(:,end+1)=VarVals(1);
                NumCurves=length(Curves(:,1));                
                if length(VarVals)>1
                    CurveName(:,end+1)={[VarName '=' VarVals{1}]};
                end 
                for NumVal=2:length(VarVals)
                    Curves=[Curves; Curves(1:NumCurves,:)];
                    CurveName=[CurveName; CurveName(1:NumCurves,:)];
                    Curves(end-NumCurves+1:end,end)=VarVals(NumVal);
                    CurveName(end-NumCurves+1:end,end)={[VarName '=' VarVals{NumVal}]};
                end
            end
            
            DepAxis=[];
            if isempty(Curves)
                Curves={nan};
            end
            
            if time_flag
                DepAxis = nan(length(IndepAxis_max),length(Curves(:,1)));
                IndepAxis = nan(length(IndepAxis_max),length(Curves(:,1)));
            end
            
            DepVariableName=app.DependentVariableDropDown.Value;
            minmax = DepVariableName(1:3);
            statename = DepVariableName(5:end);

            if strcmpi(statename,'Temperature')
                statename = 'Thermal';
            end
            %Assume that the state units for 1st case are the same as for all
            stateunits = lResults(1).getStateUnit(statename);
            for I=1:length(lResults)
                Descriptor=lResults(I).Model.Descriptor;
                for Ci=1:length(Curves(:,1))
                    % if time is independent variable, reshape along
                    % GlobalTime rather than IndepVar
                    if time_flag
                        % set string for ylabel
                        YLabel = [DepVariableName ' (' stateunits ')'];
                        % D contains descriptor of each case
                        D = [Descriptor([VarPosit ],2)];
                        % Curves holds the predetermined curves of interest
                        C = [Curves(Ci,:)]';
                        % if D and C match = case of interest
                        if all(strcmp(D,C))
                            IndepAxis([1:length(lResults(I).Model.GlobalTime)],Ci) = lResults(I).Model.GlobalTime;
                            reshaped_state_use = app.get_minmaxstate (lResults,I,statename,minmax,time_flag);
                            DepAxis([1:length(lResults(I).Model.GlobalTime)],Ci)= reshaped_state_use;
                        end
                    % if time isn't independent variable
                    else
                        YLabel = [DepVariableName ' (all time) (' stateunits ')'];
                        for Ii=1:length(IndepAxisC)
                            if isnan(Curves{Ci})
                                D=[Descriptor([IndepVar{1}],2)];
                                C=[IndepAxisC(Ii)]';
                            else
                                D=[Descriptor([VarPosit IndepVar{1}],2)];
                                C=[Curves(Ci,:) IndepAxisC(Ii)]';
                            end
                            % if C and D match, then it is a case of interest
                            if all(strcmp(D,C))
                                %Extract max/min state for all time
                                reshaped_state_use = app.get_minmaxstate (lResults,I,statename,minmax,time_flag);
                                DepAxis(Ii,Ci) = reshaped_state_use;
                            end
                            
                        end
                    end
                end
            end

           % get user-selected features (returned as indices)
           selected_features = get(app.FeatureListBox,'Value');
           % get cell array of all feature names as strings
           all_feature_names = get(app.FeatureListBox,'Items');
           
           % create feature string list for title
           % only include first three selected features
           if length(selected_features) <=3
               number_features = length(selected_features);
           else
               number_features = 3;
           end
           % if no features selected, dependent variable calculated over
           % all features
           if app.MaxoverFeaturesCheckBox.Value == false
               feature_string = '(All Features)';
           else
               feature_string = '(';
               for feature = 1:number_features-1
                   featureindex = selected_features(feature);
                   featurename = all_feature_names{featureindex};
                   feature_string = append(feature_string,featurename,', ');
               end
               
               lastfeatureindex = selected_features(number_features);
               lastfeature = all_feature_names{lastfeatureindex};
               
               % if more than three features, use ellipse (...) to indicate
               % more features
               if length(selected_features) > 3
                   feature_string = append(feature_string,lastfeature,',...)');
               else
                   feature_string = append(feature_string,lastfeature,')');
               end
           end

            
            app.PlotWindows=[app.PlotWindows figure];
            set(app.PlotWindows(end),'name','ARL ParaPower Post')
            clf
            PlotAxis=axes;
            plot(IndepAxis,DepAxis,'marker','o')
            ylabel(PlotAxis,YLabel,'Interpreter','none');
            xlabel(PlotAxis,XLabel);
            title_dependent = app.DependentVariableDropDown.Value;
            full_title_string = append(title_dependent,' ',feature_string);
            title(full_title_string,'Interpreter','none')
            if ~isempty(CurveName)
                LegText=CurveName(:,1);
                for Ci=1:length(CurveName(:,1))
                    for Ei=2:length(CurveName(1,:))
                        LegText{Ci}=[LegText{Ci} ', ' CurveName{Ci, Ei}];
                    end
                end
                Lg=legend(PlotAxis,LegText);
                set(Lg,'interpreter','none')
            end
        end

        % Close request function: PPPP
        function PPPPCloseRequest(app, event)
            delete(app.PlotWindows)
            delete(app)
            
        end

        % Button pushed function: ClosePlotWindowsButton
        function ClosePlotWindowsButtonPushed(app, event)
           delete(app.PlotWindows)
        end

        % Value changed function: MaxoverFeaturesCheckBox
        function MaxoverFeaturesCheckBoxValueChanged(app, event)
            value = app.MaxoverFeaturesCheckBox.Value;
            if value == 1
                app.FeatureListBox.Enable = true;
            else
                app.FeatureListBox.Enable = false;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create PPPP and hide until all components are created
            app.PPPP = uifigure('Visible', 'off');
            app.PPPP.Position = [100 100 640 480];
            app.PPPP.Name = 'ParaPower Parametric Post Processor';
            app.PPPP.Resize = 'off';
            app.PPPP.CloseRequestFcn = createCallbackFcn(app, @PPPPCloseRequest, true);

            % Create LoadCurrentResultsButton
            app.LoadCurrentResultsButton = uibutton(app.PPPP, 'push');
            app.LoadCurrentResultsButton.ButtonPushedFcn = createCallbackFcn(app, @LoadCurrentResultsButtonPushed, true);
            app.LoadCurrentResultsButton.Position = [129 73 129 22];
            app.LoadCurrentResultsButton.Text = {'Load Current Results'; ''};

            % Create PlotButton
            app.PlotButton = uibutton(app.PPPP, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [382 73 83 22];
            app.PlotButton.Text = {'Plot'; ''};

            % Create DependentVariableDropDownLabel
            app.DependentVariableDropDownLabel = uilabel(app.PPPP);
            app.DependentVariableDropDownLabel.HorizontalAlignment = 'right';
            app.DependentVariableDropDownLabel.Position = [311 459 111 22];
            app.DependentVariableDropDownLabel.Text = 'Dependent Variable';

            % Create DependentVariableDropDown
            app.DependentVariableDropDown = uidropdown(app.PPPP);
            app.DependentVariableDropDown.Items = {'Max Temp'};
            app.DependentVariableDropDown.Position = [437 459 100 22];
            app.DependentVariableDropDown.Value = 'Max Temp';

            % Create IndependentVariableDropDownLabel
            app.IndependentVariableDropDownLabel = uilabel(app.PPPP);
            app.IndependentVariableDropDownLabel.HorizontalAlignment = 'right';
            app.IndependentVariableDropDownLabel.Position = [41 459 119 22];
            app.IndependentVariableDropDownLabel.Text = 'Independent Variable';

            % Create IndependentVariableDropDown
            app.IndependentVariableDropDown = uidropdown(app.PPPP);
            app.IndependentVariableDropDown.Items = {'No Data'};
            app.IndependentVariableDropDown.ValueChangedFcn = createCallbackFcn(app, @IndependentVariableDropDownValueChanged, true);
            app.IndependentVariableDropDown.Position = [175 459 100 22];
            app.IndependentVariableDropDown.Value = 'No Data';

            % Create ListBoxLabel
            app.ListBoxLabel = uilabel(app.PPPP);
            app.ListBoxLabel.HorizontalAlignment = 'right';
            app.ListBoxLabel.Position = [16 405 48 22];
            app.ListBoxLabel.Text = 'List Box';

            % Create ListBoxTemplate
            app.ListBoxTemplate = uilistbox(app.PPPP);
            app.ListBoxTemplate.Items = {'No Data Yet'};
            app.ListBoxTemplate.Multiselect = 'on';
            app.ListBoxTemplate.Position = [16 332 100 74];
            app.ListBoxTemplate.Value = {'No Data Yet'};

            % Create FileLoadButton
            app.FileLoadButton = uibutton(app.PPPP, 'push');
            app.FileLoadButton.ButtonPushedFcn = createCallbackFcn(app, @FileLoadButtonPushed, true);
            app.FileLoadButton.Position = [278 73 85 22];
            app.FileLoadButton.Text = 'File Load';

            % Create StatusBox
            app.StatusBox = uilistbox(app.PPPP);
            app.StatusBox.Position = [125 7 484 56];

            % Create LogoSpace
            app.LogoSpace = uiaxes(app.PPPP);
            title(app.LogoSpace, 'Title')
            xlabel(app.LogoSpace, 'X')
            ylabel(app.LogoSpace, 'Y')
            app.LogoSpace.Position = [1 1 105 73];

            % Create ClosePlotWindowsButton
            app.ClosePlotWindowsButton = uibutton(app.PPPP, 'push');
            app.ClosePlotWindowsButton.ButtonPushedFcn = createCallbackFcn(app, @ClosePlotWindowsButtonPushed, true);
            app.ClosePlotWindowsButton.Position = [487 73 122 22];
            app.ClosePlotWindowsButton.Text = 'Close Plot Windows';

            % Create FeatureListBox
            app.FeatureListBox = uilistbox(app.PPPP);
            app.FeatureListBox.Multiselect = 'on';
            app.FeatureListBox.Position = [487 332 114 74];
            app.FeatureListBox.Value = {'Item 1'};

            % Create MaxoverFeaturesCheckBox
            app.MaxoverFeaturesCheckBox = uicheckbox(app.PPPP);
            app.MaxoverFeaturesCheckBox.ValueChangedFcn = createCallbackFcn(app, @MaxoverFeaturesCheckBoxValueChanged, true);
            app.MaxoverFeaturesCheckBox.Text = 'Max over Features';
            app.MaxoverFeaturesCheckBox.Position = [487 405 122 22];

            % Show the figure after all components are created
            app.PPPP.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = PostProcessResults_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.PPPP)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.PPPP)
        end
    end
end