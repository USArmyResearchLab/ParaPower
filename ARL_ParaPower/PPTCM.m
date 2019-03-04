classdef PPTCM  %PP Test Case Model
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
%        ExternalConditions {ValidStruct(ExternalConditions,{'h_Xminus'  'h_Xplus'  'h_Yminus'  'h_Xplus'  'h_Zminus'  'h_Zplus' ...
%                                                           'Ta_Xminus' 'Ta_Xplus' 'Ta_Yminus' 'Ta_Xplus' 'Ta_Zminus' 'Ta_Zplus' ...
%                                                           'Tproc' })}
%                                                               
%        Params {ValidStruct(Params, {'Tinit' 'DeltaT' 'Tsteps'})}
        PottingMaterial   = '0';
        MatLib            = []
    end
    
    properties (Access = private)
        iFeatures         % {ValidStruct(iFeatures,{'x' 'y' 'z' 'Matl' 'Q' 'dx' 'dy' 'dz' 'Desc'})}
        iParams
        iExternalConditions
    end
    
    properties (Dependent)
        Features = [];
        Params = [];
        ExternalConditions = [];
    end
    
    properties (SetAccess = immutable)
        Version='V3.0';
    end
    
    methods (Static)
        function ObjIn=loadobj(ObjIn) %Generate error on version mismatch
            ObjCur=PPModelDef();
            if str2num(ObjIn.Version(2:end))<str2num(ObjCur.Version(2:end)) 
                warning('Incoming object is version %s, current version is %s. Default values will be assigned.',ObjIn.Version,ObjCur.Version)
            elseif str2num(ObjIn.Version(2:end))>str2num(ObjCur.Version(2:end)) 
                warning('Incoming object is version %s, current version is %s. Functionality may have been deprecated.',ObjIn.Version,ObjCur.Version)
            end
        end
    end
    
    methods
        function FeaturesOut=get.Params(obj)
            FeaturesOut=obj.iParams;
        end
        
        function obj=set.Params(obj,Input)
            S.Tinit = 20;
            S.DeltaT = 0.1;
            S.Tsteps = 10;
            ErrText='';
            if isstruct(Input(1))
                Fields = fieldnames(Input(1));
            else
                Fields={};
                ErrText=sprintf('%sParam property must be a structure\n',ErrText);
            end
            if isempty(obj.iParams)
                obj.iParams=S;
            end
            for Fi=1:length(Fields)
                if ~any(strcmp(fieldnames(S),Fields(Fi)))
                    ErrText=sprintf('%s Field %s is not a valid Params fieldname\n',ErrText,Fields{Fi});
                else
                    obj.iParams.(Fields{Fi})=Input.(Fields{Fi});
                end
            end
            if ~isempty(ErrText)
                error(ErrText)
            end
        end            
            
        function FeaturesOut=get.Features(obj)
            FeaturesOut=obj.iFeatures;
        end
        
        function obj=set.Features(obj,Input)
            F.x=[];
            F.y=[];
            F.z=[];
            F.Matl='';
            F.Q=[];
            F.dx=[];
            F.dy=[];
            F.dz=[];
            F.Desc='';
            ErrText='';
            Fields=fieldnames(Input(1));
            if isempty(obj.iFeatures) 
                obj.iFeatures=F;
            end
            for Fi=1:length(Fields)
                if ~any(strcmp(fieldnames(F),Fields(Fi)))
                    ErrText=sprintf('%s Field %s is not a valid feature fieldname\n',ErrText,Fields{Fi});
                end
            end
            if ~isempty(ErrText)
                error(ErrText)
            end
            for I=1:length(Input)
                %ThisF=F;
                for Fi=1:length(Fields)
                    obj.iFeatures(I).(Fields{Fi})=Input(I).(Fields{Fi});
                end
                %obj.iFeatures(I)=ThisF;
            end
        end
        
        function obj = PPTCM(ExternalConditions, Features, Params, PottingMaterial, MatLib)  %Constructor
            if nargin==3
                obj.ExternalConditions=ExternalConditions;
                obj.Features=Features;
                obj.Params=Params;
            elseif nargin==4
                obj.ExternalConditions=ExternalConditions;
                obj.Features=Features;
                obj.Params=Params;
                obj.PottingMaterial=PottingMaterial;
            elseif nargin==5
                obj.ExternalConditions=ExternalConditions;
                obj.Features=Features;
                obj.Params=Params;
                obj.PottingMaterial=PottingMaterial;
                obj.MatLib=MatLib;
            elseif nargin==0
    
            else
                error('Invalid number of input argument for initialization of PPModelDef')
            end
        end
        
    end
end

%Validation functions
function ValidLength(Array, Sz)
    if ~(all(size(Array)==Sz))
        ErrText=[ 'Input array is not [' ErrText sprintf('%.0f', Sz) '] Elements'];
        error(ErrText)
    end
end

function ValidCellToNumericMap(CellArray)

    try
        if iscell(CellArray)
            for I=1:length(CellArray(:))
                eval([CellArray{I} ';'])
            end
        else
            eval([CellArray ';'])
        end
    catch ME
        error(['Cell element %i: ' CellArray{I} ' doesn''t evaluate.'],I);
    end
end

function ValidStruct(Structure, FieldList)
    ErrFlag=false;
    ErrText='';
    if isstruct(Structure)
        Fields=fieldnames(Structure);
        for Fi=1:length(FieldList)
            if ~isfield(Structure,FieldList{Fi})
                ErrText=[ErrText sprintf('Field %s must exist.\n',FieldList{Fi})];
                ErrFlag=true;
            else
                Fields=Fields(~strcmp(FieldList{Fi},Fields));
            end
        end
        if ~isempty(Fields)
            warning(sprintf('Extra fields (%s) in structure will be ignored.\n',char(Fields)'))
        end
    elseif ~isempty(Structure)
        ErrFlag=true;
         ErrText=[ErrText sprintf('Variable must be a structure with fields:\n')];
        for Fi=1:length(FieldList)
            ErrText=[ErrText sprintf('  %s\n',FieldList{Fi})];
        end
    end
    if ErrFlag
        error(ErrText)
    end
end


function VA=ComputeVA(DCoord)
%Compute the volume and area of the model elements.  Volumes are R, areas are i

    %Get length of each coordinate
    Lx=length(DCoord.X);
    Ly=length(DCoord.Y);
    Lz=length(DCoord.Z);
    
    %Matrix multiply Nx1(x) * 1xN(y), then reshape and Nx1(xy) * 1xN(z) then reshape into nxmxo
    VA=reshape(reshape(DCoord.X' * DCoord.Y,[],1) * DCoord.Z,Lx, Ly,[]);
    
    %Construct vector that is 0's for all non-zero elements and 1 for all Zeros
    Xz=(DCoord.X==0);
    Yz=(DCoord.Y==0);
    Zz=(DCoord.Z==0);

    %Compute (sequentially) Areas for zero thickness X, then Y, then Z
    Az=reshape(reshape(DCoord.X' * DCoord.Y,[],1) * Zz,Lx, Ly,[]);
    Ay=reshape(reshape(DCoord.X' * Yz,[],1) * DCoord.Z,Lx, Ly,[]);
    Ax=reshape(reshape(Xz' * DCoord.Y,[],1) * DCoord.Z,Lx, Ly,[]);

    %Combine the areas of the zero thickness elements and make them imag.
    VA=VA + (Ax+Ay+Az)*1i;
end
