function Visualize (PlotTitle, MI, varargin)
%Visualize creates a graphic visualization of the model and takes two forms
%(one for results and one for initial conditions)
%
%visualize (PlotTitle, MI, 'propery_1','value_1', 'propery_n','value_n')
%
%   MI is the model information structure provided by FormModel
%
%   2D - X+, X-, Y+, Y-, Z+, Z- - plot only those faces. Can be called
%      multiplie time to include multiple faces.
%   ScaleTitle  - title of the colorbar, value is a char array
%   State - a matrix the same dimenstions as modelmat with the state to plot, value is 3 dim array
%   PlotParms.RemoveMaterial=[] - Which materials to remove from the plot, value is array of mat numbers
%   EdgeOnlyMaterial=[] - Show only the edges of this material, value is array of mat numbers
%   Transparency=0.5 - FaceAlpha value, 0-clear, 1-opaque, value is a scalar between 0 & 1
%   ShowQ - Display Q on each face, no value, this is a flag
%   EdgeColor=[0 0 0] - Color of the edges ('none' or [R,G,B] value), value is color as 3x1 RGB array
%   ModelGeometry - plot model geometry, no value, this is a flag to just plot model geometry
%   TransMaterial=[] - List of materials to make transparent, value is array of mat numbers that should be transparent
%   MinCoord=[0 0 0] - Set of model origin (minimum of X, Y & Z), value is a 3 element vecotr that identifies minimum (X,Y,Z) of model
%   NoAxis - Do not plot the axes (they help maintain aspect ration in the plot), no value, this is a flag to remove the axes
%
%To Do Features:
%  X cross section
%  Y cross Section
%  Z cross section
%  Vectorize


    ThisAxis=gca;
    AxisParent=get(ThisAxis,'parent');
    Kids=get(AxisParent,'children');
    for i=1:length(Kids)
        if strcmpi(get(Kids(i),'userdata'),'REMOVE');
            delete(Kids(i))
        end
    end
    cla;drawnow
    DrawStatus=text(.5,.5,'Drawing...','fontsize',40,'userdata','REMOVE','horizontal','center','vertical','middle','unit','normal'); drawnow

    DeltaCoord=  {MI.X MI.Y MI.Z};
    ModelMatrix=MI.Model;
	
	SzModel=size(ModelMatrix);
	if (length(MI.X) ~= SzModel(1)) || (length(MI.Y) ~=SzModel(2)) || (length(MI.Z) ~= SzModel(3))
		fprintf(' %10s %9s %9s %9s \n %10s %9i %9i %9i \n %10s %9i %9i %9i\n', ...
		           '','Rows(X)','Columns(Y)','Layers(Z)', ...
				   'Model',SzModel(1),SzModel(2),SzModel(3), ...
				   'Vectors',length(MI.X),length(MI.Y),length(MI.Z))
		error('There is a size mismatch between the Model and the X, Y or Z vectors');
	end


    PlotGeom=true; %If no other parameters are called, then plot the model geom
    h=MI.h;
    Ta=MI.Ta;
    matlist=MI.matlist;

    PlotParms.RemoveMatl=[0];
    PlotParms.TransMatl=[];
    PlotParms.Transparency=0.5;
    PlotParms.EdgeColor=[];
    PlotParms.EdgeOnlyMat=[];
    PlotParms.PlotAxes=true;
    PlotParms.TwoD={};
    MinCoord=[0 0 0];
    ColorTitle='';
    PlotState=ModelMatrix;
    Q=[];

    strleft=@(S,n) S(1:min(n,length(S)));

    QList=containers.Map;
    
    if (not(isempty(varargin))) && iscell(varargin{1})
        PropValPairs=varargin{1};
    else
        PropValPairs=varargin;
    end
    while ~isempty(PropValPairs) 
        [Prop, PropValPairs]=Pop(PropValPairs);
        if ~ischar(Prop)
            error('Property name must be a string.');
        end
        Pl=length(Prop);
        %disp(Prop)
        switch lower(Prop)
            case strleft('scaletitle',Pl)
                [Value, PropValPairs]=Pop(PropValPairs); 
                ColorTitle=Value;
            case strleft('2d',Pl)
                [Value, PropValPairs]=Pop(PropValPairs); 
                PlotParms.TwoD=[PlotParms.TwoD upper(Value)];
            case strleft('state',Pl)
                [Value, PropValPairs]=Pop(PropValPairs); 
                PlotGeom=false;
                PlotState=Value;
            case strleft('removematerial',Pl)
                [Value, PropValPairs]=Pop(PropValPairs); 
                PlotParms.RemoveMatl=[PlotParms.RemoveMatl Value];
            case strleft('edgeonlymaterial',Pl)
                [Value, PropValPairs]=Pop(PropValPairs); 
                PlotParms.EdgeOnlyMat=Value;
            case strleft('transmaterial',Pl)
                [Value, PropValPairs]=Pop(PropValPairs); 
                PlotParms.TransMatl=Value;
            case strleft('transparency',Pl)
                [Value, PropValPairs]=Pop(PropValPairs); 
                PlotParms.Transparency=Value;
            case strleft('showq',Pl)
                Q=MI.Q;
            case strleft('noaxes',Pl)
                PlotParms.PlotAxes=false;
            case strleft('edgeColor',Pl)
                [Value, PropValPairs]=Pop(PropValPairs); 
                PlotParms.EdgeColor=Value;
            case strleft('mincoord',Pl)
                [Value, PropValPairs]=Pop(PropValPairs); 
                MinCoord=Value;
            case strleft('modelgeometry',Pl)
                h=MI.h;
                Ta=MI.Ta;
                matlist=MI.matlist;
                PlotGeom=true;
            otherwise
                fprintf('Property "%s" is unknown.\n',Prop)
        end

    end
    
    Direx=FormModel('GetDirex');
    
    if ~all(size(PlotState)==size(ModelMatrix))
        error('The dimensions of the plotstate provided do not match the dimensions of the model.')
    end
        

    %Visualization of defined model

    X=[MinCoord(1) MinCoord(1) + cumsum(DeltaCoord{1})];
    Y=[MinCoord(2) MinCoord(2) + cumsum(DeltaCoord{2})];
    Z=[MinCoord(3) MinCoord(3) + cumsum(DeltaCoord{3})];

    if PlotGeom
        ColorList=unique(PlotState(:));  
        ColorList=ColorList(ColorList~=0);
        CM=colormap(parula(length(ColorList)));
        ValMin=1;
        ValRange=length(ColorList);
    else
        CM=colormap(parula(64));
        ValMin=min(PlotState(:));
        ValRange=max(PlotState(:))-ValMin;
        if ValRange==0
            ValRange=1;
        end
    end

    hold on
    drawnow nocallbacks limitrate
    for Xi=1:length(X)-1
        for Yi=1:length(Y)-1
            for Zi=1:length(Z)-1
                if isempty(find(ModelMatrix(Xi,Yi,Zi) == PlotParms.RemoveMatl, 1))
                    Zoffset=0;
                    Xoffset=0;
                    Yoffset=0;
                    if (Z(Zi)==Z(Zi+1)) || (Y(Yi)==Y(Yi+1)) || (X(Xi)==X(Xi+1))
                        FaceAlpha=1;
                        if Z(Zi)==Z(Zi+1)
                            Zoffset=min(DeltaCoord{3}(DeltaCoord{3}>0))*.01;
                        end
                        if X(Xi)==X(Xi+1)
                            Xoffset=min(DeltaCoord{1}(DeltaCoord{1}>0))*.01;
                        end
                        if Y(Yi)==Y(Yi+1)
                            Yoffset=min(DeltaCoord{2}(DeltaCoord{2}>0))*.01;
                        end
                    else
                        FaceAlpha=PlotParms.Transparency;
                    end
                    P(1,:)=[X(Xi)   Y(Yi)   Z(Zi)  ] + [  Xoffset  Yoffset  Zoffset] ;
                    P(2,:)=[X(Xi)   Y(Yi+1) Z(Zi)  ] + [  Xoffset -Yoffset  Zoffset] ; 
                    P(3,:)=[X(Xi+1) Y(Yi+1) Z(Zi)  ] + [ -Xoffset -Yoffset  Zoffset] ;
                    P(4,:)=[X(Xi+1) Y(Yi)   Z(Zi)  ] + [ -Xoffset  Yoffset  Zoffset] ;
                    P(5,:)=[X(Xi)   Y(Yi)   Z(Zi+1)] + [  Xoffset  Yoffset -Zoffset] ;
                    P(6,:)=[X(Xi)   Y(Yi+1) Z(Zi+1)] + [  Xoffset -Yoffset -Zoffset] ;
                    P(7,:)=[X(Xi+1) Y(Yi+1) Z(Zi+1)] + [ -Xoffset -Yoffset -Zoffset] ;
                    P(8,:)=[X(Xi+1) Y(Yi)   Z(Zi+1)] + [ -Xoffset  Yoffset -Zoffset] ;
                    %fprintf('Xi=%i, Yi=%i, Zi=%i  (%g, %g, %g) (%g, %g, %g)\n',Xi, Yi,Zi, X1, Y1, Z1, X2, Y2, Z2)
                    if ~isempty(find(ModelMatrix(Xi,Yi,Zi) == PlotParms.TransMatl, 1))
                        FaceAlpha=PlotParms.Transparency;
                    end
                    if PlotGeom
                        ThisColor=find(ColorList==PlotState(Xi,Yi,Zi));
                    else
                        ThisColor=floor((PlotState(Xi,Yi,Zi)-ValMin)/ValRange*(length(CM(:,1))-1) + 1);
                        %fprintf('%i ',ThisColor)
                    end
                    if ~isnan(ThisColor)
                        if isempty(PlotParms.TwoD)
                            F   =patch('faces',[1 2 3 4 1 5 6 2 1 4 8 5 1],'vertices',P,'facecolor',CM(ThisColor,:),'FaceAlpha',FaceAlpha);
                            F(2)=patch('faces',[7 6 5 8 7 8 4 3 7 3 2 6 7],'vertices',P,'Facecolor',CM(ThisColor,:),'FaceAlpha',FaceAlpha);
                        else
                            F=[];
                            if any(strcmp(PlotParms.TwoD,'X+'))
                                F=[F patch('faces',[4 3 7 8],'vertices',P,'facecolor',CM(ThisColor,:),'FaceAlpha',FaceAlpha)];
                            end
                            if any(strcmp(PlotParms.TwoD,'X-'))
                                F=[F patch('faces',[1 2 6 5],'vertices',P,'facecolor',CM(ThisColor,:),'FaceAlpha',FaceAlpha)];
                            end
                            if any(strcmp(PlotParms.TwoD,'Y+'))
                                F=[F patch('faces',[7 3 2 6],'vertices',P,'facecolor',CM(ThisColor,:),'FaceAlpha',FaceAlpha)];
                            end
                            if any(strcmp(PlotParms.TwoD,'Y-'))
                                F=[F patch('faces',[1 4 8 5],'vertices',P,'facecolor',CM(ThisColor,:),'FaceAlpha',FaceAlpha)];
                            end
                            if any(strcmp(PlotParms.TwoD,'Z+'))
                                F=[F patch('faces',[5 6 7 8],'vertices',P,'facecolor',CM(ThisColor,:),'FaceAlpha',FaceAlpha)];
                            end
                            if any(strcmp(PlotParms.TwoD,'Z-'))
                                F=[F patch('faces',[1 2 3 4],'vertices',P,'facecolor',CM(ThisColor,:),'FaceAlpha',FaceAlpha)];
                            end
                        end
                        if ~isempty(find(ModelMatrix(Xi,Yi,Zi) == PlotParms.EdgeOnlyMat, 1))
                            set(F,'EdgeColor',get(F(1),'facecolor'));
                            set(F,'facecolor','none');
                        end
                    end
                    
                    NoHeat=true;
                    if ~isempty(Q)
                        T='';
                        ThisQ=unique(Q(Xi,Yi,Zi,:));
                        if (~isscalar(ThisQ)) || ThisQ ~=0
                            if isreal(ThisQ)
                                ThisQ=sprintf('%g',ThisQ);
                            else
                                ThisQ=char(ThisQ);
                            end
                            if isKey(QList,ThisQ)
                                QList(ThisQ)=[QList(ThisQ) F];
                            else
                                QList(ThisQ)=F;
                            end
