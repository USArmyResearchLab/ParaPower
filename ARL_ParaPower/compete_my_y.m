if 1
    
%load('ipack.mat','ipack_11_11_7','ipack_10cases','ipack_10y')

%n_case = length(ipack_10cases);
n_case = length(ipack_10y);
%n_case = 3

% 1: sequential, 2: vec
result_time = zeros(n_case,2);

% size of the data
result_size = zeros(n_case,1);

%for imodel = 1:n_case


for imodel = 1:n_case
    
%    ppr = ipack_10cases(imodel);
    ppr = ipack_10y(imodel);
    datasize_x = size(ppr.Model.Model,1);
    datasize_y = size(ppr.Model.Model,2);
    datasize_z = size(ppr.Model.Model,3);
    datasize = datasize_x*datasize_y*datasize_z;
    
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

save('compete_10ysize.mat','result_size','result_time')
end

load('compete_10ysize.mat','result_size','result_time')

clf
hold on
plot(result_size(:,1),result_time(:,1),'o')
plot(result_size(:,1),result_time(:,2),'o')
legend('Seq (y)','Vec (y)','Location','Northwest')
xlabel('Data size')
ylabel('Time (s)')
title('Scaling in Y')



