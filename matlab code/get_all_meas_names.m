function list_moves = get_all_meas_names(date,type ,resample)
matlab_code_path = "C:\Users\Marina\Documents\Technion\Winter semester 2020\Project B\Project-B\matlab code";
curr_dir = pwd;
if(~strcmp(matlab_code_path,curr_dir))
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
