classdef PPMat
%classdef PPMat - Abstract class that is not used directly but from which
%new materials must be derived.
%
%To derive a new material use the following template.  Lines with a %ADD
%need to be modified for the new material.
%
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
%                     OutText=ParamDesc@PPMat(obj, Param);
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
%             obj=obj@PPMat([ 'type' Type varargin]);
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
    
    properties (Access=public)
        Name    {mustBeChar(Name)} 
    end
    properties (Access = protected)
        PropValPairs = {}
    end
    properties (SetAccess = immutable)
        Type  
    end
    
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
        function OutText=ParamDesc(obj, Param)
            OutText='';
            switch lower(Param)
                case 'name'
                    OutText='Name';
                case 'type'
                    OutText='Type';
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
                            Name=Value;
                        case obj.strleft('type',Pl)
                            [Value, PropValPairs]=obj.Pop(PropValPairs); 
                            if ischar(Value)
                                Type=Value;
                            else
                                error('Material type must be of type char')
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
            obj.Name=Name;
            obj.Type=Type;
            obj.CheckProperties(mfilename('class'));

        end
    end
end

function mustBeChar(Value)
    if ~isempty(Value) & ~ischar(Value)
        error('Value must be a character.')
    end
end
    
