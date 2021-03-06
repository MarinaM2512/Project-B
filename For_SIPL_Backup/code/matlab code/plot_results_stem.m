function plot_results_stem(algo_labels,date,order)
% function plots raw data and stem of algo_labels in same figure
% total of 4 figures one for each movement
% INPUT: the optimal results we got from grid_search

list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);
curr_dir = pwd;
split_path = split(curr_dir,'\');
if(~strcmp("matlab code",split_path{end}))
    DirPath = "..\..\measurements\resample";
else
    DirPath = "..\measurements\resample";
end
for i = 1:length(list_moves)
    move_name = list_moves{i};
    data_mat = load_measurment_mat_from_dir(DirPath,date,move_name,"FILTERED_INIT");
    time = data_mat(:,20);
    curr_algo_labels =  algo_labels{i};
    if(contains(move_name,"tap"))
        gyro_data = data_mat(:,4);
    elseif(contains(move_name,"ancle"))
        gyro_data = data_mat(:,5);
    else
        gyro_data = data_mat(:,6);
    end
    figure;
    stem(time,curr_algo_labels(:,1)*max(gyro_data),'o');
    hold on;
    stem(time,curr_algo_labels(:,2)*max(gyro_data),'o');
    hold on;
    stem(time,curr_algo_labels(:,3)*max(gyro_data),'o');
    hold on;
    stem(time,curr_algo_labels(:,4)*max(gyro_data),'o');
    if(contains(move_name,"all"))
            plot(time,data_mat(:,4));
            hold on;
            plot(time,data_mat(:,5));
            hold on;
            plot(time,data_mat(:,6));
            legend("detected swipe left" , "detected swipe right",...
        "detected tap", "detected side ankle","raw data","raw data","raw data");
    else
        plot(time,gyro_data);
        legend("detected swipe left" , "detected swipe right",...
        "detected tap", "detected side ankle","raw data");
    end
    
    newStr = strrep(move_name,'_',' ');
    title(["raw data of " ,newStr , "and all detected movements"]);
end
end