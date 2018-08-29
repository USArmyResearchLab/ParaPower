function [basernames,layerrnames, layercnames, envrnames, envcnames,geornames,featcnames,geocnames, layoutpop,basecnames,basePCcnames,paracnames,pararnames,matparacnames,matparatype,bccnames,bcrnames,...
    featbctype,sysbctype,geoparatype,assortedparatype,msm,NA,bcfeat,proftemplate,solutionpoptxt,constcnames,featconsttype,sysconsttype,resultsrnames,resultpoptxt]= tables()
basernames={'Base'};
basecnames={'Center on Features','X-Coor (m)','Y-Coor (m)','Length (m)','Width (m)'}; %Defines column headers for device table
basePCcnames={'Border Length(m)','Border Width (m)'};
layoutpop={'Base P.C.', 0; 'Base U.D.', 99; 'Layout 1' 1; 'Layout 2' 2;'Layout 3' 3;'Layout 4' 4;'Layout 5' 5;'Layout 6' 6};
geornames={'Feature 1';'Feature 2';'Feature 3';'Feature 4';...                              %String of potential pads
    'Feature 4';'Feature 4';'Feature 7';'Feature 8';'Feature 9';'Feature 10';'Feature 11';'Feature 12'};
featcnames={'Quantity'};
geocnames={'Material','X-Coor (m)','Y-Coor (m)','Length (m)','Width (m)','Heat Gen. (W)'}; %Defines column headers for device table
layerrnames={'Layer 1';'Layer 2';'Layer 3';'Layer 4';...                    %String of layer names
    'Layer 5';'Layer 6';'Layer 7';'Layer 8';'Layer 9';'Layer 10';'Layer 11';'Layer 12'}; 
layercnames={'Material','Thickness (m)','Layout','Cond.(w/mK)','CTE','Young''s Mod.','Poisson''s Rat.','Density (kg/m3)','Spec. Heat (J/C)'}; %Defines column names for layer table
% % layerpoptext={'Layer 1';'Layer 2';'Layer 3';'Layer 4';'Layer 5';...         %String of potential layer names for multi material layer pop
%     'Layer 6';'Layer 7';'Layer 8';'Layer 9';'Layer 10';'Layer 11'};
envrnames={'h';'Ta'};                                                       %Defines row names for Env. table
envcnames={'Left','Right','Front','Back','Bottom','Top'};                   %Defines column names for Env. table
paracnames={'Paramerter','Geometry','Associated','Min','Steps', 'Max'}; %Defines column names of parameter sweep table
pararnames={'System'};                                                       %Defines row names of parameter sweep table
matparacnames={'Feature','Material','Material Property','Min','Steps','Max'};
matparatype={'Cond.(w/mK)','CTE','Young''s Mod.','Poisson''s Rat.','Density','Spec. Heat'};
constcnames={'Constraint','Feature','Linked Feature','Value'};
bccnames={'Boundary Condition','Feature','Linked Feature','Min','Max'}; %Defines column names of boundary condition table
bcrnames={'Condition 1'};          %Defines row names of boundary condtions table. 
geoparatype={'Position X','Position Y','Length','Width','Scale','Heat Gen.'};
assortedparatype={'Transient','Layer Thickness','Conv. Coeff. (h)','Ambient Temp. (Ta)'};
featbctype={'Distance Range: X','Distance Range: Y','Heat Gen. (W) Range'};
sysbctype={'Layer Thickness Range','Substrate Thickness Rat.','Conv. Coeff. (h) Range','Ambient Temp. (Ta) Range','Base Length Range',...
    'Base Width Range','Module Volume'};
featconsttype={'Distance Fixed: X','Distance Fixed: Y','Heat Gen. (W) Fixed','Base Length','Base Width','Base Border Length','Base Border Width'};
sysconsttype={'Layer Thickness: Fixed','Conv. Coeff. (h) Fixed','Ambient Temp. (Ta) Fixed'};
bcfeat={'System','N/A'};
msm={'Min';'Steps';'Max'};
% NA={'N/A','N/A','N/A','Layer 1','Layer 2','Layer 3','Layer 4','Layer 5','Layer 6','Feature 1','Feature 2','Feature 3','Feature 4','N/A','N/A','N/A','N/A','N/A','N/A','N/A',};
NA={'N/A'};
proftemplate={'Number of Layers';'Temp.  Process';'Initial Node Temp.';'h';'Ta';'Layer Thickness';'Materials by Layer';...
'Layer Type';'Layer Type Code';'Base Geo';'Quantity ';'Tabstatus';'Layout 1 Feat. Data';'Layout 2 Feat. Data';'Layout 3 Feat. Data';...
'Layout 4 Feat. Data';'Layout 5 Feat. Data';'Layout 6 Feat. Data';'Layout 7 Feat. Data';'Layout 1 Geometry Data';'Layout 2 Geometry Data';...
'Layout 3 Geometry Data';'Layout 4 Geometry Data';'Layout 5 Geometry Data';'Layout 6 Geometry Data';'Layout 7 Geometry Data';...
'Constraints';'Boundary Conditions';'Parameters';'Groupings';'Results'};
solutionpoptxt={'Solution 1'};
resultsrnames={'Max Temp. (C)', 'Max Stress (Pa)'};
resultpoptxt={'Board Area Vs T/S','Trial # Vs T/S','Transient'};
end