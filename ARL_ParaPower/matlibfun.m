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
% isPCM = matprops(:,7)'; %flags material as Phase Change Material, and thus meltable
% kondl = matprops(:,8)'; %liquid thermal conductivity
% rhol = matprops(:,9)'; %density of the liquid state
% sphtl = matprops(:,10)'; %solid volumetric heat (volumetric form of specific heat)
% Lw = matprops(:,11)'; %Latent heat of fusion
% Tm = matprops(:,12)'; %Melting point of material, in degrees C



%In process of redefining material library
Material=[];
Material(end+1).Name            ='Al';
Material(end).Solid_Condivity   =172;
Material(end).cte               =23.5e-6;
Material(end).E                 =69e9;
Material(end).PoissonRatio      =.33;
Material(end).Solid_Density     =2700;
Material(end).Solid_SpecHeat    =900;
Material(end).isPCM             =0;
Material(end).Liq_Conductivity  =0;
Material(end).Liq_Density       =0;
Material(end).Liq_SpecHeat      =0;
Material(end).HeatFusion        =0;
Material(end).Tmelt             =0;

Al=[172 23.5e-6 69e9 0.33 2700 900 0 0 0 0 0 0]; %Aluminum Material Data
Cu=[390 24e-6 110e9 0.37 8900 390 0 0 0 0 0 0]; %Copper Materail Data
AlN=[170 5.3e-6 344e9 0.24 3260 740 0 0 0 0 0 0]; %Aluminum Nitride Material Data
SiC=[120 4e-6 410e9 0.14 3100 750 0 0 0 0 0 0]; %Silicon Carbide Material Data
EN=[0.1 55e-6 2.5e9 0.3 0 0 0 0 0 0 0 0]; %Encapsulent Material Data
Ga=[33.7 0 0 0 5903 340 1 24 6093 397 80300 29.8]; %Galium Material Data
Chip=[1.14 0 0 0 2230 753.12 0 0 0 0 0 0];
Alumina=[25 0 0 0 3720 880 0 0 0 0 0 0];
AIR=[0.024 100 0 0 1.225 0 0 0 0 0 0 0];
Pyrex = [1.2 0 0 0 2200 830 0 0 0 0 0 0];
Mike_Plastic = [1 0 0 0 1000 3000 0 0 0 0 0 0];
Fields_Metal = [18.9 0 0 0 7900 300 1 18.5 7700 250 29140 59]; %kond = 18.9 spht = 300 Lw = 29140 rho = 7900
PureTemp_29 = [0.25 0 0 0 940 1770 1 0.15 850 1940 202000 29];
BiPbSnIn = [33.2 0 0 0 9060 323 1 10.6 8220 721 29500 57];
matprops=[Al;Cu;AlN;SiC;EN;Ga;Chip;Alumina;AIR;Pyrex;Mike_Plastic;Fields_Metal;PureTemp_29;BiPbSnIn];%Material matrix, will display with several vaules 
kond=matprops(:,1)';
cte=matprops(:,2)';
E=matprops(:,3)';
nu=matprops(:,4)';
rho=matprops(:,5)';
spht=matprops(:,6)';

% equal to zero do to large magnitude differences. The correct vaules are
% still retained when accessed. 
matlist={'Al';'Cu';'AlN';'SiC';'EN';'Ga';'Chip';'Alumina';'AIR';'Pyrex';'Mike Plastic';'Fields Metal';'PureTemp 29';'BiPbSnIn'}; %Material display list, entry must be
% string and in identical order as matrix M
Al=[0.88 0.88 0.88];            %aluminum  colorway
Cu=[0.72 0.45 0.2];             %copper colorway
AlN=[0.3 0.2 0.2];              %aluminum nitride colorway
SiC=[0.16 0.2 0.2];             %silicon carbide colorwary
EN=[0 1 1];                     %encapsulent colorway
Ga=[0.5 0.5 0.5];
Chip=[1 1 1];
Alumina=[1 1 1];
AIR=[1 1 1];
Pyrex = [.7 .7 .7];
Mike_Plastic = [.72 .45 .2];
Fields_Metal = [.5 .5 .5];
PureTemp_29 = [.2 .2 .2];
BiPbSnIn = [0.6 0.6 0.6];
matcolors=[Al;Cu;AlN;SiC;EN;Ga;Chip;Alumina;AIR;Pyrex;Mike_Plastic;Fields_Metal;PureTemp_29;BiPbSnIn];   %material colorway matrix. Must also be in identical order to material matrix
end

