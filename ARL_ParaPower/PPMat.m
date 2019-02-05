classdef PPMat
    
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
                            [Value, PropValPairs]=obj.Pop(PropValPairs); 
                            obj.PropValPairs=[Prop Value obj.PropValPairs ];
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
    
