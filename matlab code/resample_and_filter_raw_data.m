function resample_and_filter_raw_data(DirPath, date,n,type)
    listOfFiles = get_meas_names_from_dir(DirPath,date,"");
    mat_full_names = get_list_of_files_from_dir (DirPath,date,"");
    all_data_filetered = LPF_filter_raw_data_from_dir(DirPath,date , n);
    for i = 1:length(listOfFiles)
        if(~contains(mat_full_names{i},"FILTERED"))
            switch type
                case "LPF"
                    data_filetered = all_data_filetered{i};
                case "MEDIAN"
                    data_mat = load_measurment_mat_from_dir(DirPath,date,listOfFiles{i},"");
                    data_filetered=median_data_filt(data_mat,n);
            end            
            filtered_mat = resample_all_data(data_filetered);
            name=split(mat_full_names{i},".");
            mat_full_name = name{1};
            mat_name=strcat(DirPath,"\",date,"\",mat_full_name,"_FILTERED",".mat");
            save(mat_name,'filtered_mat'); 
        end
    end
end