%ParaPowerThermal
%Edited by Michael Deckard
%given timestep size,geometry, temperature, and material properties, this 
%program estimates the temperature and thermally induced stresses in the 
%control geometry for the all timesteps

%WARNING: Coefficients of thermal expansion, thermal stresses, and residual
%stresses from processing temperatures have not been implemented for all
%materials
        
function [Tprnt, Stress,meltfrac] = ParaPowerThermal(NL,NR,NC,h,Ta,dx,dy,dz,Tproc,Mat,Q,delta_t,steps,T_init,matprops)
% This program uses the resistance network concept to solve for the
% temperatures and stresses due to CTE mismatch in an electronic component
% module

time_thermal = tic; %start recording time taken to do bulk of analysis

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

nlsub=1; % # layers that are substrate material
% Pre-load Matrices with zeros
A=zeros(Num_Row*Num_Col*Num_Lay,Num_Row*Num_Col*Num_Lay); % Conductance matrix in [A](T)={B}
B=zeros(Num_Row*Num_Col*Num_Lay,1); % Constants vector in [A](T)={B}
% Q=zeros(NR,NC,NL); % Nodal heat generation matrix, W


[isPCM,kondl,rhol,sphtl,Lw,Tm,meltfrac,hft,K,CP,RHO] = PCM_init(matprops,Num_Row,Num_Col,Num_Lay,steps,Mat,kond,spht,rho);

Cap=zeros(Num_Row,Num_Col,Num_Lay); % Nodal capacitance terms for transient effects
T=zeros(Num_Lay*Num_Row*Num_Col,steps); % Temperature matrix
Tres=zeros(Num_Row,Num_Col,Num_Lay,steps); % Nodal temperature results
Tprnt=zeros(Num_Row,Num_Col,Num_Lay); % Nodal temperature results realigned to match mesh layout
Stress=zeros(Num_Row,Num_Col,Num_Lay); % Nodal thermal stress results
Strprnt=zeros(Num_Row,Num_Col,Num_Lay); % Nodal stress results realigned to match mesh layout
B_stead=zeros(Num_Lay*Num_Row*Num_Col,1); % Steady state contribution to the B vector, only needed for a transient solution.
% B_Trans=zeros(Num_Lay*Num_Row*Num_Col,1);

[A,B] = Resistance_Network(Num_Row,Num_Col,Num_Lay,A,B,Ta,Q,Mat,h,K,dx,dy,dz);


if steps > 1
    B_stead=B;
%     A_read_1 = diag(A);
    % Claculate the capacitance term associated with each node and adjust the 
    % A matrix and B vector to include the transient effects
    for kk=1:Num_Lay
        for ii=1:Num_Row
            for jj=1:Num_Col
                Ind=(kk-1)*Num_Row*Num_Col+(ii-1)*Num_Col+jj;
                Cap(ii,jj,kk)=mass(Mat(ii,jj,kk),dx(ii),dy(jj),dz(kk),RHO(ii,jj,kk),CP(ii,jj,kk),delta_t);
                A(Ind,Ind)=A(Ind,Ind)-Cap(ii,jj,kk); %Includes Transient term in the A matrix
                B(Ind)=B_stead(Ind)-Cap(ii,jj,kk)*T_init; %Includes Transient term in the B vector
%                 A_read(ii,jj,kk)=A_read_1(Ind);
%                 B_read2(ii,jj,kk) = B(Ind);
            end
        end
    end
end
% Form loop over the number of time steps desired
for it=1:steps
    T(:,it)=A\B;
    for kk=1:Num_Lay
        for ii=1:Num_Row
            for jj=1:Num_Col
                Ind=(kk-1)*Num_Row*Num_Col+(ii-1)*Num_Col+jj;
                % Load Temperature results matrix that reflects layer by layer position of the nodes
                Tres(ii,jj,kk,it)=T(Ind,it);
                % Makes the temperatures print in the same order as nodes for any partucular layer               
                
                if isPCM(Mat(ii,jj,kk)) == 1
                [Tres(ii,jj,kk,it),hft(ii,jj,kk),meltfrac(ii,jj,kk,it),K(ii,jj,kk),CP(ii,jj,kk),RHO(ii,jj,kk),Cap(ii,jj,kk)] = Phase_Change(Mat,Tres(ii,jj,kk,it),Tm(Mat(ii,jj,kk)),hft(ii,jj,kk),Lw(Mat(ii,jj,kk)),CP(ii,jj,kk),kondl(Mat(ii,jj,kk)),kond(Mat(ii,jj,kk)),sphtl(Mat(ii,jj,kk)),spht(Mat(ii,jj,kk)),rhol(Mat(ii,jj,kk)),rho(Mat(ii,jj,kk)),dx(ii),dy(jj),dz(kk),delta_t);
                end

                
                Tprnt(ii,jj,kk,it)=T(Ind,it);
                % Update B vector for next time step of a transient solution
                if steps > 1
                    %                     B_Trans(Ind) = -Cap(ii,jj,kk)*Tres(ii,jj,kk,it);
                    B(Ind)=B_stead(Ind)-Cap(ii,jj,kk)*Tres(ii,jj,kk,it); %Includes Transient term in the B vector
                end
            end
        end
    end
    %A matrix redone to account for changes in conductivity from melting of
    %PCM. Could potentially be optomized to only redo A matrix for nodes
    %which are affected by this conductivity change. Whether this will
    %improve or worsen times is unknown. It may be that the math and
    %processes required to isolate affected nodes is more intense than
    %simply redoing all nodes. Improvement may be affected by ratio of PCM
    %to non PCM nodes, and geometry. Could also be improved by activating
    %only when PCM phase state is changing.
    
    [A,~] = Resistance_Network(Num_Row,Num_Col,Num_Lay,A,B,Ta,Q,Mat,h,K,dx,dy,dz);
    
    
    
    for kk=1:Num_Lay
        for ii=1:Num_Row
            for jj=1:Num_Col
                Ind=(kk-1)*Num_Row*Num_Col+(ii-1)*Num_Col+jj;
                A(Ind,Ind)=A(Ind,Ind)-Cap(ii,jj,kk); %Includes new Transient term in the A matrix
            end
        end
    end
end
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