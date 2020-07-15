% run loop for many iterations
% try running the s00 models
% super large data set (10-20 sec)


datasetname = 'ipack';

load('ipack.mat',datasetname)
[x y z v] = Stress_NoSubstrate4D(complexmodel);
[a b c d] = Stress_NoSubstrate4D_vec(complexmodel);

load('compete.mat','time_lapse_4D','time_lapse_4D_vec');

clf
bar([time_lapse_4D time_lapse_4D_vec])
legend('Sequential','Vectorized')
title(datasetname)
xlabel('Stage')
ylabel('Time (s)')
xticks([1:5])
xticklabels({'init','x','y','z','stress'})
