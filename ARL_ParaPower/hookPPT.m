classdef hookPPT < sPPT
    
    properties (Access = protected)%(DiscreteState)
        bdry_watts
    end
    
    methods (Access = protected)
        function [bdry_watts] = stepImpl(obj,GlobalTime,htcs,Ta_vec)
            obj.htcs=htcs;
            obj.Ta_vec=Ta_vec;
            [~]=stepImpl@sPPT(obj,GlobalTime);
            bdry_watts=obj.bdry_watts;            
        end
        
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
        
        function icon = getIconImpl(obj)
            % Define icon for System block
            icon = mfilename("sPPT"); % Use class name
            % icon = "My System"; % Example: text icon
            % icon = ["My","System"]; % Example: multi-line text icon
            % icon = matlab.system.display.Icon("myicon.jpg"); % Example: image file icon
        end     
        
        function outsz = getOutputSizeImpl(obj)
            numsteps = propagatedInputSize(obj,1);
            outsz = [10 numsteps(2)];  %10 being the number of nodes in the input model
        end        
        
        function outtype = isOutputFixedSizeImpl(obj)
            outtype = propagatedInputFixedSize(obj,1);
        end
        
        function type = getOutputDataTypeImpl(obj)
            type = "double";
        end
        
        function cx = isOutputComplexImpl(obj)
            cx =false;
        end
    end
    
    methods(Static, Access = protected)
        %% Simulink customization functions
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(mfilename("class"));
        end

        function group = getPropertyGroupsImpl
            % Define property section(s) for System block dialog
            group = matlab.system.display.Section(mfilename("class"));
        end
    end
end