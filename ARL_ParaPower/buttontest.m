function buttontest

  DoButtons('init',{'Al' 'Cu' 'AlN'},[.01 .1 .2 .1],'normal',{'red' 'cyan' 'yellow'})
end

function DoButtons(Action,varargin)
%'Init', ButtonNames{'button1', 'button2'}, Position (X, Y, Width, Height), Color{'red' 'blue' 'green'} Units

    switch upper(Action)
        case 'INIT'
            ButtonNames=varargin{1};
            Position=varargin{2};
            if length(varargin) >2
                Units=varargin{3};
            else
                Units='normal';
            end
            if length(varargin) > 3
                Color=varargin{4};
            else
                Color=[];
            end
        otherwise
    end
    
    if strcmpi(Action,'init')
        PanelH=uipanel('parent',gcf,'posit',Position,'bordertype','none');
        TotalWidth=0;
        for I=1:length(ButtonNames)
            ButtonNames{I}=[' ' ButtonNames{I} ' '];
            BH=uicontrol('parent',gcf,'style','togglebutton','min',0,'max',1,'string',ButtonNames{I},'fontweight','bold','units','normal');
            E=get(BH,'extent');
            delete(BH);
            TotalWidth=TotalWidth+E(3);
            Values(I)=1;
        end
        set(PanelH,'user',Values);
        Gap=(Position(3)-TotalWidth)/(length(ButtonNames)-1);
        CurX=Position(1);
        for I=1:length(ButtonNames)
            W=Position(3)-Gap*(length(ButtonNames)-1)/length(ButtonNames);
            H=Position(4);
            Y=Position(2);
            Toggle=@TogglePanel;
            BH(I)=uicontrol('parent',PanelH,'style','togglebutton','min',0,'max',1,'string',ButtonNames{I},...
                            'units',Units, 'position',[CurX Y W H],'value',1,'fontweight','bold', ...
                            'callback',Toggle);
            if ~isempty(Color)
                set(BH(I),'backgroundcolor',Color{I})
                C=get(BH(I),'backgroundcolor');
                set(BH(I),'foregroundcolor',[1 1 1]-C,'user',{I C})
            end
            E=get(BH(I),'extent');
            set(BH(I),'position',[CurX Y E(3) E(4)]);
            CurX=CurX+E(3)+Gap;
        end
    end
end

function TogglePanel(ButtonH,Action)

    PanelH=get(ButtonH,'parent');
    IndexColor=get(ButtonH,'user');
    Index=IndexColor{1};
    OrigColor=IndexColor{2};
    
    VisText{1}='off';
    VisText{2}='on';
    
    Parms=get(gca,'user');
    
    Values=get(PanelH,'user');
    %Values(Index)=xor(1,Values(Index));
    if get(ButtonH,'value')
        Values(Index)=1;
        set(ButtonH,'backgroundcolor',OrigColor,'foregroundcolor',[1 1 1]-OrigColor)
        set(Parms.MatPatchList{Index},'visible','on');
    else
        Values(Index)=0;
        set(ButtonH,'backgroundColor',[.9 .9 .9],'foregroundcolor',[0 0 0]);
        set(Parms.MatPatchList{Index},'visible','off');
    end
    set(PanelH,'user',Values)
end
    