classdef scPPT < sPPT
    
    properties (Access = protected)
        sc_mask
    end
    
    methods (Access = protected)
        function setupImpl(obj)
            setupImpl@sPPT(obj);
            obj.sc_mask=strcmp(obj.MI.MatLib.Type(obj.Mat(obj.Map)),'SCPCM');
            %future: create submasks for each scPCM type to disallow
            %propagation
        end
        
        function [obj,changing]=ph_ch_hook(obj,changing,it)
            sc_mask=obj.sc_mask
            priorPH=obj.PH(:,it-1);
            newPH=obj.PH(:,it);
            %curate a list of active/triggered supercoolable elements
            %three criteria
            %1 able to melt and/or continue freezing ... PH<1
            %2 satisfies local nucleation rule ... e.g.  T<=T_nuc
            %3 satisfies propagation rule ... e.g. ..... any(PH_nn=0)
            state=zeros(numel(sc_mask),3);
            state(sc_mask,1)=priorPH(sc_mask)<1;  %1
            state(sc_mask,2)=obj.T(sc_mask,it)<=T_nuc(obj.Mat(obj.Map(sc_mask))); %2
            
            prop = true;
            while prop
                state(sc_mask,3)=priorPH(sc_mask)==0;  %propogation threshold
                state(sc_mask,3)=sc_mask & find((obj.A.adj*state(sc_mask,3))>0);  %3
                %find not only those elements changing, but those touched by changing elements
                
                sc_trig=any(state,2); %if an element satisfies any of the three criteria, it is eligable for phch
                
                
                [obj.T(:,it),newPH,sc_changing,obj.K,obj.CP,obj.RHO]=vec_Phase_Change(obj.T(:,it),priorPH,obj.Mat,obj.Map,sc_trig,...
                    obj.MI.MatLib.k,obj.MI.MatLib.k_l,obj.MI.MatLib.cp,obj.MI.MatLib.cp_l,obj.MI.MatLib.rho,obj.MI.MatLib.rho_l,...
                    obj.MI.MatLib.tmelt,obj.Lv,obj.K,obj.CP,obj.RHO);   %These arguments need to be restructured
                %did any new elements hit PH==0?
                prop = any(min(state(sc_mask,3)-(newPH==0),0)); %was using xor
                if prop
                    priorPH=newPH;
                end
            end
            
            obj.PH(:,it)=newPH;
            changing = sc_changing | changing; %update changing to include changing supercoolable elements
            end
    end
        
end
                                                                        
                                                                        