if 1
    
load('ipack_125xyz.mat','ipack_125xyz')

n_case = 1;

% 1: sequential, 2: vec
result_time = zeros(n_case,2);

% size of the data
result_size = zeros(n_case,1);

cubesize = size(ppr.Model.Model);

    
for imodel = 1:n_case
    
    index = (imodel-1)*25 + (imodel-1)*5 + (imodel-1) + 1;
    ppr = ipack_125xyz(index);
    datasize_x = size(ppr.Model.Model,1);
    datasize_y = size(ppr.Model.Model,2);
    datasize_z = size(ppr.Model.Model,3);
    datasize = datasize_x*datasize_y*datasize_z;
    
    tic
    [x0 y0 z0 v0] = Stress_Miner_time_loop(ppr,1);
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

save('compete_125xyz_late.mat','result_size','result_time','cubesize')
end

load('compete_125xyz_late.mat','result_size','result_time','cubesize')

clf
hold on
plot(result_size(:,1),result_time(:,1),'-+')
plot(result_size(:,1),result_time(:,2),'-o')
legend('Sequential','Vectorized','Location','Northwest')
xlabel('Total Number of Elements')
ylabel('Solution Time (s)')
title(sprintf('Simultaneous Scaling in X, Y, and Z'))



