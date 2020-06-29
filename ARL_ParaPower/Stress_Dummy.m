function [Stress] = Stress_Dummy(Results)
% Display available degrees of freedom and corresponding times
% Date modified: 06-28-20
% Trinity Cheng
% Input: object created from PPResults
% Output: display available degrees of freedom and corresponding times in
% command window

% get temperature for each coordinate in model (x,y,z)
temperature = Results.getState('Thermal');

% get temperature for each coordinate in model (x,y,z) at time 3
temperature_time3 = temperature(:,:,:,3);

% extract physical dimensions of model (vector)
x_dimensions = cumsum(Results.Model.X);
y_dimensions = cumsum(Results.Model.Y);
z_dimensions = cumsum(Results.Model.Z);
% length of each vector
x_size = length(x_dimensions);
y_size = length(y_dimensions);
z_size = length(z_dimensions);

% center and corner point
% squeeze: remove dimensions of length 1
% https://www.mathworks.com/help/matlab/ref/squeeze.html
centerpoint = squeeze(temperature(5,5,3,:));
cornerpoint = squeeze(temperature(1,1,1,:));

% global time vector
time = Results.Model.GlobalTime;

% visualization
clf

% temperature of z layers (horizontal cross-sections) at time 3
subplot(2,2,1)
for i = 1:z_size
   draw_zLayer(temperature_time3,i,x_dimensions,y_dimensions,z_dimensions,x_size,y_size)
   hold on
end
key = colorbar;
key.Label.String = 'Temperature (Celsius)';
xlabel('x (mm)')
ylabel('y (mm)')
title('Temperature of bottom layer (z=1) at 0.2 sec')

% temperature of y layers (vertical cross-sections) at time 3
subplot(2,2,2)
for i = 1:y_size
    draw_yLayer(temperature_time3,i,z_dimensions,x_dimensions,y_dimensions,z_size,x_size)
    hold on
end
key2 = colorbar;
key2.Label.String = 'Temperature (Celsius)';
xlabel('z (mm)')
ylabel('x (mm)')
title('Temperature of vertical cross-section (y=3) at 0.2 sec')

% graph of temperature of center and corner points over time
subplot(2,2,[3,4])
plot(time,centerpoint)
hold on
plot(time,cornerpoint)

xlabel('Elapsed time (seconds)')
ylabel('Temperature (Celsius)')
title('Temperature of Model Points over Time')
legend({'Center (5,5,3)', 'Corner (1,1,1)'}, 'Location', 'east')
return

function draw_zLayer(time,n,x,y,z,xsize,ysize)
% cross-section (z=n layer) at time=3
layer_temperature = squeeze(time(:,:,n));
layer_n = z(n);
% surf: plot (x,y,z,c) to make 3D solid figure (a surface) with color c
surf(x,y,layer_n*ones(ysize,xsize),layer_temperature)
return

function draw_yLayer(time,n,x,y,z,xsize,ysize)
% cross-section (y=n layer) at time=3
layer_temperature = squeeze(time(:,n,:));
layer_n = z(n);
% surf: plot (x,y,z,c) to make 3D solid figure (a surface) with color c
surf(x,y,layer_n*ones(ysize,xsize),layer_temperature)
return

% problem: 06-25-20: Matlab auto-labels 5 ticks, only takes first 5 values from array
% xtickformat('%.1f')
% problem 06-25-20: xtickformat uses automated labels, and overrides
% xticklabels
% problem 06-27-20: cannot use imagesc because x and y are evenly spaced