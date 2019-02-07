classdef PPMatIBC < PPMat
    
    properties (Access=public)
        h_ibc   {mustBeNumeric(h_ibc), mustBeReal(h_ibc)}   = NaN
        T_ibc   {mustBeNumeric(T_ibc), mustBeReal(T_ibc)}     = NaN
    end
    
    methods

        function OutText=ParamDesc(obj, Param)
            OutText='';
            switch lower(Param)
                case 'h_ibc'
                    OutText='IBC heat flux';
                case 't_ibc'
                    OutText='IBC Temp.';
                otherwise
                    OutText=ParamDesc@PPMat(obj, Param);
            end
        end
        
        function [obj]=PPMatIBC(varargin)
            %Default Values
            Type='IBC';
            h_ibc=nan; 
            T_ibc=nan;
            
            if nargin == 1 & ~iscell(varargin{1})
                Name=varargin{1};
                varargin={'name' Name};
            elseif nargin == 1 & iscell(varargin{1})
                varargin=varargin{1};
            end
            obj=obj@PPMat([ 'type' Type varargin]);
            
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
                    case obj.strleft('h_ibc',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        h_ibc=Value;
                    case obj.strleft('t_ibc',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        T_ibc=Value;
                    otherwise
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        obj.PropValPairs=[Prop Value obj.PropValPairs ];
                end
            end
            obj.CheckProperties(mfilename('class'));  %Checks for left over properties.

            obj.h_ibc=h_ibc;
            obj.T_ibc=T_ibc;
        end
    end
end
