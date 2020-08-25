function move_name = get_move_name (fullFileName)
%function erases strings in the measurments' file names
    match = ["Data_extraction_","_FILTERED_","_INIT.mat","_FILTERED.mat", "_LPF_FILTERED.mat","_INIT_",".mat","INIT","_LPF", "LPF"];
    move_name = erase(fullFileName,match);
end
