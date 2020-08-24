function filtered = LPF_filter_raw_data_from_dir(DirPath,date , Fpass)
listOfFiles = get_list_of_files_from_dir(DirPath ,date, "");
filtered = cell(length(listOfFiles));
for i= 1:length(listOfFiles)
    mat_name=strcat(DirPath,"\",date,"\",listOfFiles{i});
    if(~contains(mat_name,"FILTERED"))
        M=load(mat_name);
        mat=M.final;
        resampled = resample_all_data(mat);
        t = resampled(:,20);
        Fs = 1000/(t(2)-t(1));
        filtered{i} = [lowpass(resampled(:,1:19),Fpass,Fs) t]; 
%         name=split(listOfFiles{i},".");
%         filt_mat_name=strcat(DirPath,"\",date,"\",name{1},"_LPF_FILTERED",".mat");
%         save(filt_mat_name,'filtered_mat');
    end
end
end