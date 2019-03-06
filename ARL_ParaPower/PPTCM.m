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
        ParamVar          = {};
    end
    
    properties (Access = private)
        iFeatures = [];
        iParams = [];
        iExternalConditions = [];
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
        function TCMout = GenerateTCM (obj, VariableList)
        %TCMout=GenerateTCM(VariableList)
        %Generates Scalar TestCaseModels using substitutions in VariableList
        %Variable list is a structure array. VariableList{:,1}=name and
        %              VariableList{:,2}=value
            ErrText='';
            if exist('VariableList','var')
                VarEval='';
                for Row=1:length(VariableList(:,1))
                    try
                        if isnumeric(VariableList{Row,2})
                            VarEval=[VariableList{Row,1} '=VariableList{Row,2}; '];
                        else
                            VarEval=[VariableList{Row,1} '=' VariableList{Row,2} ';'];
                        end
                        eval(VarEval);
                    catch ME
                        ErrText=[ErrText sprintf('Variable ''%s'' must be a string that evaluates to a numeric scalar or vector (''%s'')',VariableList{Row,1}, VariableList{Row,2})];
                    end
                end
            end
            if ~isempty(ErrText)
                error(ErrText)
            end
            ErrText='';
            TCMmaster=obj;
            TCMout=obj;
            PropList=properties(TCMmaster);
            PropList=PropList(~strcmpi(PropList,'Version'));
            PropList=PropList(~strcmpi(PropList,'MatLib'));
            for Ip=1:length(PropList)
                ThisPropName=PropList{Ip};
                ThisPropVal=TCMmaster.(ThisPropName);
                if isstruct(ThisPropVal)
                    FieldList=fieldnames(ThisPropVal);
                    FieldList=FieldList(~strcmpi(FieldList,'Desc'));
                    FieldList=FieldList(~strcmpi(FieldList,'Q'));
                    for Ifl=1:length(FieldList)
                        ThisFieldName=FieldList{Ifl};
                        for Ipv=1:length(ThisPropVal)  %Because features is a structure array
                            ThisFieldVal=ThisPropVal(Ipv).(ThisFieldName);
                            if strcmpi(ThisFieldName,'Matl')                        %Specificly for Matieral Field
                                if isempty(ThisFieldVal)                            %Specificly for Matieral Field
                                    FieldVals={''};                                 %Specificly for Matieral Field
                                elseif ischar(ThisFieldVal)                         %Specificly for Matieral Field
                                    ThisFieldVal=ThisFieldVal(ThisFieldVal~=' '); %Remove spaces     %Specificly for Matieral Field
                                    FieldVals=split(ThisFieldVal,','); %Separate by commas     %Specificly for Matieral Field
                                elseif iscell(ThisFieldVal)                         %Specificly for Matieral Field
                                    FieldVals=ThisFieldVal;                         %Specificly for Matieral Field
                                end                                                 %Specificly for Matieral Field
                                for Imat=1:length(FieldVals)
                                    if isempty(TCMmaster.MatLib.GetMatName(FieldVals{Imat}))
                                        ErrText=[ErrText sprintf('Material ''%s'' does not exist in the library\n',FieldVals{Imat})];
                                        FieldVals{Imat}='XXXX';
                                    end
                                end
                                FieldVals=FieldVals(~strcmpi(FieldVals,'XXXX'));
                                TCMcur=[];                                          %Specificly for Matieral Field
                                for Ifv=1:length(FieldVals)                         %Specificly for Matieral Field
                                    for Itcm=1:length(TCMout)                       %Specificly for Matieral Field
                                        if isempty(TCMcur)                          %Specificly for Matieral Field
                                            TCMcur=TCMout(Itcm);                    %Specificly for Matieral Field
                                        else                                        %Specificly for Matieral Field
                                            TCMcur(end+1)=TCMout(Itcm);             %Specificly for Matieral Field
                                        end                                         %Specificly for Matieral Field
                                        TCMcur(end).(ThisPropName)(Ipv).(ThisFieldName)=FieldVals{Ifv};     %Specificly for Matieral Field
                                        if length(FieldVals)>1                              %Specificly for Matieral Field
                                            TCMcur(end).ParamVar{end+1,1}=sprintf('TCM.%s(%.0f-%s).%s',ThisPropName,Ipv,TCMcur(end).(ThisPropName)(Ipv).Desc,ThisFieldName);     %Specificly for Matieral Field
                                            TCMcur(end).ParamVar{end,2}=FieldVals{Ifv};     %Specificly for Matieral Field
                                        end                                                 %Specificly for Matieral Field
                                    end                                                     %Specificly for Matieral Field
                                end                                                         %Specificly for Matieral Field
                                TCMout=TCMcur;                                              %Specificly for Matieral Field
                            else
                                if ischar(ThisFieldVal) || length(ThisFieldVal(:))>1
                                    if ischar(ThisFieldVal)
                                        try 
                                            eval(['FieldVals=' ThisFieldVal ';'])
                                        catch ME
                                            ErrText=[ErrText 'Cannot evaluate ''' ThisFieldVal ''' for ' sprintf('TCM.%s(%.0f-%s).%s\n',ThisPropName,Ipv,TCMcur(end).(ThisPropName)(Ipv).Desc,ThisFieldName) ];
                                            FieldVals=[];
                                        end
                                    else
                                        FieldVals=ThisFieldVal(:);
                                    end
                                    TCMcur=[];
                                    for Ifv=1:length(FieldVals)
                                        for Itcm=1:length(TCMout)
                                            if isempty(TCMcur)
                                                TCMcur=TCMout(Itcm);
                                            else
                                                TCMcur(end+1)=TCMout(Itcm);
                                            end
                                            TCMcur(end).(ThisPropName)(Ipv).(ThisFieldName)=FieldVals(Ifv);
                                            if length(FieldVals)>1
                                                if length(ThisPropVal)==1
                                                    TCMcur(end).ParamVar{end+1,1}=sprintf('TCM.%s.%s',ThisPropName,ThisFieldName);
                                                else
                                                    TCMcur(end).ParamVar{end+1,1}=sprintf('TCM.%s(%.0f-%s).%s',ThisPropName,Ipv,TCMcur(end).(ThisPropName)(Ipv).Desc,ThisFieldName);
                                                end
                                                TCMcur(end).ParamVar{end,2}=FieldVals(Ifv);
                                            end
                                        end
                                    end
                                    if ~isempty(FieldVals)
                                        TCMout=TCMcur;  
                                    end
                                end
                            end
                        end
                    end
                else
                    if ischar(ThisPropVal) || length(ThisPropVal(:))>1
                        if ischar(ThisPropVal)
                            try 
                                eval(['PropVals=' ThisPropVal ';']);
                            catch ME
                                ErrText=[ErrText 'Cannot evaluate ''' ThisPropVal ''' for ' sprintf('TCM.%s\n',ThisPropName)];
                                PropVals=[];
                            end
                        else
                            PropVals=ThisPropVal(:);
                        end
                        TCMcur=[];  %TCMcur is the TCM currently being modified, TCMout is the current source TCM
                        for Ipv=1:length(PropVals)
                            for Itcm=1:length(TCMout)
                                if isempty(TCMcur)
                                    TCMcur=TCMout(Itcm);
                                else
                                    TCMcur(end+1)=TCMout(Itcm);
                                end
                                TCMcur(end).(ThisPropName)=PropVals(Ipv);
                                if length(PropVals) > 1
                                    TCMcur(end).ParamVar{end+1,1}=sprintf('TCM.%s',ThisPropName);
                                    TCMcur(end).ParamVar{end,2}=PropVals(Ipv);
                                end
                            end
                        end
                        if ~isempty(PropVals)
                            TCMout=TCMcur;
                        end
                    end
                end
            end
            if ~isempty(ErrText)
                warning(ErrText)
            end
        end
        function FeaturesOut=get.ExternalConditions(obj)
%             if isempty(obj.iExternalConditions)
%                 obj.ExternalConditions='Init';
%             end
            FeaturesOut=obj.iExternalConditions;
        end
        
        function obj=set.ExternalConditions(obj,Input)
            S.h_Xminus=[];
            S.h_Xplus=[];
            S.h_Yminus=[];
            S.h_Yplus=[];
            S.h_Zminus=[];
            S.h_Zplus=[];
            S.Ta_Xminus=[];
            S.Ta_Xplus=[];
            S.Ta_Yminus=[];
            S.Ta_Yplus=[];
            S.Ta_Zminus=[];
            S.Ta_Zplus=[];
            S.Tproc=[];
            ErrText='';
            if isstruct(Input(1))
                Fields = fieldnames(Input(1));
            else
                Fields={};
                if strcmpi(Input,'Init')
                    Fields=[];
                else
                    ErrText=sprintf('%ExternalConditions property must be a structure\n',ErrText);
                end
            end
            if isempty(obj.iExternalConditions)
                obj.iExternalConditions=S;
            end
            for Fi=1:length(Fields)
                if ~any(strcmp(fieldnames(S),Fields(Fi)))
                    ErrText=sprintf('%s Field %s is not a valid ExternalConditions fieldname\n',ErrText,Fields{Fi});
                else
                    obj.iExternalConditions.(Fields{Fi})=Input.(Fields{Fi});
                end
            end
            if ~isempty(ErrText)
                error(ErrText)
            end
        end                    
        
        function FeaturesOut=get.Params(obj)
%             if isempty(obj.iParams)
%                 obj.Params='Init';
%             end
            FeaturesOut=obj.iParams;
        end
        
        function obj=set.Params(obj,Input)
            S.Tinit = [];
            S.DeltaT = [];
            S.Tsteps = [];
            ErrText='';
            if isstruct(Input(1))
                Fields = fieldnames(Input(1));
            else
                if strcmpi(Input,'Init')
                    Fields=[];
                else
                    Fields={};
                    ErrText=sprintf('%sParam property must be a structure\n',ErrText);
                end
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
            if isstruct(Input(1))
                Fields = fieldnames(Input(1));
            else
                if strcmpi(Input,'Init')
                    Fields=[];
                    Input=[];
                else
                    Fields={};
                    ErrText=sprintf('%sFeatures property must be a structure\n',ErrText);
                end
            end
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
                obj.MatLib=PPMatLib;
                obj.Params='Init';
                obj.Features='Init';
                obj.ExternalConditions='Init';
    
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
