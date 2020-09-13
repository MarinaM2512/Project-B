function [move_mat ,times ,rel_times]  = detect_movement(movement_cell)
%%Goal: recieve x,y,z of detected movements and extract the movements so that  
%X, Y, Z axis are the same length and at the same times.
%%Inputs: movement_cell - a cell array containing 3 cells each corresponds
%with axis of gyro (x,y,z) each with shape = N x number of moves x 2
% where N is the length of the movement ,number of moves is the number of
% movements detected in the current measurment matrix , and in the 3
% dimention - (:,:,1) the gyro values and (:,:,2) - times.
%%outputs: 
% 1. move_mat - a Mx3 matrix with movements detedted where X, Y,Z are
% the same size.
% 2.times - the times of the extracted movements
% 3. rel_times - relative times.
    gyroX = movement_cell{1};
    gyroY = movement_cell{2};
    gyroZ = movement_cell{3}; 
    num_meas = min([size(gyroY,2),size(gyroX,2),size(gyroZ,2)]);
    cols = 1: num_meas;
    ColNumsX = repmat(cols,size(gyroX,1),1);
    ColNumsY = repmat(cols,size(gyroY,1),1);
    ColNumsZ = repmat(cols,size(gyroZ,1),1);
    gyroX_N = cat(3,gyroX(:,1:num_meas,1),gyroX(:,1:num_meas,2),ColNumsX);
    gyroY_N = cat(3,gyroY(:,1:num_meas,1),gyroY(:,1:num_meas,2),ColNumsY);
    gyroZ_N = cat(3,gyroZ(:,1:num_meas,1),gyroZ(:,1:num_meas,2),ColNumsZ);
    movements = [{gyroX_N} {gyroY_N} {gyroZ_N}] ;  
    col_stacked = cellfun(@(x) reshape(x,size(x(:,:,1),1)*size(x(:,:,1),2),3),movements,'UniformOutput',false);
    % remove points that are zero
    reduce_redundant_points = cellfun(@(x) x(find(x(:,1)),:),col_stacked,'UniformOutput',false);
    [~,idx] = min(cellfun(@(x) length(x(:,2)),reduce_redundant_points)); %choose the axis with least points
    idx_other = find(1:3 ~=idx);
    other = {reduce_redundant_points{1, idx_other}};
     A = reduce_redundant_points{1, 1:3 == idx};
     A = A(:,2); %the shortest movement vector
     B1 = other{1,1};
     B2 = other{1,2};
     TMP1 = bsxfun(@(x,y) abs(x-y), A(:), reshape(B1(:,2),1,[]));
     TMP2 = bsxfun(@(x,y) abs(x-y), A(:), reshape(B2(:,2),1,[]));
     % TMP1 & TMP2 contain the time diffference between the each element from A
     % and B1\B2
     [D1, idxB1] = min(TMP1,[],2);
     [D2, idxB2] = min(TMP2,[],2);
     % coose the elemts from B1 and B2 with the closest times to the elements in A
     B1 = B1(idxB1,:);
     B2 = B2(idxB2,:);
     reduce_redundant_points(1,idx_other(1)) ={B1};
     reduce_redundant_points(1,idx_other(2)) ={B2};
     meas = cellfun(@(x) x(:,1) , reduce_redundant_points ,'UniformOutput',false);
     % meas is a cell array containing X, Y,Z gyro movements in the same
     % times.
     times = zeros(size(meas{1,1},1),1);
     rel_times = zeros(size(meas{1,1},1),1);
     times_col = reduce_redundant_points{1,1};
     times_col = times_col(:,2:3);
     curr_idx = 1;
     for i = 1:size(gyroX,2)
         tmp = times_col(find(times_col(:,2)==i));
         times(curr_idx:curr_idx+length(tmp)-1) = tmp;
         rel_times(curr_idx:curr_idx+length(tmp)-1) = relative_times(tmp);
         curr_idx =curr_idx+length(tmp);
     end
     move_mat = cat(2,meas{1,1},meas{1,2},meas{1,3});
end

function new_times = relative_times(orig_times)
    new_times =zeros(length(orig_times),1);
    for i = 1:length(orig_times)
        new_times(i) = orig_times(i)-orig_times(1);
    end
end