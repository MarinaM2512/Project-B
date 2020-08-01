clear all;
close all;
clc;
%% Test xcorr normalized
move_name = "sit_N_tap1";
data_mat = loadMeasurmentMat("17_04",move_name,1,"INIT"); 
gyro_data = data_mat(:,4:6);
times = data_mat(:,20);
gyro = cat(2,data_mat(:,4:6),data_mat(:,20));
[xcorr,corr_times] = xcorr_all_intresting_data(gyro,-1000,'normalized',"start");
xcorr_padded = reshape(cell2mat(xcorr),[length(xcorr{1}),3,4]);
xcorr_padded = padarray(xcorr_padded,[(length(data_mat)-length(xcorr_padded)),0,0],0,'post');
orig_times = cell2mat(get_movment_times("start",{move_name}));
orig_times = ismember(times,orig_times);
colors = ["r", "g","b","m"];
figure;
for j = 1:4
    subplot(3,1,1);
    plot(times,xcorr_padded(:,1,j),colors(j));
    title("X");
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
    subplot(3,1,2);
    plot(times,xcorr_padded(:,2,j),colors(j));
    title("Y");
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
    subplot(3,1,3);
    plot(times,xcorr_padded(:,3,j),colors(j));
    title("Z");
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
end
    legend("swipe left template","original times","swipe right template","tap template","ankle template");
    newStr = strrep(move_name,'_',' ');
    sgtitle(["raw cross correlation of " ,newStr]);

%% Load PCA weights
tmp = load("./templates/tap_principle_vec");
vec_tap = tmp.tap;
tmp = load("./templates/ank_principle_vec");
vec_ank = tmp.ank;
tmp = load("./templates/swl_principle_vec");
vec_swl = tmp.swl;
tmp = load("./templates/swr_principle_vec");
vec_swr = tmp.swr; 
wight_vec = [vec_swl vec_swr vec_tap vec_ank];
%% Weighted normalised xcorr
xcorr_weighted = zeros(length(xcorr_padded),4);
for i = 1:length(xcorr_padded)
    xcorr_weighted(i,1:4) = sum(reshape(xcorr_padded(i,1:3,1:4),[3,4]) .* wight_vec);
end
figure;
for j = 1:4
    plot(times,xcorr_weighted(:,j),colors(j));
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
end
    legend("swipe left template","original times","swipe right template","tap template","ankle template");
    newStr = strrep(move_name,'_',' ');
    title(["normalized and weighted cross correlation of " ,newStr]);
%% Threshold normalized corr and use weights
[labels,xcorr_out] = tresholding_xcorr(xcorr,corr_times,0.7,'MinPeakHeight',0.3,250);
xcorr_out = reshape(cell2mat(xcorr_out),[length(xcorr_out{1}),3,4]);
xcorr_weighted = zeros(length(xcorr_out),4);
for i = 1:length(xcorr_out)
    xcorr_weighted(i,1:4) = sum(reshape(xcorr_out(i,1:3,1:4),[3,4]) .* wight_vec);
end
xcorr_padded = padarray(xcorr_weighted,[(length(data_mat)-length(xcorr_weighted)),0,0],0,'post');
figure;
for j = 1:4
    plot(times,xcorr_padded(:,j),colors(j));
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
end
    legend("swipe left template","original times","swipe right template","tap template","ankle template");
    newStr = strrep(move_name,'_',' ');
    title(["normalized thresholded and weighted cross correlation of " ,newStr]);
%% normlized with weighted ryy to all axis
move_name = "sit_N_swipe_R1";
data_mat = loadMeasurmentMat("17_04",move_name,1,"INIT"); 
times = data_mat(:,20);
gyro = cat(2,data_mat(:,4:6),data_mat(:,20));
[xcorr,corr_times] = xcorr_all_intresting_data(gyro,-1000,'none',"start");
xcorr_padded = reshape(cell2mat(xcorr),[length(xcorr{1}),3,4]);
xcorr_padded = padarray(xcorr_padded,[(length(data_mat)-length(xcorr_padded)),0,0],0,'post');
orig_times = cell2mat(get_movment_times("start",{move_name}));
orig_times = ismember(times,orig_times);
colors = ["r", "g","b","m"];
template_mat = loadTemplateMat;
temp_power = cellfun(@(x) sum(x(:,:,1).^2),template_mat,'UniformOutput',false);
temp_power = reshape(cell2mat(temp_power),[3,4]);
weighted_temp_power = sum(wight_vec .* temp_power);
weighted_temp_power = repmat(weighted_temp_power,[3,1]);
for i = 1:length(xcorr_padded)
    xcorr_padded(i,1:3,1:4) = reshape(xcorr_padded(i,1:3,1:4),[3,4]) ./ weighted_temp_power;
