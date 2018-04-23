% This program uses the resistance network concept to solve for the
% temperatures and stresses due to CTE mismatch in an electronic component
% module
% Establish global variables

S=[0:0.01:0.02];
for i=1:3
    clear global
global NL NR NC h Mat kond dx dy dz A B Ta Q cte E nu nlsub
    % Input parameters
NL=6; % # of layers in the model
NR=7; % # of rows in the model
NC=7; % # of columns in the model
% Convection coefficients for the left, right, front, back, top and bottom
% of the model, W/m^2 K
% For an adiabatic or symmetry boundary enter 0
h=[10 10 10 10 1000 10];
% Ambient or sink temperature for the left, right, front, back, top and bottom
% of the model, C
Ta=[20 20 20 20 20 20];
Q=zeros(NR,NC,NL); % Nodal heat generation matrix, W
Mat=zeros(NR,NC,NL); % Nodal material matrix
Tres=zeros(NR,NC,NL); % Nodal temperature results
Tprnt=zeros(NR,NC,NL); % Nodal temperature results realigned to match mesh layout
Stress=zeros(NR,NC,NL); % Nodal thermal stress results
xx=zeros(1,NC); % x position vector
yy=zeros(1,NR); % y position vector
zz=zeros(1,NL); % z position vector
% Material conductivity vector, W/m K, load value for each material
% Materials are Al, Cu, AlN, SiC, Encapsulent
kond=[172 401 170 380 0.1];
% Material CTE vector, m/m K, load value for each material
% Materials are Al, Cu, AlN, SiC, Encapsulent
cte=[23.5e-6 16.6e-6 5.3e-6 2.8e-6 55e-6];
% Young's modulus vector, N/m^2, load value for each material
% Materials are Al, Cu, AlN, SiC, Encapsulent
E=[69e9 117e9 344e9 450e9 2.5e9];
% Poisson's ratio vector, load value for each material
% Materials are Al, Cu, AlN, SiC, Encapsulent
nu=[0.33 0.36 0.24 0.19 0.3];
% Processing temperature for thermal stress calculation, C
Tproc=280;
dx=[.002 .008 .002 .006 .002 .008 .002]; % Column width vector, m, load value for each column
dx(1,4)=dx(1,4)+S(1,i);
dx
dy=[.002 .008 .002 .006 .002 .008 .002]; % Row height vector, m, load value for each row
dz=[.01 .0003 .00064 .0003 .0005 .0058]; % Layer thickness vector, m, load value for each layer
nlsub=1; % # layers that are substrate material
% Load the Q matrix
% Replace ii,jj,kk with corresponding row, column and layer values and replace q with the heat generation, W
Q(2,2,5)=64; 
Q(2,6,5)=64;
Q(6,2,5)=64;
Q(6,6,5)=64;
% Load the Mat matrix
% Replace ii,jj,kk with corresponding row, column and layer values and replace m with the material designation
% Enter a 0 for a location that does not have any material present
Mat(:,:,1)=1; 
Mat(:,:,2)=2;
Mat(:,:,3)=3;
Mat(:,:,4)=2;
Mat(1,4,4)=5;
Mat(2,4,4)=5;
Mat(3,4,4)=5;
Mat(4,1,4)=5;
Mat(4,2,4)=5;
Mat(4,3,4)=5;
Mat(4,4,4)=5;
Mat(4,5,4)=5;
Mat(4,6,4)=5;
Mat(4,7,4)=5;
Mat(:,:,5)=5;
Mat(2,2,5)=4;
Mat(2,6,5)=4;
Mat(6,2,5)=4;
Mat(6,6,5)=4;
Mat(:,:,6)=5;
A=zeros(NR*NC*NL,NR*NC*NL); % Conductance matrix in [A](T)={B}
B=zeros(NR*NC*NL,1); % Constants vector in [A](T)={B}
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
T=A\B;
% Load Temperature results matrix that reflects layer by layer position of
% the nodes
for kk=1:NL
    for ii=1:NR
        for jj=1:NC
            Ind=(kk-1)*NR*NC+(ii-1)*NC+jj;
            Tres(ii,jj,kk)=T(Ind);
            % Makes the temperatures print in the same order as nodes for
            % any partucular layer
            Tprnt(NR+1-ii,jj,kk)=T(Ind); 
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
% Calculate vectors that contain the X, Y and Z positions of nodes for
% plotting. X contains the x position of the columns, Y contains the y
% positions of the rows, and Z contains the z positions of the layers
% xx(1)=dx(1)/2;
% for i=2:NC
%     xx(i)=xx(i-1)+(dx(i-1)+dx(i))/2;
% end
% yy(1)=dy(1)/2;
% for i=2:NR
%     yy(i)=yy(i-1)+(dy(i-1)+dy(i))/2;
% end
% zz(1)=dz(1)/2;
% for i=2:NL
%     zz(i)=zz(i-1)+(dz(i-1)+dz(i))/2;
% end
% [X,Y]=meshgrid(xx,yy);    
% for i=1:NL
%     xlswrite('ConfirmStress12.xlsx',Stress(:,:,i),i)
%     xlswrite('ConfirmTemp12.xlsx',Tres(:,:,i),i)
% end
tmax=max(Tres(:))
end
