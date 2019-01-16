%ParaPowerThermal as a class definition
%calling constructor as S = PPT(MI) will initialize a simulation 
classdef PPT2 % < matlab.System & matlab.system.mixin.Propagates & matlab.system.mixin.CustomIcon
    %going to do this as a generic class first, debug, and circle back to
    %system objects.
 
    % Public, non-tunable properties.  We don't want this changing during
    % simulation
    properties %(Nontunable)
        MI %Input model information
    end
    
    properties     % Public, tunable properties
        htcs
        Ta_vec
        Q          %function handle cell array
        GlobalTime
    end
    
    properties %(DiscreteState)
        %Outputs
        Tres  %4D Array corresponding to temperatures at x,y,z,t.
        PHres %4D Array Meltfraction
        % should flux go here?
    end

    % Pre-computed constants
    properties(Access = private)
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
    end

        
    properties (SetAccess=protected)
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
        %contstructor
        %% Initialization
        function obj = PPT2(MI)
       
        
            h=MI.h;
            Ta=MI.Ta;
            Mat=MI.Model;
            Q=MI.Q;
            T_init=MI.Tinit;
            GlobalTime=MI.GlobalTime;

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
            T=zeros(nnz(Mat>0),max([2 length(GlobalTime)])); % Temperature DOF vector, must hold at least initial cond and static/single result
            T(:,1)=T_init;
            Tres=zeros(numel(Mat),size(T,2)); % Nodal temperature results

            %% Phase Change Setup Hook
            PHres=Tres;
            %[isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(Mat,matprops,Num_Row,Num_Col,Num_Lay,steps);
            [~,rhol,~,Lw,~,PH,PH_init] = PCM_init(MI,Mat);
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
            obj.GlobalTime=GlobalTime;
            obj.Tres=Tres;
            obj.PHres=PHres;
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
            obj.Atrans=Atrans;
            obj.Cap=Cap;
            obj.vol=vol;
            obj.B=B;
            obj.C=C;
            obj.Aj=Aj;
            obj.Bj=Bj;
           
        end
        
        function obj=simulate(obj)
            
            Qv = obj.Qinit(obj.Q,obj.GlobalTime,obj.Qmask);
            
            MI=obj.MI;
            htcs=obj.htcs;
            Ta_vec=obj.Ta_vec;
            Q=obj.Q;
            GlobalTime=obj.GlobalTime;
            Tres=obj.Tres;
            PHres=obj.PHres;
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
            T=obj.T;
            PH=obj.PH;
            A=obj.A;
            Atrans=obj.Atrans;
            Cap=obj.Cap;
            vol=obj.vol;
            B=obj.B;
            C=obj.C;
            Aj=obj.Aj;
            Bj=obj.Bj;
            delta_t=obj.delta_t;
            
            
            for it=2:length(GlobalTime)
                
                T(:,it)=(A+Atrans)\(-B*Ta_vec'+Qv(Map,it-1)+C);  %T is temps at the end of the it'th step, C holds info about temps prior to it'th step
                
                if meltable && not(isnan(GlobalTime(2))) %melting disabled for static analyses
                    %{
                    [T(:,it),PH(:,it),changing,K,CP,RHO]=vec_Phase_Change(T(:,it),PH(:,it-1),Mat,Map,meltmask,...
                                                                                               MI.MatLib.k,MI.MatLib.k_l,MI.MatLib.cp,MI.MatLib.cp_l,MI.MatLib.rho,MI.MatLib.rho_l,...
                                                                                               MI.MatLib.tmelt,Lv,K,CP,RHO);   %These arguments need to be restructured
                     %}                                                                      
                                                                                           
                   [T(:,it),PH(:,it),changing,K,CP,RHO]=vec_Phase_Change(T(:,it),PH(:,it-1),Mat,Map,meltmask,...
                                                                            MI.MatLib.k,MI.MatLib.k_l,MI.MatLib.cp,MI.MatLib.cp_l,MI.MatLib.rho,MI.MatLib.rho_l,...
                                                                            MI.MatLib.tmelt,Lv,K,CP,RHO);   %These arguments need to be restructured
                end
                
                if not(isnan(GlobalTime(2))) && it~=length(GlobalTime)  %Do we have timesteps to undertake?
                    
                    if meltable && any(changing)  %Have material properties changed?
                        touched=find((abs(A)*changing)>0);  %find not only those elements changing, but those touched by changing elements
                        
                        %update capacitance (only those changing since internal to element)
                        Cap(changing)=mass(MI.X,MI.Y,MI.Z,RHO,CP,Mat,Map(changing)); %units of J/K
                        
                        %Entire Rebuild, for testing
                        %[A,B,A_areas,B_areas,A_hLengths,B_hLengths,htcs] = conduct_build(Acon,Bcon,newMap,fullheader,K,hint,h,Mat,dx,dy,dz);
                        
                        %update A and B
                        [A,B,htcs] = conduct_update(A,B,Aj.areas,Bj.areas,Aj.hLengths,Bj.hLengths,htcs,K(Map),touched);
                    end
                    
                    
                    Atrans=-spdiags(Cap,0,size(A,1),size(A,2))./delta_t(it-1);  %Save Transient term for the diagonal of A matrix, units W/K
                    C=-Cap./delta_t(it-1).*T(:,it); %units of watts
                end
                
                %Time history of A and B are not being stored, instead overwritten
            end
            
            obj.Tres(obj.Mat>0,:)=T;
            obj.PHres(obj.Mat>0,:)=PH;
            
            obj.Tres=reshape(obj.Tres,[size(MI.Model) length(GlobalTime)]);
            obj.PHres=reshape(obj.PHres,[size(MI.Model) length(GlobalTime)]);
           
                        %dump properties
            obj.MI=MI;
            obj.htcs=htcs;
            obj.Ta_vec=Ta_vec;
            obj.Q=Q;
            obj.GlobalTime=GlobalTime;
            obj.Tres=Tres;
            obj.PHres=PHres;
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
            obj.Atrans=Atrans;
            obj.Cap=Cap;
            obj.vol=vol;
            obj.B=B;
            obj.C=C;
            obj.Aj=Aj;
            obj.Bj=Bj;
            
        end
        
    end
        
    methods (Static)
        
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
                GT_eval{1}=GlobalTime;
                GT_eval=repmat(GT_eval,nnz(Qmask),1);
                Qval=cell2mat(cellfun(@arrayfun,Q(Qmask),GT_eval,'UniformOutput',false));
                clear GT_eval
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
            diagfullT = spdiags([T;Ta],0,size(A,1)+size(B,2),size(A,1)+size(B,2));
            flux = diagT*[A B]-[A B]*diagfullT;
        end
        
        function flux = ExternalFlux(T,B,Ta)
            %creates sparse matrix flux with size(B) with entries f_ij,
            %gives nodal power transfer from node i to boundary j in Watts.
            %the columns j are
            %specified by the fullheader that corresponds to columns of B
            diagT = spdiags(T,0,size(B,1),size(B,1));
            diagTa = spdiags(Ta,0,size(B,2),size(B,2));
            flux = diagT*B-B*diagTa;
        end
        
        function accum = Storage(T,A)
            %returns a vector of size(T) that gives the nodal energy accumulation in
            %Watts.  In steady state, this vector should be zero for unheated elements,
            %and be equal in magnitude to the heat rate of heated elements.
            accum = A*T;
        end      
        
    end
end

