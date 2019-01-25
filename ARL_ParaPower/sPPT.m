classdef sPPT < matlab.System & matlab.system.mixin.Propagates ...
        & matlab.system.mixin.CustomIcon
    % Untitled Add summary here
    %
    % NOTE: When renaming the class name Untitled, the file name
    % and constructor name must be updated to use the class name.
    %
    % This template includes most, but not all, possible properties, attributes,
    % and methods that you can implement for a System object in Simulink.

    %these were previously tunable, but simulink disallows internal
    %modification through sys_ob methods (i.e. stepImpl)
    properties(Access = protected) % Public, tunable properties
        htcs
        Ta_vec
        Q          %function handle cell array
        GlobalTime
    end

    % Public, non-tunable properties
    properties(Nontunable)
        MI %Input model information
    end

    properties(Access = protected)%(DiscreteState)
        Tres  %4D Array corresponding to temperatures at x,y,z,t.
        PHres %4D Array Meltfraction
        T_in  %3D Array corresponding to temperatures at initial time
        PH_in %3D Array Meltfraction to temperatures at initial time
    end

    % Pre-computed constants
    properties(Access = protected)
        %various masks and flags
        Qmask     %masks out unheated elements
        meltmask  %masks out unmeltable elements
        meltable  %logical indicating presence of pcm
        Qv
        delta_t
        
        %Element-wise thermal properties
        K
        CP
        RHO
        Lv
        
        %Maps
        Map
        fullheader
        Mat
        
        %internal state
        T
        PH
        
        %Matrices
        A       %static conductance matrix  units W/K
        Atrans  %transient diagonal capacitance  units W/K
        Cap     %capacitance vector, units J/K.  Divide by timestep to generate diagonal for Atrans
        vol     %volume vector, m3.
        B       %boundary conductance matrix  units W/K
        C       %inertia load vector for rhs, units W.  formed C=-Cap./delta_t(t).*T(:,t-1);
        Aj      %struct holding internal adjacency, areas, and hLengths matrices
        Bj      %struct holding boundary adjacency, areas, and hLengths
    end

    methods
        % Constructor
        function obj = sPPT(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform model initialization using parameters stored in MI
            MI=obj.MI;
            h=MI.h;
            Ta=MI.Ta;
            Mat=MI.Model;
            Q=MI.Q;
            T_init=MI.Tinit;
            GlobalTime=MI.GlobalTime;
            
            if isempty(obj.GlobalTime)  %GT needs to be defined prior to setup if using repeated absolute calls
                obj.GlobalTime=GlobalTime; %This assumes repeated relative calls
            end

            rollcall=unique(Mat);
            rollcall=rollcall(rollcall>0); %cant index zero or negative mat numbers

            % This program uses the resistance network concept to solve for the
            % temperatures and stresses due to CTE mismatch in an electronic component
            % module
            if not(strcmpi(MI.Version,'V2.0'))
                error(['Incorrect ModelInput version.  V2.0 required, this data is ' ModelInput.Version]);
            end

            kond = MI.MatLib.k; %Thermal conductivity of the solid
            rho = MI.MatLib.rho; %density of the solid state
            spht = MI.MatLib.cp; %solid specific heat

            K = zeros(size(Mat));
            K = reshape(K,[],1);
            CP=K; %Seeding with 0's, for Matl 0 = seed
            RHO=K; %Seeding with 0's, for Matl 0 = seed
            K(Mat ~=0 ) = kond(Mat(Mat~=0));
            CP(Mat ~=0) = spht(Mat(Mat~=0));
            RHO(Mat ~=0) = rho(Mat(Mat~=0));



            %% Voids Setup Hook
            vmatnum=rollcall(strcmp(MI.MatLib.Type(rollcall),'IBC'));
            hint=zeros(1,length(vmatnum));
            Ta_void=hint;

            for vn=1:length(vmatnum)
                %set Mat entries corresponding to voids to negative numbers per legacy
                %definition.  Initialize parameters
                hint(vn)=MI.MatLib.h_ibc(vmatnum(vn));
                Ta_void(vn)=MI.MatLib.T_ibc(vmatnum(vn));
                Mat(Mat==vmatnum(vn))=-vn;
            end

            %% Variable Q and State Initialization
            Qmask=~cellfun('isempty',Q(:));  %return logical mask with ones where Qs are def


            
            C=zeros(nnz(Mat>0),1); % Nodal capacitance terms for transient effects
            T=zeros(nnz(Mat>0),1); % Temperature DOF vector, must hold at least initial cond and static/single result
            T(:,1)=T_init;
            %Tres=zeros(numel(Mat),size(T,2)); % Nodal temperature results

            %% Phase Change Setup Hook
            %PHres=Tres;
            %[isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(Mat,matprops,Num_Row,Num_Col,Num_Lay,steps);
            [~,rhol,~,Lw,~,~,PH_init] = PCM_init(MI,Mat);
            PH=zeros(nnz(Mat>0),1);
            PH(:,1)=PH_init;
            obj.Lv=(rho+rhol)/2 .* Lw;  %generate volumetric latent heat of vap using average density
            %should we have a PH_init?
            meltable=any(strcmp(MI.MatLib.Type(rollcall),'PCM'));


            %% Build Adjacency and Conductance Matrices
            Aj = struct('adj',[],'areas',[],'hLengths',[]);
            Bj = Aj;         

            [Aj.adj,Bj.adj,~,Map]=Connect_Init(Mat,h);
            [Aj.adj,Bj.adj,Map,fullheader,Ta_vec]=null_void_init(Mat,h,hint,Aj.adj,Bj.adj,Map,Ta,Ta_void);
            %fullheader=[header find(h)];  %fullheader is a rowvector of negative matnums and a subset of 1 thru 6
            [A,B,Aj.areas,Bj.areas,Aj.hLengths,Bj.hLengths,htcs] = conduct_build(Aj.adj,Bj.adj,Map,fullheader,K,hint,h,Mat,MI.X,MI.Y,MI.Z);
            if isempty(B)
                B=spalloc(size(C,1),size(C,2),0);
                fullheader=1;
                Ta_vec=1;
            end

            %{ 
            Moved to stepImpl
            % Diagonal Terms
            if not(isempty(GlobalTime))
                obj.delta_t=GlobalTime(2:end)-GlobalTime(1:end-1);
                % Calculate the capacitance term associated with each node and adjust the 
                % A matrix (implicit end - future) and C vector (explicit - present) to include the transient effects
                [Cap,vol]=mass(MI.X,MI.Y,MI.Z,RHO,CP,Mat); %units of J/K
                vol=reshape(vol,size(Mat));
                Atrans=-spdiags(Cap,0,size(A,1),size(A,2))./obj.delta_t(1);  %Save Transient term for the diagonal of A matrix, units W/K
                C=-Cap./obj.delta_t(1).*T(:,1); %units of watts
            else
                %implies static analysis
                obj.delta_t=NaN;
                Atrans=spalloc(size(A,1),size(A,2),0); %allocate Atrans as zero
                GlobalTime=[0 NaN];
                %C is zero from init
            end
            % Form loop over the number of time steps desired
            %}
            
            %Globaltime is to single time step from 0 to NaN if static analysis is needed
            %delta_t is based off of GlobalTime for transient analysis and set to NaN
            %   for static analysis.  
            %For time step "it" that corresponds to t=GlobalTime(it).  The preceding 
            %   delta time is delta_t(it-1).  So, the delta_t leading up to time step
            %   5 [GlobalTime(5)] is delta_t(4)

            if meltable
                obj.meltmask=strcmp(MI.MatLib.Type(Mat(Map)),'PCM');
            end
            
            
            %dump properties
            obj.MI=MI;
            obj.htcs=htcs;
            obj.Ta_vec=Ta_vec;
            obj.Q=Q;

            %obj.Tres=Tres;
            %obj.PHres=PHres;
            obj.Qmask=Qmask;
            %obj.meltmask=meltmask;
            obj.meltable=meltable;
            obj.K=K;
            obj.CP=CP;
            obj.RHO=RHO;
            %obj.LV handled above
            obj.Map=Map;
            obj.fullheader=fullheader;
            obj.Mat=Mat;
            obj.T=T;
            obj.PH=PH;
            obj.A=A;
            %obj.Atrans=Atrans;
            %obj.Cap=Cap;
            %obj.vol=vol;
            obj.B=B;
            %obj.C=C;
            obj.Aj=Aj;
            obj.Bj=Bj;
        end

        function [Tres, T_in, PHres, PH_in] = stepImpl(obj,GlobalTime)
            % Implement algorithm. 
            if nargin<2
              GlobalTime=obj.GlobalTime;  %use last stored GT
              disp('Using internal time definition... assuming relative timestepping')
              %This method assumes the first element of GT is the time of
              %the initial state.  A dt vector is computed that has one less
              %element, and is the basis of the timestepping.   Time-dep
              %conditions are still referenced by the absolute time of GT.
           
            else
              disp('Using absolute time input')
              time_in=obj.GlobalTime(end);
              if ~(time_in < GlobalTime(1))
                  error('non-positive initial step')
              end
              GlobalTime=[time_in GlobalTime]; %pad input GT
              obj.GlobalTime=GlobalTime;  %overwrite stored GT
              %new_time=true;
            end
            
            
            
            MI=obj.MI;
            %htcs=obj.htcs;
            %Ta_vec=obj.Ta_vec;
            Q=obj.Q;
            
            %Tres=obj.Tres;
            %PHres=obj.PHres;
            Qmask=obj.Qmask;
            meltmask=obj.meltmask;
            meltable=obj.meltable;
            K=obj.K;
            CP=obj.CP;
            RHO=obj.RHO;
            Lv=obj.Lv;
            Map=obj.Map;
            fullheader=obj.fullheader;
            Mat=obj.Mat;
            %T=obj.T;
            %PH=obj.PH;
            A=obj.A;
            Atrans=obj.Atrans;
            Cap=obj.Cap;
            vol=obj.vol;
            B=obj.B;
            C=obj.C;
            Aj=obj.Aj;
            Bj=obj.Bj;
            %delta_t=obj.delta_t;
            
            
            Qv = obj.Qinit(Q,GlobalTime,Qmask);
            
            %adjust state vectors to timestep
            T=zeros(nnz(Mat>0),max([2 length(GlobalTime)])); % Temperature DOF vector, must hold at least initial cond and static/single result
            PH = zeros(nnz(Mat>0),max([2 length(GlobalTime)])); %percent melted of a given node
            T(:,1)=obj.T(:,end);    %initialize state with last state.
            PH(:,1)=obj.PH(:,end);

            
            % Diagonal Terms
            if not(isempty(GlobalTime))
                delta_t=GlobalTime(2:end)-GlobalTime(1:end-1);
                % Calculate the capacitance term associated with each node and adjust the 
                % A matrix (implicit end - future) and C vector (explicit - present) to include the transient effects
                [Cap,vol]=mass(MI.X,MI.Y,MI.Z,RHO,CP,Mat); %units of J/K
                vol=reshape(vol,size(Mat));
                Atrans=-spdiags(Cap,0,size(A,1),size(A,2))./delta_t(1);  %Save Transient term for the diagonal of A matrix, units W/K
                C=-Cap./delta_t(1).*T(:,1); %units of watts
            else
                %implies static analysis
                delta_t=NaN;
                Atrans=spalloc(size(A,1),size(A,2),0); %allocate Atrans as zero
                GlobalTime=[0 NaN];
                %C is zero from init
            end
            obj.delta_t=delta_t;
            
            obj=pre_step_hook(obj);
            
            for it=2:length(GlobalTime)
                
                T(:,it)=(A+Atrans)\(-B*obj.Ta_vec'+Qv(Map,it-1)+C);  %T is temps at the end of the it'th step, C holds info about temps prior to it'th step
                
                if meltable && not(isnan(GlobalTime(2))) %melting disabled for static analyses
                    %{
                    [T(:,it),PH(:,it),changing,K,CP,RHO]=vec_Phase_Change(T(:,it),PH(:,it-1),Mat,Map,meltmask,...
                                                                                               MI.MatLib.k,MI.MatLib.k_l,MI.MatLib.cp,MI.MatLib.cp_l,MI.MatLib.rho,MI.MatLib.rho_l,...
                                                                                               MI.MatLib.tmelt,Lv,K,CP,RHO);   %These arguments need to be restructured
                     %}                                                                      
                   
                   [T(:,it),PH(:,it),changing,K,CP,RHO]=vec_Phase_Change(T(:,it),PH(:,it-1),Mat,Map,meltmask,...
                                                                            MI.MatLib.k,MI.MatLib.k_l,MI.MatLib.cp,MI.MatLib.cp_l,MI.MatLib.rho,MI.MatLib.rho_l,...
                                                                            MI.MatLib.tmelt,Lv,K,CP,RHO);   %These arguments need to be restructured
                    
                   [obj,T,PH,changing] = ph_ch_hook(obj,T,PH,changing,it);
                end
                
                if ~isnan(GlobalTime(2)) %update even after last timestep
                    %was not(isnan(GlobalTime(2))) && it~=length(GlobalTime)  %Do we have timesteps to undertake?
                    
                    if meltable && any(changing)  %Have material properties changed?
                        touched=changing | (Aj.adj*changing)>0;  %find not only those elements changing, but those touched by changing elements
                        
                        %update capacitance (only those changing since internal to element)
                        Cap(changing)=mass(MI.X,MI.Y,MI.Z,RHO,CP,Mat,Map(changing)); %units of J/K
                        
                        %Entire Rebuild, for testing
                        %[A,B,A_areas,B_areas,A_hLengths,B_hLengths,htcs] = conduct_build(Acon,Bcon,newMap,fullheader,K,hint,h,Mat,dx,dy,dz);
                        
                        %update A and B
                        [A,B,~] = conduct_update(A,B,Aj.areas,Bj.areas,Aj.hLengths,Bj.hLengths,obj.htcs,K(Map),touched);
                    end
                    
                    
                    Atrans=-spdiags(Cap,0,size(A,1),size(A,2))./delta_t(it-1);  %Save Transient term for the diagonal of A matrix, units W/K
                    C=-Cap./delta_t(it-1).*T(:,it); %units of watts
                end
                
                %Time history of A and B are not being stored, instead overwritten
                obj.T=T(:,it);
                obj.PH=PH(:,it);
                obj.A=A;
                obj.B=B;
                obj=post_step_hook(obj);
            end
            
            Tres=zeros(numel(Mat),size(T,2)-1); % Nodal temperature results
            PHres=Tres;
            T_in=zeros(numel(Mat),1);
            PH_in=T_in;
            
            T_in(Mat>0,:)=T(:,1);
            Tres(Mat>0,:)=T(:,2:end);
            PH_in(Mat>0,:)=PH(:,1);
            PHres(Mat>0,:)=PH(:,2:end);
            
            T_in=reshape(T_in,size(MI.Model));
            Tres=reshape(Tres,[size(MI.Model) length(GlobalTime)-1]);
            PH_in=reshape(PH_in,size(MI.Model));
            PHres=reshape(PHres,[size(MI.Model) length(GlobalTime)-1]);
            
            obj.T_in=T_in;
            obj.Tres=Tres;
            obj.PH_in=PH_in;
            obj.PHres=PHres;
            
                        %dump properties
            %obj.MI=MI;
            %obj.htcs=htcs;
            %obj.Ta_vec=Ta_vec;
            obj.Q=Q;
            %obj.GlobalTime=GlobalTime;
            obj.Tres=Tres;
            obj.PHres=PHres;
            %obj.Qmask=Qmask;
            %obj.meltmask=meltmask;
            %obj.meltable=meltable;
            obj.K=K;
            obj.CP=CP;
            obj.RHO=RHO;
            %obj.LV handled above
            %obj.Map=Map;
            %obj.fullheader=fullheader;
            %obj.Mat=Mat;
            obj.T=T; 
            obj.PH=PH;
            %obj.A=A; moved
            obj.Atrans=Atrans;
            obj.Cap=Cap;
            %obj.vol=vol;
            %obj.B=B; moved
            obj.C=C;
            %obj.Aj=Aj;
            %obj.Bj=Bj;
            
        end

        function obj = pre_step_hook(obj)
            %derive and overload me to insert post-property initialization
        end
        
        function obj = post_step_hook(obj)
            %derive and overload me to insert postprocessing hook
        end
        
        function [obj,T,PH,changing] = ph_ch_hook(obj,T,PH,changing,it);
            %derive and overload me to insert phase change modification hook
        end
        
        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        %% Backup/restore functions
        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj

            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);

            % Set private and protected properties
            %s.myproperty = obj.myproperty;
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s

            % Set private and protected properties
            % obj.myproperty = s.myproperty; 

            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        %% Simulink functions
        %function ds = getDiscreteStateImpl(obj)
            % Return structure of properties with DiscreteState attribute
            %ds = struct([]);
        %end

        function flag = isInputSizeMutableImpl(obj,index)
            % Return false if input size cannot change
            % between calls to the System object
            flag = false;
        end

        function out = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function icon = getIconImpl(obj)
            % Define icon for System block
            icon = mfilename("sPPT"); % Use class name
            % icon = "My System"; % Example: text icon
            % icon = ["My","System"]; % Example: multi-line text icon
            % icon = matlab.system.display.Icon("myicon.jpg"); % Example: image file icon
        end
    end

    methods (Static)  %ParaPower internal methods.
        function Qv=Qinit(Q,GlobalTime,Qmask)
            %creates sparse array of element nodal power
            
            if ~exist('Qmask','var')
                Qmask=~cellfun('isempty',Q(:));  %return logical mask with ones where Qs are def
            end
            
            %Indicator for static analysis, if steps is empty. Form Q vectors.
            if isempty(GlobalTime)||isnan(GlobalTime(2))
                disp('Static Analysis');
                %convert Q from function handle form to value at single time of Qtime
                zer_eval=num2cell(zeros(nnz(Qmask),1));
                Qval=cellfun(@feval,Q(Qmask),zer_eval);
                clear zer_eval
                %evaluate each nonempty cell of Q at t=0
                Qv=sparse(find(Qmask),1,Qval,length(Q(:)),1);  %
                %Q's for the entire Mat matrix, vector for the single static step
                
            else
                disp('Transient Analysis');
                %cell arrays are fun!
                %cell arrays are fun!
%                 tic
%                 GT_eval{1}=GlobalTime;
%                 GT_eval=repmat(GT_eval,nnz(Qmask),1);  
%                 Qval=cell2mat(cellfun(@arrayfun,Q(Qmask),GT_eval,'UniformOutput',false));
%                 toc
%                 tic
                QmFind=find(Qmask);
                Qval=zeros(length(QmFind),length(GlobalTime));
                for Qi=1:length(QmFind)
                    Qval(Qi,:)=Q{QmFind(Qi)}(GlobalTime);
                    
                 end
%                 toc
%                 clear GT_eval
                %evaluate each nonempty cell of Q at all timesteps
                Qv=spalloc(length(Q(:)),length(GlobalTime)-1,nnz(Qmask)*(length(GlobalTime)-1));
                Qv(Qmask,:)=sparse(Qval(:,1:end-1)+Qval(:,2:end))/2;
                %Qv is now a sparse 2D array with rows corresponding to Mat entries and
                %columns for each timestep numel(dt).  The Q dissipated during a
                %timestep is the average of the values at times bookending the step
                %CONS of ENERGY ISSUE - this is a trapz approx of the variable Q
                %dissipation.
                
            end
        end
        
        function flux = InternalFlux(T,A)
            %creates (sparse) matrix 'flux' with size(A) with entries f_ij that
            %gives nodal power transfer from node i to node j in Watts.
            %This matrix should be skew symmetric with 0s on the diagonal.
            diagT = spdiags(T,0,size(A,1),size(A,2));
            flux = diagT*A-A*diagT;
        end
        
        function flux = Flux(T,A,B,Ta)
            %creates sparse matrix flux with size([A B]) with entries f_ij,j<=Ni that
            %gives nodal power transfer from node i to node j in Watts.
            %the augemented columns j>Ni give nodal power transfer to the boundaries
            %specified by the fullheader that corresponds to columns of B
            %The submatrix stemming from A should be skew symmetric with 0s on the diagonal.
            diagT = spdiags(T,0,size(A,1),size(A,2));
            diagfullT = spdiags([T;Ta'],0,size(A,1)+size(B,2),size(A,1)+size(B,2));
            flux = diagT*[A B]-[A B]*diagfullT;
        end
        
        function flux = ExternalFlux(T,B,Ta)
            %creates sparse matrix flux with size(B) with entries f_ij,
            %gives nodal power transfer from node i to boundary j in Watts.
            %the columns j are
            %specified by the fullheader that corresponds to columns of B
            diagT = spdiags(T,0,size(B,1),size(B,1));
            diagTa = spdiags(Ta',0,size(B,2),size(B,2));
            flux = diagT*B-B*diagTa;
        end
        
        function accum = Storage(T,A)
            %returns a vector of size(T) that gives the nodal energy accumulation in
            %Watts.  In steady state, this vector should be zero for unheated elements,
            %and be equal in magnitude to the heat rate of heated elements.
            accum = A*T;
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
