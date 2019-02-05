classdef PPMatSCPCM < PPMatPCM
    
    properties (Access=public)
        dT_Nucl     {mustBeNumeric(dT_Nucl), mustBeReal(dT_Nucl)}   = NaN
    end
    
    
    methods
        function OutText=ParamDesc(obj, Param)
            OutText='';
            switch lower(Param)
                case 'dt_nucl'
                    OutText='Nucleation Delta Temp';
                otherwise
                    OutText=ParamDesc@PPMat(obj, Param);
            end
        end
        
        function [obj]=PPMatSCPCM(varargin)
            %Default Values
            Type='SCPCM';
            dT_Nucl=nan;
            
            if nargin == 1 & ~iscell(varargin{1})
                Name=varargin{1};
                varargin={'name' Name};
            elseif nargin == 1 & iscell(varargin{1})
                varargin=varargin{1};
            end
            obj=obj@PPMatPCM([ 'type' Type varargin]);
            
            PropValPairs=obj.PropValPairs;
            obj.PropValPairs={};
            while ~isempty(PropValPairs) 
                [Prop, PropValPairs]=obj.Pop(PropValPairs);
                if ~ischar(Prop)
                    error('Property name must be a string.');
                end
                Pl=length(Prop);
                %disp(Prop)
                switch lower(Prop)
%                     case obj.strleft('name',Pl)
%                         [Value, PropValPairs]=obj.Pop(PropValPairs); 
%                         Name=Value;
                    case obj.strleft('dt_nucl',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        dT_Nucl=Value;
                    otherwise
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        obj.PropValPairs=[Prop Value obj.PropValPairs ];
                end
            end
            obj.CheckProperties(mfilename('class'));
            
            obj.dT_Nucl = dT_Nucl;
        end
    end
end
