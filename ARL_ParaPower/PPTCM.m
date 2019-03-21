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
        VariableList      = {};
    end
    
    properties (Access = private)
        iFeatures = [];
        iParams = [];
        iExternalConditions = [];
        iExpanded=false;
    end
    
%    properties(SetAccess = immutable)
    properties (Access = private)
        SymAvail
    end
    
    properties (Dependent)
        Features = [];
        Params = [];
        ExternalConditions = [];
    end
    
    properties (Constant)
        Version='V3.0';
    end
    
    methods (Static)
        function ObjIn=loadobj(ObjIn) %Generate error on version mismatch
            %ObjCur=PPModelDef();
            if str2num(ObjIn.Version(2:end))<str2num(ObjIn.Version(2:end)) 
                warning('Incoming object is version %s, current version is %s. Default values will be assigned.',ObjIn.Version,ObjCur.Version)
            elseif str2num(ObjIn.Version(2:end))>str2num(ObjIn.Version(2:end)) 
                warning('Incoming object is version %s, current version is %s. Functionality may have been deprecated.',ObjIn.Version,ObjCur.Version)
            end
        end
        
        function QTextOut=GenQFunction(Qtext, Parameters)
            %Output will be a cell array of strings
            SymAvail=license('test','symbolic_toolbox');
            VarText='';
            if exist('Parameters','var') && ~isempty(Parameters)
                for Ip=1:length(Parameters(:,1))
                    if ~isempty(Parameters{Ip,1})
                        VarText=[VarText  Parameters{Ip,1} '=' Parameters{Ip,2} ';' char(10)];
                    end
                end
                %eval(VarText)
            end
            QTextOut={};
            if SymAvail
                t=sym('t');
                EvalText=[VarText 'QHFn=(-1)*' Qtext];
                eval([EvalText ';']);  %if the Q function evaluates to multiple formulae it will be an array
                for I=1:length(QHFn)
                    QTextOut{I}=char(QHFn(I));
                end
            else
                QTextOut{1}=['(-1)*' QText];
                %EvalText=[VarText 'Qhandle{1}=@(t)(-1)*' Qtext ';'];
                %eval([EvalText ';']);
            end
        end
            
    end
    
    methods
        function obj=GeomFactor(obj, Factor, Action)
            ErrText='';
            SFactor=['(00' num2str(Factor) ')*(']; %Add mathematical operators to the factor and leading 0's to make it unique
            for Fi=1:length(obj.Features)
                if strcmpi(Action,'add')
                    for Fld={'x' 'y' 'z'}
                        for Ei=1:length(obj.Features(Fi).(Fld{1}))
                            Value=obj.Features(Fi).(Fld{1}){Ei};
                            if ischar(Value)
                                Value = [SFactor obj.Features(Fi).(Fld{1}){Ei} ')'];
                            else
                                Value=Value*Factor;
                            end
                            obj.Features(Fi).(Fld{1}){Ei}=Value;
                        end
                    end
                elseif strcmpi(Action,'strip')
                    for Fld={'x' 'y' 'z'}
                        for Ei=1:length(obj.Features(Fi).(Fld{1}))
                            Value=obj.Features(Fi).(Fld{1}){Ei};
                            if ischar(Value)
                                if  length(Value) > length(SFactor)
                                    Value=[strrep(Value(1:length(SFactor)),SFactor,'') Value(length(SFactor)+1:end)];
                                    Value=Value(1:end-1);
                                else
                                    ErrText=[ErrText sprintf('Factor (%g) cannot be stripped from TCM.Features(%.0f).%s(%.0f)\n',Factor, Fi,Fld{1},Ei)];
                                end
                            else
                                Value=Value/Factor;
                            end
                            obj.Features(Fi).(Fld{1}){Ei}=Value;
                        end
                    end
                else
                    error('Unknown action "%s"', Action)
                end
            end
            if ~isempty(ErrText)
                warning([char(10) ErrText])
            end
        end
        
        function TCMout = GenerateCases (obj, VariableList)
        %TCMout=GenerateTCM(VariableList)
        %Generates Scalar TestCaseModels using substitutions in VariableList
        %Variable list is a structure array. VariableList{:,1}=name and
        %              VariableList{:,2}=value
            if ~obj.SymAvail
                disp('WARNING: Symbolic toolbox is not available, Function based Q definitions limited to preclude use of any parameters.')
            end
            ErrText='';
            if exist('VariableList','var')
                if ~isempty(obj.VariableList)
                    warning('PPTCM.GenerateTCM using passed VariableList and ignoring PPTCM.VariableList')
                end
            else
                VariableList=obj.VariableList;
            end
            if ~isempty(VariableList)
                VarEval='';
                for Row=1:length(VariableList(:,1))
                    try
                        if isnumeric(VariableList{Row,2})
                            VarEval=[VariableList{Row,1} '=VariableList{Row,2}; '];
                        elseif isempty(VariableList{Row,1})
                            VarEval='';
                        else
                            VarEval=[VariableList{Row,1} '=' VariableList{Row,2} ';'];
                        end
                        eval(VarEval);
                    catch ME
                        ErrText=[ErrText sprintf('Variable ''%s'' must be a string that evaluates to a numeric scalar or vector (''%s'')\n',VariableList{Row,1}, VariableList{Row,2})];
                    end
                end
            end
            if ~isempty(ErrText)
                error(ErrText)
            end
            ErrText='';
            TCMmaster=obj;
            TCMout=obj;
            MatLibList=TCMout.MatLib.GenerateCases(TCMout.VariableList);
            
            TCMout.VariableList={}; %Since TCMout will contain no variables, strike the variable list from it.
            NewTCM=[];
            for Imat=1:length(MatLibList)
                NewTCM=[NewTCM TCMout];
                NewTCM(end).MatLib=MatLibList(Imat);
                NewTCM(end).ParamVar=MatLibList(Imat).ParamVar;
                %NewTCM(end).
            end
            TCMout=NewTCM;
            clear NewTCM
            PropList=properties(TCMmaster);
            PropList=PropList(~strcmpi(PropList,'Version'));      %These properties will NOT be cycled through
            PropList=PropList(~strcmpi(PropList,'VariableList')); %These properties will NOT be cycled through
            PropList=PropList(~strcmpi(PropList,'MatLib'));       %These properties will NOT be cycled through
            PropList=PropList(~strcmpi(PropList,'ParamVar'));     %These properties will NOT be cycled through
            for Ip=1:length(PropList)  %go through list of properties
                ThisPropName=PropList{Ip}; %DEBUG
                ThisPropVal=TCMmaster.(ThisPropName);
                if iscell(ThisPropVal)
                    error('Cell valued properties are not yet addressed.')
                elseif isstruct(ThisPropVal)
                    for Ipe=1:length(ThisPropVal)   %go through each element when a property is an array
                        ThisPropValElement=ThisPropVal(Ipe);
                        FieldList=fieldnames(ThisPropValElement);
                        FieldList=FieldList(~strcmpi(FieldList,'Desc'));  %These fields will NOT be cycled through
                        %FieldList=FieldList(~strcmpi(FieldList,'Q'));     %These fields will NOT be cycled through
                        for Ifl=1:length(FieldList)
                            ThisFieldName=FieldList{Ifl};
                            ThisFieldVal=ThisPropValElement.(ThisFieldName);
                            if strcmpi(ThisFieldName,'Matl')  %Materials must be treated differently becasue they are a cell array of strings
                                if isempty(ThisFieldVal)                            %Specificly for Matieral Field
                                    ThisFieldVal={''};                                 %Specificly for Matieral Field
                                elseif ischar(ThisFieldVal)                         %Specificly for Matieral Field
                                    ThisFieldVal=ThisFieldVal(ThisFieldVal~=' '); %Remove spaces     %Specificly for Matieral Field
                                    ThisFieldVal=split(ThisFieldVal,','); %Separate by commas     %Specificly for Matieral Field
                                elseif iscell(ThisFieldVal)                         %Specificly for Matieral Field
                                    ThisFieldVal=ThisFieldVal;                         %Specificly for Matieral Field
                                end                                                 %Specificly for Matieral Field
                                for Imat=1:length(ThisFieldVal)
                                    if isempty(TCMmaster.MatLib.GetMatName(ThisFieldVal{Imat}))
                                        ErrText=[ErrText sprintf('Material ''%s'' does not exist in the library\n',ThisFieldVal{Imat})];
                                        ThisFieldVal{Imat}='XXXX';
                                    end
                                end
                                ThisFieldVal=ThisFieldVal(~strcmpi(ThisFieldVal,'XXXX'));
                                TCMout=ExpandTCM(TCMout, ThisFieldVal, ThisPropName, Ipe, ThisFieldName);
                            elseif ismember(ThisFieldName,{'Q'})  %Q treated differently since they are more than 1 element
                                if isempty(ThisFieldVal) || (isnumeric(ThisFieldVal) && length(ThisFieldVal(1,:))==2) %Q is a table
                                    %Do Nothing at this point as tables don't allow parameters
                                elseif isnumeric(ThisFieldVal) && isscalar(ThisFieldVal)
                                    %Do nothing, it's a scalar number
                                elseif ischar(ThisFieldVal) %Could be a parameter or a function
                                    try %Try without defining 't', should be numeric
                                        if exist('t','var')
                                            Old_t=t;
                                        else
                                            Old_t=[];
                                        end
                                        clear t
                                        EvalString='';
                                        EvalString=[EvalString sprintf('ThisFieldVal=%s;\n',ThisFieldVal)];
                                        eval(EvalString)
                                        t=Old_t;
                                    catch ME
                                        try
                                            %ThisFieldVal will be an array of functions if the functional form of Q evaluates to multiple functions
                                            ThisFieldVal={ThisFieldVal}; %Esnures ThisFieldVal is a cell whether or not eval succedes.
                                            ThisFieldVal=TCMmaster.GenQFunction(ThisFieldVal{1}, VariableList);  %Output will ALWAYS be a cell array
                                            eval(['TestFn=@(t)' ThisFieldVal{1} ';']);
                                            TestFn(0);

