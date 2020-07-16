% run loop for many iterations
% try running the s00 models
% super large data set (10-20 sec)
% get mean and std of two columns
% report sizes/dimensions in output
% stop at place where memory not enough
% see where can clear

iterations = 7;

% time_model has 5 different time steps
% subdiv_model.mat (subdiv_model) has 25 different x/y subdivision
% combinations
datasetname = 'time_model';

load('time_model.mat',datasetname)
total_models = length(time_model)

% dimensions: 2 stress models, # iterations, 5 stages
alldata = zeros(total_models, 2, iterations, 5);
matsize = zeros(total_models, 2, iterations, 3);

for model = 1:length(time_model)
    currentmodel = time_model(model);
    
    for n = 1:iterations
        [x y z v] = Stress_NoSubstrate4D(currentmodel);
        [a b c d] = Stress_NoSubstrate4D_vec(currentmodel);
        load('compete.mat','time_lapse_4D','time_lapse_4D_vec','size_4D','size_4D_vec');
        
        % time_lapse_4D is 5x1
        % time_lapse_4D_vec is 5x1
        
        alldata(model,1,n,:) = time_lapse_4D;
        alldata(model,2,n,:) = time_lapse_4D_vec;
        
        matsize(model,1,n,:) = size_4D;
        matsize(model,2,n,:) = size_4D_vec;
        
        %     subplot(1,iterations,n)
        %     bar([seq{n} vec{n}])
        %     legend('Sequential','Vectorized')
        %     title(datasetname)
        %     xlabel('Stage')
        %     ylabel('Time (s)')
        %     xticks([1:5])
        %     xticklabels({'init','x','y','z','stress'})
        
    end
end

% obtain mean over the iterations, which is the 2nd dimension
alldata_mean = squeeze(mean(alldata,2));

% obtain std over the iterations, which is the 2nd dimension
% https://www.mathworks.com/help/matlab/ref/std.html
alldata_std = squeeze(std(alldata,0,2));

seq_mean = alldata_mean(1,:);
vec_mean = alldata_mean(2,:);

seq_std = alldata_std(1,:);
vec_std = alldata_std(2,:);

alldata


% show lines with errorbars
% https://www.mathworks.com/help/matlab/ref/errorbar.html
clf
% bar([seq_mean' vec_mean'] r)
hold on
errorbar(seq_mean',seq_std')
errorbar(vec_mean',vec_std')
legend('Seq','Vec')
xlabel('Stage #')
ylabel('Time (s)')
title(sprintf('Data from %d iterations',iterations))
axis([0 6 0 max(alldata_mean,[],'all')*1.5])
return

clf

