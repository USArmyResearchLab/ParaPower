% call Miner 3D to construct 4D and VM
function [stressx,stressy,stressz,stressvm] = Stress_Miner_time_loop (Results,VECTORIZED)

time = Results.Model.GlobalTime;
dx = Results.Model.X;
dy = Results.Model.Y;
dz = Results.Model.Z;

n_dx = length(dx);
n_dy = length(dy);
n_dz = length(dz);
n_time = length(time);

% Miner's matrix order: 1st=y, 2nd=x, 3rd=z
stressx = zeros(n_dx,n_dy,n_dz,n_time);
stressy = zeros(n_dx,n_dy,n_dz,n_time);
stressz = zeros(n_dx,n_dy,n_dz,n_time);
stressvm = zeros(n_dx,n_dy,n_dz,n_time);

% calculate x, y, and z stress for each timestep
for timestep = 1:n_time
    
    [stressx3D, stressy3D, stressz3D] = Stress_Miner_time(Results,timestep,VECTORIZED);
   
    stressx(:,:,:,timestep) = stressx3D;
    stressy(:,:,:,timestep) = stressy3D;
    stressz(:,:,:,timestep) = stressz3D;
    
end

% VM
stressvm = (((stressx-stressz).^2 + (stressx-stressy).^2 + (stressy-stressz).^2)/2).^.5;

end
