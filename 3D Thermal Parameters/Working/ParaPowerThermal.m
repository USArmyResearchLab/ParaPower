function [Tres, Stress] = ParaPowerThermal(NL,NR,NC,h,Ta,dx,dy,dz,Tproc,Mat,Q,delta_t,steps,T_init,matprops)
% This program uses the resistance network concept to solve for the
% temperatures and stresses due to CTE mismatch in an electronic component
% module
% Establish global variables
global NL NR NC h Mat kond dx dy dz A B Ta Q cte E nu nlsub delta_t rho spht


kond=matprops(:,1)';
cte=matprops(:,2)';
E=matprops(:,3)';
nu=matprops(:,4)';
rho=matprops(:,5)';
spht=matprops(:,6)';
% Input parameters
% NL=2; % # of layers in the model
% NR=2; % # of rows in the model
% NC=2; % # of columns in the model
% Convection coefficients for the left, right, front, back, top and bottom
% of the model, W/m^2 K
% For an adiabatic or symmetry boundary enter 0
% h=[0 0 0 0 20000 0];
% Ambient or sink temperature for the left, right, front, back, top and bottom
% of the model, C
% Ta=[20 20 20 20 20 20];
% steps=10; % Number of time steps for calculation, steps=1 is steady state calculation
% Material conductivity vector, W/m K, load value for each material
% Materials are Cu, SiC
% kond=[390 120];
% Material CTE vector, m/m K, load value for each material
% Materials are Cu, SiC
% cte=[24.0e-6 4.0e-6];
% Young's modulus vector, N/m^2, load value for each material
% Materials are Cu, SiC
% E=[110e9 410e9];
% Poisson's ratio vector, load value for each material
% Materials are Cu, SiC
% nu=[0.37 0.14];
% Density vector, kg/m^3, load value for each material
% Materials are Cu, SiC
% rho=[8900 3100];
% Specific Heat vector, J/kg K, load value for each material
% Materials are Cu, SiC
% spht=[390 750];
% Processing temperature for thermal stress calculation, C
% Tproc=217;
% delta_t=.25; % Time step, sec
% dx=[.001 .0005]; % Column width vector, m, load value for each column
% dy=[.001 .0005]; % Row height vector, m, load value for each row
% dz=[.002 .0005]; % Layer thickness vector, m, load value for each layer
nlsub=1; % # layers that are substrate material
% Pre-load Matrices with zeros
A=zeros(NR*NC*NL,NR*NC*NL); % Conductance matrix in [A](T)={B}
B=zeros(NR*NC*NL,1); % Constants vector in [A](T)={B}
% Q=zeros(NR,NC,NL); % Nodal heat generation matrix, W
% Mat=zeros(NR,NC,NL); % Nodal material matrix
Cap=zeros(NR,NC,NL); % Nodal capacitance terms for transient effects
T_init=zeros(NR,NC,NL)+20; % Sets initial nodal temperatures to 20
T=zeros(NL*NR*NC,steps); % Temperature matrix
Tres=zeros(NR,NC,NL); % Nodal temperature results
Tprnt=zeros(NR,NC,NL); % Nodal temperature results realigned to match mesh layout
Stress=zeros(NR,NC,NL); % Nodal thermal stress results
Strprnt=zeros(NR,NC,NL); % Nodal stress results realigned to match mesh layout
B_stead=zeros(NL*NR*NC,1); % Steady state contribution to the B vector, only needed for a transient solution.
% Load the Q matrix
% Replace ii,jj,kk with corresponding row, column and layer values and replace q with the heat generation, W
% Q(2,2,2)=0.125; 
% Load the Mat matrix
% Replace ii,jj,kk with corresponding row, column and layer values and replace m with the material designation
% Enter a 0 for a location that does not have any material present
% Mat(:,:,1)=1; 
% Mat(:,:,2)=2;
% Load the A matrix and B vector without including the capacitance term associated with transient problems
% Load A matrix and B vector for left face nodes
LeftFace
% Load A matrix and B vector for right face nodes
RightFace
% Load A matrix and B vector for front face nodes
FrontFace
% Load A matrix and B vector for back face nodes
BackFace
% Load A matrix and B vector for bottom face nodes
BottomFace
% Load A matrix and B vector for top face nodes
TopFace
% Load A matrix and B for the interior nodes
Interior
% Check to see if a transient solution is desired, steps > 1.
if steps > 1
    B_stead=B;
    % Claculate the capacitance term associated with each node and adjust the 
    % A matrix and B vector to include the transient effects
    for kk=1:NL
        for ii=1:NR
            for jj=1:NC
                Ind=(kk-1)*NR*NC+(ii-1)*NC+jj;
                Cap(ii,jj,kk)=mass(ii,jj,kk);
                A(Ind,Ind)=A(Ind,Ind)-Cap(ii,jj,kk); %Includes Transient term in the A matrix
                B(Ind)=B_stead(Ind)-Cap(ii,jj,kk)*T_init(ii,jj,kk); %Includes Transient term in the B vector
            end
        end
    end
end
% Form loop over the number of time steps desired
for it=1:steps
    T(:,it)=A\B;
    for kk=1:NL
        for ii=1:NR
            for jj=1:NC
                Ind=(kk-1)*NR*NC+(ii-1)*NC+jj;
                % Load Temperature results matrix that reflects layer by layer position of the nodes
                Tres(ii,jj,kk,it)=T(Ind,it);
                % Makes the temperatures print in the same order as nodes for any partucular layer
                Tprnt(NR+1-ii,jj,kk,it)=T(Ind,it);
                % Update B vector for next time step of a transient solution
                if steps > 1
                    B(Ind)=B_stead(Ind)-Cap(ii,jj,kk)*T(Ind,it); %Includes Transient term in the B vector
                end
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
    for kk=1:NL
        for ii=1:NR
            for jj=1:NC
                % Calculate the thermal stress
                % Skip locations that have no material
                if Mat(ii,jj,kk) == 0
                    Stress(ii,jj,kk,it)=0;
                elseif kk <= nlsub
                    Stress(ii,jj,kk,it)=substrate_ex(ii,jj,kk,delT);
                else
                    Stress(ii,jj,kk,it)=layer_ex(ii,jj,kk,delT);
                end
                % Makes the stresses print in the same order as nodes for
                % any partucular layer
                Strprnt(NR+1-ii,jj,kk,it)=Stress(ii,jj,kk,it);
            end
        end
    end
end