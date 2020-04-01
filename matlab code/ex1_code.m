% accel_x accel_y accel_z gyro_x gyro_y gyro_z qW qX qY qZ 
% Cal_sys Cal_gyro Cal_accel Cal_mag FSR0 FSR1 FSR2 FSR3 FSR4
%%%%%%%%%%%%%%%%%%%%%%%%%Extract Data from text file%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
date= "30_03";
num_meas=1;
for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    for k=1:num_meas
        textFileName= strcat("..\measurements\",date,"\",name,num2str(k),".txt");
        if exist(textFileName, 'file')
            s=fileread(textFileName); 
            begining_idx=regexp(s,'Test')+length('Test')+1;
            s=s(begining_idx:end);
            expression=' \n';
            splitStr = regexp(s,expression,'split');
            writecell(splitStr,'tmp.txt')
            final=readmatrix('tmp.txt');
            final=final(1:end-1,:);
            mat_name=strcat("..\measurements\",date,"\","Data_extraction_",name,num2str(k),".mat");
            save(mat_name,'final');
            
        else
            fprintf('File %s does not exist.\n', textFileName);
        end
    end
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%Open mat files%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
num_move=2;
all_data=cell(num_meas,19,num_move);
%for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    for name = ["sit_swipe_R", "sit_swipe_L"]
    for k=1:num_meas
        %mat_name=strcat("Data_extraction_",name,num2str(k),".mat");
        %fullFileName = fullfile('measurments','22_03', mat_name);
        mat_name= strcat("..\measurements\",date,"\Data_extraction_",name,num2str(k),".mat");
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


% %% plot all coordinates on same plot
% 
% name = ["sit tap", "sit side ancle" ,"sit swipe right", "sit swipe left"];
%     for ii=1:num_move
%         for jj=1:19
%             for k=1:num_meas
%                 y=cell2mat(all_data(k,jj,ii));
%                 len_vec=1:length(y);
%                 figure(ii);
%             if(jj<=3) % acc
%                 subplot(2,2,1)
%                 plot(len_vec,y);
%                 hold on;
%                 title('acceleration');
%                 if (jj==3)
%                     legend('x','y','z');
%                 end
% 
%             elseif jj>=4 && jj<=6 %gyro
%                 subplot(2,2,2)
%                 plot(len_vec,y);
%                 hold on;
%                 title('gyro');
%                 if (jj==6)
%                     legend('x','y','z');
%                 end
% 
%             elseif jj>=7 &&jj<=10 %quat
%                 subplot(2,2,3)
%                 plot(len_vec,y);
%                 hold on;
%                 title('quat');
%                 if (jj==10)
%                     legend('w','x','y','z');
%                 end
% 
%             elseif jj>=15 && jj<=19 %%fsr
%                 subplot(2,2,4)
%                 plot(len_vec,y);
%                 hold on;
%                 title('fsr');
%                 if (jj==19)
%                     legend('FSR0','FSR1','FSR2','FSR3','FSR4');
%                 end
% 
%             end
%             end
%             sgtitle(name(ii));
% 
%         end
%         
%     end
                
%% Plot evry measurment type on different figure
%for 3 measurment and 4 motions
close all;
title_3=["x" "y" "z"];
title_q=["qW" "qX" "qY" "qZ"];
title_fsr=["FSR0" "FSR1" "FSR2" "FSR3" "FSr4"];
name = ["sit swipe right", "sit swipe left"];
for motion =1:num_move
    for meas=1:19 
        for k=1:num_meas %% new try
        y_1=cell2mat(all_data(k,meas,motion));
        %y_2=cell2mat(all_data(2,meas,motion));
        %y_3=cell2mat(all_data(3,meas,motion));
        len1_vec=1:length(y_1);
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
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
            if(k==num_meas)
                legend('1','2','3');
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
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
            if(k==num_meas)
                legend('1','2','3');
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
%             plot(len2_vec,y_2);
%             hold on;
%             plot(len3_vec,y_3);
            if(k==num_meas)
                legend('1','2','3');
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
            
            
            
            
            
            
           
                                
                                
            


        


        

            
        
        
 
                
                
                
 