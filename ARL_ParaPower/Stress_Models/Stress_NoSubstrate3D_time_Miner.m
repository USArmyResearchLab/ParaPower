

function [stressx,stressy,stressz,stressvm] = Stress_NoSubstrate3D_time_Miner (Results)
% change 3D to 4D by adding time
% original stress model (Stress_NoSubstrate1) only calculates stress for one
% time step

dx=Results.Model.X;
dy=Results.Model.Y;
dz=Results.Model.Z;
NL=length(dz);
NR=length(dy);
NC=length(dx);

time = Results.Model.GlobalTime;

stressx = zeros(NC,NR,NL,length(time));
stressy = zeros(NC,NR,NL,length(time));
stressz = zeros(NC,NR,NL,length(time));
stressvm = zeros(NC,NR,NL,length(time));

for timestep = 1:length(time)
    [stressx(:,:,:,timestep), stressy(:,:,:,timestep), stressz(:,:,:,timestep)] = Stress_NoSubstrate_Miner_time(Results,timestep);
end

stressvm = (((stressx-stressz).^2 + (stressx-stressy).^2 + (stressy-stressz).^2)/2).^.5;

% save the data for debugging
if 0
save('debug_3D_time_vm.mat','stressx','stressy','stressz','stressvm')
end

return

end
