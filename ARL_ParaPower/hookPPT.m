classdef hookPPT < scPPT
    
    properties (Access = protected)%(DiscreteState)
        bdry_watts
    end
    
    methods (Access = protected)
        function setupImpl(obj)
            setupImpl@scPPT(obj);
            obj.GlobalTime = -1;
        end
        
        function [bdry_watts,Tres,PHres] = stepImpl(obj,GlobalTime,htcs,Ta_vec)
            obj.htcs=htcs;
            obj.Ta_vec=Ta_vec;
            [Tres, ~, PHres, ~]=stepImpl@scPPT(obj,GlobalTime);
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
        
        function [outsz_1,outsz_2,outsz_3] = getOutputSizeImpl(obj)
            numsteps = propagatedInputSize(obj,1);
            if isempty(obj.GlobalTime)
                outsz_1 = [10 1];  %Need to case-handle first iteration.
            else
                outsz_1 = [10 numsteps(2)];  %10 being the number of nodes in the input model
            end
            outsz_2=[3,10,4];
            outsz_3=outsz_2;
        end
        
        function [outtype_1,outtype_2,outtype_3] = isOutputFixedSizeImpl(obj)
            outtype_1 = propagatedInputFixedSize(obj,1);
            outtype_2 = true;
            outtype_3 = true;
        end
        
        function [type_1,type_2,type_3] = getOutputDataTypeImpl(obj)
            type_1 = 'double';
            type_2 = type_1;
            type_3 = type_1;
        end
        
        function [cx1,cx2,cx3] = isOutputComplexImpl(obj)
            cx1 = false;
            cx2 = false;
            cx3 = false;
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