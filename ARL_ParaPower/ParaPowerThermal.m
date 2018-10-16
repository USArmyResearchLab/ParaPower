%ParaPowerThermal
%given timestep size,geometry, temperature, and material properties, this 
%program estimates the temperature and thermally induced stresses in the 
%control geometry for the all timesteps

%WARNING: Coefficients of thermal expansion, thermal stresses, and residual
%stresses from processing temperatures have not been implemented for all
%materials
        
function [Tres,Stress,PHres] = ParaPowerThermal(NL,NR,NC,h,Ta,dx,dy,dz,Tproc,Mat,Q,delta_t,steps,T_init,matprops)
% This program uses the resistance network concept to solve for the
% temperatures and stresses due to CTE mismatch in an electronic component
% module

time_thermal = tic; %start recording time taken to do bulk of analysis
new_method = true;


%% Initialize variables
Num_Lay = NL;
Num_Row = NR;
Num_Col = NC;
dy = fliplr(dy);                                                            %flips the dy values so that the y indexing in this function, which is top to bottom, is consistent with dy(row)

kond = matprops(:,1)'; %Thermal conductivity of the solid
cte = matprops(:,2)'; %Coeficient of Thermal Expansion
E = matprops(:,3)'; %Young's Modulus
nu = matprops(:,4)'; %poissons ratio
rho = matprops(:,5)'; %density of the solid state
spht = matprops(:,6)'; %solid specific heat


K = kond(reshape(Mat,[],1))'; %Thermal Conductivity vector for nodal thermal conductivities. Updatable with time
CP = spht(reshape(Mat,[],1))'; %Specific heat vector for effective nodal specific heats. Updatable with time
RHO = rho(reshape(Mat,[],1))'; %effective density vector. Updatable with time

Qv=reshape(Q(:,:,:,1),[],1);  %pull a column vector from the i,j,k format of the first timestep




[isPCM,kondl,rhol,sphtl,Lw,Tm,PH,PH_init] = PCM_init(matprops,Num_Row,Num_Col,Num_Lay,steps);
Lv=(rho+rhol)/2 .* Lw;  %generate volumetric latent heat of vap using average density
%should we have a PH_init?



nlsub=1; % # layers that are substrate material
% Pre-load Matrices with zeros
A=zeros(Num_Row*Num_Col*Num_Lay,Num_Row*Num_Col*Num_Lay); % Conductance matrix in [A](T)={B}
Atrans=zeros(Num_Row*Num_Col*Num_Lay,Num_Row*Num_Col*Num_Lay); % diagonal matrix that will hold transient contributions
B=zeros(Num_Row*Num_Col*Num_Lay,1); % BC vector in [A](T)={B}
% Q=zeros(NR,NC,NL); % Nodal heat generation matrix, W

C=zeros(Num_Row*Num_Col*Num_Lay,1); % Nodal capacitance terms for transient effects
T=zeros(Num_Lay*Num_Row*Num_Col,steps); % Temperature matrix
Tres=zeros(Num_Row,Num_Col,Num_Lay,steps); % Nodal temperature results
Tprnt=zeros(Num_Row,Num_Col,Num_Lay); % Nodal temperature results realigned to match mesh layout
Stress=zeros(Num_Row,Num_Col,Num_Lay); % Nodal thermal stress results
Strprnt=zeros(Num_Row,Num_Col,Num_Lay); % Nodal stress results realigned to match mesh layout

if new_method
    hint=[];
    [Acon,Bcon,Bext,Map]=Connect_Init(Mat,h);
    [Acon,Bcon,newMap,header]=null_void_init(Mat,hint,Acon,Bcon,Map);
    fullheader=[header find(h)];
    [A,B,A_areas,B_areas,htcs] = conduct_build(Acon,Bcon,newMap,fullheader,K,hint,h,Mat,dx,dy,dz);

else
    [A,B] = Resistance_Network(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
end

if steps > 1
    % Calculate the capacitance term associated with each node and adjust the 
    % A matrix (implicit end - future) and C vector (explicit - present) to include the transient effects
    Cap=mass(dx,dy,dz,RHO,CP); %units of J/K
    Atrans=-diag(Cap./delta_t(1));  %Save Transient term for the diagonal of A matrix, units W/K
    C=-Cap./delta_t(1).*T_init; %units of watts
    
end
% Form loop over the number of time steps desired
for it=1:steps
    T(:,it)=(A+Atrans)\(B+Qv+C);  %T is temps at the end of the it'th step, C holds info about temps prior to it'th step
                    
    if any(isPCM(Mat(:)))
        if it==1
            [T(:,it),PH(:,it),changing,K,CP,RHO]=vec_Phase_Change(T(:,it),PH_init,Mat,kond,kondl,spht,sphtl,rho,rhol,Tm,Lv,K,CP,RHO);
        else
            [T(:,it),PH(:,it),changing,K,CP,RHO]=vec_Phase_Change(T(:,it),PH(:,it-1),Mat,kond,kondl,spht,sphtl,rho,rhol,Tm,Lv,K,CP,RHO);
        end
    end
       

    if steps > 1 && it~=steps
        Cap=mass(dx,dy,dz,RHO,CP); %units of J/K
        Atrans=-diag(Cap./delta_t(1));  %Save Transient term for the diagonal of A matrix, units W/K
        C=-Cap./delta_t(1).*T(:,it); %units of watts
        
        if exist('changing','var') && any(changing)
            touched=find((abs(A)*changing)>0);  %find not only those elements changing, but those touched by changing elements
            for u=1:length(touched)
               %[A,B]=Resistance_Update(u,A,B,Ta,Mat,h,K,dx,dy,dz);
            % Rebuild A, B with new material properties
            end
        % [A,B] = Resistance_Network(changing,A,B,K, etc);
        end
        
    end
   
    [A,B] = Resistance_Network(Num_Row,Num_Col,Num_Lay,A,B,Ta,Mat,h,K,dx,dy,dz);
    
    %Time history of A and B are not being stored, instead overwritten
end
Tres=reshape(T,NR,NC,NL,steps);
PHres=reshape(PH,NR,NC,NL,steps);

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

thermal_elapsed = toc(time_thermal)