end
figure;
for j = 1:4
    subplot(3,1,1);
    plot(times,xcorr_padded(:,1,j),colors(j));
    title("X");
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
    subplot(3,1,2);
    plot(times,xcorr_padded(:,2,j),colors(j));
    title("Y");
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
    subplot(3,1,3);
    plot(times,xcorr_padded(:,3,j),colors(j));
    title("Z");
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
end
    legend("swipe left template","original times","swipe right template","tap template","ankle template");
    newStr = strrep(move_name,'_',' ');
    sgtitle(["normalized - with weighted template power cross correlation of " ,newStr]);
%% Threshold xcorr normalized by weighted templates
for i=1:4
    xcorr_weighted_padded{i} =  xcorr_padded(:,:,i);
end
[labels,xcorr_out] = tresholding_xcorr(xcorr_weighted_padded,times,0.5,'MinPeakHeight',0.3,250);
xcorr_out = reshape(cell2mat(xcorr_out),[length(xcorr_out{1}),3,4]);
xcorr_weighted = zeros(length(xcorr_out),4);
for i = 1:length(xcorr_out)
    xcorr_weighted(i,1:4) = sum(reshape(xcorr_out(i,1:3,1:4),[3,4]) .* wight_vec);
end
xcorr_padded = padarray(xcorr_weighted,[(length(data_mat)-length(xcorr_weighted)),0,0],0,'post');
figure;
for j = 1:4
    plot(times,xcorr_padded(:,j),colors(j));
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
end
    legend("swipe left template","original times","swipe right template","tap template","ankle template");
    newStr = strrep(move_name,'_',' ');
    title(["normalized thresholded and weighted cross correlation of " ,newStr]);

%% Normalized by weighted template and signal power - not good!
move_name = "sit_N_tap2";
data_mat = loadMeasurmentMat("17_04",move_name,1,"INIT"); 
gyro_data = data_mat(:,4:6);
times = data_mat(:,20);
gyro = cat(2,data_mat(:,4:6),data_mat(:,20));
[xcorr,corr_times] = xcorr_all_intresting_data(gyro,-1000,'normalized',"start");
xcorr_padded = reshape(cell2mat(xcorr),[length(xcorr{1}),3,4]);
xcorr_padded = padarray(xcorr_padded,[(length(data_mat)-length(xcorr_padded)),0,0],0,'post');
orig_times = cell2mat(get_movment_times("start",{move_name}));
orig_times = ismember(times,orig_times);
template_mat = loadTemplateMat;
temp_power = cellfun(@(x) sum(x(:,:,1).^2),template_mat,'UniformOutput',false);
temp_power = cellfun(@(x) x.^0.5,temp_power,'UniformOutput',false);
temp_power = reshape(cell2mat(temp_power),[3,4]);
weighted_temp_power = sum(wight_vec .* (temp_power.^2));
weighted_temp_power = repmat(weighted_temp_power,[3,1]);
% xcorr_padded = xcorr_padded .* temp_power;
for i = 1:length(xcorr_padded)
    xcorr_padded(i,1:3,1:4) = (reshape(xcorr_padded(i,1:3,1:4),[3,4]) .* temp_power)./ (weighted_temp_power.^0.5);
end
colors = ["r", "g","b","m"];
figure;
for j = 1:4
    subplot(3,1,1);
    plot(times,xcorr_padded(:,1,j),colors(j));
    title("X");
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
    subplot(3,1,2);
    plot(times,xcorr_padded(:,2,j),colors(j));
    title("Y");
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
    subplot(3,1,3);
    plot(times,xcorr_padded(:,3,j),colors(j));
    title("Z");
    hold on;
    if(j==1)
        stem(times,orig_times);
        hold on;
    end
end
    legend("swipe left template","original times","swipe right template","tap template","ankle template");
    newStr = strrep(move_name,'_',' ');




