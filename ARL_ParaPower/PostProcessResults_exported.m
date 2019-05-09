classdef PostProcessResults_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        LoadCurrentResultsButton        matlab.ui.control.Button
        PlotButton                      matlab.ui.control.Button
        DependentVariableDropDownLabel  matlab.ui.control.Label
        DependentVariableDropDown       matlab.ui.control.DropDown
        IndependentVariableDropDownLabel  matlab.ui.control.Label
        IndependentVariableDropDown     matlab.ui.control.DropDown
        ListBoxLabel                    matlab.ui.control.Label
        ListBox                         matlab.ui.control.ListBox
        FileLoadButton                  matlab.ui.control.Button
    end

    
    properties (Access = private)
        Results % Description
        ParaPower % Description
    end
    
    methods (Access = private)
        
        function results = getvarbox(app, VarName)
            LBh=findobj(app.UIFigure, 'tag', 'VarLB');
            LB=[];
            for I=1:length(LBh)
                U=LBh(I).UserData;
                if strcmpi(U{2},VarName)
                    LB=LBh(I);
                    LBi=U{1};
                end
            end
            if ~isempty(LB)
                LBL=findobj(app.UIFigure,'tag','VarLBL','userdata',LBi);
            end
            results=[LB LBL];
        end
        
        function results = PopulateResults(app)
            lResults=app.Results;
             figure(app.UIFigure)
             NumVars=length(app.Results(1).Model.Descriptor(:,1));
             for Vi=1:NumVars
                VarName{Vi}=lResults(1).Model.Descriptor{Vi,1};
                VarVals{Vi}={};
                for Ri=1:length(lResults)
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
             P=app.ListBox.Position;
             Pl=app.ListBoxLabel.Position;
             app.ListBox.Visible=false;
             app.ListBoxLabel.Visible=false;
             Wdth=P(3)*1.05;
             Hgt=P(4)*1.05;
             Xpos=Pl(1);
             Ypos=Pl(2);
             NumInRow=4;
             delete(findobj(app.UIFigure,'tag','VarLB'));
             delete(findobj(app.UIFigure,'tag','VarLBL'));
             for I=1:NumVars
                 TagNum=num2str(I);
                 UI=uilistbox(app.UIFigure,'items',VarVals{I},'tag',['VarLB'],'user',{I VarName{I}},'position',[Xpos Ypos-(Pl(2)-P(2)) P(3) P(4)],'MultiSelect',true);
                 UIt=uieditfield(app.UIFigure,'value',VarName{I},'tag',['VarLBL'],'user',I,'position',[Xpos Ypos P(3) Pl(4)],'enable',true);
                 RestoreUIt=@(A,B)set(UIt,'value',VarName{I});
                 UIt.ValueChangedFcn=RestoreUIt;
                 %set(UIt,'ValueChangedFcn',UItRestore);
                 Xpos=Xpos+Wdth;
                 if mod(I,NumInRow)==0
                    Ypos=Ypos-Hgt-Pl(4) ;
                    Xpos=Pl(1);
                 end
             end
             app.IndependentVariableDropDown.Items=VarName;
             app.DependentVariableDropDown.Items={'Max Temperature'};
            
        end
    end
    

    methods (Access = private)

        % Button pushed function: LoadCurrentResultsButton
        function LoadCurrentResultsButtonPushed(app, event)
             app.ParaPower=ParaPowerGUI_V2;
             figure(app.UIFigure)
             if isappdata(app.ParaPower,'Results')
                 app.Results=getappdata(app.ParaPower,'Results');
                 lResults=app.Results;
             else
                 disp('No Results available.')
                 msgbox('No results available')
                 return
             end
            app.PopulateResults;
        end

        % Value changed function: IndependentVariableDropDown
        function IndependentVariableDropDownValueChanged(app, event)
            value = app.IndependentVariableDropDown.Value;
            %Gray out the box that's selected here.
            %Value is the text of the independent variable.  shoudl be able to have it match other.
            VarBlock=app.getvarbox(value)
        end

        % Button pushed function: FileLoadButton
        function FileLoadButtonPushed(app, event)
            load('deleteme_postprocessing.ppmodel','-mat');  
            if exist('Results','var')
                app.Results=Results;
            else
                disp('No Results in file')
                return
            end
            app.PopulateResults;
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create LoadCurrentResultsButton
            app.LoadCurrentResultsButton = uibutton(app.UIFigure, 'push');
            app.LoadCurrentResultsButton.ButtonPushedFcn = createCallbackFcn(app, @LoadCurrentResultsButtonPushed, true);
            app.LoadCurrentResultsButton.Position = [154.5 35 129 22];
            app.LoadCurrentResultsButton.Text = {'Load Current Results'; ''};

            % Create PlotButton
            app.PlotButton = uibutton(app.UIFigure, 'push');
            app.PlotButton.Position = [408 35 100 22];
            app.PlotButton.Text = {'Plot'; ''};

            % Create DependentVariableDropDownLabel
            app.DependentVariableDropDownLabel = uilabel(app.UIFigure);
            app.DependentVariableDropDownLabel.HorizontalAlignment = 'right';
            app.DependentVariableDropDownLabel.Position = [311 459 111 22];
            app.DependentVariableDropDownLabel.Text = 'Dependent Variable';

            % Create DependentVariableDropDown
            app.DependentVariableDropDown = uidropdown(app.UIFigure);
            app.DependentVariableDropDown.Items = {'Max Temp'};
            app.DependentVariableDropDown.Position = [437 459 100 22];
            app.DependentVariableDropDown.Value = 'Max Temp';

            % Create IndependentVariableDropDownLabel
            app.IndependentVariableDropDownLabel = uilabel(app.UIFigure);
            app.IndependentVariableDropDownLabel.HorizontalAlignment = 'right';
            app.IndependentVariableDropDownLabel.Position = [41 459 119 22];
            app.IndependentVariableDropDownLabel.Text = 'Independent Variable';

            % Create IndependentVariableDropDown
            app.IndependentVariableDropDown = uidropdown(app.UIFigure);
            app.IndependentVariableDropDown.ValueChangedFcn = createCallbackFcn(app, @IndependentVariableDropDownValueChanged, true);
            app.IndependentVariableDropDown.Position = [175 459 100 22];

            % Create ListBoxLabel
            app.ListBoxLabel = uilabel(app.UIFigure);
            app.ListBoxLabel.HorizontalAlignment = 'right';
            app.ListBoxLabel.Position = [16 405 48 22];
            app.ListBoxLabel.Text = 'List Box';

            % Create ListBox
            app.ListBox = uilistbox(app.UIFigure);
            app.ListBox.Multiselect = 'on';
            app.ListBox.Position = [16 332 100 74];
            app.ListBox.Value = {'Item 1'};

            % Create FileLoadButton
            app.FileLoadButton = uibutton(app.UIFigure, 'push');
            app.FileLoadButton.ButtonPushedFcn = createCallbackFcn(app, @FileLoadButtonPushed, true);
            app.FileLoadButton.Position = [294 35 100 22];
            app.FileLoadButton.Text = 'File Load';
        end
    end

    methods (Access = public)

        % Construct app
        function app = PostProcessResults_exported

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end