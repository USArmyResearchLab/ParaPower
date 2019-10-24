classdef PPResults  %PP Results
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)

        Model             = [];
        Case              = [];
        TimeDate          = [];
    end
    
    properties (Dependent, SetAccess=private)
        StatesAvail
    end
    
    properties (Access = private)
        iStates = {};
        iStateVals = {};
    end
    
    properties (Constant)
        Version='V1.0';
    end
    
    methods
        function S=get.StatesAvail(obj)
            S=obj.listStates;
        end
        function obj = PPResults(varargin) %TimeDate, MI, Case, varargin)  %Constructor
            if nargin==0
                obj.Model=[];
                obj.Case=[];
                obj.TimeDate=[];
                obj.iStates={};
                obj.iStateVals={};
            elseif nargin>=3
                obj.TimeDate=varargin{1};
                obj.Model=varargin{2};
                obj.Case=varargin{3};
                for I=4:length(varargin)
                    obj.iStates{end+1}=varargin{I};
                end
            else
                error('Invalid number of input argument for initialization of PPModelDef')
            end
        end
        
        function obj=setState(obj,Desc,Vals)
            Is=find(strcmpi(obj.iStates, Desc));
            
            if isempty(Is)
                error('State %s not available in this results structure',Desc)
            else
                obj.iStateVals{Is}=Vals;
            end
        end
        
        function obj=addState(obj, StateName, StateVal)
            if ~exist('StateVal','var')
                StateVal=[];
            end
            Is=find(strcmpi(obj.iStates, StateName), 1);
            if isempty(Is)
                obj.iStates{end+1}=StateName;
                obj.iStateVals{end+1}=StateVal;
            else
                error('State %s already exists in this structure', StateName);
            end
            
        end
        
        function S=listStates(obj)
            if length(obj)==1
                S=obj(1).iStates;
                for I=1:length(S)
                    V=size(obj(1).iStateVals{I});
                    if isempty(V)
                        disp([sprintf('%s: %g',S{I},0)]);
                    else
                        disp([sprintf('%s: %g',S{I},V(1)) sprintf('x%g',V(2:end))]);
                    end
                end
            else
                for Oi=1:length(obj)
                    S=obj(Oi).iStates;
                    for I=1:length(S)
                        V=size(obj(Oi).iStateVals{I});
                        if isempty(V)
                            disp([sprintf('R(%g), %s: %g',Oi,S{I},0)]);
                        else
                            disp([sprintf('R(%g), %s: %g',Oi,S{I},V(1)) sprintf('x%g',V(2:end))]);
                        end
                    end
                end
            end
        end
        
        function Vals=getState(obj,Desc, Mask)
            Is=strcmpi(obj.iStates, Desc);
            if isempty(Is)
                error('State %s not available in this results structure',Desc)
            else
                if exist('Mask','var')
                    Vals=obj.iStateVals{Is}(Mask);
                else
                    Vals=obj.iStateVals{Is};
                end
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

function TCMnew=ExpandTCM(TCMinstance, Values, Prop, Iprop, Field, Ifield)
%Note that TCM looks like: TCM.Prop(iProp).Field{Ifield}
%                          TCM.Prop(iProp).Field
%                          TCM.Prop(iProp)
%                          TCM.Prop

    if ~(exist('Prop','var') && exist('Values','var'))
        error('Must pass at least a property and Values.')
    end
        
    TCMnew=[];
    if isnumeric(Values)
        Values=num2cell(Values);
    end
    for Itcm=1:length(TCMinstance)
        if exist('Prop','var') && strcmpi(Prop,'Features')
            if exist('Iprop','var')
                FeatDesc=['-' TCMinstance(Itcm).(Prop)(Iprop).Desc];
            else
                FeatDesc=['-' TCMinstance(Itcm).(Prop)(1).Desc];
            end
        else
            FeatDesc='';
        end
        if ~isempty(Values)
            for Ival=1:length(Values)
                TCMnew=[TCMnew TCMinstance(Itcm)];
                if exist('Ifield','var')
                    TCMnew(end).(Prop)(Iprop).(Field){Ifield}=Values{Ival};
                    VarText=sprintf('TCM.%s(%.0f%s).%s(%.0f)',Prop,Iprop,FeatDesc,Field,Ifield);
                elseif exist('Field','var')
                    TCMnew(end).(Prop)(Iprop).(Field)=Values{Ival};
                    VarText=sprintf('TCM.%s(%.0f%s).%s',Prop,Iprop,FeatDesc,Field);
                elseif exist('Iprop','var')
                    TCMnew(end).(Prop)(Iprop)=Values{Ival};
                    VarText=sprintf('TCM.%s(%.0f%s)',Prop,Iprop,FeatDesc);
                elseif exist('Prop','var')
                    TCMnew(end).(Prop)=Values{Ival};
                    VarText=sprintf('TCM.%s',Prop);
                end
                if length(Values)>1
                    TCMnew(end).ParamVar{end+1,1}=VarText;
                    if isnumeric(Values{Ival})
                        TCMnew(end).ParamVar{end,2}=sprintf('%g, ',Values{Ival});
                        TCMnew(end).ParamVar{end,2}=TCMnew(end).ParamVar{end,2}(1:end-2);
                    else
                        TCMnew(end).ParamVar{end,2}=Values{Ival};
                    end
                end
            end
        else
            TCMnew=[TCMnew TCMinstance(Itcm)];
        end
    end
end
