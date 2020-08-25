function list_moves = get_meas_names_from_dir(DirPath,date,type)
% function get name list of all diffrenet measurments in the directory
% "DirPath/date" 
% INPUT: 
% 1. DirPath - path directory all measurments are saved
% 2. date - directory in DirPath where the data collected in date was saved 
% "DirPath/date" is the Directory Path where raw data is saved
% 3. type - can get the following:
%            a. "" : empty string - to get listOfFiles for raw data
%            b. "FILTERED_INIT" : to get listOfFiles of the filtered
%            measurments
% OUTPUT:
% list_moves - cell of srings 
%               contains all names of diffrenet measurments collected on date
    listOfFiles = get_list_of_files_from_dir (DirPath,date,type);
    list_moves = cell(1, length(listOfFiles));
    for i = 1: length(listOfFiles)
        list_moves{i} = get_move_name (listOfFiles{i});
    end
end
