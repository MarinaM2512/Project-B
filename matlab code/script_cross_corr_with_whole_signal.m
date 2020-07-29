%% Load saved templates
tmp = load("./templates/tap_template");
temp_tap = tmp.tap(:,:,1);
temp_tap_t = tmp.tap(:,:,2);
tmp = load("./templates/ank_template");
temp_ank = tmp.ank(:,:,1);
temp_ank_t = tmp.ank(:,:,2);
tmp = load("./templates/swl_template");
temp_swl = tmp.swl(:,:,1);
temp_swl_t = tmp.swl(:,:,2);
tmp = load("./templates/swr_template");
temp_swr = tmp.swr(:,:,1);
temp_swr_t = tmp.swr(:,:,2);
template_mat = cell(...
    [{temp_swl} {temp_swr} {temp_tap} {temp_ank}]);
%%
move_name = "sit_N_tap1";
data_mat = loadMeasurmentMat("17_04",move_name,1,"INIT"); 
gyro_data = data_mat(:,4:6);
times = data_mat(:,20);
gyro = cat(2,data_mat(:,4:6),data_mat(:,20));
[xcorr,corr_times] = xcorr_all_intresting_data(gyro,-1000,'sig',"start");
xcorr_padded = padarray(xcorr,[(length(data_mat)-length(xcorr)),0,0],0,'post');
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
    sgtitle(["normalized cross correlation of " ,newStr]);



