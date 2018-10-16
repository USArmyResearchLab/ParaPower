function [GlobalTime, Tprnt, Stress, MeltFrac]=CLI_Input(Features, PottingMaterial, ExternalConditions, Params, VisualizeFlag)
%disp('============================')
%Overall structures orientation/BCs for ease of reference
Left=1; %X-
Right=2; %X+ Face
Front=3; %Y- Face
Back=4; %Y+ Face
Bottom=5; %Z- Face
Top=6; %Z+ Face


%Material Properties
[matprops, matlist, matcolors, kond, cte,E,nu,rho,spht]=matlibfun;

h(Left)=ExternalConditions.h_Left;
h(Right)=ExternalConditions.h_Right;
h(Front)=ExternalConditions.h_Front;
h(Back)=ExternalConditions.h_Back;
h(Top)=ExternalConditions.h_Top;
h(Bottom)=ExternalConditions.h_Bottom;

Ta(Left)=ExternalConditions.Ta_Left;
Ta(Right)=ExternalConditions.Ta_Right;
Ta(Front)=ExternalConditions.Ta_Front;
Ta(Back)=ExternalConditions.Ta_Back;
Ta(Top)=ExternalConditions.Ta_Top;
Ta(Bottom)=ExternalConditions.Ta_Bottom;

Tproc=ExternalConditions.Tproc;


%Construct dx, dy, dz
X=[];  %X coordinates 
Y=[];  %Y coordinates
Z=[];  %Z coordinates
Z0=[]; %Z coordinates with zero thickness

for i=1:length(Features)
    Features(i).x=sort(Features(i).x);
    Features(i).y=sort(Features(i).y);
    Features(i).z=sort(Features(i).z);
    X=[X linspace(Features(i).x(1), Features(i).x(2), 1+Features(i).dx)];
    Y=[Y linspace(Features(i).y(1), Features(i).y(2), 1+Features(i).dy)];
    if Features(i).z(1)==Features(i).z(2) %Acount for special case of zero height layer
        Z0=[Z0 Features(i).z(1)];
        Z=[Z Features(i).z(1)];
    else
        Z=[Z linspace(Features(i).z(1), Features(i).z(2), 1+Features(i).dz)];
    end
end

%Collapse X and y completely.  Maintain zero thickness layers for dz
X=unique(X);
Y=unique(Y);
Z=unique(Z);
Z0=unique(Z0);
Z=sort([Z Z0]); 

ModelMatrix=zeros(length(Y)-1,length(X)-1,length(Z)-1);
Q=zeros(length(Y)-1,length(X)-1,length(Z)-1,Params.Tsteps);
GlobalTime=[0:Params.DeltaT:(Params.Tsteps-1)*Params.DeltaT];

%Get minimum values of feature coords for visualization purposes.
MinCoord.X=min(X);
MinCoord.Y=min(Y);
MinCoord.Z=min(Z);


for Xi=1:length(X)-1
    for Yi=1:length(Y)-1
        for Zi=1:length(Z)-1
            for Fi=1:length(Features)
                InX = (Features(Fi).x(1)<=X(Xi) ) && ( Features(Fi).x(2)>=X(Xi+1));
                InY = (Features(Fi).y(1)<=Y(Yi) ) && ( Features(Fi).y(2)>=Y(Yi+1));
                if (Features(Fi).z(1) == Features(Fi).z(2))
                    InZ = Z(Zi)==(Features(Fi).z(1) ) && ( Z(Zi+1)==Features(Fi).z(1));
                else
                    InZ=(Features(Fi).z(1)<=Z(Zi)) && (Features(Fi).z(2)>=Z(Zi+1));
                end
%                 fprintf('%i: Locn (%7g %7g %7g) to (%7g %7g %7g), Features (%7g %7g %7g) to (%7g %7g %7g) %i %i %i\n',Fi, ...
%                                                                                X(Xi)            ,Y(Yi)             ,Z(Zi), ...
%                                                                                X(Xi+1)          ,Y(Yi+1)           ,Z(Zi+1), ...
%                                                                                Features(Fi).x(1), Features(Fi).y(1), Features(Fi).z(1), ...
%                                                                                Features(Fi).x(2), Features(Fi).y(2), Features(Fi).z(2), InX, InY, InZ)
                 if InX && InY && InZ
                     MatNum=find(strcmp(matlist,Features(Fi).Matl));
                     if isempty(MatNum)
                        fprintf('Material %s not found in database. Check spelling\n',Features(Fi).Matl)
                        MatNum=nan;
                     end
                     ModelMatrix(Yi,Xi,Zi)=MatNum;
                     if isscalar(Features(Fi).Q)
                         Q(Yi,Xi,Zi,:)=Features(Fi).Q;
                     else
                         disp('Defining time dependent Q')
                         ThisQ=Features(Fi).Q;
                         if ThisQ(1,1) > GlobalTime(1) %If Q for features is not defined at time beginning, then define it
                             ThisQ=[[GlobalTime(1) ThisQ(1,2)]; ThisQ];
                             disp('Defining Q at min(time)')
                         end
                         if ThisQ(end,1) < GlobalTime(end)
                             disp('Defining Q at max(time)')
                             ThisQ=[ThisQ; [GlobalTime(end) ThisQ(end,2)]];
                         end
                         Q(Yi,Xi,Zi,:)=interp1(ThisQ(:,1),ThisQ(:,2), GlobalTime,'spline');
                     end
                end
            end
        end
    end
