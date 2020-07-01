%This is the original shell for Steve's code

% This .m file executes the Substrate based stress model
% Required input is the appropriate .ppmodel -mat
% Output includes the X and Y components of stress at each element location
% Load the .ppmadel
load HighVoltageModule.ppmodel -mat
% Load the results of the thermal analysis
ThermalResults=Results;
% Specify number of layers in the substrate
nlsub=2;
[StressX,StressY]=Stress_Substrate_Hsueh(ThermalResults,nlsub);

