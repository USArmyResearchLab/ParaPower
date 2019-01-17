classdef hookPPT < sPPT
    
    properties (DiscreteState)
        bdry_watts
    end
    
    methods (Access = protected)
        function obj = pre_step_hook(obj)
            obj.bdry_watts = NaN(length(obj.Ta_vec),length(obj.GlobalTime)-1);
        end  
        
        function obj = post_step_hook(obj)
            %derive and overload me to insert postprocessing hook
            flux=obj.ExternalFlux(obj.T,obj.B,obj.Ta_vec);
            step=find(isnan(obj.bdry_watts(1,:)),1);
            obj.bdry_watts(:,step)=sum(flux,1)';
        end
        
        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end