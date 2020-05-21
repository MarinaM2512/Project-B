%% Plot every measurment type on different figure
%recive name of movement and plot all the filtered raw data measurments of
%that movement on the same plot
function plot_raw_data_with_move_extraction(movement_name,date)
title_3=["x" "y" "z"];
title_q=["qW" "qX" "qY" "qZ"];
title_fsr=["FSR0" "FSR1" "FSR2" "FSR3" "FSR4"];
data_mat = loadMeasurmentMat(date,movement_name,1,"INIT");
t = data_mat(:,20);
[to_avgX, ~, ~] = join_measurments_of_movements(date,movement_name,10000,500,10,7);
[~, to_avgY, ~] = join_measurments_of_movements(date,movement_name,10000,500,10,5);
[~, ~, to_avgZ] = join_measurments_of_movements(date,movement_name,10000,500,10,9);
move_cell = [{to_avgX} {to_avgY} {to_avgZ}] ; 
[~,time,~] = detect_movement(move_cell);
moveCombined = ismember(t,time);
moveX_t = to_avgX(:,:,2);
moveX = ismember(t,moveX_t);
moveY_t = to_avgY(:,:,2);
moveY = ismember(t,moveY_t);
moveZ_t = to_avgZ(:,:,2);
moveZ = ismember(t,moveZ_t);
windows = {moveX moveY moveZ};
[~,num_features]=size(data_mat);
    for meas = 1:num_features
        if(meas<=3) %accel
            if(meas==1 )
                figure;
            end
            subplot(3,1,meas)
            plot(t,data_mat(:,meas));
            hold on;
            plot(t,windows{meas}*max(data_mat(:,meas)));
            title(title_3(meas));
            if(meas==3)
              sgtitle("acceleration");
            end
        elseif(meas<=6) %gyro
            if(meas==4)
                figure;
            end
            subplot(3,1,meas-3)
            plot(t,data_mat(:,meas));
            hold on;
            plot(t,windows{meas-3}*max(data_mat(:,meas)));
            title(title_3(meas-3));
            if(meas==6)
              sgtitle("gyro");
            end
        elseif(meas<=10) %quat
            if(meas==7)
                figure;
            end
            subplot(2,2,meas-6)
            plot(t,data_mat(:,meas));
            hold on;
            plot(t,moveCombined*max(data_mat(:,meas)));
            title(title_q(meas-6));
            if(meas==10)
              sgtitle("quaternion");
            end
        elseif(meas>=15 && meas<num_features)
            if(meas==15 )
                figure;
            end
            subplot(2,3,meas-14)
            plot(t,data_mat(:,meas));
            hold on;
            plot(t,moveCombined*max(data_mat(:,meas)));
            title(title_fsr(meas-14));
            if(meas==19)
              sgtitle("FSR");
            end
        end
    end
end


