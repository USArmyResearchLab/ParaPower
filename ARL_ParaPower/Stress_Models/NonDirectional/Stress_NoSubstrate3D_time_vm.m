

function [stressx,stressy,stressz,stressvm] = Stress_NoSubstrate3D_time_vm (Results)
% change 3D to 4D by adding time
% original stress model (Stress_NoSubstrate1) only calculates stress for one
% time step

time = Results.Model.GlobalTime;
for t = 1:length(time)
    [stressx, stressy, stressz] = Stress_NoSubstrate3D(Results,t);
end

stressvm = (((stressx-stressz).^2 + (stressx-stressy).^2 + (stressy-stressz).^2)/2).^.5;

% save the data for debugging
if 0
save('debug_4d.mat','stressx','stressy','stressz')
end

return

end
