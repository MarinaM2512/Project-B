function LPF_filter_raw_data(date , Fpass)
listOfFiles = get_list_of_files(date,"INIT" ,0);
for i= 1:length(listOfFiles)
    mat_name=strcat("..\measurements\",date,"\",listOfFiles{i});
    if(~contains(mat_name,"FILTERED"))
        M=load(mat_name);
        mat=M.initialised;
        resampled = resample_all_data(mat);
        t = resampled(:,20);
        Fs = 1000/(t(2)-t(1));
        filtered_mat = [lowpass(resampled(:,1:19),Fpass,Fs) t];
        name=split(listOfFiles{i},".");
        filt_mat_name=strcat("..\measurements\",date,"\",name{1},"_LPF_FILTERED",".mat");
        save(filt_mat_name,'filtered_mat');
    end
end
end