end

if ischar(PottingMaterial)
    MatNum=find(strcmp(PottingMaterial,matlist));
    if isempty(MatNum)
        MatNum=NaN;
        fprintf('Other material %s is unknown',PottingMaterial);
    end
    ModelMatrix(ModelMatrix==0)=MatNum;
end

% %Check for existance of Z=0 layer
% Zzero=find(Z==0);
% if isempty(find(ModelMatrix(:,:,Zzero)))
%     ModelMatrix=ModelMatrix(:,:,Z~=0);
% end 
    

% for Zi=1:length(Z)-1
%     fprintf('Between Z=%g and Z=%g\n',Z(Zi),Z(Zi+1))
%     ModelMatrix(:,:,Zi)
% end
%step through, dx, dy, dz, compare to Features and set material number


NL=length(ModelMatrix(1,1,:));
NR=length(ModelMatrix(:,1,1));
NC=length(ModelMatrix(1,:,1));

DeltaCoord.X=X(2:end)-X(1:end-1);
DeltaCoord.Y=Y(2:end)-Y(1:end-1);
DeltaCoord.Z=Z(2:end)-Z(1:end-1);

if VisualizeFlag
    Visualize (MinCoord, DeltaCoord, ModelMatrix, h, Ta, matlist, Q)
end

disp('Analysis starting...')
tic

[Tprnt, Stress, MeltFrac]=ParaPowerThermal(NL,NR,NC, ...
                                           h,Ta, ...
                                           DeltaCoord.X,DeltaCoord.Y,DeltaCoord.Z, ...
                                           Tproc, ...
                                           ModelMatrix,-Q, ...
                                           Params.DeltaT,Params.Tsteps,Params.Tinit,matprops);
toc
disp('Analysis complete.')
Visualize(MinCoord, DeltaCoord, ModelMatrix, Tprnt(:,:,:,end));

end

function Visualize (MinCoord, DeltaCoord, ModelMatrix, varargin)
if length(varargin)==1
    PlotGeom=false;
    PlotState=varargin{1};
else
    PlotGeom=true;
    PlotState=ModelMatrix;
    h=          varargin{1};
    Ta=         varargin{2};
    matlist=    varargin{3};
    Q=          varargin{4};
end

%Visualization of defined model

    X=[MinCoord.X cumsum(DeltaCoord.X)];
    Y=[MinCoord.Y cumsum(DeltaCoord.Y)];
    Z=[MinCoord.Z cumsum(DeltaCoord.Z)];
    
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
                    if ~PlotGeom || (Z1==Z2)
                        FaceAlpha=1;
                    else
                        FaceAlpha=0.5;
                    end
                    F(1)=fill3([X1 X1 X2 X2], [Y1 Y2 Y2 Y1], [Z1 Z1 Z1 Z1],PlotState(Yi,Xi,Zi),'facealpha',FaceAlpha);
                    F(2)=fill3([X1 X1 X2 X2], [Y1 Y2 Y2 Y1], [Z2 Z2 Z2 Z2],PlotState(Yi,Xi,Zi),'facealpha',FaceAlpha);
                    F(3)=fill3([X1 X1 X2 X2], [Y1 Y1 Y1 Y1], [Z1 Z2 Z2 Z1],PlotState(Yi,Xi,Zi),'facealpha',FaceAlpha);
                    F(4)=fill3([X1 X1 X2 X2], [Y2 Y2 Y2 Y2], [Z1 Z2 Z2 Z1],PlotState(Yi,Xi,Zi),'facealpha',FaceAlpha);
                    F(5)=fill3([X1 X1 X1 X1], [Y1 Y1 Y2 Y2], [Z1 Z2 Z2 Z1],PlotState(Yi,Xi,Zi),'facealpha',FaceAlpha);
                    F(6)=fill3([X2 X2 X2 X2], [Y1 Y1 Y2 Y2], [Z1 Z2 Z2 Z1],PlotState(Yi,Xi,Zi),'facealpha',FaceAlpha);
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
                                set(F(1),'edgecolor',[1 0 0]);
                                set(F(1),'linewidth',5);
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

    Hoffset=0.5;

    if PlotGeom
        text(min(X)-Hoffset*Xrange,Ymid,Zmid,sprintf('h=%g, T_a=%g',h(1),Ta(1)),'edge',[0 0 0 ]);
        text(max(X)+Hoffset*Xrange,Ymid,Zmid,sprintf('h=%g, T_a=%g',h(2),Ta(2)),'edge',[0 0 0 ]);
        text(Xmid, min(Y)-Hoffset*Yrange,Zmid,sprintf('h=%g, T_a=%g',h(3),Ta(1)),'edge',[0 0 0 ]);
        text(Xmid, max(Y)+Hoffset*Yrange,Zmid,sprintf('h=%g, T_a=%g',h(4),Ta(2)),'edge',[0 0 0 ]);
        text(Xmid, Ymid, min(Z)-Hoffset*Zrange,sprintf('h=%g, T_a=%g',h(5),Ta(1)),'edge',[0 0 0 ]);
        text(Xmid, Ymid, max(Z)+Hoffset*Zrange,sprintf('h=%g, T_a=%g',h(6),Ta(2)),'edge',[0 0 0 ]);
    end

    hold off

    view(3)
    if PlotGeom
        disp('Press key to continue')
        pause
    else
        colorbar
    end
end