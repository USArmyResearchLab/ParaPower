%ParaPowerThermal
%given timestep size,geometry, temperature, and material properties, this 
%program estimates the temperature and thermally induced stresses in the 
%control geometry for the all timesteps
       
function [Tres,ModelInput,PHres] = ParaPowerThermal(ModelInput)

%% Initialization

h=ModelInput.h;
Ta=ModelInput.Ta;
dx=ModelInput.X;
dy=ModelInput.Y;
dz=ModelInput.Z;
Mat=ModelInput.Model;
Q=ModelInput.Q;
T_init=ModelInput.Tinit;
GlobalTime=ModelInput.GlobalTime;

hint=[];
Ta_void=[];

% This program uses the resistance network concept to solve for the
% temperatures and stresses due to CTE mismatch in an electronic component
% module
if not(strcmpi(ModelInput.Version,'V2.0'))
    error(['Incorrect ModelInput version.  V2.0 required, this data is ' ModelInput.Version]);
end

time_thermal = tic; %start recording time taken to do bulk of analysis

kond = ModelInput.MatLib.k; %Thermal conductivity of the solid
rho = ModelInput.MatLib.rho; %density of the solid state
spht = ModelInput.MatLib.cp; %solid specific heat

K = zeros(size(Mat));
K = reshape(K,[],1);
CP=K; %Seeding with 0's, for Matl 0 = seed
RHO=K; %Seeding with 0's, for Matl 0 = seed
K(Mat ~=0 ) = kond(Mat(Mat~=0));
CP(Mat ~=0) = spht(Mat(Mat~=0));
RHO(Mat ~=0) = rho(Mat(Mat~=0));

Qmask=~cellfun('isempty',Q(:));  %return logical mask with ones where Qs are def

%Indicator for static analysis, if steps is empty. Form Q vectors.
if isempty(GlobalTime)
    disp('Static Analysis');
    %convert Q from function handle form to value at single time of Qtime
    zer_eval=num2cell(zeros(nnz(Qmask),1));  
    Qval=cellfun(@feval,Q(Qmask),zer_eval);  
    clear zer_eval
    %evaluate each nonempty cell of Q at t=0
    Qv=sparse(find(Qmask),ones(nnz(Qmask)),Qval,length(Mat(:)));  %
    %Q's for the entire Mat matrix, vector for the single static step
    
else
    disp('Transient Analysis');    
    %cell arrays are fun!
    GT_eval{1}=GlobalTime;
    GT_eval=repmat(GT_eval,nnz(Qmask),1);  
    Qval=cell2mat(cellfun(@arrayfun,Q(Qmask),GT_eval,'UniformOutput',false));
    clear GT_eval
    %evaluate each nonempty cell of Q at all timesteps
    Qv=spalloc(length(Mat(:)),length(GlobalTime)-1,nnz(Qmask)*(length(GlobalTime)-1));
    Qv(Qmask,:)=sparse(Qval(:,1:end-1)+Qval(:,2:end))/2;
    %Qv is now a sparse 2D array with rows corresponding to Mat entries and
    %columns for each timestep numel(dt).  The Q dissipated during a
    %timestep is the average of the values at times bookending the step
    %CONS of ENERGY ISSUE - this is a trapz approx of the variable Q
    %dissipation.
    
end

C=zeros(nnz(Mat>0),1); % Nodal capacitance terms for transient effects
T=zeros(nnz(Mat>0),length(GlobalTime)); % Temperature DOF vector
T(:,1)=T_init;
Tres=zeros(numel(Mat),length(GlobalTime)); % Nodal temperature results


