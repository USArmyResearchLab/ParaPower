function [Stress] = Stress_Dummy(Results)
% Display available degrees of freedom and corresponding times
% Date: 06-24-20
% Trinity Cheng
% Input: object created from PPResults
% Output: display available degrees of freedom and corresponding times in
% command window


temp = Results.getState('Thermal');

time3 = temp(:,:,:,3);

% bottom layer (z=1) at time=3
layer1 = squeeze(time3(:,:,1));

% cross-section (y=3) at time=3
layer2 = squeeze(time3(:,3,:));

point1 = squeeze(temp(5,5,3,:));
point2 = squeeze(temp(1,1,1,:));

% global time vector
time = Results.Model.GlobalTime

% visualization
clf

% temperature of bottom layer (z=1) at time 3
subplot(2,2,1)
imagesc(layer1)
key = colorbar
key.Label.String = 'Temperature (Celsius)';
set(gca, 'YDir', 'normal')
xlabel('x (mm)')
ylabel('y (mm)')
title('Temperature of bottom layer (z=1) at 0.2 sec')

% temperature of vertical cross section (y=3) at time 3
subplot(2,2,2)
imagesc(layer2)
key2 = colorbar
key2.Label.String = 'Temperature (Celsius)';
set(gca, 'YDir', 'normal')
xlabel('x (mm)')
ylabel('z (mm)')
title('Temperature of vertical cross-section (y=3) at 0.2 sec')

% graph of temperature of center and corner points over time
subplot(2,2,[3,4]) 
plot(time,point1)
hold on
plot(time,point2)

xlabel('Elapsed time (seconds)')
ylabel('Temperature (Celsius)')
title('Temperature of Model Points over Time')
legend({'Center (5,5,3)', 'Corner (1,1,1)'}, 'Location', 'east')
return