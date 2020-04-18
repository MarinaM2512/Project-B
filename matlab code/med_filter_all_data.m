function med_filter_all_data(date,n)
textFileName= strcat("..\measurements\",date,"\","Data_extraction_","*",".mat");
DirList = dir(fullfile(textFileName));
listOfFiles = {DirList.name};
for i= 1:length(listOfFiles)
    mat_name=strcat("..\measurements\",date,"\",listOfFiles{i});
    if(~contains(mat_name,"FILTERED"))
        M=load(mat_name);
        mat=M.final;
        filtered_mat = zeros(size(mat));
        filtered_mat(:,1:end-1) = median_data_filt(mat(:,1:end-1),n);
        filtered_mat(:,end) = mat(:,end);
        name=split(listOfFiles{i},".");
        filt_mat_name=strcat("..\measurements\",date,"\",name{1},"_FILTERED",".mat");
        save(filt_mat_name,'filtered_mat');
    end
end
end
