function ModelInput=FormModel(TestCaseModel)
%disp('============================')

%Overall structures orientation/BCs for ease of reference
Left  = 1; %X- Face
Right = 2; %X+ Face
Front = 3; %Y- Face
Back  = 4; %Y+ Face
Bottom= 5; %Z- Face
Top   = 6; %Z+ Face

if ischar(TestCaseModel) 
    if strcmpi('GetDirex',TestCaseModel) %this argument will return the directional index definitions
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
    if not(isfield(TestCaseModel,'Version')) || not(strcmpi(TestCaseModel.Version,'V2.0'))
        error(['Incorrect TestCaseModel version.  V2.0 required, this data is ' TestCaseModel.Version]);
    end
    ExternalConditions=TestCaseModel.ExternalConditions;
    Features=TestCaseModel.Features;
    Params=TestCaseModel.Params;
    PottingMaterial=TestCaseModel.PottingMaterial;
end

%Material Properties
if isfield(TestCaseModel,'MatLib')
    MatLib=TestCaseModel.MatLib;
else
    msgbox('MatLib needs to be included in the TestCaseModel structure','Warning');
    return
end
%[matprops, matlist, matcolors, kond, cte,E,nu,rho,spht]=matlibfun;


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
    Fd=Features(i).x;
    if isscalar(Fd)
        Fd=[1 1]*Fd;
    end
    Features(i).x=Fd;
    
    Fd=Features(i).y;
    if isscalar(Fd)
        Fd=[1 1]*Fd;
    end
    Features(i).y=Fd;

    Fd=Features(i).z;
    if isscalar(Fd)
        Fd=[1 1]*Fd;
    end
    Features(i).z=Fd;
    
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
%Fix floating point inaccuracies.  Round to accuracy of epsilon - 2
%decimals
if ~isempty(X0)
    X0=unique(round(X0,floor(abs(log10(100*eps(max(X0)))))));
end
if ~isempty(Y0)
    Y0=unique(round(Y0,floor(abs(log10(100*eps(max(Y0)))))));
end
if ~isempty(Z0)
    Z0=unique(round(Z0,floor(abs(log10(100*eps(max(Z0)))))));
end
X=unique(round(X,floor(abs(log10(100*eps(max(X)))))));
Y=unique(round(Y,floor(abs(log10(100*eps(max(Y)))))));
Z=unique(round(Z,floor(abs(log10(100*eps(max(Z)))))));

X=sort([X X0]); 
Y=sort([Y Y0]); 
Z=sort([Z Z0]); 

DeltaCoord.X=X(2:end)-X(1:end-1);
DeltaCoord.Y=Y(2:end)-Y(1:end-1);
DeltaCoord.Z=Z(2:end)-Z(1:end-1);

Params.Tsteps=floor(Params.Tsteps);
ModelMatrix=zeros(length(X)-1,length(Y)-1,length(Z)-1);
%Q=zeros([size(ModelMatrix) Params.Tsteps]);
S=size(ModelMatrix);
Q{S(1),S(2),S(3)}=[];
%Q=zeros([size(ModelMatrix) Params.Tsteps]);

if isempty(Params.Tsteps)
    GlobalTime=[];
else
    GlobalTime=[0:Params.DeltaT:(Params.Tsteps-1)*Params.DeltaT];
end

%Get minimum values of feature coords for visualization purposes.
MinCoord=[min(X) min(Y) min(Z)];

%MODIFY ALGORTHM as follows.
%Initilize model matrix to NaN
%Loop through features with non-zero thickness in any direction
%Loop thorugh features with zero thickness and apply non-feature areas as above or below material
%Set all NaN elements to potting material

ZeroThickness=[];
NonZeroThickness=[];
for Fi=1:length(Features)
    if any([ isscalar(unique(Features(Fi).x)) ...
             isscalar(unique(Features(Fi).y)) ...
             isscalar(unique(Features(Fi).z)) ])
         ZeroThickness(end+1)=Fi;
    else
         NonZeroThickness(end+1)=Fi;
    end
end

%Apply materials for non-zero thickness elements
for Fii=1:length(NonZeroThickness) 
    Fi=NonZeroThickness(Fii);
    InX=GetInXYZ(Features(Fi).x, X);
    InY=GetInXYZ(Features(Fi).y, Y);
    InZ=GetInXYZ(Features(Fi).z, Z);
    
    Features(Fi).TotalVolume=diff(Features(Fi).x)*diff(Features(Fi).y)*diff(Features(Fi).z);
    Features(Fi).TotalArea=NaN;
  
    %Define Material for the feature
    MatNum=find(strcmpi(MatLib.AllMatsList,Features(Fi).Matl));
    if isempty(MatNum)
        fprintf('Material %s not found in database. Check spelling\n',Features(Fi).Matl)
        MatNum=nan;
    else
        MatNum=MatLib.AllMatsNum(MatNum);
    end
    ModelMatrix(InX, InY, InZ)=MatNum;
end

%Apply materials for zero-thickness elements
for Fii=1:length(ZeroThickness) 
    Fi=ZeroThickness(Fii);
    InX=GetInXYZ(Features(Fi).x, X);
    InY=GetInXYZ(Features(Fi).y, Y);
    InZ=GetInXYZ(Features(Fi).z, Z);
    Features(Fi).TotalVolume=NaN;
    
    if isscalar(unique(Features(Fi).x))  %X is zero thickness
        UseLayer=GetZeroLayer(X, Features(Fi).x);
        ModelMatrix(InX,:,:)=ModelMatrix(UseLayer,:,:);
