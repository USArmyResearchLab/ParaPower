%ParaPowerThermal
%given timestep size,geometry, temperature, and material properties, this 
%program estimates the temperature and thermally induced stresses in the 
%control geometry for the all timesteps

%WARNING: Coefficients of thermal expansion, thermal stresses, and residual
%stresses from processing temperatures have not been implemented for all
%materials
        
function [Tres,Stress,PHres] = ParaPowerThermal(ModelInput)


h=ModelInput.h;
Ta=ModelInput.Ta;
dx=ModelInput.X;
dy=ModelInput.Y;
dz=ModelInput.Z;
Tproc=ModelInput.Tproc;
Mat=ModelInput.Model;
Q=ModelInput.Q;
T_init=ModelInput.Tinit;
matprops=ModelInput.matprops;
GlobalTime=ModelInput.GlobalTime;

% This program uses the resistance network concept to solve for the
% temperatures and stresses due to CTE mismatch in an electronic component
% module
if not(strcmpi(ModelInput.Version,'V2.0'))
    error(['Incorrect ModelInput version.  V2.0 required, this data is ' ModelInput.Version]);
end

time_thermal = tic; %start recording time taken to do bulk of analysis
new_method = true;


% %% Initialize variables
% Num_Lay = NL;
% Num_Row = NR;
% Num_Col = NC;


kond = matprops(:,1)'; %Thermal conductivity of the solid
cte = matprops(:,2)'; %Coeficient of Thermal Expansion
E = matprops(:,3)'; %Young's Modulus
nu = matprops(:,4)'; %poissons ratio
rho = matprops(:,5)'; %density of the solid state
spht = matprops(:,6)'; %solid specific heat

K = zeros(size(Mat));
K = reshape(K,[],1);
CP=K; %Seeding with 0's, for Matl 0 = seed
RHO=K; %Seeding with 0's, for Matl 0 = seed
K(Mat ~=0 ) = kond(Mat(Mat~=0));
CP(Mat ~=0) = spht(Mat(Mat~=0));
RHO(Mat ~=0) = rho(Mat(Mat~=0));




% K = kond(reshape(Mat,[],1))'; %Thermal Conductivity vector for nodal thermal conductivities. Updatable with time
% CP = spht(reshape(Mat,[],1))'; %Specific heat vector for effective nodal specific heats. Updatable with time
% RHO = rho(reshape(Mat,[],1))'; %effective density vector. Updatable with time

%convert Q from function handle form to value at single time of Qtime
Qtime=0; %Evaluate Q at time=0
for i=1:length(Q(:))
    if isempty(Q{i})
        Qv(i)=0;
    else
        Qv(i)=Q{i}(Qtime);
    end
end
Qv=reshape(Qv,size(Q));
        
%Qv=Q(:,:,:,1);
Qv=reshape(Qv(Mat>0),[],1);  %pull a column vector from the i,j,k format of the first timestep

%Indicator for static analysis, if steps is empty.
if isempty(GlobalTime)
    disp('Static Analysis');
else
    disp('Transient Analysis');
end


