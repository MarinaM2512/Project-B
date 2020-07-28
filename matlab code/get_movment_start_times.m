function move_start_times = get_movment_start_times
list_moves  = get_all_meas_names("17_04", "FILTERED_INIT", 1);
lengths = zeros(length(list_moves)-1,2);
thresholds = zeros(3,length(list_moves)-1);
move_start_times = cell(length(list_moves)-1,1);
for i=1:length(list_moves)-1
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
    start_times = cat(1,to_avgX(1,:,2),to_avgY(1,:,2),to_avgZ(1,:,2));
    move_start_times{i} = min(start_times);
end
