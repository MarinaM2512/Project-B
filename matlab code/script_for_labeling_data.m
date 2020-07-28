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
%% Get movments times
clear all;
close all;
clc;
list_moves  = get_all_meas_names("17_04", "FILTERED_INIT", 1);
lengths = zeros(length(list_moves)-1,2);
thresholds = zeros(3,length(list_moves)-1);
move_start_times = cell(length(list_moves)-1,1);
delay_start = zeros(length(list_moves)-1,1);
for i=1:length(list_moves)-1
    data_mat = loadMeasurmentMat("17_04",list_moves{i},1,"INIT"); %load one data mes
    if(contains(list_moves{i},"tap"))
        thresholds(1:3,i) = [500,12,10];
        if(contains(list_moves{i},"stand"))
            thresholds(1:3,i) = [500,18,9]; 
        end
    elseif(contains(list_moves{i},"stand"))
        thresholds(1:3,i) = [500,15,7];
        if(contains(list_moves{i},"side"))
            thresholds(1:3,i) = [500,10,7]; 
        end
    else
        thresholds(1:3,i) = [500,10,7];
    end
    plot_raw_data_with_move_extraction(list_moves{i},"17_04","gyro",thresholds(:,i));
    [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements("17_04",list_moves{i},10000,thresholds(1,i),thresholds(2,i),thresholds(3,i));
    sizes = [size(to_avgX,2),size(to_avgY,2),size(to_avgZ,2)];
    [num_moves,~] = max(sizes);
    ind_max = find(sizes == num_moves);
    gyros = {to_avgX,to_avgY,to_avgZ};
    for j=1:num_moves
        if (j> min([size(to_avgX,2),size(to_avgY,2),size(to_avgZ,2)]) || ...
              ((size(gyros{1},2)==size(gyros{2},2)) && (size(gyros{3},2) ==size(gyros{2},2))))
            break;
        end
        tx = to_avgX(:,j,2);
        ty = to_avgY(:,j,2);
        tz = to_avgZ(:,j,2);
        xy = intersect(tx,ty);
        xz = intersect(tx,tz);
        yz = intersect(ty,tz);
        if (isempty(xy) || isempty(xz) || isempty(yz))
            if (size(ind_max,2)>1)
                [mat_del1,mat_del2]=gyros{ind_max};
                mat_del1(:,j,:) = [];
                mat_del2(:,j,:) = [];
                gyros{ind_max(1)} = mat_del1;
                gyros{ind_max(2)} = mat_del2;
            else
                mat_del = gyros{ind_max};
                mat_del(:,j,:) = [];
                gyros{ind_max} = mat_del;
            end
            sizes = [size(gyros{1},2),size(gyros{2},2),size(gyros{3},2)];
            [num_moves,~] = max(sizes);
            ind_max = find(sizes == num_moves);
        end
    end
    [to_avgX,to_avgY,to_avgZ] = gyros{1:3};
    len_move = max([size(to_avgX,1),size(to_avgY,1),size(to_avgZ,1)]);
    lengths(i,:) = [len_move,i];
    delay_start(i) = max([abs(to_avgX(1,:,2)-to_avgY(1,:,2)),abs(to_avgY(1,:,2)-to_avgZ(1,:,2)),...
        abs(to_avgX(1,:,2)-to_avgZ(1,:,2))]);
    start_times = cat(1,to_avgX(1,:,2),to_avgY(1,:,2),to_avgZ(1,:,2));
    move_start_times{i} = min(start_times);
end


        
    