classdef PPMatPCM < PPMatSolid
    
    properties (Access=public)
        k_l         {mustBeNumeric(k_l), mustBeReal(k_l)}   = NaN
        rho_l       {mustBeNumeric(rho_l), mustBeReal(rho_l)}     = NaN
        cp_l        {mustBeNumeric(cp_l), mustBeReal(cp_l)}    = NaN
        lf          {mustBeNumeric(lf), mustBeReal(lf)}     = NaN
        tmelt       {mustBeNumeric(tmelt), mustBeReal(tmelt)}   = NaN
    end
    
    
    methods
        function OutText=ParamDesc(obj, Param)
            OutText='';
            switch lower(Param)
                case 'k_l'
                    OutText='Conductivity (liq)';
                case 'rho_l'
                    OutText='Density (liq)';
                case 'cp_l'
                    OutText='Specific Heat (liq)';
                case 'lf'
                    OutText='Liquid Fraction';
                case 'tmelt'
                    OutText='Melt Temp';
                otherwise
                    OutText=ParamDesc@PPMat(obj, Param);
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
