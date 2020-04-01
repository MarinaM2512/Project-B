% accel_x accel_y accel_z gyro_x gyro_y gyro_z qW qX qY qZ 
% Cal_sys Cal_gyro Cal_accel Cal_mag FSR0 FSR1 FSR2 FSR3 FSR4
%%%%%%%%%%%%%%%%%%%%%%%%%Extract Data from text file%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    for k=1:3
        textFileName= strcat("..\measurements\22_03\",...%was 25_03
                               name,num2str(k),".txt");
        if exist(textFileName, 'file')
            s=fileread(textFileName); 
            begining_idx=regexp(s,'FSR4')+length('FSR4')+1;
            s=s(begining_idx:end);
            expression=' ';
            splitStr = regexp(s,expression,'split');
            writecell(splitStr,'tmp.txt')
            final=readmatrix('tmp.txt');
            final=final(1:end-1,:);
            mat_name=strcat("..\measurements\22_03\",...%was 25_03
                             "Data_extraction_",name,num2str(k),".mat");
            save(mat_name,'final');
            
        else
            fprintf('File %s does not exist.\n', textFileName);
        end
    end
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%Open mat files%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
i=1;
all_data=cell(3,19,4); % dims: num of measerments, num of parameters, num of movements
for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    for k=1:3
        %mat_name=strcat("Data_extraction_",name,num2str(k),".mat");
        %fullFileName = fullfile('measurments','22_03', mat_name);
        mat_name= strcat("..\measurements\25_03\Data_extraction_"... %was 25_03
                            ,name,num2str(k),".mat");
        if exist(mat_name, 'file')
        M=load(mat_name);
            m=M.final;
            for jj=1:19
                all_data(k,jj,i)={m(:,jj)};
            end
        else
            fprintf('File %s does not exist.\n', mat_name);
        end
    end
    i=i+1;
end


%% plot all coordinates on same plot

name = ["sit tap", "sit side ancle" ,"sit swipe right", "sit swipe left"];
    for ii=1:4
        for jj=1:19
            for k=1:3
                y=cell2mat(all_data(k,jj,ii));
                len_vec=1:length(y);
                figure(ii);
            if(jj<=3) % acc
                subplot(2,2,1)
                plot(len_vec,y);
                hold on;
                title('acceleration');
                if (jj==3)
                    legend('x','y','z');
                end

            elseif jj>=4 && jj<=6 %gyro
                subplot(2,2,2)
                plot(len_vec,y);
                hold on;
                title('gyro');
                if (jj==6)
                    legend('x','y','z');
                end

            elseif jj>=7 &&jj<=10 %quat
                subplot(2,2,3)
                plot(len_vec,y);
                hold on;
                title('quat');
                if (jj==10)
                    legend('w','x','y','z');
                end

            elseif jj>=15 && jj<=19 %%fsr
                subplot(2,2,4)
                plot(len_vec,y);
                hold on;
                title('fsr');
                if (jj==19)
                    legend('FSR0','FSR1','FSR2','FSR3','FSR4');
                end

            end
            end
            sgtitle(name(ii));

        end
        
    end
                
%% Plot every measurment type on different figure
close all;

all_data_medfilt3 = median_all_data_filt(all_data,3);
all_data_medfilt5 = median_all_data_filt(all_data,5);
plot_param_on_diff_fig(all_data_medfilt3);
plot_param_on_diff_fig(all_data_medfilt5);

%% inserted to function "plot_param_on_diff_fig"
% title_3=["x" "y" "z"];
% title_q=["qW" "qX" "qY" "qZ"];
% title_fsr=["FSR0" "FSR1" "FSR2" "FSR3" "FSr4"];
% name = ["sit tap", "sit side ancle" ,"sit swipe right", "sit swipe left"];
% for motion =1:4
%     for meas=1:19 
%         y_1=cell2mat(all_data(1,meas,motion));
%         y_2=cell2mat(all_data(2,meas,motion));
%         y_3=cell2mat(all_data(3,meas,motion));
%         len1_vec=1:length(y_1);
%         len2_vec=1:length(y_2);
%         len3_vec=1:length(y_3);
%         if(meas<=3) %accel
%             if(meas==1)
%                 figure;
%             end
%             subplot(3,1,meas)
%             plot(len1_vec,y_1);
%             hold on;
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
%             legend('1','2','3');
%             title(title_3(meas));
%             if(meas==3)
%               sgtitle(strcat(name(motion)," ","acceleration"));
%             end
%         elseif(meas<=6) %gyro
%             if(meas==4)
%                 figure;
%             end
%             subplot(3,1,meas-3)
%             plot(len1_vec,y_1);
%             hold on;
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
%             legend('1','2','3');
%             title(title_3(meas-3));
%             if(meas==6)
%               sgtitle(strcat(name(motion)," ","gyro"));
%             end
%         elseif(meas<=10) %quat
%             if(meas==7)
%                 figure;
%             end
%             subplot(2,2,meas-6)
%             plot(len1_vec,y_1);
%             hold on;
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
%             legend('1','2','3');
%             title(title_q(meas-6));
%             if(meas==10)
%               sgtitle(strcat(name(motion)," ","quaternion"));
%             end
%         elseif(meas>=15)
%             if(meas==15)
%                 figure;
%             end
%             subplot(2,3,meas-14)
%             plot(len1_vec,y_1);
%             hold on;
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
%             legend('1','2','3');
%             title(title_fsr(meas-14));
%             if(meas==19)
%               sgtitle(strcat(name(motion)," ","FSR"));
%             end
%         end
%     end
% end