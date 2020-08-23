function resample_and_filter_raw_data(DirPath, date,n)
    listOfFiles = get_meas_names_from_dir(DirPath,date,"");
    mat_full_names = get_list_of_files_from_dir (DirPath,date,"");
    for i = 1:length(listOfFiles)
        if(~contains(mat_full_names{i},"FILTERED"))
            data_mat = load_measurment_mat_from_dir(DirPath,date,listOfFiles{i},"");
            data_medfilt=median_data_filt(data_mat,n); 
            initialised = resample_all_data(data_medfilt);
            name=split(mat_full_names{i},".");
            mat_full_name = name{1};
            mat_name=strcat(DirPath,"\",date,"\",mat_full_name,"_FILTERED",".mat");
            save(mat_name,'initialised'); 
        end
    end
end