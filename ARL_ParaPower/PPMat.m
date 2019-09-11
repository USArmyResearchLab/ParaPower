classdef PPMat
%classdef PPMat
%  Properties
%     Name - name of the material
%     Type - material type (neadonly)
%     MaxPlot - Does this material appear in the "MaxPlot" graph
%
%  Methods
%     ParamList - List parameter of this material (w/o name/type)
%     ParamDesc(Param) - Descriptor for Param
%
%------ Below information is for adding a new material -----
%
%%classdef PPMat - Abstract class that is not used directly but from which
%%new materials must be derived.
%% 
%%To derive a new material use the following template.  Lines with a %ADD
%%need to be modified for the new material.
%%
%classdef PPMatNew < PPMatOld %ADD (PPMatNew is the new material name 
%                             %which must start with PPMat. PPMatOld is the 
%                             %materal from which the new one is being derived)
%     
%     properties (Access=public)
%         NewProp1   {mustBeNumeric(NewProp1), mustBeReal(NewProp1)}   = NaN  %ADD
%         NewProp2   {mustBeNumeric(NewProp2), mustBeReal(NewProp2)}   = NaN  %ADD
%     end
%     
%     methods
% 
%         function OutText=ParamDesc(obj, Param)
%             OutText='';
%             switch lower(Param)       %Note that the 'cases' must be lower case!
%                 case 'newprop1'  %Must be lowercase.  %ADD 
%                     OutText='newprop1 Description';   %ADD
%                 case 'newprop2'                       %ADD
%                     OutText='newprop2 Description';   %ADD 
%                 otherwise
%                     OutText=ParamDesc@PPMatOld(obj, Param);  %ADD Change this to immediate superclass
%             end
%         end
%         
%         function [obj]=PPMatNew(varargin)  %ADD Name of this function must match the class name
%             %Default Values
%             Type='New';            %ADD  This is the new material type
%                                    %     which must match the text following 
%                                    %     PPMat in the class name
%             NewProp1=nan;          %ADD Default values of new properties
%             NewProp1=nan;          %ADD
%             
%             if nargin == 1 & ~iscell(varargin{1})
%                 Name=varargin{1};
%                 varargin={'name' Name};
%             elseif nargin == 1 & iscell(varargin{1})
%                 varargin=varargin{1};
%             end
%             obj=obj@PPMatOld([ 'type' Type 'NoExpandProps' {'Prop1' 'Prop2'} varargin]); %ADD this must be updated to an immediate superclass constructor
%             
%             PropValPairs=obj.PropValPairs;
%             obj.PropValPairs={};
%             while ~isempty(PropValPairs) 
%                 [Prop, PropValPairs]=obj.Pop(PropValPairs);
%                 if ~ischar(Prop)
%                     error('Property name must be a string.');
%                 end
%                 Pl=length(Prop);
%                 %disp(Prop)
%                 switch lower(Prop)  %Note that 'cases' must be lower!
%                     case obj.strleft('newprop1',Pl)                     %ADD
%                         [Value, PropValPairs]=obj.Pop(PropValPairs);    %ADD
%                         obj.newprop1=Value;                             %ADD
%                     case obj.strleft('newprop2',Pl)                     %ADD
%                         [Value, PropValPairs]=obj.Pop(PropValPairs);    %ADD
%                         obj.newprop2=Value;                             %ADD
%                     otherwise
%                         [Value, PropValPairs]=obj.Pop(PropValPairs); 
%                         obj.PropValPairs=[Prop Value obj.PropValPairs ];
%                 end
%             end
%             obj.CheckProperties(mfilename('class'));  %Checks for left over properties.
%         end
%     end
% end

%

    %Note that some admin values are defined as static functions so that
    %they do not appear as properties.
    
    properties (Access=public)
        Name    {mustBeChar(Name)} 
        MaxPlot {CheckLogical(MaxPlot)} = true
    end
    properties (Access = protected)
        PropValPairs = {}
    end
    properties (SetAccess = immutable)
        Type  
%        NoExpandProps %Properties that will not be expanded by eval
    end
    
    %properties (SetAccess = immutable)
    %    NoParam = {'NoExpandProps' 'NoParam' 'ValidChars'};
    %end
