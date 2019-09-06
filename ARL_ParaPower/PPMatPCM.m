classdef PPMatPCM < PPMatSolid
%Material type Phase Change Material.
%To define a new material instance
%   PPMatPCM('Prop_Name_1', Prop_Value_1, 'Prop_Name_2', Prop_Value_2, etc)
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
    
    properties (Access=public)
        k_l         = NaN %{mustBeNumeric(k_l), mustBeReal(k_l)}   = NaN
        rho_l       = NaN %{mustBeNumeric(rho_l), mustBeReal(rho_l)}     = NaN
        cp_l        = NaN %{mustBeNumeric(cp_l), mustBeReal(cp_l)}    = NaN
        lf          = NaN %{mustBeNumeric(lf), mustBeReal(lf)}     = NaN
        tmelt       = NaN %{mustBeNumeric(tmelt), mustBeReal(tmelt)}   = NaN
    end
    
    
    methods
        function OutText=ParamDesc(obj, Param)
            OutText='';
            %fprintf('%s sees %s: Sclass is %s\n',mfilename, class(obj), obj.SClass)
            switch lower(Param)
                case 'k_l'
                    OutText='Cond.-liq (W/m-K)';
                case 'rho_l'
                    OutText='Density-liq (kg/m^3)';
                case 'cp_l'
                    OutText='Spec. Ht-liq (J/kg-K)';
                case 'lf'
                    OutText='Latent Ht Fusion (J/kg)';
                case 'tmelt'
                    OutText='Melt Temp (C)';
                otherwise
                    OutText=ParamDesc@PPMatSolid(obj, Param);
            end
        end
        
        function [obj]=PPMatPCM(varargin)
            %Default Values
            Type='PCM';
            k_l=nan;
            rho_l=nan;
            cp_l=nan;
            lf=nan;
            tmelt=nan;
            
            if nargin == 1 & ~iscell(varargin{1})
                Name=varargin{1};
                varargin={'name' Name};
            elseif nargin == 1 & iscell(varargin{1})
                varargin=varargin{1};
            end
            obj=obj@PPMatSolid([ 'type' Type varargin]);
            
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
                    case obj.strleft('k_l',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        k_l=Value;
                    case obj.strleft('rho_l',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        rho_l=Value;
                    case obj.strleft('cp_l',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        cp_l=Value;
                    case obj.strleft('lf',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        lf=Value;
                    case obj.strleft('tmelt',Pl)
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        tmelt=Value;
                    otherwise
                        [Value, PropValPairs]=obj.Pop(PropValPairs); 
                        obj.PropValPairs=[Prop Value obj.PropValPairs ];
                end
            end
            obj.CheckProperties(mfilename('class'));
            
            obj.k_l     =k_l;
            obj.rho_l   =rho_l;
            obj.cp_l    =cp_l;
            obj.lf      =lf;
            obj.tmelt   =tmelt;
        end
    end
end
