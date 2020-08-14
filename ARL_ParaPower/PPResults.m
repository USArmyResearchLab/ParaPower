classdef PPResults  %PP Results
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)

        Model             = [];
        Case              = [];
        TimeDate          = [];
    end
    
    properties (Dependent, SetAccess = private)
        StatesAvail
    end
    
    properties (Access = private)
        iStates = {};
        iStateVals = {};
        iStateUnit = {};
    end
    
    properties (Constant)
        Version = 'V1.0';
    end
    
    methods
        
        function S = get.StatesAvail(obj)
            S = obj.listStates;
        end
        
        function obj = PPResults(varargin) %TimeDate, MI, Case, varargin)  %Constructor
            if nargin==0
                obj.Model = [];
                obj.Case = [];
                obj.TimeDate = [];
                obj.iStates = {};
                obj.iStateVals = {};
            elseif nargin>=3
                obj.TimeDate = varargin{1};
                obj.Model = varargin{2};
                obj.Case = varargin{3};
                for I = 4:length(varargin)
                    obj.iStates{end+1} = varargin{I};
                end
            else
                error('Invalid number of input argument for initialization of PPModelDef')
            end
        end
        
        function validateInput(obj, StateVal)

            % stage 1: the input data must be a 4D array
            assert(length(size(StateVal))==4, 'Input data must be a 4D array');
            
            % stage 2: check whether the dimensions match
            % (a) StateVal and obj.Model.Model match in #1, #2, and
            % #3 dimensions, and
            % (b) StateVal and obj.GlobalTime in #4 dimension
            
            % things to compare
            input_size = size(StateVal);
            ref_size_123 = size(obj.Model.Model);
            ref_size_4 = size(obj.Model.GlobalTime);
            
            % stage 2a
            step_a = isequal(input_size(1,1:3),ref_size_123);
            
            % stage 2b 
            step_b = isequal(input_size(1,4),ref_size_4);
            
            % terminate if mismatch
            assert(~step_a || ~step_b, 'Stored results state does not match dimensions with existing model.');
            
        end
        
        % change value of existing state
        function obj = setState(obj,StateName,StateVal,StateUnit)
            
            % try to find if the input "StateName" already exists in iStates
            % then return the index or indices as Is
            Is = find(strcmpi(obj.iStates, StateName));
            
            if isempty(Is) % if state doesn't exist, error
                error('State %s not available in this results structure',StateName)
            else
                % if exists, change value in iStateVals after checking for valid input
                validateInput(obj, StateVal)
                obj.iStateVals{Is} = StateVal;
                if ~exist('StateUnit','var')
                    warning('State units remain unchanged.')
                else
                    obj.iStateUnit{Is} = StateUnit;
                end
            end
        end

        % add state (used when state does not already exist)
        function obj = addState (obj, StateName, StateVal, StateUnit)
            
            % check 1: if no StateVal is input, assign empty vector
            if ~exist('StateVal','var')
                StateVal = [];
            end
            
            if ~exist('StateUnit','var')
                StateUnit='Undefined';
                warning('Don''t forget to set units when you set a state!')
            end

            % check 2: does StateName already exist?
            Is = find(strcmpi(obj.iStates, StateName), 1);
            
            if isempty(Is) % if doesn't exist, add state
                
                % check 3: do input dimensions match with those of
                % existing model?
                validateInput(obj, StateVal)
                
                % all checks passed, proceed to add state
                % append StateName to iStates and StateVal to iStateVals
                obj.iStates{end+1} = StateName;
                obj.iStateVals{end+1} = StateVal;
                obj.iStateUnit{end+1} = StateUnit;
            else % if state exists, error
                error('State %s already exists in this structure', StateName);
            end
            
        end
        
        function S = listStates(obj)
            if length(obj)==1
                S = obj(1).iStates;
                for I = 1:length(S)
                    V = size(obj(1).iStateVals{I});
                    if isempty(V)
                        disp([sprintf('%s: %g',S{I},0)]);
                    else
                        disp([sprintf('%s: %g',S{I},V(1)) sprintf('x%g',V(2:end))]);
                    end
                end
            else
                for Oi = 1:length(obj)
                    S = obj(Oi).iStates;
                    for I = 1:length(S)
                        V = size(obj(Oi).iStateVals{I});
                        if isempty(V)
                            disp([sprintf('R(%g), %s: %g',Oi,S{I},0)]);
                        else
                            disp([sprintf('R(%g), %s: %g',Oi,S{I},V(1)) sprintf('x%g',V(2:end))]);
                        end
                    end
                end
            end
        end
        
        function Vals = getState(obj,Desc, Mask)
            % search for desired state (Desc) in iStates
            Is = strcmpi(obj.iStates, Desc);
            
            if isempty(Is)
                error('State %s not available in this results structure',Desc)
            else
                if exist('Mask','var')
                    %
                    % Problem (07-03-20):
                    % Error of "The logical indices contain a true value outside of the array bounds."
                    % when running NonDirectional"
                    %
                    % Cause:
                    % variable Mask is 4D matrix but iStateVals{3} is a 1
                    % by 1 struct with 3 fields (3D matrices X, Y and Z)
                    %
                    size_of_Mask = size(Mask);
                    size_of_iStateVals = size(obj.iStateVals{Is});
                    if length(size_of_Mask) ~= length(size_of_iStateVals)
                        'PPResults line #115: error detected, dumping data...'
                        Is
                        size_of_Mask
                        size_of_iStateVals
                        data = obj.iStateVals{Is}
                        if 0   
                            % Option 1: terminate
                            assert(length(size_of_Mask) == length(size_of_iStateVals))
                        else
                            % Option 2: try to "fix" it by making up a function
                            % and expanding along the time dimension
                            '"Fixing" error with fake data...'
                            cube_XYZ = data.X .* data.Y .* data.Z;
                            Vals = repmat(cube_XYZ,size_of_Mask(4));
                        end
                    else
                        Vals = obj.iStateVals{Is}(Mask);
                    end
                else
                    Vals = obj.iStateVals{Is};
                end
            end
        end
        
        function Units = getStateUnit(obj,Desc)
            % search for desired state (Desc) in iStates
            Is = strcmpi(obj.iStates, Desc);
            if isempty(Is)
                error('State %s not available in this results structure',Desc)
                Units='';
            else
                if isprop(obj,'iStateUnit') && ~isempty(obj.iStateUnit)
                    Units = obj.iStateUnit{Is};
                else
                    Units='units?';
                end
            end
        end
        
    end
        
