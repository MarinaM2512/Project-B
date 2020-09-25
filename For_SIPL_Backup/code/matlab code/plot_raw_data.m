%% Plot every measurment type on different figure
%recive name of movement and plot all the filtered raw data measurments of
%that movement on the same plot
function plot_raw_data(movement_name,date)
% movement_name="sit_swipe_R";
% date="30_03";
title_3=["x" "y" "z"];
title_q=["qW" "qX" "qY" "qZ"];
title_fsr=["FSR0" "FSR1" "FSR2" "FSR3" "FSR4"];
textFileName= strcat("..\measurements\resample\",date,"\","*",movement_name,"*","FILTERED_INIT.mat");
DirList = dir(fullfile(textFileName)); % all files with the name texeFileName
listOfFiles = {DirList.name};
num_meas=length(listOfFiles);
all_measurments=cell(num_meas,1);
for motion= 1:num_meas
    fileName=strcat("..\measurements\",date,"\",listOfFiles{motion});
    mat=load(fileName);
    all_measurments(motion,1)={mat.initialised};
end
[~,num_features]=size(all_measurments{1,1});
    for meas = 1:num_features
        if(meas<=3) %accel
                if(meas==1 )
                    figure;
                end
            subplot(3,1,meas)
            for ind = 1:num_meas
                meas_mat = all_measurments{ind,1};
                %[len_data ,~]=size(meas_mat);
                t=meas_mat(:,end);
                plot(t,meas_mat(:,meas));
                hold on;
                if(ind==num_meas)
                    title(title_3(meas));
                end
                if(meas==3 && ind==num_meas)
                  sgtitle("acceleration");
                end
            end
        elseif(meas<=6) %gyro
                if(meas==4)
                    figure;
                end
                subplot(3,1,meas-3)
            for ind = 1:num_meas
                meas_mat = all_measurments{ind,1};
                %[len_data ,~]=size(meas_mat);
                t=meas_mat(:,end);
                plot(t,meas_mat(:,meas));
                hold on;
                if(ind==num_meas)
                    title(title_3(meas-3));
                    xlabel("time [sec]");
                end
                if(meas==6 && ind==num_meas)
                  sgtitle("gyro");
                end
            end
        elseif(meas<=10) %quat
                if(meas==7)
                    figure;
                end
                subplot(2,2,meas-6)
            for ind = 1:num_meas
                meas_mat = all_measurments{ind,1};
                %[len_data ,~]=size(meas_mat);
                t=meas_mat(:,end);
                plot(t,meas_mat(:,meas));
                hold on;
                if(ind==num_meas)
                    title(title_q(meas-6));
                end
                if(meas==10 && ind==num_meas)
                  sgtitle("quaternion");
                end
            end
        elseif(meas>=15 && meas<num_features)
                if(meas==15 )
                    figure;
                end
                subplot(2,3,meas-14)
            for ind = 1:num_meas
                meas_mat = all_measurments{ind,1};
                %[len_data ,~]=size(meas_mat);
                t=meas_mat(:,end);
                plot(t,meas_mat(:,meas));
                hold on;
                if(ind==num_meas)
                    title(title_fsr(meas-14));
                end
                if(meas==19 && ind==num_meas)
                  sgtitle("FSR");
                end
            end
        end
    end
end


