%% read data from dates 11_04 17_04
%read_data_to_mat("11_04")
med_filter_all_data("11_04",5)
%read_data_to_mat("17_04")
med_filter_all_data("17_04",5)
%% Normalise all data and plot 
for date = ["11_04" "17_04"]
    textFileName= strcat("..\measurements\",date,"\","*","FILTERED.mat");
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
    for i= 1:length(listOfFiles)
        mat_name=strcat("..\measurements\",date,"\",listOfFiles{i});
        M=load(mat_name);
        mat=M.filtered_mat;
        delay=200;
        [S_qw,T_qw]= data2timeSegments(mat(:,7),  mat(:,20), delay);
        [S_qx,T_qx]= data2timeSegments(mat(:,8),  mat(:,20), delay);
        [S_qy,T_qy]= data2timeSegments(mat(:,9),  mat(:,20), delay);
        [S_qz,T_qz]= data2timeSegments(mat(:,10), mat(:,20), delay);
        q_norm1=normalize_quat(S_qw,S_qx,S_qy,S_qz);
        q_norm=cell2mat(q_norm1);
        t=mat(:,20);
        initialised = mat;
        initialised(:,7:10) = q_norm(2:end,:);
        figure();
        subplot(2,2,1);
        plot(t,q_norm(1:end-1,1));
        title('w');
        subplot(2,2,2);
        plot(t,q_norm(1:end-1,2));
        title('x');
        subplot(2,2,3);
        plot(t,q_norm(1:end-1,3));
        title('y');
        subplot(2,2,4);
        plot(t,q_norm(1:end-1,4));
        title('z');
        plt_title = strcat(date," ",listOfFiles{i});
        newStr = strrep(plt_title,'_',' ');
        newStr = split(newStr,'.');
        sgtitle(newStr(1));
        mat_name = split(mat_name,'.mat');
        mat_name=strcat(mat_name(1),"_INIT",".mat");
        save(mat_name,'initialised'); 
    end
end
%% join measurments of movements
date = "17_04";
movement_name = "sit_N_swipe_L2";
[to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name,10000,500,10,7);

%% check movement finding
textFileName= strcat("..\measurements\",date,"\","*",movement_name,"*","INIT.mat");
DirList = dir(fullfile(textFileName));
listOfFiles = {DirList.name};
mat_name=strcat("..\measurements\",date,"\",listOfFiles{1});
M=load(mat_name);
mat=M.initialised;
t = mat(:,20);
moveX_t = to_avgX(:,:,2);
moveX = ismember(t,moveX_t)*200;
moveY_t = to_avgY(:,:,2);
moveY = ismember(t,moveY_t)*200;
moveZ_t = to_avgZ(:,:,2);
moveZ = ismember(t,moveZ_t)*200;
figure();
subplot(3,1,1)
plot(t,mat(:,4));
hold on;
plot(t,moveX);
title('x');
subplot(3,1,2)
plot(t,mat(:,5));
hold on;
plot(t,moveY);
title('y');
subplot(3,1,3)
plot(t,mat(:,6));
hold on;
plot(t,moveZ);
title('z');