end

%Validation functions
function ValidLength(Array, Sz)
    if ~(all(size(Array)==Sz))
        ErrText = [ 'Input array is not [' ErrText sprintf('%.0f', Sz) '] Elements'];
        error(ErrText)
    end
end

function ValidCellToNumericMap(CellArray)

    try
        if iscell(CellArray)
            for I = 1:length(CellArray(:))
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
    ErrFlag = false;
    ErrText = '';
    if isstruct(Structure)
        Fields = fieldnames(Structure);
        for Fi = 1:length(FieldList)
            if ~isfield(Structure,FieldList{Fi})
                ErrText = [ErrText sprintf('Field %s must exist.\n',FieldList{Fi})];
                ErrFlag = true;
            else
                Fields = Fields(~strcmp(FieldList{Fi},Fields));
            end
        end
        if ~isempty(Fields)
            warning(sprintf('Extra fields (%s) in structure will be ignored.\n',char(Fields)'))
        end
    elseif ~isempty(Structure)
        ErrFlag = true;
         ErrText = [ErrText sprintf('Variable must be a structure with fields:\n')];
        for Fi = 1:length(FieldList)
            ErrText = [ErrText sprintf('  %s\n',FieldList{Fi})];
        end
    end
    if ErrFlag
        error(ErrText)
    end
end


function VA = ComputeVA(DCoord)
%Compute the volume and area of the model elements.  Volumes are R, areas are i

    %Get length of each coordinate
    Lx = length(DCoord.X);
    Ly = length(DCoord.Y);
    Lz = length(DCoord.Z);
    
    %Matrix multiply Nx1(x) * 1xN(y), then reshape and Nx1(xy) * 1xN(z) then reshape into nxmxo
    VA = reshape(reshape(DCoord.X' * DCoord.Y,[],1) * DCoord.Z,Lx, Ly,[]);
    
    %Construct vector that is 0's for all non-zero elements and 1 for all Zeros
    Xz = (DCoord.X==0);
    Yz = (DCoord.Y==0);
    Zz = (DCoord.Z==0);

    %Compute (sequentially) Areas for zero thickness X, then Y, then Z
    Az = reshape(reshape(DCoord.X' * DCoord.Y,[],1) * Zz,Lx, Ly,[]);
    Ay = reshape(reshape(DCoord.X' * Yz,[],1) * DCoord.Z,Lx, Ly,[]);
    Ax = reshape(reshape(Xz' * DCoord.Y,[],1) * DCoord.Z,Lx, Ly,[]);

    %Combine the areas of the zero thickness elements and make them imag.
    VA = VA + (Ax+Ay+Az)*1i;
end

function TCMnew = ExpandTCM(TCMinstance, Values, Prop, Iprop, Field, Ifield)
%Note that TCM looks like: TCM.Prop(iProp).Field{Ifield}
%                          TCM.Prop(iProp).Field
%                          TCM.Prop(iProp)
%                          TCM.Prop

    if ~(exist('Prop','var') && exist('Values','var'))
        error('Must pass at least a property and Values.')
    end
        
    TCMnew = [];
    if isnumeric(Values)
        Values = num2cell(Values);
    end
    for Itcm = 1:length(TCMinstance)
        if exist('Prop','var') && strcmpi(Prop,'Features')
            if exist('Iprop','var')
                FeatDesc = ['-' TCMinstance(Itcm).(Prop)(Iprop).Desc];
            else
                FeatDesc = ['-' TCMinstance(Itcm).(Prop)(1).Desc];
            end
        else
            FeatDesc = '';
        end
        if ~isempty(Values)
            for Ival = 1:length(Values)
                TCMnew = [TCMnew TCMinstance(Itcm)];
                if exist('Ifield','var')
                    TCMnew(end).(Prop)(Iprop).(Field){Ifield} = Values{Ival};
                    VarText = sprintf('TCM.%s(%.0f%s).%s(%.0f)',Prop,Iprop,FeatDesc,Field,Ifield);
                elseif exist('Field','var')
                    TCMnew(end).(Prop)(Iprop).(Field) = Values{Ival};
                    VarText = sprintf('TCM.%s(%.0f%s).%s',Prop,Iprop,FeatDesc,Field);
                elseif exist('Iprop','var')
                    TCMnew(end).(Prop)(Iprop) = Values{Ival};
                    VarText = sprintf('TCM.%s(%.0f%s)',Prop,Iprop,FeatDesc);
                elseif exist('Prop','var')
                    TCMnew(end).(Prop) = Values{Ival};
                    VarText = sprintf('TCM.%s',Prop);
                end
                if length(Values)>1
                    TCMnew(end).ParamVar{end+1,1} = VarText;
                    if isnumeric(Values{Ival})
                        TCMnew(end).ParamVar{end,2} = sprintf('%g, ',Values{Ival});
                        TCMnew(end).ParamVar{end,2} = TCMnew(end).ParamVar{end,2}(1:end-2);
                    else
                        TCMnew(end).ParamVar{end,2} = Values{Ival};
                    end
                end
            end
        else
            TCMnew = [TCMnew TCMinstance(Itcm)];
        end
    end
end
