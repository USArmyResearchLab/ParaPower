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

    %properties(DiscreteState)
    %    State
    %end

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


            rollcall=unique(Mat);
            rollcall=rollcall(rollcall>0); %cant index zero or negative mat numbers

            % This program uses the resistance network concept to solve for the
            % temperatures and stresses due to CTE mismatch in an electronic component
            % module
            if not(strcmpi(MI.Version,'V2.0'))
                error(['Incorrect ModelInput version.  V2.0 required, this data is ' ModelInput.Version]);
            end





            %% Voids Setup Hook
            Types=MI.MatLib.GetParam('Type');
            vmatnum=rollcall(strcmp(Types(rollcall),'IBC'));
            hint=zeros(1,length(vmatnum));
            Ta_void=hint;

            for vn=1:length(vmatnum)
                %set Mat entries corresponding to voids to negative numbers per legacy
                %definition.  Initialize parameters
                h_ibc=MI.MatLib.GetParamVector('h_ibc');
                hint(vn)=h_ibc(vmatnum(vn));
                T_ibc=MI.MatLib.GetParamVector('T_ibc');
                Ta_void(vn)=T_ibc(vmatnum(vn));
                Mat(Mat==vmatnum(vn))=-vn;
            end

            %% Variable Q and State Initialization
            Qmask=~cellfun('isempty',Q(:));  %return logical mask with ones where Qs are def


            
            C=zeros(nnz(Mat>0),1); % Nodal capacitance terms for transient effects
            T=zeros(nnz(Mat>0),1); % Temperature DOF vector, must hold at least initial cond and static/single result
            T(:,1)=T_init;
            %Tres=zeros(numel(Mat),size(T,2)); % Nodal temperature results
            
            kond = MI.MatLib.GetParamVector('k'); %Thermal conductivity of the solid
            rho = MI.MatLib.GetParamVector('rho'); %density of the solid state
            spht = MI.MatLib.GetParamVector('cp'); %solid specific heat
            
            K = zeros(nnz(Mat>0),1);  %These will have same size as state DOF vectors.
            CP=K; %Seeding with 0's, for Matl 0 = seed
            RHO=K; %Seeding with 0's, for Matl 0 = seed
            K = kond(Mat(Mat>0));
            CP = spht(Mat(Mat>0));
            RHO = rho(Mat(Mat>0));
            
            %% Phase Change Setup Hook
            %PHres=Tres;
            %[isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(Mat,matprops,Num_Row,Num_Col,Num_Lay,steps);
            Types=MI.MatLib.GetParam('Type');
            meltable=any(strcmp(Types(rollcall),'PCM') | strcmp(Types(rollcall),'SCPCM'));
            PH=zeros(nnz(Mat>0),1);
            
            
            if any(meltable)
                %Convert greater than zero mats into a vector for processing
                kondl= MI.MatLib.GetParamVector('k_l');
                sphtl = MI.MatLib.GetParamVector('cp_l');
                rhol = MI.MatLib.GetParamVector('rho_l');
                Lw = MI.MatLib.GetParamVector('lf');
                Tmelt = MI.MatLib.GetParamVector('tmelt');
                MatGZVec=reshape(Mat(Mat>0),1,[]);
                for ThisMat=reshape(unique(MatGZVec(:)),1,[])
                    MatMask=MatGZVec==ThisMat;
                    PH(MatMask,1)=double(T(MatMask,1)>=Tmelt(ThisMat));
                end
                %[~,rhol,~,Lw,~,~,PH_init] = PCM_init(MI,Mat);
                %PH(:,1)=zeros(nnz(Mat>0),1);
                
                
                obj.Lv=(rho+rhol)/2 .* Lw;  %generate volumetric latent heat of vap using average density
            else
                obj.Lv=rho*0;
            end
            %should we have a PH_init?


            %% Build Adjacency and Conductance Matrices
            Aj = struct('adj',[],'areas',[],'hLengths',[]);
            Bj = Aj;         

            [Aj.adj,Bj.adj,~,Map]=obj.Connect_Init(Mat,h);
            [Aj.adj,Bj.adj,Map,fullheader,Ta_vec]=obj.null_void_init(Mat,h,hint,Aj.adj,Bj.adj,Map,Ta,Ta_void);
            %fullheader=[header find(h)];  %fullheader is a rowvector of negative matnums and a subset of 1 thru 6
            
            %here is where we should implement bottom-up element/material
            %contributions to assembly
            
            
            meltmask = PH(:,1)>0;
            if any(meltmask)
                K(meltmask) = 1./( PH(meltmask)./kondl(Mat(Map(meltmask))) +(1-PH(meltmask))./kond(Mat(Map(meltmask))));  %update properties, K using series resistance
                CP(meltmask) = sphtl(Mat(Map(meltmask))).*PH(meltmask)+spht(Mat(Map(meltmask))).*(1-PH(meltmask));           %others using rule of mixtures
                RHO(meltmask) = rhol(Mat(Map(meltmask))).*PH(meltmask)+rho(Mat(Map(meltmask))).*(1-PH(meltmask));
            end
                
            [A,B,Aj.areas,Bj.areas,Aj.hLengths,Bj.hLengths,htcs] = obj.conduct_build(Aj.adj,Bj.adj,Map,fullheader,K,hint,h,Mat,MI.X,MI.Y,MI.Z);
           
            if isempty(B)
                B=spalloc(size(C,1),size(C,2),0);
                fullheader=1;
                Ta_vec=1;
            end

            Types=MI.MatLib.GetParam('Type');
            if meltable
                obj.meltmask=strcmp(Types(Mat(Map)),'PCM');
            end          
            
            %% Dump Properties

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
            obj.C=C;
            obj.Aj=Aj;
            obj.Bj=Bj;
        end

        function [Tres, T_in, PHres, PH_in] = stepImpl(obj,GlobalTime)
            % Implement algorithm. 

            %% Set up Timesteps
            if isempty(GlobalTime) || any(isnan(GlobalTime))
                disp('Time is empty or NaN, analysis will be static.')
                obj.GlobalTime=GlobalTime;  %overwrite stored GT
            else
                % for transient, original implementation is GT is one
                % element longer than the computed results.  It is a list
                % of absolute time marks
                if isempty(obj.GlobalTime) %1st run
                    obj.GlobalTime=GlobalTime;
                else
                    %three cases
                    if GlobalTime(1) <= obj.GlobalTime(1) == 1
                        error('attempted time reversal prior to beyond stored record')
                    elseif GlobalTime(1) > obj.GlobalTime(end) == 1
                        %advance time ... prepend last known time and execute.
                        GlobalTime = [obj.GlobalTime(end) GlobalTime];
                        obj.GlobalTime = GlobalTime;
                        disp('advancing')
                    else %Resuming model from intermediate state
                        resume_step=find(obj.GlobalTime<GlobalTime(1),1,'last');
                        obj.T(:,end)=obj.T(:,resume_step);
                        obj.PH(:,end)=obj.PH(:,resume_step);
                        GlobalTime=[obj.GlobalTime(resume_step) GlobalTime];
                        fprintf('Resuming from %g s\n',obj.GlobalTime(resume_step));
                        obj.GlobalTime = GlobalTime;
                    end
                end
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
            %K=obj.K;  fully object oriented
            %CP=obj.CP;
            %RHO=obj.RHO;
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
                [Cap,vol]=obj.mass(MI.X,MI.Y,MI.Z,obj.RHO,obj.CP,Mat); %units of J/K
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
                   
                   [T(:,it),PH(:,it),changing,obj.K,obj.CP,obj.RHO]=obj.vec_Phase_Change(T(:,it),PH(:,it-1),Mat,Map,meltmask,...
                                                                            MI.MatLib.GetParamVector('k'), ...
                                                                            MI.MatLib.GetParamVector('k_l'), ...
                                                                            MI.MatLib.GetParamVector('cp'), ...
                                                                            MI.MatLib.GetParamVector('cp_l'), ...
                                                                            MI.MatLib.GetParamVector('rho'), ...
                                                                            MI.MatLib.GetParamVector('rho_l'),...
                                                                            MI.MatLib.GetParamVector('tmelt'), ...
                                                                            Lv, obj.K,obj.CP,obj.RHO);   %These arguments need to be restructured
                    
                   [obj,T,PH,changing] = ph_ch_hook(obj,T,PH,changing,it);
                end
                
                if ~isnan(GlobalTime(2)) %update even after last timestep
                    %was not(isnan(GlobalTime(2))) && it~=length(GlobalTime)  %Do we have timesteps to undertake?
                    
                    if meltable && any(changing)  %Have material properties changed?
                        touched=changing | (Aj.adj*changing)>0;  %find not only those elements changing, but those touched by changing elements
                        
                        %update capacitance (only those changing since internal to element)
                        Cap(changing)=obj.mass(MI.X,MI.Y,MI.Z,obj.RHO,obj.CP,Mat,changing); %units of J/K
                        
                        %Entire Rebuild, for testing
                        %[A,B,A_areas,B_areas,A_hLengths,B_hLengths,htcs] = conduct_build(Acon,Bcon,newMap,fullheader,K,hint,h,Mat,dx,dy,dz);
                        
                        %update A and B
                        [A,B,~] = obj.conduct_update(A,B,Aj.areas,Bj.areas,Aj.hLengths,Bj.hLengths,obj.htcs,obj.K,touched);
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
            
            [modelsize(1),modelsize(2),modelsize(3)]=size(MI.Model);
            T_in=reshape(T_in,modelsize);
            Tres=reshape(Tres,[modelsize length(GlobalTime)-1]);
            PH_in=reshape(PH_in,modelsize);
            PHres=reshape(PHres,[modelsize length(GlobalTime)-1]);
            
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
            
            %obj.K=K;   these should be fully obj oriented
            %obj.CP=CP;
            %obj.RHO=RHO;

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
        
        function [obj,T,PH,changing] = ph_ch_hook(obj,T,PH,changing,it)
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
            flag = true;
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

    methods (Static, Access = protected)  %ParaPower internal matrix methods - shift to o-o coding (i.e. non-static)
        function [A,B,Bexp,Map] = Connect_Init(Mat,h)
            % Initializes matrix blocks A, B, and expanded B with connectivity entries implied by
            % Mat and h.
            %  A is n x n where n = length(Mat), B is n x m where m is
            % number of nonzero h, and Ext = eye(m).  Interior boundary voids, custom
            % connectivity, and null materials not handled by this routine.  Connectivity to null boundaries are included in Bexp.
            
            Map=reshape(1:numel(Mat),size(Mat)); %x,y,z
            nodes=numel(Map);  %number of rows of A and B
            
            % Convection coefficients for the row=0, row=end+1, col=0, col=end+1, layer=0, and layer=end+1
            h1=ones(1,size(Map,2)+2,size(Map,3)); h2=h1;  %dimensions extended for padding
            h3=ones(size(Map,1),1,size(Map,3)); h4=h3;
            h5=ones(size(Map,1)+2,size(Map,2)+2,1); h6=h5; %dimensions extended for padding
            
            padmap=[h1*(nodes+1); [h3*(nodes+3) Map h4*(nodes+4)]; h2*(nodes+2)];
            padmap=cat(3,h5*(nodes+5),padmap,h6*(nodes+6));  %extended array containing Mat that allows for indexing
            
            %Build expanded connectivity map
            rowup=padmap(3:end,2:end-1,2:end-1);        %Row-wise map of columns of [A B] that need to be 1
            rowdown=padmap(1:end-2,2:end-1,2:end-1);    %The ith element (linear indexing) of these vectors
            colup=padmap(2:end-1,3:end,2:end-1);        %   contains the column index j of element ij in [A B]
            coldown=padmap(2:end-1,1:end-2,2:end-1);    %   that needs a 1
            layup=padmap(2:end-1,2:end-1,3:end);
            laydown=padmap(2:end-1,2:end-1,1:end-2);
                       
            % Creating sparse triplet vectors (row,column,value)
            i=repmat([1:nodes]',6,1);
            j=[rowup(:); rowdown(:); colup(:); coldown(:); layup(:); laydown(:)];
            v=[ones(nodes*2,1); 2*ones(nodes*2,1); 3*ones(nodes*2,1)];
            
            Full=sparse(i,j,v,nodes,nodes+numel(h));

            A=Full(:,1:numel(Mat));
            Bexp=Full(:,numel(Mat)+1:end);
            B(:,:)=Bexp(:,h~=0);
            
            if ~issymmetric(A)
                error('Symmetry of A violated')
            elseif nnz(Full)/size(Full,1)~=6
                warning('Non-standard connectivity')
            end
        end
        
        function [A,B,Map,fullheader,Ta_vec]=null_void_init(Mat,h,hint,A,B,Map,Ta,Ta_void)
            % Modifies connectivity maps to account for internal voids and null
            % materials.  The returned index Map is updated from optional 4th arg or
            % from default constructed via Mat.
            %  Does not break connectivity due to low dimensional elements or
            %  explicitly zero conductances.  Row/Col of nulled materials deleted, void
            %  connections reordered to become part of B.
            
            Map=reshape(Map,[],1);
            header=[];
            if any(Mat(:)<0)        %Handle any voids present in the model and reconfigure
                
                for voidnum=1:abs(min(Mat(:)))
                    voids = Mat(:)==-voidnum;
                    if ~any(voids)  %there are no voids of this number
                        continue
                    end
                    if voidnum>numel(hint)|| hint(voidnum)==0  %the voids of this number have an undefined or zero h
                        Mat(Mat==-voidnum) = 0;  %reset the material number of these voids to null material
                        fprintf('Void %d has zero or undefined h.\n',-voidnum)
                        continue
                    end
                    
                    remap_full = [find(~voids); find(voids)];
                    remain = nnz(~voids);
                    
                    A(:,:)=A(remap_full,remap_full);
                    B(:,:)=B(remap_full,:);
                    Map(:)=Map(remap_full);
                    Mat(:)=Mat(remap_full);
                    
                    %collapse A by shifting void connections to B and collecting
                    %be careful of connection multiplicity
                    
                    Badd = A(1:remain,remain+1:end);
                    [i,~]=find(Badd);
                    if length(i)==length(unique(i)) %there are no multiplicities
                        B=[sum(Badd,2) B(1:remain,:)]; %essentially or'ing things
                        mt=1;
                    else
                        Badd = sort(Badd,2,'descend');  %move all nonzero entries to left
                        [~,j]=find(Badd);
                        mt=max(j);                       %j lists multiplicity
                        B = [Badd(:,1:mt) B(1:remain,:)];
                    end
                    
                    A=A(1:remain,1:remain);
                    Map=Map(1:remain);
                    Mat=Mat(1:remain);
                    
                    header=[-voidnum*ones(1,mt) header];
                end
            end
            
            if any(Mat(:)==0)  %Handle any null materials and reconfigure
                remap=find(Mat);
                
                A=A(remap,remap);   %delete rows and cols corresponding to null materials
                B=B(remap,:);       %delete rows
                Map=Map(remap);     %consolidate Map and Mat
                Mat=Mat(remap);
            end
            
            fullheader=[header find(h)]; %fullheader is a rowvector of negative matnums and a subset of 1 thru 6
            Ta_vec=Ta_void(-(header));
            Ta_vec=[Ta_vec Ta(h~=0)];  %grab just those Ta corresponding to the active ext boundaries
            
        end
        
        function [Acond,Bcond,A_areas,B_areas,A_hLengths,B_hLengths,htcs] = conduct_build(Acon,Bcon,Map,header,K,hint,h,Mat,drow,dcol,dlay)
            %Builds Conductance Matrices using connectivity matrices, dimensional info,
            %and material properties/convection coefficients.
            
            %Acon and Bcon connectivity is coded as 0,1,2,3 where 0 is no connection,
            % 1 is connection row-wise, 2 is connection col-wise, 3 is conn layer-wise
            % such that drow                dcol                      dlay
            % are the length dimensions of these connections
            %
            %Want to build a A-matrix with dimensional info.  One will contain areas
            %for flux computation. Symmetric.  The other will have half length info,
            %with coefficient ij holding the half length from center of element i to
            %boundary of element j.
            
            %Elemental conductivities will be multiplied into these and harmonic
            %summed.
            
            %% Initialize
            A_areas=spalloc(size(Acon,1),size(Acon,2),nnz(Acon));
            A_hLengths=A_areas; %Acond=A_areas;
            
            B_areas=spalloc(size(Bcon,1),size(Bcon,2),nnz(Bcon));
            B_hLengths=B_areas; %Bcond_out=B_areas;

            %% Store Geometry
            
            for dir=1:3
                [Ai,Aj]=find(Acon==dir);  %is find slow here?
                [Bi,Bj]=find(Bcon==dir);
                
                
                [A_rows,A_cols,A_lays]=ind2sub(size(Mat),Map(Ai));
                [B_rows,B_cols,B_lays]=ind2sub(size(Mat),Map(Bi));
                
                switch dir
                    case 1      %row-wise connections
                        areasA=dcol(A_cols').*dlay(A_lays');
                        areasB=dcol(B_cols').*dlay(B_lays');
                        lengthsA=drow(A_rows')/2;
                        lengthsB=drow(B_rows')/2;
                    case 2      %column-wise connections
                        areasA=drow(A_rows').*dlay(A_lays');
                        areasB=drow(B_rows').*dlay(B_lays');
                        lengthsA=dcol(A_cols')/2;
                        lengthsB=dcol(B_cols')/2;
                    case 3      %layer-wise connections
                        areasA=dcol(A_cols').*drow(A_rows');
                        areasB=dcol(B_cols').*drow(B_rows');
                        lengthsA=dlay(A_lays')/2;
                        lengthsB=dlay(B_lays')/2;
                end
                
                A_areas=A_areas+sparse(Ai,Aj,areasA,size(Acon,1),size(Acon,2));
                A_hLengths=A_hLengths+sparse(Ai,Aj,lengthsA,size(Acon,1),size(Acon,2));
                
                B_areas=B_areas+sparse(Bi,Bj,areasB,size(Bcon,1),size(Bcon,2));
                B_hLengths=B_hLengths+sparse(Bi,Bj,lengthsB,size(Bcon,1),size(Bcon,2));
            end
            
            
            %% Incorporate Conductivities
            
            recip=@(x) 1./x;  %anonymous function handle
            Acond=A_areas.* spfun(recip,A_hLengths);
            Acond=spdiags(K,0,size(Acon,1),size(Acon,2))*Acond;  %conductance from center of element i up to bdry of element j
            Acond=spfun(recip, (spfun(recip,Acond) + spfun(recip,Acond')) );
            
            
            if ~issymmetric(Acond)
                error('Symmetry Error!')
            end
            
            Bcond_out=B_areas.* spfun(recip,B_hLengths);
            Bcond_out=spdiags(K,0,size(Acon,1),size(Acon,2))*sparse(Bcond_out);  %conductance from center of element i up to bdry of convection
            htcs=[hint(-header(header<0)) h(header(header>0))];  %build htcs from header and h lists
            Bcond_in = sparse(B_areas*diag(htcs));
            Bcond = spfun(recip, (spfun(recip,Bcond_out) + spfun(recip,Bcond_in)) );
            
            %the diagonal of the A conductance matrix holds the center of the central
            %differences.  These must balance cntr=sum([Acond Bcond],2);
            Acond=Acond-spdiags(sum([Acond Bcond],2),0,size(Acon,1),size(Acon,2));
        end
        
        function [Acond,Bcond,htcs] = conduct_update(Acond,Bcond,A_areas,B_areas,A_hLengths,B_hLengths,htcs,K,Mask)
            %Updates Conductance Matrices using connectivity matrices, dimensional info,
            %and material properties/convection coefficients.
            szM=nnz(Mask);
            
            recip=@(x) 1./x;  %anonymous function handle
            Acond(Mask,Mask)=A_areas(Mask,Mask).* spfun(recip,A_hLengths(Mask,Mask));
            Acond(Mask,Mask)=spdiags(K(Mask),0,szM,szM)*Acond(Mask,Mask);  %conductance from center of element i up to bdry of element j
            Acond(Mask,Mask)=spfun(recip, (spfun(recip,Acond(Mask,Mask)) + spfun(recip,Acond(Mask,Mask)')) );
            
            
            if ~issymmetric(Acond)
                error('Symmetry Error!')
            end
            
            Bcond_out=sparse(B_areas(Mask,:)).*spfun(recip,sparse(B_hLengths(Mask,:)));
            Bcond_out=spdiags(K(Mask),0,szM,szM)*Bcond_out;  %conductance from center of element i up to bdry of convection
            
            if ~isempty(htcs) && ~isempty(B_areas)
                Bcond_in = sparse(B_areas(Mask,:)*diag(htcs));
                Bcond(Mask,:) = spfun(recip, (spfun(recip,Bcond_out) + spfun(recip,Bcond_in)) );
            end
            
            Acond(Mask,Mask)=Acond(Mask,Mask)-spdiags(sum([Acond(Mask,:) Bcond(Mask,:)],2),0,szM,szM);
        end

        function [T,PH,changing,K,CP,RHO]=vec_Phase_Change(T,PH,Mat,Map,meltmask,kond,kondl,spht,sphtl,rho,rhol,Tm,Lv,K,CP,RHO)
            %take in T(:,t),PH(:,t-1),Mat,properties,geometry
            %make sure latent heat is volumetric!
            %pass out updated T(:,t), current PH(:,t), updated properties, and flags to
            %use updated properties.
            % post melt.
            
            if ~any(meltmask)  %no meltable elements declared
                changing=meltmask;
                return
            end
            
            %Case Checking
            state=[T(meltmask)>Tm(Mat(Map(meltmask))),PH(meltmask)~=0,PH(meltmask)==1];
            %state is only defined for the meltable rows of A           
            %      011 (Solidifying)  |  111 (Liquid)
            %    1 -------------------|---------------------
            % PH   010 (Solidifying)  |  110 (Melting)
            %    0 -------------------|---------------------
            %      000 (Solid)        |  100 (Melting)
            %     ____________________|_____________________T
            %                         Tm
            
            % compute direction of Temp, PH adjustments
            changing = ~all(state,2) & any(state,2);  %ones where some change is happening
            %changing mask is same size as state
            meltmask(meltmask==1)=changing; %update meltable rows to only those changing
            
            
            if any(changing)  %things are changing phase, update
                direction = (2*state(changing,1)-1);  %decide a direction based on T>Tm
                %has length=nnz(changing) i.e. is only defined for changing nodes
                changing=meltmask;
                %changing now expanded to size of meltmask for direct pass
                
                %Update DOF of changing elements
                PH(changing) = PH(changing) + direction.*(abs(T(changing)-Tm(Mat(Map(changing))))).*(RHO(changing).*CP(changing)./Lv(Mat(Map(changing))));  %increment PH according to excess sensible
                T(changing) = T(changing) - direction .* abs(T(changing)-Tm(Mat(Map(changing))));                %decrement T by temperature excess
                %Everything right unless overmelted/oversolidified  PH>1 || PH<0
                
                PH_ex=zeros(size(PH));
                PH_ex(changing)=max(1/2,abs(PH(changing)-1/2))-1/2;   %unsigned excursion outside of interval 0<PH<1
                PH(changing)=PH(changing)-PH_ex(changing).*direction; %PH is pinned to be within [0,1]  Seen machine error issues here
                PH(PH_ex~=0)=round(PH(PH_ex~=0));
                
                
                K(changing) = 1./( PH(changing)./kondl(Mat(Map(changing))) +(1-PH(changing))./kond(Mat(Map(changing))));  %update properties, K using series resistance
                CP(changing) = sphtl(Mat(Map(changing))).*PH(changing)+spht(Mat(Map(changing))).*(1-PH(changing));           %others using rule of mixtures
                RHO(changing) = rhol(Mat(Map(changing))).*PH(changing)+rho(Mat(Map(changing))).*(1-PH(changing));
                
                %walk back PH_ex into T using new properties
                if any(PH_ex)
                    T(changing) = T(changing) + direction .* PH_ex(changing) .* (Lv(Mat(Map(changing)))./(RHO(changing).*CP(changing)));
                end
               
            else %no change
                changing=meltmask;  %update changing to the expanded size (its all zeros)
            end
        end
     
    end
    
    methods (Static)  %ParaPower internal static methods.
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
        
        function [cap,vol]=mass(dx,dy,dz,RHO,CP,Mat,Mask)
            %takes dx, dy, dz of length NC, NR, NL to compute volume vector
            % capacity is computed from vol RHO and CP vectors - length NR*NC*NL
            
            %if a Mask is input, cap will be calculated for only those masked elements,
            %and will have length nnz(Mask).  Else, it will be calculated for the
            %entire solid portion of Mat.
            
            vol = reshape(reshape(dx'*dy,[],1)*dz,[],1);
            if ~exist('Mask','var')
                cap=RHO.*CP.*vol(Mat>0);
            else
                solid_vol=vol(Mat>0);
                cap=RHO(Mask).*CP(Mask).*solid_vol(Mask);
                %make sure your target output variable is also masked!
            end
        end
        
        function flux = InternalFlux(T,A)
            %flux = InternalFlux(T,A)
            %creates (sparse) matrix 'flux' with size(A) with entries f_ij that
            %gives nodal power transfer from node i to node j in Watts.
            %This matrix should be skew symmetric with 0s on the diagonal.
            diagT = spdiags(T,0,size(A,1),size(A,2));
            flux = diagT*A-A*diagT;
        end
        
        function flux = Flux(T,A,B,Ta)
            %flux = Flux(T,A,B,Ta)
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
            %flux = ExternalFlux(T,B,Ta)
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
    
    methods(Access = public)
         function obj=load_T_init(obj,T_init,times)
            % Load Predefined T_init distribution into internal state
            obj.T(:,times)=T_init(obj.Map,:);
         end
        
         function obj=load_PH_init(obj,PH_init,times)
         % Load Predefined T_init distribution into internal state
            obj.PH(:,times)=PH_init(obj.Map,:);
         end
    end
    
end
