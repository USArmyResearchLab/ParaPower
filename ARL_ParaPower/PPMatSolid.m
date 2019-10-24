classdef PPMatSolid < PPMat
%Material type Solid.
%To define a new material instance
%   PPMatSolid('Prop_Name_1', Prop_Value_1, 'Prop_Name_2', Prop_Value_2, etc)
%
%The following Prop_Names can be defined
%   Name
%   cte     Coeff. Thermal Expansion
%   E       Young's Modulus
%   nu      Poisson's ratio
%   k       Conductivity
%   rho     Density
%   cp      Specific Heat

    properties (Access=public)
        cte     = NaN %{mustBeNumeric(cte), mustBeReal(cte)}   = NaN
        E       = NaN %{mustBeNumeric(E), mustBeReal(E)}     = NaN
        nu      = NaN %{mustBeNumeric(nu), mustBeReal(nu)}    = NaN
        k       = NaN %{mustBeNumeric(k), mustBeReal(k)}     = NaN
        rho     = NaN %{mustBeNumeric(rho), mustBeReal(rho)}   = NaN
        cp      = NaN %{mustBeNumeric(cp), mustBeReal(cp)}    = NaN
    end
    
    methods 
        function OutText=ParamDesc(obj, Param)
            OutText='';
            %fprintf('%s sees %s: Sclass is %s\n',mfilename,class(obj),obj.SClass)
            switch lower(Param)
                case 'cte'
                    OutText='CTE (1/K)';
                case 'e'
                    OutText='Young''s Mod (Pa)';
                case 'nu'
                    OutText='Poisson''s Ratio';
                case 'k'
                    OutText='Conductivity (W/m-K)';
                case 'rho'
                    OutText='Density (kg/m^3)';
                case 'cp'
                    OutText='Specific Heat (J/kg-K)';
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
