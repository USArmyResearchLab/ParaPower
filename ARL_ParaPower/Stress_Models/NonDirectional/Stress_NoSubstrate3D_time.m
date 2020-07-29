%% Stress_NoSubstrate3D_time (calculation of 4D stresses X, Y, Z, and VM)
% Stress_NoSubstrate3D_time calculates stresses X, Y, Z, and VM (Von Mises)
% for all timesteps defined in the input PPResults object.
% Stress_NoSubstrate3D is called in a time loop to construct 4D stress
% arrays X, Y, and Z, which are then used to calculate the 4D VM stress. 

%% Input and Output
% * Results is PPResults object
% * stressx, stressy, stressz, and stressvm are 4D arrays which represent stress X,
% stress Y, stress Z, and Von Mises stress at all the timesteps defined in the GlobalTime vector in the input PPResults object. 

function [stressx,stressy,stressz,stressvm] = Stress_NoSubstrate3D_time (Results)

% TC 07-29-20 
% Problem: length of GlobalTime does not equal time dimension of
% thermal matrix
% Solution: use 4th dimension of thermal state as time iterator (since stress
% calculations depend on thermal state)
% time = Results.Model.GlobalTime;
thermal_matrix = Results.getState('Thermal');
n_time = size(thermal_matrix,4);

dx = Results.Model.X;
dy = Results.Model.Y;
dz = Results.Model.Z;

n_dx = length(dx);
n_dy = length(dy);
n_dz = length(dz);

% initialize 4D stress matrices (x,y,z,time)
stressx = zeros(n_dx,n_dy,n_dz,n_time);
stressy = zeros(n_dx,n_dy,n_dz,n_time);
stressz = zeros(n_dx,n_dy,n_dz,n_time);
stressvm = zeros(n_dx,n_dy,n_dz,n_time);


% calculate x, y, and z stress for each timestep
for timestep = 1:n_time
    
    [stressx3D, stressy3D, stressz3D] = Stress_NoSubstrate3D(Results,timestep);
   
    stressx(:,:,:,timestep) = stressx3D;
    stressy(:,:,:,timestep) = stressy3D;
    stressz(:,:,:,timestep) = stressz3D;
    
end

% Von Mises stress
stressvm = (((stressx-stressz).^2 + (stressx-stressy).^2 + (stressy-stressz).^2)/2).^.5;

end
