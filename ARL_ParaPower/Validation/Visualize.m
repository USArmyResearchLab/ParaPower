function visualize (PlotTitle, MinCoord, DeltaCoord, ModelMatrix, varargin)
%Visualize creates a graphic visualization of the model and takes two forms
%(one for results and one for initial conditions)
%
%visualize (PlotTitle, MinCoords, DeltaX, DeltaY, DeltaZ, ModelMatrix, h, Ta, matlist, Q)
%visualize (PlotTitle, MinCoords, MinZ, DeltaX, DeltaY, DeltaZ, ModelMatrix, State, ColorTitle)
%
%   MinCoords - [MinX MinY MinZ]; origin point of the model
%   DeltaCoord - { DeltaX(1,l) DeltaY(1xm) DeltaZ(1xn) }: cell array of the distances between model nodes
%   ModelMatrix - [l, m, n]: Array that identifies material index number at each node
%   h - [6x1]: heat transfer from outside model to inside
%   Ta - [6x1]: Ambiant temps surrounding the model
%   matlist - {1xj}: Cell array of materials names associated with each number
%   Q - [l, m, n]: Matrix of Heat input to each node of model
%   State - [l, m, n]: Matrix of scalars with result to color plot with

if length(varargin)==2
    PlotGeom=false;
    PlotState=varargin{1};
    ColorTitle=varargin{2};
else
    PlotGeom=true;
    PlotState=ModelMatrix;
    h=          varargin{1};
    Ta=         varargin{2};
    matlist=    varargin{3};
    Q=          varargin{4};
end

Direx=FormModel('GetDirex');

%Visualization of defined model

    X=[MinCoord(1) MinCoord(1) + cumsum(DeltaCoord{1})];
    Y=[MinCoord(2) MinCoord(2) + cumsum(DeltaCoord{2})];
    Z=[MinCoord(3) MinCoord(3) + cumsum(DeltaCoord{3})];
    
    ColorList=[unique(PlotState(:))];    
    clf
    hold on
    for Xi=1:length(X)-1
        for Yi=1:length(Y)-1
            for Zi=1:length(Z)-1
                if (ModelMatrix(Yi,Xi,Zi) ~=0)
                    X1=X(Xi);
                    X2=X(Xi+1);
                    Y1=Y(Yi);
                    Y2=Y(Yi+1);
                    Z1=Z(Zi);
                    Z2=Z(Zi+1);
                    %fprintf('Xi=%i, Yi=%i, Zi=%i  (%g, %g, %g) (%g, %g, %g)\n',Xi, Yi,Zi, X1, Y1, Z1, X2, Y2, Z2)
                    if ~PlotGeom || (Z1==Z2) || (Y1==Y2) || (X1==X2)
                        FaceAlpha=1;
                    else
                        FaceAlpha=0.5;
                    end
                    ThisColor=find(ColorList==PlotState(Yi,Xi,Zi));
                    F(1)=fill3([X1 X1 X2 X2], [Y1 Y2 Y2 Y1], [Z1 Z1 Z1 Z1],ThisColor,'facealpha',FaceAlpha);
                    F(2)=fill3([X1 X1 X2 X2], [Y1 Y2 Y2 Y1], [Z2 Z2 Z2 Z2],ThisColor,'facealpha',FaceAlpha);
                    F(3)=fill3([X1 X1 X2 X2], [Y1 Y1 Y1 Y1], [Z1 Z2 Z2 Z1],ThisColor,'facealpha',FaceAlpha);
                    F(4)=fill3([X1 X1 X2 X2], [Y2 Y2 Y2 Y2], [Z1 Z2 Z2 Z1],ThisColor,'facealpha',FaceAlpha);
                    F(5)=fill3([X1 X1 X1 X1], [Y1 Y1 Y2 Y2], [Z1 Z2 Z2 Z1],ThisColor,'facealpha',FaceAlpha);
                    F(6)=fill3([X2 X2 X2 X2], [Y1 Y1 Y2 Y2], [Z1 Z2 Z2 Z1],ThisColor,'facealpha',FaceAlpha);
                    if PlotGeom
                        T=sprintf('%s (%i)',matlist{ModelMatrix(Yi,Xi,Zi)}, ModelMatrix(Yi,Xi,Zi));
                        ThisQ=unique(Q(Yi,Xi,Zi,:));
                        if (~isscalar(ThisQ)) || ThisQ ~=0
                            Sp=' '; %char(10) if want them on different line
                            if isscalar(ThisQ)
                                T=[T Sp sprintf('Q=%g',ThisQ)];
                            else
                                T=[T Sp sprintf('Q=f(t)')];
                            end
                            for lll=1:6
                                set(F(lll),'edgecolor',[1 0 0]);
                                set(F(lll),'linewidth',5);
                            end
                        end
                        text(mean([X(Xi) X(Xi+1)]), mean([Y(Yi) Y(Yi+1)]), mean([Z(Zi) Z(Zi+1)]),T,'horiz','center')
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
    T=[T text(min(X)-Hoffset*Xrange,Ymid,Zmid,sprintf('Lft %s',LftT),'edge',[0 0 0 ])];
    T=[T text(max(X)+Hoffset*Xrange,Ymid,Zmid,sprintf('Rgt %s', RgtT),'edge',[0 0 0 ])];
    T=[T text(Xmid, min(Y)-Hoffset*Yrange,Zmid,sprintf('Bck %s', BckT),'edge',[0 0 0 ])];
    T=[T text(Xmid, max(Y)+Hoffset*Yrange,Zmid,sprintf('Frt %s', FrtT),'edge',[0 0 0 ])];
    T=[T text(Xmid, Ymid, max(Z)+Hoffset*Zrange,sprintf('Top %s', TopT),'edge',[0 0 0 ])];
    T=[T text(Xmid, Ymid, min(Z)-Hoffset*Zrange,sprintf('Btm %s', BtmT),'edge',[0 0 0 ])];
 
    title(PlotTitle)

    %Display axes in green.
    Xmax=max(max([X Y Z]))*1.1;
    Ymax=Xmax;
    Zmax=Ymax;
    L(1)=line([0 Xmax],[0 0],[0 0]);
    L(2)=line([0 0],[0 Ymax],[0 0]);
    L(3)=line([0 0],[0 0],[0 Zmax]);
    set(L,'color',[0 1 0], 'linewidth',2)
    text(Xmax,0,0,'X');
    text(0,Ymax,0,'Y');
    text(0,0,Zmax,'Z');

    hold off

    pbaspect([1 1 1])

    view(3)
    if ~PlotGeom
        ylabel(colorbar,ColorTitle);
    else
        NumColors=length(ColorList);
        P=colormap(parula(64));
        if NumColors==1
            Pn=floor(length(P)/2);
        else
            Pn=floor([0:(NumColors-1)]/(NumColors-1)*(length(P(:,1))-1));
        end
        P=P(Pn+1,:);
        colormap(P)
        CB=colorbar;
%        Ticks=[1:NumColors];
%        Ticks(1)=Ticks(1)+0.5;
%        Ticks(end)=Ticks(end)-0.5;
%        set(CB,'ticks',Ticks,'tickLabels',ColorList);
    end
end