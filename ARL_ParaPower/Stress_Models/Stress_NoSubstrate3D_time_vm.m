

function [stressx,stressy,stressz,stressvm] = Stress_NoSubstrate3D_time_vm (Results)
% change 3D to 4D by adding time
% original stress model (Stress_NoSubstrate1) only calculates stress for one
% time step

dx=Results.Model.X;
dy=Results.Model.Y;
dz=Results.Model.Z;
NLz=length(dz);
%NR=length(dy);
%NC=length(dx);

NRx=length(dx);  %Morris switched these
NCy=length(dy);  %to match the substrate based model

time = Results.Model.GlobalTime

stressx = zeros(NRx,NCy,NLz,length(time));
stressy = zeros(NRx,NCy,NLz,length(time));
stressz = zeros(NRx,NCy,NLz,length(time));
stressvm = zeros(NRx,NCy,NLz,length(time));

for timestep = 1:length(time)
    [stressx(:,:,:,timestep), stressy(:,:,:,timestep), stressz(:,:,:,timestep)] = Stress_NoSubstrate3D(Results,timestep);
end

stressvm = (((stressx-stressz).^2 + (stressx-stressy).^2 + (stressy-stressz).^2)/2).^.5;

% save the data for debugging
if 1
save('debug_3D_time_vm.mat','stressx','stressy','stressz','stressvm')
end

return

end
