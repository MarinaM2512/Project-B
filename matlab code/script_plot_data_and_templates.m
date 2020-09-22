clc;clear all;close all;
template_mat = loadTemplateMat; %Padded to same length
date = "17_04"; 
Ts = 20;
template_len = 63;
folderPath = "..\measurements\resample"; 
moves_names = [{"sit_N_swipe_L1"} {"sit_N_swipe_R1"} {"sit_N_tap1"} {"sit_N_side_ancle1"}];
move_times = get_movment_times("start",moves_names,date);
swl = template_mat{1};
swl = swl(:,:,1);
swr = template_mat{2};
swr = swr(:,:,1);
tap = template_mat{3};
tap = tap(:,:,1);
ank = template_mat{4};
ank = ank(:,:,1);
for i = 1:4
    data_mat = load_measurment_mat_from_dir(folderPath,date,moves_names{i},"FILTERED_INIT");
    gyro = data_mat(:,4:6);
    times = data_mat(:,20);
    curr_move_temp = zeros(size(gyro));
    template = template_mat{i};
    template = template(:,:,1);
    shifts = move_times{i};
    shifts = floor(shifts/Ts);
    for j = 1:length(shifts)
        curr_move_temp(shifts(j):shifts(j)+template_len-1,:) = template;
    end
    figure;
    subplot(3,1,1);
    plot(times,gyro(:,1));
    hold on;
    plot(times,curr_move_temp(:,1));
    title("X");
    xlabel("time [sec]");
    ylabel("gyro [rad\sec]");
    legend("raw data","moved template");
    subplot(3,1,2);
    plot(times,gyro(:,2));
    hold on;
    plot(times,curr_move_temp(:,2));
    title("Y");
    xlabel("time [sec]");
    ylabel("gyro [rad\sec]");
    legend("raw data","moved template");
    subplot(3,1,3);
    plot(times,gyro(:,3));
    hold on;
    plot(times,curr_move_temp(:,3));
    title("Z");
    xlabel("time [sec]");
    ylabel("gyro [rad\sec]");
    legend("raw data","moved template");
    newStr = strrep(moves_names{i},'_',' ');
    sgtitle("Raw data of " + newStr + " with moved template");
end