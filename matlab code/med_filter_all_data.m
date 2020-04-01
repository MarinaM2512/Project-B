function med_filter_all_data(date,n)
num_meas=10;
for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    for k=1:num_meas
        mat_name=strcat("..\measurements\",date,"\","Data_extraction_",name,num2str(k),".mat");
        if exist(mat_name, 'file')
            M=load(mat_name);
            mat=M.final;
            filtered_mat=median_data_filt(mat,n);
            filt_mat_name=strcat("..\measurements\",date,"\","Data_extraction_",name,num2str(k),"_FILTERED",".mat");
            save(filt_mat_name,'filtered_mat');
        end
    end
end
end