%        error('must be fixed to match z')
        Features(Fi).TotalArea=diff(Features(Fi).z)*diff(Features(Fi).y);
    elseif isscalar(unique(Features(Fi).y)) %y is zero thickness
        UseLayer=GetZeroLayer(Y, Features(Fi).y);
        ModelMatrix(:,InY,:)=ModelMatrix(:,UseLayer,:);
        Features(Fi).TotalArea=diff(Features(Fi).z)*diff(Features(Fi).x);
        %error('must be fixed to match z')
    elseif isscalar(unique(Features(Fi).z)) %z is zero thickness
        UseLayer=GetZeroLayer(Z, Features(Fi).z);
        Features(Fi).TotalArea=diff(Features(Fi).x)*diff(Features(Fi).y);
        ModelMatrix(:,:,InZ)=ModelMatrix(:,:,UseLayer);
    end
    %Define Material for the feature
    MatNum=find(strcmpi(MatLib.AllMatsList,Features(Fi).Matl));
    if isempty(MatNum)
        fprintf('Material %s not found in database. Check spelling\n',Features(Fi).Matl)
        MatNum=nan;
    else
        MatNum=MatLib.AllMatsNum(MatNum);
    end
    ModelMatrix(InX, InY, InZ)=MatNum;
end

%Apply Q's (Note that Q's are now defined as function handles)
for Fi=1:length(Features)
    %Define Q for the feature
     %Negate Q so that postive Q is corresponds to heat generation
     if strcmpi(class(Features(Fi).Q),'function_handle')
         ThisQ=@(t)Features(Fi).Q(t)*(-1);
     elseif isscalar(Features(Fi).Q)
         if Features(Fi).Q==0
             ThisQ=[];
         else
            ThisQ=@(t)(-1)*Features(Fi).Q;
         end
     elseif ischar(Features(Fi).Q)
         ThisQ=@(t)eval(Features(Fi).Q);
     elseif isempty(Features(Fi).Q)
         ThisQ=[];
     else
         ThisQ=@(t)(-1)*interp1(Features(Fi).Q(:,1),Features(Fi).Q(:,2),t);
         GlobalTime=[GlobalTime Features(Fi).Q(:,1)];
     end


     if not(isempty(ThisQ)) 
         for Xi=InX
             for Yi=InY
                 for Zi=InZ
                     if isscalar(unique(Features(Fi).x))  %X is zero thickness
                         ScaledQ=@(t)ThisQ(t)*DeltaCoord.Z(Zi)*DeltaCoord.Y(Yi)/abs(Features(Fi).TotalArea);
                     elseif isscalar(unique(Features(Fi).y)) %y is zero thickness
                         ScaledQ=@(t)ThisQ(t)*DeltaCoord.Z(Zi)*DeltaCoord.X(Xi)/abs(Features(Fi).TotalArea);
                     elseif isscalar(unique(Features(Fi).z)) %z is zero thickness
                         ScaledQ=@(t)ThisQ(t)*DeltaCoord.X(Xi)*DeltaCoord.Y(Yi)/abs(Features(Fi).TotalArea);
                     else
                         ScaledQ=@(t)ThisQ(t)*DeltaCoord.X(Xi)*DeltaCoord.Z(Zi)*DeltaCoord.Y(Yi)/abs(Features(Fi).TotalVolume);
                     end
                     Q{Xi,Yi,Zi}=ScaledQ;
                 end
             end
         end
     end
end
     

if ischar(PottingMaterial)
    MatNum=find(strcmpi(PottingMaterial,lower(matlist)));
    if isempty(MatNum)
        MatNum=NaN;
        fprintf('Potting material %s is unknown',PottingMaterial);
    end
else
    MatNum=PottingMaterial;
end
ModelMatrix(isnan(ModelMatrix))=MatNum;

[NR, NC, NL]=size(ModelMatrix);
GlobalTime = uniquetol(GlobalTime, eps(max(GlobalTime)));

ModelInput.h=h;
ModelInput.Ta=Ta;
ModelInput.X=DeltaCoord.X;
ModelInput.Y=DeltaCoord.Y;
ModelInput.Z=DeltaCoord.Z;
ModelInput.Tproc=Tproc;
ModelInput.Model=ModelMatrix;
ModelInput.Q=Q;
ModelInput.GlobalTime=GlobalTime;
ModelInput.Tinit=Params.Tinit;
ModelInput.MatLib=MatLib;
ModelInput.matprops=MatLib.matprops;
ModelInput.matlist=MatLib.matlist;
ModelInput.Version='V2.0';

return

function UseLayer=GetZeroLayer(Coords, FeatureCoords)
    ZeroLayer=min(find(Coords==FeatureCoords(1)));
    if ZeroLayer==1
        UseLayer=2;
    else
        UseLayer=ZeroLayer-1;
    end
return

function In=GetInXYZ(FeatureExtent, Coords)

    if FeatureExtent(1)==FeatureExtent(2)
        In=find(FeatureExtent(1)==Coords);
        In=In(1:end-1);
    else
        In=find(FeatureExtent(1) <= Coords & FeatureExtent(2) > Coords);
        if length(Coords(In))~=length(unique(Coords(In)))
            In=In(2:end);
        end
    end
return