PHres=Tres;
%[isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(Mat,matprops,Num_Row,Num_Col,Num_Lay,steps);
[kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(ModelInput);
PH(:,1)=PH_init;
Lv=(rho+rhol)/2 .* Lw;  %generate volumetric latent heat of vap using average density
%should we have a PH_init?
rollcall=unique(Mat);
rollcall=rollcall(rollcall>0); %cant index zero or negative mat numbers
meltable=any(strcmp(ModelInput.MatLib.Type(rollcall),'PCM'));



%% Build Adjacency and Conductance Matrices

[Aadj,Badj,Bext,Map]=Connect_Init(Mat,h);
[Aadj,Badj,Map,fullheader,Ta_vec]=null_void_init(Mat,h,hint,Aadj,Badj,Map,Ta,Ta_void);
%fullheader=[header find(h)];  %fullheader is a rowvector of negative matnums and a subset of 1 thru 6
[A,B,A_areas,B_areas,A_hLengths,B_hLengths,htcs] = conduct_build(Aadj,Badj,Map,fullheader,K,hint,h,Mat,dx,dy,dz);
if isempty(B)
    B=spalloc(size(C,1),size(C,2),0);
    fullheader=1;
    Ta_vec=1;
end

% Diagonal Terms
if not(isempty(GlobalTime))
    delta_t=GlobalTime(2:end)-GlobalTime(1:end-1);
    % Calculate the capacitance term associated with each node and adjust the 
    % A matrix (implicit end - future) and C vector (explicit - present) to include the transient effects
    [Cap,vol]=mass(dx,dy,dz,RHO,CP,Mat); %units of J/K
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
% Form loop over the number of time steps desired

%Globaltime is to single time step from 0 to NaN if static analysis is needed
%delta_t is based off of GlobalTime for transient analysis and set to NaN
%   for static analysis.  
%For time step "it" that corresponds to t=GlobalTime(it).  The preceding 
%   delta time is delta_t(it-1).  So, the delta_t leading up to time step
%   5 [GlobalTime(5)] is delta_t(4)

if meltable
    meltmask=strcmp(ModelInput.MatLib.Type(Mat(Map)),'PCM');
end


%% Timestepping 
for it=2:length(GlobalTime)
    
    T(:,it)=(A+Atrans)\(-B*Ta_vec'+Qv(Map,it-1)+C);  %T is temps at the end of the it'th step, C holds info about temps prior to it'th step

    if meltable && not(isnan(GlobalTime(2))) %melting disabled for static analyses
        [T(:,it),PH(:,it),changing,K,CP,RHO]=vec_Phase_Change(T(:,it),PH(:,it-1),Mat,Map,meltmask,kond,kondl,spht,sphtl,rho,rhol,Tm,Lv,K,CP,RHO);
    end

    if not(isnan(GlobalTime(2))) && it~=length(GlobalTime)  %Do we have timesteps to undertake?
        
       if exist('changing','var') && any(changing)  %Have material properties changed?
            touched=find((abs(A)*changing)>0);  %find not only those elements changing, but those touched by changing elements
            
            %update capacitance (only those changing since internal to element)
            Cap(changing)=mass(dx,dy,dz,RHO,CP,Mat,Map(changing)); %units of J/K
            
            %Entire Rebuild, for testing
            %[A,B,A_areas,B_areas,A_hLengths,B_hLengths,htcs] = conduct_build(Acon,Bcon,newMap,fullheader,K,hint,h,Mat,dx,dy,dz);
            
            %update A and B
            [A,B,htcs] = conduct_update(A,B,A_areas,B_areas,A_hLengths,B_hLengths,htcs,K(Map),touched);
        end
        
        
        Atrans=-spdiags(Cap,0,size(A,1),size(A,2))./delta_t(it-1);  %Save Transient term for the diagonal of A matrix, units W/K
        C=-Cap./delta_t(it-1).*T(:,it); %units of watts
    end
    
    %Time history of A and B are not being stored, instead overwritten
end

Tres(Mat>0,:)=T;
PHres(Mat>0,:)=PH;

Tres=reshape(Tres,[size(Mat) length(GlobalTime)]);
PHres=reshape(PHres,[size(Mat) length(GlobalTime)]);

ModelInput.A=A;
ModelInput.B=B;
ModelInput.A_areas=A_areas;
ModelInput.B_areas=B_areas;
ModelInput.A_hLengths=A_hLengths;
ModelInput.B_hLengths=B_hLengths;
ModelInput.Map=Map;  %The rows of A correspond to elements enumerated by Mat(Map)

thermal_elapsed = toc(time_thermal);

end