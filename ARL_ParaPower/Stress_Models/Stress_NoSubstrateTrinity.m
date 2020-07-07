

function [stressx,stressy,stressz] = Stress_NoSubstrateTrinity (Results)
% change 3D to 4D by adding time

time = Results.Model.GlobalTime;
for t = 1:length(time)
    [stressx, stressy, stressz] = Stress_NoSubstrate1(Results,t);
end

save('4d_debug.mat','stressx','stressy','stressz')

return

end
