function list_moves = get_all_meas_names(date,type ,resample)
curr_dir = pwd;
split_path = split(curr_dir,'\');
if(~strcmp("matlab code",split_path{end}))
    DirPath = "..\..\measurements\resample";
else
    DirPath = "..\measurements\resample";
end
    listOfFiles = get_list_of_files_from_dir (DirPath ,date, type);
    list_moves = cell(1, length(listOfFiles));
    for i = 1: length(listOfFiles)
        list_moves{i} = get_move_name (listOfFiles{i});
    end
end
