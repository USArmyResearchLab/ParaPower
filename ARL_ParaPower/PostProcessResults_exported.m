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
    end

    
    properties (Access = private)
        Results % Description
        ParaPower % Description
        PlotWindows = []% Description
    end
    
    properties (Constant)
        %AvailStates={'Max Temperature' 'Min Melt Frac'};
        AvailStates={'Max Temperature' }; %Removed until it can be limited to PCM only
        ParaPowerName='ParaPowerGUI_V2';
    end
    
    methods (Access = private)
        
        function results = getvarbox(app, VarName)
            LBh=findobj(app.PPPP, 'tag', 'VarLB');
            LB=[];
            for I=1:length(LBh)
                U=LBh(I).UserData;
                if strcmpi(U{2},VarName)
                    LB=LBh(I);
                    LBi=U{1};
                end
            end
            if ~isempty(LB)
                LBL=findobj(app.PPPP,'tag','VarLBL','userdata',LBi);
            end
            results=[LB LBL];
        end
        
        function results = PopulateResults(app)
             lResults=app.Results;
             figure(app.PPPP)
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
             app.IndependentVariableDropDown.Items=VarName;
             app.DependentVariableDropDown.Items=app.AvailStates;
             IndependentVariableDropDownValueChanged(app)
             app.IndependentVariableDropDown.Enable=true;
             app.DependentVariableDropDown.Enable=true;

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
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.ListBoxTemplate.Visible=false;
            app.ListBoxLabel.Visible=false;
            app.IndependentVariableDropDown.Enable=false;
            app.DependentVariableDropDown.Enable=false;
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
                 lResults=app.Results;
             else
                 app.AddStatusLine('No Results available.')
                 return
             end
            app.PopulateResults;
        end

        % Value changed function: IndependentVariableDropDown
        function IndependentVariableDropDownValueChanged(app, event)
            value = app.IndependentVariableDropDown.Value;
            %Gray out the box that's selected here.
            %Value is the text of the independent variable.  shoudl be able to have it match other.
            VarBlock=app.getvarbox(value);
            set(findobj(app.PPPP,'tag','VarLB'),'enable',true);
            set(findobj(app.PPPP,'tag','VarLBL'),'enable',true);
            set(VarBlock,'enable',false)
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
            lResults=app.Results;
            LabelH=findobj(app.PPPP,'tag','VarLBL');
            VarBxH=findobj(app.PPPP,'tag','VarLB');
            IndepVar=get(findobj(VarBxH,'enable',false),'userdata');
            IndepAxisC=get(findobj(VarBxH,'enable',false),'Items');
            XLabel=IndepVar{2};
            VarBxH=findobj(VarBxH,'enable',true);
            for I=1:length(IndepAxisC)
                IndepAxis{I}=str2double(IndepAxisC{I});
            end
            IndepAxis=cell2mat(IndepAxis);
            NumCurves=1;
            %Curves = {Var1_Val1 Var2_Val1 Var2_Val1
            %          Var1_Val1 Var2_Val1 Var2_Val2
            %          Var1_Val1 Var2_Val2 Var2_Val1
            %          Var1_Val1 Var2_Val2 Var2_Val2 }
            %CurveName = Names of curves corresponding to rows above (only includes vars that have multiple values)
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
            DepVariableName=lower(app.DependentVariableDropDown.Value);
            for I=1:length(lResults)
                Descriptor=lResults(I).Model.Descriptor;
                for Ci=1:length(Curves(:,1))
                    for Ii=1:length(IndepAxisC)
                        if isnan(Curves{Ci})
                            D=[Descriptor([IndepVar{1}],2)];
                            C=[IndepAxisC(Ii)]';
                        else
                            D=[Descriptor([VarPosit IndepVar{1}],2)];
                            C=[Curves(Ci,:) IndepAxisC(Ii)]';
                        end
                        %[C'; D']
                        if all(strcmp(D,C))
                            %Extract max temp over all features for all time
                            switch DepVariableName
                                case lower(app.AvailStates{1}) %Max Temp
                                    YLabel='Max Temp (all features, all time)';
                                    FullState=lResults(I).getState('Thermal');
                                    DepAxis(Ii,Ci)=max(FullState(:));
                                case lower(app.AvailStates{2}) % Max Melt Frac
                                    YLabel='Min Melt Frac (all features, all time)';
                                    FullState=lResults(I).getState('MeltFrac');
                                    DepAxis(Ii,Ci)=min(FullState(:));
                                otherwise
                                    YLabel='Unknown Dependent Variable';
                                    DepAxis(Ii,Ci)=NaN;
                            end
                                    
                        end
                    end
                end
            end
            app.PlotWindows=[app.PlotWindows figure];
            set(app.PlotWindows(end),'name','ARL ParaPower Post')
            clf
            PlotAxis=axes;
            plot(PlotAxis,IndepAxis,DepAxis,'marker','o')
            ylabel(PlotAxis,YLabel);
            xlabel(PlotAxis,XLabel);
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
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create PPPP
            app.PPPP = uifigure;
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
        end
    end

    methods (Access = public)

        % Construct app
        function app = PostProcessResults_exported

            % Create and configure components
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