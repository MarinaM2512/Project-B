function all_data_medfilt=median_all_data_filt(all_data,n) %all data dims:(3,19,4)
    arguments
        all_data (3,19,4) cell
        n double
    end
accel_data_vec= cell2mat(all_data(:,1:3,:));
gyro_data_vec = cell2mat(all_data(:,4:6,:));
quat_data_vec = cell2mat(all_data(:,7:10,:));
fsr_data_vec  = cell2mat(all_data(:,15:19,:));
all_data_medfilt=cell(3,19,4);
for ii=1:3
    for k=1:4
        [accel_x_medfilt, accel_y_medfilt, accel_z_medfilt, ~,~]=...
            median_filt(accel_data_vec(ii,:,k),zeros(ii,1,k),zeros(ii,1,k),n);
        
        [ gyro_x_medfilt,  gyro_y_medfilt,  gyro_z_medfilt, ~,~]=...
            median_filt(gyro_data_vec(ii,:,k),zeros(ii,1,k),zeros(ii,1,k),n);
        
        [ quat_w_medfilt,  quat_x_medfilt,  quat_y_medfilt, quat_z_medfilt, ~]=...
            median_filt(quat_data_vec(ii,1:3,k),quat_data_vec(ii,4,k),zeros(ii,1,k),n);
        
        [ fsr0_medfilt , fsr1_medfilt , fsr2_medfilt , fsr3_medfilt , fsr4_medfilt]=...
            median_filt(fsr_data_vec(ii,1:3,k),fsr_data_vec(ii,4,k),fsr_data_vec(ii,5,k),n);
        
        all_data_medfilt(ii,:,k)=...
            [accel_x_medfilt,accel_y_medfilt,accel_z_medfilt,...
              gyro_x_medfilt, gyro_y_medfilt, gyro_z_medfilt,...
              quat_w_medfilt, quat_x_medfilt, quat_y_medfilt, quat_z_medfilt,...
                                  0,0,0,0,...
              fsr0_medfilt  , fsr1_medfilt  , fsr2_medfilt  , fsr3_medfilt  , fsr4_medfilt];
    end
end
end

            
    


