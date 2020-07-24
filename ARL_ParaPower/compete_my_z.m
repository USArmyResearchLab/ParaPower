if 1
    
load('ipack.mat','ipack_10z')

n_case = length(ipack_10z);

% 1: sequential, 2: vec
result_time = zeros(n_case,2);

% size of the data
result_size = zeros(n_case,1);

cubesize = size(ppr.Model.Model);

    
for imodel = 1:n_case
    
    ppr = ipack_10z(imodel);
    datasize = size(ppr.Model.Model,3);
    
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

save('compete_10z.mat','result_size','result_time','cubesize')
end

load('compete_10z.mat','result_size','result_time','cubesize')

clf
hold on
plot(result_size(:,1),result_time(:,1),'o')
plot(result_size(:,1),result_time(:,2),'o')
legend('Seq','Vec','Location','Northwest')
xlabel('Data size')
ylabel('Time (s)')
title(sprintf('Scaling in Z, X=%d, Y=%d',cubesize(1),cubesize(2)))



