

%% read data from dates 11_04 17_04 and median filter them
%read_data_to_mat("11_04")
%med_filter_all_data("11_04",5)
%read_data_to_mat("17_04")
med_filter_all_data("17_04",5)
%% Normalise all data and plot 
    date =  "17_04";
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

%% join measurments of movements
date = "17_04";
movement_names = ["sit_N_swipe_L1", "sit_N_swipe_L2", "sit_N_swipe_L3"];
% template for only one mes - "sit_N_swipe_L1"
[to_avgX, ~, ~] = join_measurments_of_movements(date,movement_names(1),10000,500,10,7);
[~, to_avgY, ~] = join_measurments_of_movements(date,movement_names(1),10000,500,10,6);
[~, ~, to_avgZ] = join_measurments_of_movements(date,movement_names(1),10000,500,10,9);

[gyroX_template , tx_template] = make_template(to_avgX,0.1);
[gyroY_template , ty_template] = make_template(to_avgY,0.1);
[gyroZ_template , tz_template] = make_template(to_avgZ,0.1);

%% check movement finding and make_template
textFileName= strcat("..\measurements\resample\",date,"\","*",movement_name,"*","INIT.mat");
DirList = dir(fullfile(textFileName));
listOfFiles = {DirList.name};
mat_name=strcat("..\measurements\resample\",date,"\",listOfFiles{1});
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
subplot(3,1,1);
plot(t,mat(:,4));
hold all;
plot(t,moveX);
plot(tx_template,gyroX_template);%
ylabel('x');
subplot(3,1,2)
plot(t,mat(:,5));
hold all;
plot(t,moveY);
plot(ty_template,gyroY_template);%
ylabel('y');
subplot(3,1,3)
plot(t,mat(:,6));
hold all;
plot(t,moveZ);
plot(tz_template,gyroZ_template);
ylabel('z');
%% template for all mes in movement_names
[data_template_x, time_template_x] = make_tamplate_all_movments_x(date,movement_names,10000,500,10,7,0.1);
[data_template_y, time_template_y] = make_tamplate_all_movments_y(date,movement_names,10000,500,10,6,0.1);
[data_template_z, time_template_z] = make_tamplate_all_movments_z(date,movement_names,10000,500,10,9,0.1);
% compare templates

figure();
subplot(3,1,1);
plot(time_template_x,data_template_x);
hold on;
plot(tx_template,gyroX_template);
title("template by one mesuements in comparison to all for swipe L");
ylabel("gyro X");
legend("all swipeL","swipeL1");
subplot(3,1,2);
plot(time_template_y,data_template_y);
hold on;
plot(ty_template,gyroY_template);
ylabel("gyro Y");
legend("all swipeL","swipeL1");
subplot(3,1,3);
plot(time_template_z,data_template_z);
hold on;
plot(tz_template,gyroZ_template);
ylabel("gyro Z");
legend("all swipeL","swipeL1");
%% test is swipe L
swL = zeros(size(to_avgX,2),1);
for i=1:size(to_avgX,2)
    sx = to_avgX(:,i,1);
    tx = to_avgX(:,i,2);
    sy = to_avgY(:,i,1);
    ty = to_avgY(:,i,2);
    sz = to_avgZ(:,i,1);
    tz = to_avgZ(:,i,2);
    swL(i) = isswipeL(sx,tx,sy,ty,sz,tz);
end
    