%     
%     properties (SetAccess = protected) %This should also be immutable
%         SClass
%     end
%     properties (SetAccess = protected)
%         PropValPairs
%     end

    methods (Static=true)
        function Out=strleft(S,n)
            Out=S(1:min(n,length(S)));
        end
        
        function [Val, PV]=Pop(PV) 
            if length(PV)>=1
                Val=PV{1};
            else
                Val={};
            end
            if length(PV)>=2
                PV=PV(2:end);
            else
                PV={};
            end
        end
        
        function P=NoExpandProps()  %Defined as a function so that it doesn't appear in properties.
            P={'NoExpandProps'};
        end
        
        function C=ValidChars()
            C=char([char('0'):char('9') '_' char('a'):char('z') char('A'):char('Z')]);
        end
        
     end
    
    methods (Access = protected)
        function CheckProperties (obj, MfileClass)
            if ~isempty(obj.PropValPairs) & strcmpi(class(obj),MfileClass)
                for I=1:2:length(obj.PropValPairs)
                    warning('Property "%s" is an unknown "%s" material property (%s)',obj.PropValPairs{I}, obj.Type, class(obj))
                end
            end
        end
        
    end

    methods 
        function Params= ParamList(obj, IncludeNameType)
            if ~exist('IncludeNameType','var')
                IncludeNameType=false;
            end
            if strcmpi(class(obj),'PPMatNull')
                TempMat=PPMat;
                Params=TempMat.ParamList;
            else
                Params=properties(obj);
                Params=Params(~strcmpi(Params,'name'));
                Params=Params(~strcmpi(Params,'type'));
                %Params=Params(~strcmpi(Params,'maxplot'));
                Params=Params(~strcmpi(Params,'ValidChars'));
                Params=Params(~strcmpi(Params,'NoExpandProps'));
            end
            if IncludeNameType
                Params=['Name'; 'Type'; Params];
            end
        end
        function OutText=ParamDesc(obj, Param)
           OutText='';
           %fprintf('%s sees %s: Sclass is %s\n',mfilename,class(obj),obj.SClass)
           switch lower(Param)
                case 'name'
                    OutText='Name';
                case 'type'
                    OutText='Type';
                case 'maxplot'
                    OutText='Show in Pk Plots (T/F)';
                
                %otherwise
                %    if isempty(OutText)
                %        warning('Material type %s does not have a descriptor for parameter %s.',obj.Type,Param);
                %    end
            end
        end
        
        function obj =PPMat(varargin)
        % O = PPMat('Material_Name');
        % O = PPMat('type','Material_Type', 'Name', 'Material_Name');
        % O = PPMat();  Default Type=Base, Name=''
            Type='Abstract';
            Name='';
            MaxPlot=true;
            NoExpandProps={'Name' 'Type'};
            PropValPairs={};
            obj.PropValPairs={};
            if nargin==1 & ~iscell(varargin{1})
                Name=varargin{1};
            else
                if nargin==1 & iscell(varargin{1})
                    PropValPairs=varargin{1};
                elseif nargin > 1
                    PropValPairs=varargin;
                end
                while ~isempty(PropValPairs) 
                    [Prop, PropValPairs]=obj.Pop(PropValPairs);
                    if ~ischar(Prop)
                        disp(Prop)
                        error('Property name must be a string. ');
                    end
                    Pl=length(Prop);
                    %disp(Prop)
                    switch lower(Prop)
                        case obj.strleft('name',Pl)
                            [Value, PropValPairs]=obj.Pop(PropValPairs);
                            Spaces=findstr(Value,' ');
                            if isempty(Spaces)
                                Name=Value;
                            else
                                Name=Value;
                                Name(Spaces)='_';
                                warning('Material name ''%s'' cannot cantain spaces. Name changed to ''%s''',Value,Name);
                            end
                            
                            if ~all(ismember(Name,obj.ValidChars))
                                warning(sprintf('Material name "%s" can contain only alphanumerics.',Name))
                            end
                        case obj.strleft('type',Pl)
                            [Value, PropValPairs]=obj.Pop(PropValPairs); 
                            if ischar(Value)
                                Type=Value;
                            else
                                error('Material type must be of type char')
                            end
                        case obj.strleft('maxplot',Pl)
                            [Value, PropValPairs]=obj.Pop(PropValPairs); 
                            if strcmpi(Value,'true') || strcmpi(Value,'t')
                                Value=true;
                            elseif strcmpi(Value,'false') || strcmpi(Value,'f')
                                Value=false;
                            end
                            CheckLogical(Value);
                            Value=logical(Value);
                            MaxPlot=Value;
                        case obj.strleft('noexpandprops',Pl)
                            [Value, PropValPairs]=obj.Pop(PropValPairs); 
                            if ischar(Value)
                                Value={Value};
                            end
                            for Vi=1:length(Value)
                                NoExpandProps = [NoExpandProps Value{Vi}];
                            end
                        otherwise
                            if isempty(PropValPairs)
                                PropValPairs={'Name' Prop};
                            else
                                [Value, PropValPairs]=obj.Pop(PropValPairs); 
                                obj.PropValPairs=[Prop Value obj.PropValPairs ];
                            end
                    end
                end
            end
%            obj.SClassList=superclasses(obj);
%             if ~isempty(S)
%                 obj.SClass=S{1};
%             else
%                 obj.SClass='PPMat';
%             end
            obj.Name=Name;
            obj.Type=Type;
            obj.MaxPlot=MaxPlot;
            %obj.NoExpandProps=NoExpandProps;
            obj.CheckProperties(mfilename('class'));

        end
    end
end

function mustBeChar(Value)
    if ~isempty(Value) & ~ischar(Value)
        error('Value must be a character.')
    end
end

function CheckLogical(Value)
    if ~islogical(Value)
        if ~(Value==0 | Value ==1)
            error('Value must be a logical/boolean.')
        end
    end
end
