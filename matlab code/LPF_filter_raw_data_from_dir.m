function filtered = LPF_filter_raw_data_from_dir(DirPath,date , Fpass)
% function resamples all measurments in directory and uses lowpass Matlab 
% function.
% INPUT: 
% 1. DirPath - path directory all measurments are saved
% 2. date - directory in DirPath where the data collected in date was saved 
% "DirPath/date" is the path directory raw data is saved
% 3. Fpass - pass band frequency of the LPF[Hz]
% OUTPUT:
% 1. filtered - cell array  of length as num of movements in the directory
%               each cell contains resampled and filtered data

listOfFiles = get_list_of_files_from_dir(DirPath ,date, "");
filtered = cell(length(listOfFiles));
for i= 1:length(listOfFiles)
    mat_name=strcat(DirPath,"\",date,"\",listOfFiles{i});
    if(~contains(mat_name,"FILTERED"))            % if not filtered
        M = load(mat_name);
        mat = M.final;
        resampled = resample_all_data(mat);       % resample
        t = resampled(:,20);
        Fs = 1000/(t(2)-t(1));
        filtered{i} = [lowpass(resampled(:,1:19),Fpass,Fs) t]; 
%         name=split(listOfFiles{i},".");
%         filt_mat_name=strcat(DirPath,"\",date,"\",name{1},"_LPF_FILTERED",".mat");
%         save(filt_mat_name,'filtered_mat');
    end
end
end