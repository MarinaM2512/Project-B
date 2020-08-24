function move_times = get_movment_times(endOrStart,moves_names,date)
%returns start or end time for each movement
% endOrStart - specifies which time to return - 'start' \ 'end'
% moves_names - a cell array containing the names of the moves to get 
% times
thresholds = zeros(3,length(moves_names));
move_times = cell(length(moves_names),1);
delay = 10000;
for i=1:length(moves_names)
    if(contains(moves_names{i},"tap"))
        thresholds(1:3,i) = [500,12,10];
        if(contains(moves_names{i},"stand"))
            thresholds(1:3,i) = [500,18,9]; 
        end
    elseif(contains(moves_names{i},"stand"))
        thresholds(1:3,i) = [500,15,7];
        if(contains(moves_names{i},"side"))
            thresholds(1:3,i) = [500,10,7]; 
        end
    elseif(contains(moves_names{i},"all"))
        thresholds(1:3,i) = [300,7,12];
        delay = 5000;
    elseif(contains(moves_names{i},"walking"))
        thresholds(1:3,i) = [10000,50,50];
    else
        thresholds(1:3,i) = [350,10,8];
    end
    [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,moves_names{i},delay,thresholds(1,i),thresholds(2,i),thresholds(3,i));
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
    end_times = cat(1,to_avgX(end,:,2),to_avgY(end,:,2),to_avgZ(end,:,2));
    start_times = cat(1,to_avgX(1,:,2),to_avgY(1,:,2),to_avgZ(1,:,2));
    if(endOrStart == "start")
        move_times{i} = min(start_times);
    else
        move_times{i} = median(end_times);
    end
end
end
