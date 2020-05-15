function move_name = get_move_name (fullFileName)
    match = ["Data_extraction_","_FILTERED_","_INIT.mat","_FILTERED_.mat", "_LPF_FILTERED.mat","_INIT_",".mat","INIT"];
    move_name = erase(fullFileName,match);
end
