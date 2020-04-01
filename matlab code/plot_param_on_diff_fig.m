%% Plot every measurment type on different figure
%for 3 measurment and 4 motions
function []=plot_param_on_diff_fig(data)
title_3=["x" "y" "z"];
title_q=["qW" "qX" "qY" "qZ"];
title_fsr=["FSR0" "FSR1" "FSR2" "FSR3" "FSr4"];
name = ["sit tap", "sit side ancle" ,"sit swipe right", "sit swipe left"];
for motion =1:4
    for meas=1:19 
        y_1=cell2mat(data(1,meas,motion));
        y_2=cell2mat(data(2,meas,motion));
        y_3=cell2mat(data(3,meas,motion));
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
              sgtitle(strcat(name(motion)," ","acceleration"));
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
              sgtitle(strcat(name(motion)," ","gyro"));
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
              sgtitle(strcat(name(motion)," ","quaternion"));
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
              sgtitle(strcat(name(motion)," ","FSR"));
            end
        end
    end
end
end