%[isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(Mat,matprops,Num_Row,Num_Col,Num_Lay,steps);
[isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(Mat,matprops,length(GlobalTime));
Lv=(rho+rhol)/2 .* Lw;  %generate volumetric latent heat of vap using average density
%should we have a PH_init?



nlsub=1; % # layers that are substrate material
% Pre-load Matrices with zeros
%A=zeros(Num_Row*Num_Col*Num_Lay,Num_Row*Num_Col*Num_Lay); % Conductance matrix in [A](T)={B}
%Atrans=zeros(Num_Row*Num_Col*Num_Lay,Num_Row*Num_Col*Num_Lay); % diagonal matrix that will hold transient contributions
%B=zeros(Num_Row*Num_Col*Num_Lay,1); % BC vector in [A](T)={B}
% Q=zeros(NR,NC,NL); % Nodal heat generation matrix, W

C=zeros(nnz(Mat>0),1); % Nodal capacitance terms for transient effects
T=zeros(nnz(Mat>0),length(GlobalTime)); % Temperature DOF vector
Tres=zeros(numel(Mat),length(GlobalTime)); % Nodal temperature results
PHres=Tres;
%Tprnt=zeros(Num_Row,Num_Col,Num_Lay); % Nodal temperature results realigned to match mesh layout
Stress=zeros(size(Mat)); % Nodal thermal stress results
Strprnt=zeros(size(Mat)); % Nodal stress results realigned to match mesh layout

if new_method
    hint=[];
    [Acon,Bcon,Bext,Map]=Connect_Init(Mat,h);
    [Acon,Bcon,newMap,header]=null_void_init(Mat,hint,Acon,Bcon,Map);
    fullheader=[header find(h)];
    [A,B,A_areas,B_areas,A_hLengths,B_hLengths,htcs] = conduct_build(Acon,Bcon,newMap,fullheader,K,hint,h,Mat,dx,dy,dz);
    if isempty(B)
        B=spalloc(size(C,1),size(C,2),0);
        fullheader=[1];
    end
               
else
    [A,B] = Resistance_Network(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
end

if not(isempty(GlobalTime))
    delta_t=GlobalTime(2:end)-GlobalTime(1:end-1);
    % Calculate the capacitance term associated with each node and adjust the 
    % A matrix (implicit end - future) and C vector (explicit - present) to include the transient effects
    [Cap,vol]=mass(dx,dy,dz,RHO,CP,Mat); %units of J/K
    vol=reshape(vol,size(Mat));
    Atrans=-spdiags(Cap,0,size(A,1),size(A,2))./delta_t(1);  %Save Transient term for the diagonal of A matrix, units W/K
    C=-Cap./delta_t(1).*T_init; %units of watts
else
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

for it=2:length(GlobalTime)
    
    T(:,it)=(A+Atrans)\(-B*Ta(fullheader)'+Qv+C);  %T is temps at the end of the it'th step, C holds info about temps prior to it'th step

    if any(isPCM(Mat(Mat~=0))) && not(isnan(GlobalTime(2))) %melting disabled for static analyses
        if it==1  %use PH_init
            [T(:,it),PH(:,it),changing,K,CP,RHO]=vec_Phase_Change(T(:,it),PH_init,Mat,newMap,kond,kondl,spht,sphtl,rho,rhol,Tm,Lv,K,CP,RHO);
        else      %use PH of previous step
            [T(:,it),PH(:,it),changing,K,CP,RHO]=vec_Phase_Change(T(:,it),PH(:,it-1),Mat,newMap,kond,kondl,spht,sphtl,rho,rhol,Tm,Lv,K,CP,RHO);
        end
    end

    if not(isnan(GlobalTime(2))) && it~=length(GlobalTime)  %Do we have timesteps to undertake?
        
       if exist('changing','var') && any(changing)  %Have material properties changed?
            touched=find((abs(A)*changing)>0);  %find not only those elements changing, but those touched by changing elements
            
            %update capacitance (only those changing since internal to element)
            Cap(changing)=mass(dx,dy,dz,RHO,CP,Mat,changing); %units of J/K
            
            %Entire Rebuild, for testing
            %[A,B,A_areas,B_areas,A_hLengths,B_hLengths,htcs] = conduct_build(Acon,Bcon,newMap,fullheader,K,hint,h,Mat,dx,dy,dz);
            
            %update A and B
            [Acomp,Bcomp,htcs] = conduct_update(A,B,A_areas,B_areas,A_hLengths,B_hLengths,htcs,K(Map),touched);
            
            %diffA=A-Acomp
            %diffB=B-Bcomp
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


%{
% Calculate thermal stress based CTE mismatch
% Loop over all the time steps
for it=1:steps
    % Calculate the difference between the operating temp and the processing
    % temp for thermal stress calc
    delT=Tres(:,:,:,it)-Tproc;
    % Loop over all the nodes in the model
    for kk=1:Num_Lay
        for ii=1:Num_Row
            for jj=1:Num_Col
                % Calculate the thermal stress
                % Skip locations that have no material
                if Mat(ii,jj,kk) == 0
                    Stress(ii,jj,kk,it)=0;
                elseif kk <= nlsub
                    Stress(ii,jj,kk,it)=substrate_ex(ii,jj,kk,delT,dz,cte,E,nu,nlsub,Mat,NL);
                else
                    Stress(ii,jj,kk,it)=layer_ex(ii,jj,kk,delT,dz,cte,E,nu,nlsub,Mat,NL);
                end
                % Makes the stresses print in the same order as nodes for
                % any partucular layer
                Strprnt(Num_Row+1-ii,jj,kk,it)=Stress(ii,jj,kk,it);
            end
        end
    end
end
%}


thermal_elapsed = toc(time_thermal);