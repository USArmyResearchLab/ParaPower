

function [stressx,stressy,stressz] = Stress_NoSubstrateTrinity (Results)
% change 3D to 4D by adding time
% original stress model (Stress_NoSubstrate1) only calculates stress for one
% time step

time = Results.Model.GlobalTime;
for t = 1:length(time)
    [stressx, stressy, stressz] = Stress_NoSubstrate1(Results,t);
end

% save the data for debugging
if 1
save('debug_4d.mat','stressx','stressy','stressz')
end

return

end
