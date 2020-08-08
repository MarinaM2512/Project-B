% calculate real_labels,xcorr_data,times,n1 for grid_search function
% xcorr calculation takes takes long time so we save the data to file 
% "to grid search"
date = "17_04";
endOrStart = 'start';
move_name = get_all_meas_names(date, "FILTERED_INIT", 1);   % all names
real_labels = get_all_real_labels(endOrStart);              % cell of labels from all meas
% init
xcorr_data = cell(size(move_name')); 
xcorr_data_intresting = cell(size(move_name')); 
times = cell(size(move_name'));
n1=0;
factor = 0.01;
% each meas in cell
for i=1:length(move_name) 
        data_mat = loadMeasurmentMat(date,move_name{i},1,"INIT");%load all data of meas i
        gyro = cat(2,data_mat(:,4:6),data_mat(:,20));            %load gyro data of meas i
        times{i} = data_mat(:,20);                               %save time sampels of meas i
        n1=n1+length(times{i});                                    %update length of total time vec
        % cal xcorr and insert to corr fild
        [xcorr_data{i}.corr,~] = xcorr_all_intresting_data(gyro,-1000,'normalized',"start");
        [xcorr_data_intresting{i}.corr,~] = xcorr_all_intresting_data(gyro,factor,'normalized',"start");
        % create and update type fild in data_xcorr
        % swipe L - 1, swipe R - 2, tap - 3, ankle - 4, else - 1
        if(contains(move_name{i},"swipe_L"))
            xcorr_data{i}.type = 1;
            xcorr_data_intresting{i}.type = 1;
        elseif(contains(move_name{i},"swipe_R"))
            xcorr_data{i}.type = 2;
            xcorr_data_intresting{i}.type = 2;
        elseif(contains(move_name{i},"tap"))
            xcorr_data{i}.type = 3;
            xcorr_data_intresting{i}.type = 3;
        elseif(contains(move_name{i},"side_ancle"))
            xcorr_data{i}.type = 4;
            xcorr_data_intresting{i}.type = 4;
        else
            xcorr_data{i}.type = 1; %e.x walking
            xcorr_data_intresting{i}.type = 1;
        end         
end   
%% save to improve time complexity in main
clear n
n.val=n1;
xcorrData.val = xcorr_data;
Times.val = times;
realLabels.val = real_labels;
xcorrInrestingData.val = xcorr_data_intresting;

xcorr_data_name=strcat(".\to grid search\xcorr_data.mat");
save(xcorr_data_name,'-struct','xcorrData');

xcorr_data_intresting_name=strcat(".\to grid search\xcorr_data_intresting.mat");
save(xcorr_data_intresting_name,'-struct','xcorrInrestingData');

times_name=strcat(".\to grid search\times.mat");
save(times_name,'-struct','Times');
real_labels_name=strcat(".\to grid search\real_labels.mat");
save(real_labels_name,'-struct','realLabels');
n_name=strcat(".\to grid search\n.mat");
save(n_name,'-struct','n');