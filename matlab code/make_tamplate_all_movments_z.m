function [data_template_z, time_template_z]= ...
               make_tamplate_all_movments_z (...
                dates,names,delay,thresh_time,thresh,sum_window,border_factor)
% function returns avgraged template of gyro z for all measurments of
% the same movement. 
% using join_measurments_of_movements to collects all the mes
% at last, using make_template
% Input Arguments:
% 1. dates - string array includes dates of  the measurment
% 2. movement_names - string array includes the movement to detect. 
%                    for example: sit_N_swipe_R1/stand_E_tap2
% 3. thresh - thereshold applied to Data for movment detection
% 4. thresh_time - a period of time that will filter out short noises that 
% are not long enough to be a movement 
% 5. sum_window - 
% 6. border_factor - to select relative peak 
% Output Arguments:
% 1. data_template_z - data template vector for all mes of the selected movement
% 2. time_template_z - matching time vector
        
d_max = length(dates);
n_max = length(names);
cell_avgZ =cell(1,d_max*n_max);
i = 1;
for d = 1:d_max
    for n = 1:n_max
        [ ~ , ~ ,cell_avgZ{1,i}] = ...
                    join_measurments_of_movements(...
                    dates(d),names(n),delay,thresh_time,thresh,sum_window);
        i = i+1;                   
    end
end
to_avgZ = combine_to_matrix(cell_avgZ);
    [data_template_z , time_template_z] = make_template(to_avgZ,border_factor);
end

%% helper func for creating mat in same size
 function resized =  combine_to_matrix(a)
 % func pads all the mes to be at the same length
 move_cell = cellfun(@(x) x(:,:,1),a,'UniformOutput',false);
 time_cell = cellfun(@(x) x(:,:,2),a,'UniformOutput',false);
 res_time = cell(size(time_cell));

 maxLen = max(cellfun(@length,move_cell));
 
 res_move = cellfun(@(x) padarray(x,[(maxLen -length(x)) 0], 0,'post'),move_cell,'UniformOutput',false);
 for i=1:length(time_cell)
     
     A = cell2mat(time_cell(i));
     B = repmat(A(end,:),maxLen-size(A,1),1);
     res_time{1,i} = [A;B];
 end
 
 res_move = cell2mat(res_move);
 res_time = cell2mat(res_time);
 
 resized = cat( 3,res_move , res_time);
 end