%% Plot every measurment type on different figure
%recive name of movement and plot all the filtered raw data measurments of
%that movement on the same plot
function plot_raw_data(movement_name,date)
% movement_name="sit_swipe_R";
% date="30_03";
title_3=["x" "y" "z"];
title_q=["qW" "qX" "qY" "qZ"];
title_fsr=["FSR0" "FSR1" "FSR2" "FSR3" "FSR4"];
textFileName= strcat("..\measurements\",date,"\","*",movement_name,"*","_FILTERED.mat");
DirList = dir(fullfile(textFileName));
listOfFiles = {DirList.name};
k=0;
num_meas=length(listOfFiles);
for motion= 1:num_meas
    k=k+1;
    fileName=strcat("..\measurements\",date,"\",listOfFiles{motion});
    mat=load(fileName);
    meas_mat=mat.filtered_mat;
    [len1 ,num_features]=size(meas_mat);
    len=1:len1;
    for meas = 1:num_features
        if(meas<=3) %accel
            if(k==1)
                if(meas==1 )
                    figure;
                end
            end
            subplot(3,1,meas)
            plot(len,meas_mat(:,meas));
            hold on;
            % plot(len1_vec,windows);
            % hold on;
            if(k==num_meas)
                %legend('1','window1','2','window2','3','window3');
                title(title_3(meas));
            end
            if(meas==3 && k==num_meas)
              sgtitle("acceleration");
            end
        elseif(meas<=6) %gyro
            if(k==1)
                if(meas==4)
                    figure;
                end
                subplot(3,1,meas-3)
            end
            plot(len,meas_mat(:,meas));
            hold on;
            % plot(len,windows);
            % hold on;
            if(k==num_meas)
                %legend('1','window1','2','window2','3','window3');
                title(title_3(meas-3));
            end
            if(meas==6 && k==num_meas)
              sgtitle("gyro");
            end
        elseif(meas<=10) %quat
            if(k==1)
                if(meas==7)
                    figure;
                end
                subplot(2,2,meas-6)
            end
            plot(len,meas_mat(:,meas));
            hold on;
            % plot(len1_vec,windows);
            % hold on;
            if(k==num_meas)
                %legend('1','window1','2','window2','3','window3');
                title(title_q(meas-6));
            end
            if(meas==10 && k==num_meas)
              sgtitle("quaternion");
            end
        elseif(meas>=15)
            if(k==1)
                if(meas==15 )
                    figure;
                end
                subplot(2,3,meas-14)
            end
            plot(len,meas_mat(:,meas));
            hold on;
            if(k==num_meas)
                title(title_fsr(meas-14));
            end
            if(meas==19 && k==num_meas)
              sgtitle("FSR");
            end
        end
    end
end
end