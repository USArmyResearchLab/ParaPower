load('compete_10x.mat','result_size','result_time')

clf
hold on
plot(result_size(:,1),result_time(:,1),'o')
plot(result_size(:,1),result_time(:,2),'o')

load('compete_10y.mat','result_size','result_time')

plot(result_size(:,1),result_time(:,1),'+')
plot(result_size(:,1),result_time(:,2),'+')

load('compete_10z.mat','result_size','result_time','cubesize')

plot(result_size(:,1),result_time(:,1),'*')
plot(result_size(:,1),result_time(:,2),'*')

legend('Seq(x)','Vec(x)', 'Seq(y)','Vec(y)','Seq(z)','Vec(z)','Location','Northwest')
xlabel('Data size')
ylabel('Time (s)')
title('Individual Scaling in X, Y, and Z')
