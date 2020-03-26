%% Plot evry measurment type on different figure
%for 3 measurment and 4 motions
close all;
clc;
clear all;
title_3=["x" "y" "z"];
title_q=["qW" "qX" "qY" "qZ"];
title_fsr=["FSR0" "FSR1" "FSR2" "FSR3" "FSr4"];
field_names = ["accel_x" "accel_y" "accel_z" "gyro_x" "gyro_y" "gyro_z" "quat_w" "quat_x" "quat_y" ...
    "quat_z" "Cal_sys" "Cal_accel" "Cal_gyro" "Cal_mag" "quat_z" "fsr0" "fsr1" "fsr2" "fsr3" "fsr4"];
motion_names=["side_ancle" "swipe_L" "swipe_R" "tap"];
for motion =1:4
    mat1=load(strcat("Data_extraction_sit_",motion_names(motion),"1"));
    mat2=load(strcat("Data_extraction_sit_",motion_names(motion),"2"));
    mat3=load(strcat("Data_extraction_sit_",motion_names(motion),"3"));

    for meas=1:19 
        if(meas<=10 || meas>=15)
        y_1=getfield(mat1,field_names(meas));
        y_2=getfield(mat2,field_names(meas));
        y_3=getfield(mat3,field_names(meas));
        len1_vec=1:length(y_1);
        len2_vec=1:length(y_2);
        len3_vec=1:length(y_3);
        if(meas<=3) %accel
            if(meas==1)
                figure;
            end
            subplot(3,1,meas)
            plot(len1_vec,y_1);
            hold on;
            plot(len2_vec,y_2);
            hold on;
            plot(len3_vec,y_3);
            legend('1','2','3');
            title(title_3(meas));
            if(meas==3)
              sgtitle(strcat(motion_names(motion)," ","acceleration"));
            end
        elseif(meas<=6) %gyro
            if(meas==4)
                figure;
            end
            subplot(3,1,meas-3)
            plot(len1_vec,y_1);
            hold on;
            plot(len2_vec,y_2);
            hold on;
            plot(len3_vec,y_3);
            legend('1','2','3');
            title(title_3(meas-3));
            if(meas==6)
              sgtitle(strcat(motion_names(motion)," ","gyro"));
            end
        elseif(meas<=10) %quat
            if(meas==7)
                figure;
            end
            subplot(2,2,meas-6)
            plot(len1_vec,y_1);
            hold on;
            plot(len2_vec,y_2);
            hold on;
            plot(len3_vec,y_3);
            legend('1','2','3');
            title(title_q(meas-6));
            if(meas==10)
              sgtitle(strcat(motion_names(motion)," ","quaternion"));
            end
        elseif(meas>=15)
            if(meas==15)
                figure;
            end
            subplot(2,3,meas-14)
            plot(len1_vec,y_1);
            hold on;
            plot(len2_vec,y_2);
            hold on;
            plot(len3_vec,y_3);
            legend('1','2','3');
            title(title_fsr(meas-14));
            if(meas==19)
              sgtitle(strcat(motion_names(motion)," ","FSR"));
            end
        end
        end
    end
end