%                             Sp=' '; %char(10) if want them on different line
%                             if isscalar(ThisQ)
%                                 T=[T Sp sprintf('Q=%g',ThisQ)]; %#ok<*AGROW>
%                             else
%                                 T=[T Sp sprintf('Q=f(t)')];
%                             end
%                             set(F,'PlotParms.EdgeColor',[1 0 0]);
%                             set(F,'linewidth',5);
%                             NoHeat=false;
                        end
                        text(mean([X(Xi) X(Xi+1)]), mean([Y(Yi) Y(Yi+1)]), mean([Z(Zi) Z(Zi+1)]),T,'horiz','center')
                    end
                    if ~isempty(PlotParms.EdgeColor) && NoHeat
                        set(F,'EdgeColor',PlotParms.EdgeColor);
    %                        set(F,'facealpha',PlotParms.Transparency);
                    end
                end
            end
        end
    end
    Xrange=max(X)-min(X);
    Yrange=max(Y)-min(Y);
    Zrange=max(Z)-min(Z);
    Xmid=mean([max(X) min(X)]);
    Ymid=mean([max(Y) min(Y)]);
    Zmid=mean([max(Z) min(Z)]);
    axis equal
   % set(ThisAxis,'visi','off')
    rotate3d(ThisAxis,'on')

    if PlotGeom
        Hoffset=0.5;
        LftT=sprintf('h=%g, T_a=%g',h(Direx.Left),Ta(Direx.Left));
        RgtT=sprintf('h=%g, T_a=%g',h(Direx.Right),Ta(Direx.Right));
        BckT=sprintf('h=%g, T_a=%g',h(Direx.Back),Ta(Direx.Back));
        FrtT=sprintf('h=%g, T_a=%g',h(Direx.Front),Ta(Direx.Front));
        TopT=sprintf('h=%g, T_a=%g',h(Direx.Top),Ta(Direx.Top));
        BtmT=sprintf('h=%g, T_a=%g',h(Direx.Bottom),Ta(Direx.Bottom));
    else
        Hoffset=0.1;
        LftT='';
        RgtT='';
        BckT='';
        FrtT='';
        TopT='';
        BtmT='';
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        set(gca,'ztick',[]);
        set(gca,'color','none');
        set(gca,'xcolor','none');
        set(gca,'ycolor','none');
        set(gca,'zcolor','none');
    end
    T=[];
    T=[T text(min(X)-Hoffset*Xrange,Ymid,Zmid,sprintf('Lft %s',LftT)) ];
    T=[T text(max(X)+Hoffset*Xrange,Ymid,Zmid,sprintf('Rgt %s', RgtT)) ];
    T=[T text(Xmid, min(Y)-Hoffset*Yrange,Zmid,sprintf('Bck %s', BckT)) ];
    T=[T text(Xmid, max(Y)+Hoffset*Yrange,Zmid,sprintf('Frt %s', FrtT)) ];
    T=[T text(Xmid, Ymid, max(Z)+Hoffset*Zrange,sprintf('Top %s', TopT)) ];
    T=[T text(Xmid, Ymid, min(Z)-Hoffset*Zrange,sprintf('Btm %s', BtmT)) ];
    set(T,'edge',[0 0 0]);

    title(PlotTitle)
    set(gca,'visi','on')
    %Display axes in green.
    if PlotParms.PlotAxes
        Xmax=max(max([X Y Z]))*1.1;
        Ymax=Xmax;
        Zmax=Xmax; %max(Z)*1.1;
        L(1)=line([0 Xmax],[0 0],[0 0]);
        L(2)=line([0 0],[0 Ymax],[0 0]);
        L(3)=line([0 0],[0 0],[0 Zmax]);
        set(L,'color',[0 1 0], 'linewidth',2)
        text(Xmax,0,0,'X');
        text(0,Ymax,0,'Y');
        text(0,0,Zmax,'Z');
    end

    hold off
 
    pbaspect([1 1 1])
    
    if isempty(PlotParms.TwoD)
        view(45*3, 45*0.5)
    else
        if any(PlotParms.TwoD{1}=='Z')
            view(2)
        elseif any(PlotParms.TwoD{1}=='X')
            view(90,0)
        elseif any(PlotParms.TwoD{1}=='Y')
            view(0,0)
        end
    end
    set(ThisAxis,'unit','normal')
    CB=colorbar;    
    set(CB,'userdata','REMOVE')
    if ~PlotGeom
        ylabel(CB,ColorTitle);
        Scale=linspace(0,1,11);
        set(CB,'ticks',Scale);
        set(CB,'ticklabels',linspace(ValMin,ValMin+ValRange,length(Scale)));
    else
        NumColors=length(ColorList);
        if NumColors>1
            Offset=zeros(1,NumColors);
            Offset(1)=0.25;
            Offset(end)=-0.25;
            TickLocns=((0:NumColors-1)+Offset)/(NumColors-1);
        else
            TickLocns=0.5;
        end
        set(CB,'ticks',TickLocns);
        for Mi=1:length(matlist)
            matlist{Mi}=sprintf('%s (%i)',matlist{Mi},Mi);
        end
        set(CB,'ticklabels',matlist(ColorList));
    end