%                                             for Itfv=1:length(Qtext)
%                                                 eval(sprintf('ThisFieldVal{%.0f}=@(t)%s;',Itfv,Qtext{Itfv}))
%                                             end
%                                             if obj.SymAvail
%                                                 t=sym('t'); %Get expression as a function of t
%                                                 eval(['ThisFieldValTest=' ThisFieldVal ''])
%                                                 %if length(ThisFieldValTest)>1
%                                                     ThisFieldVal={};
%                                                     for Itfvt=1:length(ThisFieldValTest)
%                                                         ThisFieldVal{Itfvt}=char(ThisFieldValTest(Itfvt));
%                                                     end
%                                                 %end
%                                             else
%                                                 eval(['ThisFieldValTest=' ThisFieldVal ''])
%                                                 ThisFieldVal={ThisFieldValTest};
%                                             end
                                        catch ME
                                            ErrText=[ErrText sprintf('Unknown equation form of Q in TCM.%s(%.0f).%s=%s\n',ThisPropName, Ipe, ThisFieldName,ThisFieldVal{1})];
                                            ThisFieldVal=[];
                                        end
                                    end
                                    TCMout=ExpandTCM(TCMout, ThisFieldVal, ThisPropName, Ipe, ThisFieldName);
                                else
                                    ErrText=[ErrText sprintf('Unknown form of Q in TCM.%s(%.0f).%s(%.0f).Q\n',ThisFieldValElement,ThisPropName, Ipe, ThisFieldName,Ife)];
                                end
                            elseif ismember(ThisFieldName,{'x', 'y', 'z'})  %X, Y, Z treated differently since they are more than 1 element
                                if isnumeric(ThisFieldVal)
                                    ThisFieldVal=num2cell(ThisFieldVal);
                                end
                                for Ife=1:length(ThisFieldVal)  %Go through each element of the field
                                    ThisFieldValElement=ThisFieldVal{Ife};
                                    if ischar(ThisFieldValElement)
                                        try
                                            eval(['ThisFieldValElement=' ThisFieldValElement ';'])
                                            if ~isnumeric(ThisFieldValElement)
                                                ErrText=[ErrText sprintf('Non-numeric: "%s" for TCM.%s(%.0f).%s(%.0f)\n',ThisFieldValElement,ThisPropName, Ipe, ThisFieldName,Ife)];
                                                ThisFieldValElement=[];
                                            end
                                        catch ME
                                            ErrText=[ErrText sprintf('Cannot evaluate "%s" for TCM.%s(%.0f).%s(%.0f)\n',ThisFieldValElement,ThisPropName, Ipe, ThisFieldName,Ife)];
                                            ThisFieldValElement=[];
                                        end
                                    end
                                    TCMout=ExpandTCM(TCMout, ThisFieldValElement, ThisPropName, Ipe, ThisFieldName, Ife);
                                end
                            else %Single valued fields
                                if ischar(ThisFieldVal)
                                    try
                                        eval(['ThisFieldVal=' ThisFieldVal ';'])
                                        if  ~isnumeric(ThisFieldVal)
                                            ErrText=[ErrText sprintf('Non-numeric: "%s" for TCM.%s(%.0f).%s\n',ThisFieldVal,ThisPropName, Ipe, ThisFieldName)];
                                            ThisFieldVal=[];
                                        end
                                    catch ME
                                        ErrText=[ErrText sprintf('Cannot evaluate "%s" for TCM.%s(%.0f).%s\n',ThisFieldVal,ThisPropName, Ipe, ThisFieldName)];
                                        ThisFieldVal=[];
                                    end
                                end
                                TCMout=ExpandTCM(TCMout, ThisFieldVal, ThisPropName, Ipe, ThisFieldName);
                            end
                        end
                    end
                else
                    if ischar(ThisPropVal)
                        try
                            eval(['ThisPropVal=' ThisPropVal ';']) 
                            if  ~isnumeric(ThisPropVal)
                                ErrText=[ErrText sprintf('Non-numeric value: "%s" for TCM.%s\n',ThisFieldVal,ThisPropName)];
                                ThisPropVal=[];
                            end
                        catch ME
                            ErrText=[ErrText sprintf('Cannot evaluate "%s" for TCM.%s\n',ThisPropVal,ThisPropName)];
                            ErrText=[ErrText 'Cannot evaluate element ' ThisPropName ' = ' ThisPropVal char(10)  ];
                            ThisPropVal=[];
                        end
                    end
                    TCMout=ExpandTCM(TCMout, ThisPropVal, ThisPropName);
                end
            end
            [TCMout.iExpanded]=deal(true);
            if ~isempty(ErrText)
                warning([char(10) ErrText])
                TCMout=ErrText;
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
            if obj.iExpanded
                for I=1:length(FeaturesOut)
                    NumX=cell2mat(FeaturesOut(I).x);
                    NumY=cell2mat(FeaturesOut(I).y);
                    NumZ=cell2mat(FeaturesOut(I).z);
                    FeaturesOut(I).x=NumX;
                    FeaturesOut(I).y=NumY;
                    FeaturesOut(I).z=NumZ;
                end
            end
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
                    ErrText=sprintf('%s Field %s is not a valid  feature fieldname\n',ErrText,Fields{Fi});
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
            obj.SymAvail=license('test','symbolic_toolbox');
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
    elseif ischar(Values)
        Values={Values};
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
