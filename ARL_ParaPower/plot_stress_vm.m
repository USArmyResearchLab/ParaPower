function plot_stress_vm
load('ipackobj.mat','ipack')
all_features = ipack.Model.FeatureMatrix
max_feature = max(all_features,[],'all')
[x y z vm] = Stress_NoSubstrate3D_time(ipack)

clf
check_my_data(vm,'Stress VM')

return


    function check_my_data(stress, titlestring)
        
        for feature = 1:max_feature
            
            % get max for each material
            mat1 = get_one_mat(stress, feature);
            %         mat2 = get_one_mat(stress, 3);
            %         mat3 = get_one_mat(stress, 4);
            
            hold on
            plot(mat1)
            %         plot(mat2)
            %         plot(mat3)
            
            %         legend('2','3','4')
            title(titlestring)
            
        end
    end

% subfunction that plots max of just one material using a mask
    function ret = get_one_mat (stress_4d, feature_num)
        for i = 1:size(stress_4d,4) % each time step in time (4th) dimension
            % get stress in model at the i time step
            stress_3d = squeeze(stress_4d(:,:,:,i));
            % create a mask by searching for elements in 3D array Mats that match
            % with my_mat (the number representing desired material)
            mask = (all_features == feature_num);
            stress_masked = stress_3d(mask);
            % return the max stress from that time step
            ret(i) = max(max(max(stress_masked)));
            %ret(i) = max(max(max(stress_3d)));
        end
    end

end