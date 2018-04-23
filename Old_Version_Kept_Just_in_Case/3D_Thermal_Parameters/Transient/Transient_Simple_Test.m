% This program uses the resistance network concept to solve for the
% temperatures and stresses due to CTE mismatch in an electronic component
% module
% Establish global variables
global NL NR NC h Mat kond dx dy dz A B Ta Q cte E nu nlsub delta_t rho spht
% Input parameters
NL=2; % # of layers in the model
NR=2; % # of rows in the model
NC=2; % # of columns in the model
% Convection coefficients for the left, right, front, back, top and bottom
% of the model, W/m^2 K
% For an adiabatic or symmetry boundary enter 0
h=[0 0 0 0 5000 0];
% Ambient or sink temperature for the left, right, front, back, top and bottom
% of the model, C
Ta=[20 20 20 20 20 20];
steps=100; % Number of time steps for calculation, steps=1 is steady state calculation
Q=zeros(NR,NC,NL); % Nodal heat generation matrix, W
Mat=zeros(NR,NC,NL); % Nodal material matrix
Cap=zeros(NR,NC,NL); % Nodal capacitance terms for transient effects
T_init=zeros(NR,NC,NL)+20; % Sets initial nodal temperatures to 20
T=zeros(NL*NR*NC,steps); % Temperature matrix
Tres=zeros(NR,NC,NL); % Nodal temperature results
Tprnt=zeros(NR,NC,NL); % Nodal temperature results realigned to match mesh layout
Stress=zeros(NR,NC,NL); % Nodal thermal stress results
Strprnt=zeros(NR,NC,NL); % Nodal stress results realigned to match mesh layout
xx=zeros(1,NC); % x position vector
yy=zeros(1,NR); % y position vector
zz=zeros(1,NL); % z position vector
B_stead=zeros(NL*NR*NC,1); % Steady state contribution to the B vector, only needed for a transient solution.
% Material conductivity vector, W/m K, load value for each material
% Materials are Cu, SiC
kond=[390 120];
% Material CTE vector, m/m K, load value for each material
% Materials are Cu, SiC
cte=[24.0e-6 4.0e-6];
% Young's modulus vector, N/m^2, load value for each material
% Materials are Cu, SiC
E=[110e9 410e9];
% Poisson's ratio vector, load value for each material
% Materials are Al, Cu, AlN, SiC
nu=[0.37 0.14];
% Density vector, kg/m^3, load value for each material
% Materials are Cu, SiC
rho=[8900 3100];
% Specific Heat vector, J/kg K, load value for each material
% Materials are Cu, SiC
spht=[390 750];
% Processing temperature for thermal stress calculation, C
Tproc=217;
delta_t=.25; % Time step, sec
dx=[.001 .0005]; % Column width vector, m, load value for each column
dy=[.001 .0005]; % Row height vector, m, load value for each row
dz=[.002 .0005]; % Layer thickness vector, m, load value for each layer
nlsub=1; % # layers that are substrate material
% Load the Q matrix
% Replace ii,jj,kk with corresponding row, column and layer values and replace q with the heat generation, W
Q(2,2,2)=0.125; 
% Load the Mat matrix
% Replace ii,jj,kk with corresponding row, column and layer values and replace m with the material designation
% Enter a 0 for a location that does not have any material present
Mat(:,:,1)=1; 
Mat(:,:,2)=2;
% Load the A matrix and B vector without including the capacitance term
% associated with transient problems
A=zeros(NR*NC*NL,NR*NC*NL); % Conductance matrix in [A](T)={B}
B=zeros(NR*NC*NL,1); % Constants vector in [A](T)={B}

% NL 
% NR
% NC 
% h
% Mat
% kond
% dx
% dy
% dz 
% A 
% B
% Ta 
% Q 
% cte 
% E 
% nu
% nlsub
% delta_t
% rho 
% spht
% pause



% Load A matrix and B vector for left face nodes
LeftFace
B
% Load A matrix and B vector for right face nodes
RightFace
B
% Load A matrix and B vector for front face nodes
FrontFace
B
% Load A matrix and B vector for back face nodes
BackFace
B
% Load A matrix and B vector for bottom face nodes
BottomFace
B
% Load A matrix and B vector for top face nodes
TopFace
B
% Load A matrix and B for the interior nodes
Interior
% Check to see if a transient solution is desired, steps > 1.
B
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
    if steps > 1
        % Update B vector for next time step of a transient solution
        for kk=1:NL
            for ii=1:NR
                for jj=1:NC
                    Ind=(kk-1)*NR*NC+(ii-1)*NC+jj;
                    B(Ind)=B_stead(Ind)-Cap(ii,jj,kk)*T(Ind,it); %Includes Transient term in the B vector 
                end
            end
        end
    end
end
% Load Temperature results matrix that reflects layer by layer position of
% the nodes
for kk=1:NL
    for ii=1:NR
        for jj=1:NC
            Ind=(kk-1)*NR*NC+(ii-1)*NC+jj;
            Tres(ii,jj,kk)=T(Ind,steps);
            % Makes the temperatures print in the same order as nodes for
            % any partucular layer
            Tprnt(NR+1-ii,jj,kk)=T(Ind,steps); 
        end
    end
end
% Calculate thermal stress based CTE mismatch
% Calculate the difference between the operating temp and the processing
% temp for thermal stress calc
delT=Tres-Tproc;
% Loop over all the nodes in the model
for kk=1:NL
    for ii=1:NR
        for jj=1:NC
                % Calculate the thermal stress
                % Skip locations that have no material
                if Mat(ii,jj,kk) == 0
                    Stress(ii,jj,kk)=0;
                elseif kk <= nlsub
                    Stress(ii,jj,kk)=substrate_ex(ii,jj,kk,delT);
                else
                    Stress(ii,jj,kk)=layer_ex(ii,jj,kk,delT);
                end
                % Makes the stresses print in the same order as nodes for
                % any partucular layer
                Strprnt(NR+1-ii,jj,kk)=Stress(ii,jj,kk);
        end
    end
end
% A
B
% B_stead
% Cap
% delta_t
% Mat
% Q
% Stress
% T_init
% Tprnt
% Tres
% dx
% dy
% dz
% Tres
% Stress
% Calculate vectors that contain the X, Y and Z positions of nodes for
% plotting. X contains the x position of the columns, Y contains the y
% positions of the rows, and Z contains the z positions of the layers
% % % xx(1)=dx(1)/2;
% % % for i=2:NC
% % %     xx(i)=xx(i-1)+(dx(i-1)+dx(i))/2;
% % % end
% % % yy(1)=dy(1)/2;
% % % for i=2:NR
% % %     yy(i)=yy(i-1)+(dy(i-1)+dy(i))/2;
% % % end
% % % zz(1)=dz(1)/2;
% % % for i=2:NL
% % %     zz(i)=zz(i-1)+(dz(i-1)+dz(i))/2;
% % % end
% % % [X,Y]=meshgrid(xx,yy);
% % %             

