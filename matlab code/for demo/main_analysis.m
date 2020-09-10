function is_mov_detect = main_analysis(src)

% This function is the main analysis function.
% This function is activated only when the buffer is full and a new
% data-point arrived.
%
% src is a structure contains the following (but not only):
%
% src.currentData -     cell array of the window width length contains a string
%                       of the data sent by the foot controller (each row is a new cell)
% src.Msg.mov_num -     the movement number that was detected (1-4)
% src.analyzedData -    counter that is used to make sure that after
% detectiong a movement  the next samples as determined by hold_samp) are
% not detected as movements.
%
% if a hand movement command was detected, the function returns: 
%                                   is_mov_detect = true
% if not, this function returns:    is_mov_detect = false


% Text data to mat
% hold_samp = load("..\results after grid search\14-Aug-2020\hold_samp.mat").hold_samp;
hold_samp = 40;
if (src.analyzedData == hold_samp || src.analyzedData == 0 )
    line=src.currentData{1};
    newStr = split(line);
    data = cellfun(@(x) str2double(x),newStr,'UniformOutput',false);
    data = cell2mat(data);
    first_time = data(end);
    final = zeros(length(src.currentData),length(data));
    data(end) = 0;
    final(1,:) = data;
    for i=2:length(src.currentData)
        line=src.currentData{i};
        newStr = split(line);
        data = cellfun(@(x) str2double(x),newStr,'UniformOutput',false);
        data = cell2mat(data);
        time = data(end);
        data(end) = time - first_time;
        final(i,:) = data;
    end
    % Filter then Resample current data mat
    all_data_medfilt=median_data_filt(final,5);
    resampled_data = resample_all_data(all_data_medfilt);
    Ts = resampled_data(3,end) - resampled_data(2,end);
    % Preform cross correlation 
    gyro_data = resampled_data(:,4:6);
    gyro_data(:,end+1) = resampled_data(:,end);
    [xcorr.corr,times] = xcorr_all_intresting_data(gyro_data,'normalized',"start");
    xcorr = {xcorr};
    times = {times};
    % Use algo thresholds from 14-Aug-2020
    th1 = 0.7;
    th2 = 0.7;
    th3 = 0.85;
    t2 = 100;
%     th1 = load("..\results after grid search\14-Aug-2020\thresholds.mat").th1; 
%     th2 = load("..\results after grid search\14-Aug-2020\thresholds.mat").th2; 
%     th3 = load("..\results after grid search\14-Aug-2020\thresholds.mat").th3; 
%     t2 = load("..\results after grid search\14-Aug-2020\thresholds.mat").t2;
    % Preform labeling
    [algo_labels,~] = get_algo_labels_new(...
                    xcorr,times,th1,th2,t2,th3,hold_samp*Ts);
    label_curr = algo_labels{1};
    [~, ind_class] = find(label_curr);
    if(~isempty(ind_class))
        src.Msg.mov_num  = ind_class;
        is_mov_detect = true;
        src.analyzedData = 1;
    else
        is_mov_detect = false;
        src.analyzedData = 0;
    end
else 
   is_mov_detect = false;
   src.analyzedData = src.analyzedData+1;
end
   src.isAnaliseDone = 1;
end


            



        
        
        
    









