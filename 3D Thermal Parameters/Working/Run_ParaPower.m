%Rename file with consistent capitals.
movefile('PARAPowerGUI.m','PARAPowerGUI.m.tmp')
movefile('PARAPowerGUI.m.tmp','ParaPowerGUI.m')

addpath('..');
addpath('../Thermal');
addpath('../Transient');
addpath('../working');
addpath('../Stress Model 2.0');
ParaPowerGUI