
load('debug_4d.mat')
load('debug_mats.mat')

subplot(1,3,1)
check_my_data(stressx, Mats, 'Stress X')

subplot(1,3,2)
check_my_data(stressy, Mats, 'Stress Y')

subplot(1,3,3)
check_my_data(stressz, Mats, 'Stress Z')