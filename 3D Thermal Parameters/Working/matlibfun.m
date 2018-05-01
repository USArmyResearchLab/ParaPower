function [matprops,matlist,matcolors,kond,cte,E,nu,rho,spht] = matlibfun( )
% Function generates a materail matrix to be referenced through the thermal
% analysis GUI. Vectors are organized as follows: 
% [Material Conductivity, CTE, Modulus of Ela., Poission's Rat.]
% At this time new material data must be added manually with esspecially
% care in adding an new line in the "M" matrix.
%[kond cte E nu rho spht]
% % Al=[172 23.5e-6 69e9 0.33 2700 900]; %Aluminum Material Data
% % Cu=[401 16.6e-6 117e9 0.36 8900 390]; %Copper Materail Data
% % AlN=[170 5.3e-6 344e9 0.24 3260 740]; %Aluminum Nitride Material Data
% % SiC=[380 2.8e-6 450e9 0.19 3100 750]; %Silicon Carbide Material Data
% % EN=[0.1 55e-6 2.5e9 0.3 0 0]; %Encapsulent Material Data
% % matprops=[Al;Cu;AlN;SiC;EN];%Material matrix, will display with several vaules 
% % kond=matprops(:,1)';
% % cte=matprops(:,2)';
% % E=matprops(:,3)';
% % nu=matprops(:,4)';
% % rho=matprops(:,5)';
% % spht=matprops(:,6)';
Al=[172 23.5e-6 69e9 0.33 2700 900]; %Aluminum Material Data
Cu=[390 24e-6 110e9 0.37 8900 390]; %Copper Materail Data
AlN=[170 5.3e-6 344e9 0.24 3260 740]; %Aluminum Nitride Material Data
SiC=[120 4e-6 410e9 0.14 3100 750]; %Silicon Carbide Material Data
EN=[0.1 55e-6 2.5e9 0.3 0 0]; %Encapsulent Material Data
Chip=[1.14 0 0 0 2230 753.12];
Alumina=[25 0 0 0 3720 880];
AIR=[0.024 100 0 0 1.225 0];
matprops=[Al;Cu;AlN;SiC;EN;Chip;Alumina;AIR];%Material matrix, will display with several vaules 
kond=matprops(:,1)';
cte=matprops(:,2)';
E=matprops(:,3)';
nu=matprops(:,4)';
rho=matprops(:,5)';
spht=matprops(:,6)';

% equal to zero do to large magnitude differences. The correct vaules are
% still retained when accessed. 
matlist={'Al';'Cu';'AlN';'SiC';'EN';'Chip';'Alumina';'AIR'}; %Material display list, entry must be
% string and in identical order as matrix M
Al=[0.88 0.88 0.88];            %aluminum  colorway
Cu=[0.72 0.45 0.2];             %copper colorway
AlN=[0.3 0.2 0.2];              %aluminum nitride colorway
SiC=[0.16 0.2 0.2];             %silicon carbide colorwary
EN=[0 1 1];                     %encapsulent colorway
Chip=[1 1 1];
Alumina=[1 1 1];
AIR=[1 1 1];
matcolors=[Al;Cu;AlN;SiC;EN;Chip;Alumina;AIR];   %material colorway matrix. Must also be in identical order to material matrix
end

