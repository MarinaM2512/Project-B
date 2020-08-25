function resample_and_filter_raw_data(DirPath, date,n,type)
% function get Directory Path where raw data is saved
% INPUT: 
% 1. DirPath - path directory all measurments are saved
% 2. date - directory in DirPath where the data collected in date was saved 
% "DirPath/date" is the Directory Path where raw data is saved
% 3. n - order of the one-dimensional median filter. The center of the med
%        filt is in floor(0.5n)+1 ( see n in help for Matlab func medfilt1)
%        this param is used only when type is "MEDIAN"
% 4. type - type of filter used on data
%           can be one of the following:
%           a. "LPF" - uses function "LPF_filter_raw_data_from_dir"
%                      this func uses lowpass function of matlab.
%           b. "MEDIAN" - uses function "median_data_filt"
%                      this func uses midfilt1 function of matlab.
    listOfFiles = get_meas_names_from_dir(DirPath,date,"");
    mat_full_names = get_list_of_files_from_dir (DirPath,date,"");
    all_data_filetered = LPF_filter_raw_data_from_dir(DirPath,date , n);
    for i = 1:length(listOfFiles)
        if(~contains(mat_full_names{i},"FILTERED"))
            switch type
                case "LPF"
                    filtered_mat = all_data_filetered{i};
                case "MEDIAN"
                    data_mat = load_measurment_mat_from_dir(DirPath,date,listOfFiles{i},"");
                    data_filetered=median_data_filt(data_mat,n);
                    filtered_mat = resample_all_data(data_filetered);
            end            
            name=split(mat_full_names{i},".");
            mat_full_name = name{1};
            mat_name=strcat(DirPath,"\",date,"\",mat_full_name,"_FILTERED",".mat");
            save(mat_name,'filtered_mat'); 
        end
    end
end