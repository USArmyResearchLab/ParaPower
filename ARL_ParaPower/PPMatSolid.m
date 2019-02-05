classdef PPMatSolid < PPMat
    
    properties (Access=public)
        cte     {mustBeNumeric(cte), mustBeReal(cte)}   = NaN
        E       {mustBeNumeric(E), mustBeReal(E)}     = NaN
        nu      {mustBeNumeric(nu), mustBeReal(nu)}    = NaN
        k       {mustBeNumeric(k), mustBeReal(k)}     = NaN
        rho     {mustBeNumeric(rho), mustBeReal(rho)}   = NaN
        cp      {mustBeNumeric(cp), mustBeReal(cp)}    = NaN
    end
    
    methods 
        function OutText=ParamDesc(obj, Param)
            OutText='';
            switch lower(Param)
                case 'cte'
                    OutText='CTE deg';
                case 'e'
                    OutText='Young''s Mod';
                case 'nu'
                    OutText='Poisson''s Ratio';
                case 'k'
                    OutText='Conductivity';
                case 'rho'
                    OutText='Density';
                case 'cp'
                    OutText='Specific Heat';
                otherwise
                    OutText=ParamDesc@PPMat(obj, Param);
            end
        end
    end
    
    methods
        function [obj]=PPMatSolid(varargin)
            %Default Values
            Type='Solid';
            cte=nan;
            E=nan;
            nu=nan;
            k=nan;
            rho=nan;
            cp=nan;
            
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
                    case obj.strleft('cte',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        cte=Value;
                    case obj.strleft('e',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        E=Value;
                    case obj.strleft('nu',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        nu=Value;
                    case obj.strleft('k',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        k=Value;
                    case obj.strleft('rho',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        rho=Value;
                    case obj.strleft('cp',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        cp=Value;
                        
                    otherwise
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        obj.PropValPairs=[Prop Value obj.PropValPairs ];
                end
            end
            obj.CheckProperties(mfilename('class'));  %Checks for left over properties.

            obj.cte=cte;
            obj.E=E;
            obj.nu=nu;
            obj.k=k;
            obj.rho=rho;
            obj.cp=cp;
        end
    end
end
