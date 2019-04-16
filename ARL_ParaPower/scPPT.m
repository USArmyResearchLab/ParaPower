classdef scPPT < sPPT
    
    properties (Access = protected)
        sc_mask
    end
    
    methods
        % Constructor
        function obj = scPPT(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods (Access = protected)
        function setupImpl(obj)
            setupImpl@sPPT(obj);
            Types=obj.MI.MatLib.GetParam('Type');
            obj.sc_mask=strcmp(Types(obj.Mat(obj.Map)),'SCPCM');
            %meltable Y/N      scPCM?   Y   N
            %---------------------------------
            %PCM?           Y           Y   Y
            %               N           Y*  N
            if nnz(obj.sc_mask)>0 && ~obj.meltable  %* handling
                obj.meltmask=zeros(size(obj.sc_mask));  %otherwise changing is []
                obj.meltable=true;  %we need to trigger the phasechange subroutine
            end
            %future: create submasks for each scPCM type to disallow propagation
            %
        end
        
        function [obj,T,PH,changing] = ph_ch_hook(obj,T,PH,changing,it)
            sc_mask=obj.sc_mask;
            if nnz(sc_mask)==0
                return
            end
            prop_thres=0;                   %hardcode for testing.
            T_nucM=obj.MI.MatLib.GetParamVector('dT_Nucl');
            T_nucM=obj.MI.MatLib.GetParamVector('tmelt')-T_nucM;
            
            T_nuc=zeros(size(sc_mask));
            T_nuc=T_nucM(obj.Mat(obj.Map));
            
            T_nuc=T_nuc(sc_mask);
%            T_nuc=obj.MI.MatLib.dT_Nucl(obj.Mat(obj.Map(sc_mask)));
%            T_nuc=obj.MI.MatLib.tmelt(obj.Mat(obj.Map(sc_mask)))-T_nuc;
            %T_nuc is a list of sc nucleation temps of size(sc_mask)
            priorPH=PH(:,it-1);
            newPH=PH(:,it); %zeros
            %curate a list of active/triggered supercoolable elements
            %three criteria
            %1 able to melt and/or continue freezing ... PH<1
            %2 satisfies local nucleation rule ... e.g.  T<=T_nuc
            %3 satisfies propagation rule ... e.g. ..... any(PH_nn=0)
            state=zeros(numel(sc_mask),3);
            state(sc_mask,1)=priorPH(sc_mask)<1;  %1
            state(sc_mask,2)=T(sc_mask,it)<=T_nuc; %2
           
            state(sc_mask,3)=priorPH(sc_mask)<=prop_thres;  %propogation threshold
            
            if numel(state(sc_mask,3))>0
                state(sc_mask,3)=state(sc_mask,3) | (obj.Aj.adj(sc_mask,sc_mask)*state(sc_mask,3))>0;  %3
                %find not only those elements changing, but those touched by changing elements
            end
            newtouch=state(:,3);  %initialize
            
            prop = true;
            T_iter = T(:,it);
        
            while prop
                sc_trig=any(state,2); %if an element satisfies any of the three criteria, it is eligable for phch
                
                
                [T_iter,newPH,sc_changing,obj.K,obj.CP,obj.RHO]=obj.vec_Phase_Change(T_iter,priorPH,obj.Mat,obj.Map,sc_trig ...
                    ,obj.MI.MatLib.GetParamVector('k') ...
                    ,obj.MI.MatLib.GetParamVector('k_l') ...
                    ,obj.MI.MatLib.GetParamVector('cp') ...
                    ,obj.MI.MatLib.GetParamVector('cp_l') ...
                    ,obj.MI.MatLib.GetParamVector('rho') ...
                    ,obj.MI.MatLib.GetParamVector('rho_l') ...
                    ,obj.MI.MatLib.GetParamVector('tmelt') ...
                    ,obj.Lv,obj.K,obj.CP,obj.RHO);   %These arguments need to be restructured
                
                %did any new elements hit PH==0?
                
                newtouch(sc_mask)=newPH(sc_mask)<=prop_thres;  %propogation threshold
                
                if numel(newtouch(sc_mask))>0
                    newtouch(sc_mask)=newtouch(sc_mask) | (obj.Aj.adj(sc_mask,sc_mask)*newtouch(sc_mask))>0;  %3
                    %find not only those elements changing, but those touched by changing elements
                end

                prop = any(newtouch(sc_mask) & xor(state(sc_mask,3),newtouch(sc_mask))); %was using xor
                if prop
                    priorPH=newPH;
                    state(sc_mask,3)=newtouch(sc_mask);
                end
            end
            T(:,it)=T_iter;
            PH(:,it)=newPH;
            changing = sc_changing | changing; %update changing to include changing supercoolable elements
        end
    end
        
end
                                                                        
                                                                        