%    Pos=get(CB,'position');
    %set(CB,'position',[1-Pos(3) Pos(2) Pos(3)*.5 Pos(4)]);
    if PlotGeom
        set(CB,'location','north');
        set(CB,'yaxislocation','bottom')
        set(CB,'position',[.05 .95 .90 .05]);
    end

    if ~isempty(Q)
        %CurA=gca;
        P=get(ThisAxis,'posit');
        PBorder=1-(P(3)+P(1));
%        set(ThisAxis,'posit',[PBorder P(2) 1-2*PBorder P(4)]);
        KeyList=keys(QList);
        QColor(:,1)=(length(KeyList):-1:0)/(length(KeyList));
        QColor(:,2)=0;
        QColor(:,3)=0;
        QCB=axes(get(gca,'parent'));
        set(QCB,'userdata','REMOVE');
        set(QCB,'posit',[0 .09 .05 .8]);
        for Ki=1:length(KeyList)
            set(QList(KeyList{Ki}),'EdgeColor',QColor(Ki,:),'linewidth',3);
            rectangle('position',[0,(Ki-1)/length(KeyList),1,1/length(KeyList)],'facecolor',QColor(Ki,:),'userdata','REMOVE');
            BarText=sprintf('%4.2g',str2num(KeyList{Ki}));
            TT=text(1,(Ki-1)/length(KeyList)+.5/length(KeyList),BarText,'horizontalalig','right','rotation',90,'verticalalign','top','userdata','REMOVE');
        end
        set(QCB,'vis','off')
        text(0,0,'Q (w)','vertical','top')
        
        %axes(CurA); %Takes lots of time
    end
    delete(DrawStatus)
    set(ThisAxis,'userdata',PlotParms)
    drawnow
end

function [Val, PV]=Pop(PV) 
    Val=PV{1};
    PV=PV(2:end);
end
    