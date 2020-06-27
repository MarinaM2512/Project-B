list_moves  = get_all_meas_names("17_04", "FILTERED_INIT", 1);
for i=1:length(list_moves)
    data_mat = loadMeasurmentMat("17_04",list_moves{i},1,"INIT"); %load one data mes
    segmented_data=data2timeSegmentsOverlapping(data_mat(:,4:6),data_mat(:,20),63,60);
    segment_start_times = cellfun(@(x) x(1,4),segmented_data,'UniformOutput',false);
    segment_start_times = cell2mat(segment_start_times);
    segment_end_times = cellfun(@(x) x(63,4),segmented_data,'UniformOutput',false);
    segment_end_times = cell2mat(segment_end_times);
    t = data_mat(:,20);
    [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements("17_04",list_moves{i},10000,500,10,6);
    if(contains(list_moves{i},"tap"))
        [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements("17_04",list_moves{i},10000,500,5,7);
    
    elseif(contains(list_moves{i},"stand_N_swipeL"))
        [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements("17_04",list_moves{i},10000,500,10,4);
    end
    num_move = size(to_avgX,2);
    len_move = max([size(to_avgX,1),size(to_avgY,1),size(to_avgZ,1)]);
    time = zeros(len_move,num_move);
    for k = 1:num_move
        [~,T] = pad_data_to_same_size(to_avgX(:,k,1),to_avgY(:,k,1),...
            to_avgZ(:,k,1),to_avgX(:,k,2),to_avgY(:,k,2),to_avgZ(:,k,2),0.3,1);
        time(:,k) = T(:,1);
    end
    times = time(:);
    window = ismember(t,times);
%     segment_marking = zeros(length(t),1);
%     for j = 1:length(segmented_data)
% %         segment_marking(((t>=segment_start_times(j)) & (t<=segment_end_times(j-1))))= j/2;
% %         segment_marking(((t>=segment_end_times(j-1)) & (t<=segment_start_times(j+1))))= j;
%         segment_marking(t==segment_start_times(j)) = j;
%         segment_marking(t==segment_end_times(j)) = j;
%     end
    figure;
    subplot(3,1,1);
    plot(t,data_mat(:,4));
    hold on;
    plot(t,window*max(data_mat(:,4)));
    title("X");
    subplot(3,1,2);
    plot(t,data_mat(:,5));
    hold on;
    plot(t,window*max(data_mat(:,5)));
    title("Y");
    subplot(3,1,3);
    plot(t,data_mat(:,6));
    hold on;
    plot(t,window*max(data_mat(:,6)));
    title("Z");
    newStr = strrep(list_moves{i},'_',' ');
    sgtitle(newStr);
end
        
    