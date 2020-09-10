function real_labels = get_all_real_labels(endOrStart,date,order)
% Function returns a cell array containing lables for each measurment,
% indicationg the - real start or end time of the movements inside the
% mesurment vector.
%%% Input: endOrStart -specifies which times to return - 'start' \ 'end'
%%%        date - the date folder of the wanted measurments
%%%        order - cell array that for each measurment is eather empty or 
%%%        if the measurment contains more than one kind of
%%%        movement specify the order of movements. oreder will contain:
%%%        1 - swipe left, 2 - swipe right, 3- tap, 4- side ankle
%%% Output: movement_labels - a cell array in whice each cell corresponds
%%% to a measurment vector and contains a matrix of shape - Nx4 , where N
%%% is the length of the mesurment and 4 dimention correspond to the type
%%% of the measurment - 'swipeL' , 'swipeR','tap' or 'ancle'.
list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);
move_times = get_movment_times(endOrStart,list_moves,date);
real_labels = cell(length(list_moves),1);
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
    times = data_mat(:,20);
    curr_labels = zeros(length(times),4);
    orig_times = move_times{i};
    orig_times = ismember(times,orig_times);
    curr_order = order{i};
    if(contains(list_moves{i},"swipe_L"))
        curr_labels(:,1) = orig_times;
    elseif(contains(list_moves{i},"swipe_R"))
        curr_labels(:,2) = orig_times;
    elseif(contains(list_moves{i},"tap"))
        curr_labels(:,3) = orig_times;
    elseif(contains(list_moves{i},"ancle"))
        curr_labels(:,4) = orig_times;
    elseif(contains(list_moves{i},"all") && ~isempty(curr_order))
        ind_moves = find(orig_times);
        for j=1:length(ind_moves)
            curr_labels(ind_moves(j),curr_order(j))= 1;
        end          
    end
    real_labels{i} = curr_labels; 
end

end
