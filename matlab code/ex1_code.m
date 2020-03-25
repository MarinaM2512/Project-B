% accel_x accel_y accel_z gyro_x gyro_y gyro_z qW qX qY qZ 
% Cal_sys Cal_gyro Cal_accel Cal_mag FSR0 FSR1 FSR2 FSR3 FSR4

clc;
clear all;
i=1;
for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    for k=1:3
        textFileName= strcat("..\measurements\25_03\",name,num2str(k),".txt");
        if exist(textFileName, 'file')
            s=fileread(textFileName); 
            begining_idx=regexp(s,'FSR4')+length('FSR4')+1;
            s=s(begining_idx:end);
            expression=' ';
            splitStr = regexp(s,expression,'split');
            writecell(splitStr,'tmp.txt')
            final=readmatrix('tmp.txt');
            final=final(1:end-1,:);
            mat_name=strcat("..\measurements\25_03\","Data_extraction_",name,num2str(k),".mat");
            save(mat_name,'final');
            
        else
            fprintf('File %s does not exist.\n', textFileName);
        end
    end
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
i=1;
all_data=cell(3,19,4);
for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    for k=1:3
        %mat_name=strcat("Data_extraction_",name,num2str(k),".mat");
        %fullFileName = fullfile('measurments','22_03', mat_name);
        mat_name= strcat("..\measurements\25_03\Data_extraction_",name,num2str(k),".mat");
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


%%
% function get_accel_x(mat_name)
%     mat=load(mat_name);
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
%             legend('x','y','z');
%             legend('x','y','z');
%             legend('w','x','y','z');
%             legend('FSR0','FSR1','FSR2','FSR3','FSR4');

        end
        
    end
                     
    