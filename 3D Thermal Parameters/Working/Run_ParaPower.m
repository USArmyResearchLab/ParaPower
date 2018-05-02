%Rename file with consistent capitals.
if exist('PARAPowerGUI.m','file')==2
    movefile('PARAPowerGUI.m','PARAPowerGUI.m.tmp')
    movefile('PARAPowerGUI.m.tmp','ParaPowerGUI.m')
end

disp('The code has modified so that all required modules should be in the "working" directory without a need to addpath.')
% addpath('..');
% addpath('../Thermal');
% addpath('../Transient');
% addpath('../working');
% addpath('../Stress Model 2.0');
H=ParaPowerGUI;