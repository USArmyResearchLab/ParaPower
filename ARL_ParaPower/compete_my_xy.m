if 0
    
load('ipack.mat','ipack_100xy')

all_case = [1 3 4 6 7 8 9 10];
n_case = length(all_case);

% 1: sequential, 2: vec
result_time = zeros(n_case,2);

% size of the data
result_size = zeros(n_case,1);

cubesize = size(ppr.Model.Model);

    
for i = 1:n_case
    
    imodel = all_case(i);
    index = (imodel-1)*10 + (imodel-1) + 1;
    ppr = ipack_100xy(index);
    datasize = size(ppr.Model.Model,1);
    
    tic
    [x0 y0 z0 v0] = Stress_Miner_time_loop(ppr,0);
    time0 = toc;
    
    tic
    [x1 y1 z1 v1] = Stress_Miner_time_loop(ppr,1);
    time1 = toc;

    % show progress
    [imodel datasize time0 time1]
    
    result_size(imodel,1) = datasize;
    result_time(imodel,1) = time0;
    result_time(imodel,2) = time1;
end

result_time

save('compete_100xy.mat','result_size','result_time','cubesize')
end

load('compete_100xy.mat','result_size','result_time','cubesize')

clf
hold on
plot(result_size(:,1),result_time(:,1),'o')
plot(result_size(:,1),result_time(:,2),'o')
legend('Seq','Vec','Location','Northwest')
xlabel('Data size')
ylabel('Time (s)')
title(sprintf('Scaling in X and Y, Z=%d',cubesize(3)))



