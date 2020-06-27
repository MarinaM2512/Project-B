list_moves  = get_all_meas_names("17_04", "FILTERED_INIT", 1);
for i=1:length(list_moves)
    data_mat = loadMeasurmentMat("17_04",list_moves{i},1,"INIT"); %load one data mes
    segmented_data=data2timeSegmentsOverlapping(data_mat(:,4:6),data_mat(:,20),63,60);
    segment_start_times = cellfun(@(x) x(1,4),segmented_data,'UniformOutput',false);
    segment_start_times = cell2mat(segment_start_times);
    segment_end_times = cellfun(@(x) x(63,4),segmented_data,'UniformOutput',false);
    segment_end_times = cell2mat(segment_end_times);
    t = data_mat(:,20);
    segment_marking = zeros(length(t),1);
    for j = 1:length(segmented_data)
        segment_marking(((t>=segment_start_times(j)) & (t<=segment_end_times(j))))= j/2;
    end
    figure;
    subplot(3,1,1);
    plot(t,data_mat(:,4));
    hold on;
    plot(t,segment_marking);
    title("X");
    subplot(3,1,2);
    plot(t,data_mat(:,5));
    hold on;
    plot(t,segment_marking);
    title("Y");
    subplot(3,1,3);
    plot(t,data_mat(:,6));
    hold on;
    plot(t,segment_marking);
    title("Z");
    newStr = strrep(list_moves{i},'_',' ');
    sgtitle(newStr);
end
        
    