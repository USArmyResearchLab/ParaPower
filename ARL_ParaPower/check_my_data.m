load('debug_4d.mat')
load('debug_mats.mat')

x = stressx;

a2 = get_one_mat(x,Mats,2);
a3 = get_one_mat(x,Mats,3);
a4 = get_one_mat(x,Mats,4);

clf
subplot(1,3,1)
hold on
plot(a2)
plot(a3)
plot(a4)

legend('2','3','4')
title('Stress X')

y = stressy;

a2 = get_one_mat(y,Mats,2);
a3 = get_one_mat(y,Mats,3);
a4 = get_one_mat(y,Mats,4);

subplot(1,3,2)
hold on
plot(a2)
plot(a3)
plot(a4)

legend('2','3','4')
title('Stress Y')

z = stressz;

a2 = get_one_mat(z,Mats,2);
a3 = get_one_mat(z,Mats,3);
a4 = get_one_mat(z,Mats,4);

subplot(1,3,3)
hold on
plot(a2)
plot(a3)
plot(a4)

legend('2','3','4')
title('Stress Z')

return


y = stressy;
for i = 1:size(y,4)
    b(i)=max(max(max(y(:,:,:,i))))
end

y = stressz;
for i = 1:size(y,4)
    c(i)=max(max(max(y(:,:,:,i))))
end


function ret = get_one_mat (y, Mats, my_mat)
for i = 1:size(y,4)
    da = squeeze(y(:,:,:,i));
    mask = Mats == my_mat;
    da_masked = da(mask);
    ret(i) = max(max(max(da_masked)));
end
end
