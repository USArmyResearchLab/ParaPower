function ModelInput=FormModel(TestCaseModel, VisualizeFlag)
%disp('============================')


%Overall structures orientation/BCs for ease of reference
Left  = 1; %X- Face
Right = 2; %X+ Face
Front = 3; %Y- Face
Back  = 4; %Y+ Face
Bottom= 5; %Z- Face
Top   = 6; %Z+ Face

if ischar(TestCaseModel) 
    if strcmpi('GetDirex',TestCaseModel)
        ModelInput.Left=Left;
        ModelInput.Right=Right;
        ModelInput.Front=Front;
        ModelInput.Back=Back;
        ModelInput.Bottom=Bottom;
        ModelInput.Top=Top;
        return
    else
        error('Invalid optional argument');
    end
else
    ExternalConditions=TestCaseModel.ExternalConditions;
    Features=TestCaseModel.Features;
    Params=TestCaseModel.Params;
    PottingMaterial=TestCaseModel.PottingMaterial;
end

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
X0=[]; %Z coordinates with zero thickness
Y0=[]; %Z coordinates with zero thickness
Z0=[]; %Z coordinates with zero thickness

for i=1:length(Features)
    Features(i).x=sort(Features(i).x);
    Features(i).y=sort(Features(i).y);
    Features(i).z=sort(Features(i).z);
    if Features(i).x(1)==Features(i).x(2) %Acount for special case of zero height layer
        X0=[X0 Features(i).x(1)];
        X=[X Features(i).x(1)];
    else
        X=[X linspace(Features(i).x(1), Features(i).x(2), 1+Features(i).dx)];
    end
    if Features(i).y(1)==Features(i).y(2) %Acount for special case of zero height layer
        Y0=[Y0 Features(i).y(1)];
        Y=[Y Features(i).y(1)];
    else
        Y=[Y linspace(Features(i).y(1), Features(i).y(2), 1+Features(i).dy)];
    end
    if Features(i).z(1)==Features(i).z(2) %Acount for special case of zero height layer
        Z0=[Z0 Features(i).z(1)];
        Z=[Z Features(i).z(1)];
    else
        Z=[Z linspace(Features(i).z(1), Features(i).z(2), 1+Features(i).dz)];
    end
end

%Collapse X and y completely.  Maintain zero thickness layers for dz
X0=unique(X0);
Y0=unique(Y0);
Z0=unique(Z0);
X=unique(X);
Y=unique(Y);
Z=unique(Z);
X=sort([X X0]); 
Y=sort([Y Y0]); 
Z=sort([Z Z0]); 

Params.Tsteps=floor(Params.Tsteps);
ModelMatrix=zeros(length(Y)-1,length(X)-1,length(Z)-1);
Q=zeros([size(ModelMatrix) Params.Tsteps]);
%Q=zeros(length(X)-1,length(Y)-1,length(Z)-1,Params.Tsteps);
GlobalTime=[0:Params.DeltaT:(Params.Tsteps-1)*Params.DeltaT];

%Get minimum values of feature coords for visualization purposes.
MinCoord=[min(X) min(Y) min(Z)];


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
                     
                     %Negate Q so that postive Q is corresponds to heat generation
                     ThisQ=-1*Features(Fi).Q;
                     
                     %Scale Q so that total of all elements results in total Q
                     ThisQ=ThisQ / (Features(Fi).dx*Features(Fi).dy*Features(Fi).dz);
                     
                     if isscalar(ThisQ)
                         Q(Yi,Xi,Zi,:)=ThisQ;
                     else
                         disp('Defining time dependent Q')
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
    MatNum=find(strcmp(lower(PottingMaterial),lower(matlist)));
    if isempty(MatNum)
        MatNum=NaN;
        fprintf('Potting material %s is unknown',PottingMaterial);
    end
else
    MatNum=PottingMaterials;
end
ModelMatrix(ModelMatrix==0)=MatNum;

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


[NR, NC, NL]=GetNumRCL(ModelMatrix);

DeltaCoord.X=X(2:end)-X(1:end-1);
DeltaCoord.Y=Y(2:end)-Y(1:end-1);
DeltaCoord.Z=Z(2:end)-Z(1:end-1);

if VisualizeFlag
    Visualize ('Model Input', MinCoord, {DeltaCoord.X DeltaCoord.Y DeltaCoord.Z}, ModelMatrix, h, Ta, matlist, Q)
end

ModelInput.NL=NL;
ModelInput.NR=NR;
ModelInput.NC=NC;
ModelInput.h=h;
ModelInput.Ta=Ta;
ModelInput.X=DeltaCoord.X;
ModelInput.Y=DeltaCoord.Y;
ModelInput.Z=DeltaCoord.Z;
ModelInput.Tproc=Tproc;
ModelInput.Model=ModelMatrix;
ModelInput.Q=Q;
ModelInput.DeltaT=Params.DeltaT;
ModelInput.Tinit=Params.Tinit;
ModelInput.Tsteps=Params.Tsteps;
ModelInput.matprops=matprops;


end

