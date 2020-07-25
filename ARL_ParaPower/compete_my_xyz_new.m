if 0
    
load('ipack_125xyz.mat','ipack_125xyz')

n_case = 5;

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

save('compete_125xyz_new.mat','result_size','result_time','cubesize')
end

load('compete_125xyz_new.mat','result_size','result_time','cubesize')

clf
hold on

seq_x = result_size(:,1)
seq_y = result_time(:,1)
vec_y = result_time(:,2)

fit_seq = polyfit(seq_x,seq_y,1)
fit_seq_2 = polyfit(seq_x, seq_y,2)
fit_vec = polyfit(seq_x,vec_y,1)

fit_seq_eq = polyval(fit_seq,seq_x)
fit_seq_eq_2 = polyval(fit_seq_2,seq_x)
fit_vec_eq = polyval(fit_vec,seq_x)

% plot(seq_x,seq_y,'+','MarkerSize',15)
% plot(seq_x,fit_seq_eq,'-')

% txt1 = ['y = 0.013379x - 18.63'];
% text(8000, 150, txt1);

plot(seq_x,seq_y,'+','MarkerSize',15)
plot(seq_x,fit_seq_eq_2,'-')

txt3 = ['y = 4e-7x^2 + 0.0061x - 4.1551'];
text(5000, 150, txt3);

plot(seq_x,vec_y,'o','MarkerSize',15)
plot(seq_x,fit_vec_eq,'-')

txt2 = ['y = 2.5e-5x + 0.80'];
text(9000, 20, txt2);

% plot(result_size(:,1),result_time(:,1),'+','MarkerSize',15)
% plot(result_size(:,1),result_time(:,2),'o','MarkerSize',15)
legend('Sequential','Vectorized','Location','Northwest','FontSize',12)
xlabel('Data Size (Total # of Elements)')
ylabel('Solution Time (s)')
title(sprintf('Simultaneous Scaling in X, Y, and Z'))



