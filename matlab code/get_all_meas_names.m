function list_moves = get_all_meas_names(date,type ,resample)
    listOfFiles = get_list_of_files (date , type , resample);
    list_moves = cell(1, length(listOfFiles));
    for i = 1: length(listOfFiles)
        list_moves{i} = get_move_name (listOfFiles{i});
    end
end
