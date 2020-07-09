function plot_stress_v2

load('debug_4d.mat','stressx','stressy','stressz')
load('debug_mats.mat','Mats')

clf
subplot(1,3,1)
check_my_data(stressx,'Stress X')

subplot(1,3,2)
check_my_data(stressy,'Stress Y')

subplot(1,3,3)
check_my_data(stressz,'Stress Z')

return


    function check_my_data(stress, titlestring)
        
        % get max for each material
        mat1 = get_one_mat(stress, 2);
        mat2 = get_one_mat(stress, 3);
        mat3 = get_one_mat(stress, 4);
        
        hold on
        plot(mat1)
        plot(mat2)
        plot(mat3)
        
        legend('2','3','4')
        title(titlestring)
        
    end

% subfunction that plots max of just one material using a mask
    function ret = get_one_mat (stress_4d, my_mat)
        for i = 1:size(stress_4d,4) % each time step in time (4th) dimension
            % get stress in model at the i time step
            stress_3d = squeeze(stress_4d(:,:,:,i));
            % create a mask by searching for elements in 3D array Mats that match
            % with my_mat (the number representing desired material)
            mask = (Mats == my_mat);
            stress_masked = stress_3d(mask);
            % return the max stress from that time step
            ret(i) = max(max(max(stress_masked)));
        end
    end

end
