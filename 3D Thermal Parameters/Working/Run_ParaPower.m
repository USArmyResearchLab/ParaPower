%Rename file with consistent capitals.
if exist('PARAPowerGUI.m','file')==2
    movefile('PARAPowerGUI.m','PARAPowerGUI.m.tmp')
    movefile('PARAPowerGUI.m.tmp','ParaPowerGUI.m')
end

addpath('..');
addpath('../Thermal');
addpath('../Transient');
addpath('../working');
addpath('../Stress Model 2.0');
H=ParaPowerGUI;