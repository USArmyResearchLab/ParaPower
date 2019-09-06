classdef PPMatSCPCM < PPMatPCM
%Material type SuperCooledPhaseChangeMaterial.
%To define a new material instance
%   PPMatSCPCM('Prop_Name_1', Prop_Value_1, 'Prop_Name_2', Prop_Value_2, etc)
%
%The following Prop_Names can be defined
%   Name
%   cte     Coeff. Thermal Expansion
%   E       Young's Modulus
%   nu      Poisson's ratio
%   k       Conductivity
%   rho     Density
%   cp      Specific Heat
%   k_l     Liquid conductivity
%   rho_l   Liquid Density
%   cp_l    Liquid specific heat
%   lf      Latent heat of fusion
%   tmelt   Melting temperature   
%   dT_Nucl Nucleation delta temperature

    properties (Access=public)
        dT_Nucl     = NaN %{mustBeNumeric(dT_Nucl), mustBeReal(dT_Nucl)}   = NaN
    end
    
    
    methods
        function OutText=ParamDesc(obj, Param)
            OutText='';
            %fprintf('%s sees %s: Sclass is %s\n',mfilename,class(obj),obj.SClass)
            switch lower(Param)
                case 'dt_nucl'
                    OutText='Nucl Delta Temp (K)';
                otherwise
                    OutText=ParamDesc@PPMatPCM(obj, Param);
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
