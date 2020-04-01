clear all;
clc;
i=1;
num_move=1;
date= "30_03";
num_meas=1;
all_data=cell(num_meas,19,num_move);
%for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
for name = ["sit_swipe_R"]
    for k=1:num_meas
        %mat_name=strcat("Data_extraction_",name,num2str(k),".mat");
        %fullFileName = fullfile('measurments','22_03', mat_name);
        mat_name= strcat("..\measurements\",date,"\Data_extraction_",name,num2str(k),".mat");
        if exist(mat_name, 'file')
        M=load(mat_name);
        if(strcmp(date,"22_03"))
            m=convert_data_mat(M);
        else
            m=M.final;
        end
            for jj=1:19
                all_data(k,jj,i)={m(:,jj)};
            end
        else
            fprintf('File %s does not exist.\n', mat_name);
        end
    end
    i=i+1;
    end

    %%
    all_data=median_all_data_filt(all_data,5);
    close all;
title_3=["x" "y" "z"];
title_q=["qW" "qX" "qY" "qZ"];
title_fsr=["FSR0" "FSR1" "FSR2" "FSR3" "FSr4"];
%name=["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"];
name= ["sit_swipe_R"];
for motion =1:num_move
    for meas=1:19 
        for k=1:num_meas %% new try
        y_1=cell2mat(all_data(k,meas,motion));
        len1_vec=1:length(y_1);
        sum_frames=devide_to_farames(y_1,10);
        sum_frames=sort(sum_frames);
        thresh=sum_frames(length(sum_frames)-130);
        thresh_vec=zeros(1,length(y_1));
        thresh_vec(find(abs(diff(y_1))>thresh))=max(abs(y_1));
        rows=length(thresh_vec/100);
        [idx,~]=find(thresh_vec>0);
        len=mod(length(thresh_vec),100);
        windows=zeros(1,length(y_1));
        for i=(1+len):100:(length(thresh_vec)-100)
            frame=thresh_vec(i:i+100);
            idx=find(frame>0)+i+1;
            if(~isempty(idx))
                start=idx(1);
                ending=idx(end);
                windows(start:ending)=max(frame);
            end
        end
        %y_2=cell2mat(all_data(2,meas,motion));
        %y_3=cell2mat(all_data(3,meas,motion));
%         len2_vec=1:length(y_2);
%         len3_vec=1:length(y_3);
        if(meas<=3) %accel
            if(k==1)
                if(meas==1 )
                    figure;
                end
            end
            subplot(3,1,meas)
            plot(len1_vec,y_1);
            hold on;
            plot(len1_vec,windows);
            hold on;
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
            if(k==num_meas)
                legend('1','window1','2','window2','3','window3');
                title(title_3(meas));
            end
            if(meas==3 && k==num_meas)
              sgtitle(strcat(name(motion)," ","acceleration"));
            end
        elseif(meas<=6) %gyro
            if(k==1)
                if(meas==4)
                    figure;
                end
                subplot(3,1,meas-3)
            end
            plot(len1_vec,y_1);
            hold on;
            plot(len1_vec,windows);
            hold on;
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
            if(k==num_meas)
                legend('1','window1','2','window2','3','window3');
                title(title_3(meas-3));
            end
            if(meas==6 && k==num_meas)
              sgtitle(strcat(name(motion)," ","gyro"));
            end
        elseif(meas<=10) %quat
            if(k==1)
                if(meas==7)
                    figure;
                end
                subplot(2,2,meas-6)
            end
            plot(len1_vec,y_1);
            hold on;
            plot(len1_vec,windows);
            hold on;
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
            if(k==num_meas)
                legend('1','window1','2','window2','3','window3');
                title(title_q(meas-6));
            end
            if(meas==10 && k==num_meas)
              sgtitle(strcat(name(motion)," ","quaternion") );
            end
        elseif(meas>=15)
            if(k==1)
                if(meas==15 )
                    figure;
                end
                subplot(2,3,meas-14)
            end
            plot(len1_vec,y_1);
            hold on;
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
            if(k==num_meas)
                legend('1','2','3');
                title(title_fsr(meas-14));
            end
            if(meas==19 && k==num_meas)
              sgtitle(strcat(name(motion)," ","FSR"));
            end
        end
        end
    end
end


