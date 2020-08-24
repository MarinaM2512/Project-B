function list_moves = get_meas_names_from_dir(DirPath,date,type )
    listOfFiles = get_list_of_files_from_dir (DirPath,date,type);
    list_moves = cell(1, length(listOfFiles));
    for i = 1: length(listOfFiles)
        list_moves{i} = get_move_name (listOfFiles{i});
    end
end
