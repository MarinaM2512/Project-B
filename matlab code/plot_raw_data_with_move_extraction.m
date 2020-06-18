%% Plot every measurment type on different figure
%recive name of movement and plot all the filtered raw data measurments of
%that movement on the same plot
% input:
% movement_name - name of movment to extraxct
% date - date to load data from
% param - mave of parameter to plot
% output:
% t- original time vec
% extraction - clean movement of movement_name in data
function [t,extraction] = plot_raw_data_with_move_extraction(movement_name,date,param)
title_3=["x" "y" "z"];
title_q=["qW" "qX" "qY" "qZ"];
title_fsr=["FSR0" "FSR1" "FSR2" "FSR3" "FSR4"];
newStr = strrep(movement_name,'_',' ');
data_mat = loadMeasurmentMat(date,movement_name,1,"INIT");
t = data_mat(:,20);
extraction = zeros(size(data_mat(:,1:end-1)));
[to_avgX, ~, ~] = join_measurments_of_movements(date,movement_name,10000,500,10,7);
[~, to_avgY, ~] = join_measurments_of_movements(date,movement_name,10000,300,15,7);
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
  if param =="accel"
      titleStr = join(["acceleration for",newStr]);
      for meas = 1:3
%         if(meas<=3) %accel
            if(meas==1 )
                figure;
            end
            subplot(3,1,meas)
            plot(t,data_mat(:,meas));
            hold on;
            extraction(:,meas) = windows{meas}*max(data_mat(:,meas));
            plot(t,extraction(:,meas));
            title(title_3(meas));
            if(meas==3)
              sgtitle(titleStr);
            end
%         end
      end
        
  elseif param == "gyro"
     titleStr = join(["gyro for",newStr]);
     for meas = 4:6
%        if(meas<=6) %gyro
            if(meas==4)
                figure;
            end
            subplot(3,1,meas-3)
            plot(t,data_mat(:,meas),'Linewidth',2);
            hold on;
            extraction(:,meas) = windows{meas-3}*max(data_mat(:,meas));
            plot(t,extraction(:,meas),'Linewidth',2);
            title(title_3(meas-3));
            xlim([3,6]*10^4)
            if(meas==6)
              sgtitle(titleStr);
            end
      end
  elseif param == "quat"
     titleStr = join(["quaternion for",newStr]);
     for meas = 7:10
%       if (meas<=10) %quat
            if(meas==7)
                figure;
            end
            subplot(2,2,meas-6)
            plot(t,data_mat(:,meas));
            hold on;
            extraction(:,meas) = moveCombined*max(data_mat(:,meas));
            plot(t,extraction(:,meas));
            title(title_q(meas-6));
            if(meas==10)
              sgtitle(titleStr);
            end
      end
  elseif param == "fsr"
    titleStr = join(["FSR for",newStr]);
        for meas = 15:num_features-1
            if(meas==15 )
                figure;
            end
            subplot(2,3,meas-14)
            plot(t,data_mat(:,meas));
            hold on;
            extraction(:,meas) = moveCombined*max(data_mat(:,meas));
            plot(t,extraction(:,meas));
            title(title_fsr(meas-14));
            if(meas==19)
              sgtitle(titleStr);
            end
        end
  end
end


