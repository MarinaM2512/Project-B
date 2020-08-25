function init_qaut_resampled_data(dirPath,date)
% 1. get data from "dirPath\date" directory (inputs)
% 2. find q_init and normlize all quates.
% 3. save with "INIT" suffics in the same directory
    textFileName= strcat(dirPath,"\",date,"\","*","FILTERED.mat");
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
    for i= 1:length(listOfFiles)
        mat_name=strcat(dirPath,"\",date,"\",listOfFiles{i});
        M=load(mat_name);
        mat=M.filtered_mat;
        delay=200;
        [S_qw,~]= data2timeSegments(mat(:,7),  mat(:,20), delay);
        [S_qx,~]= data2timeSegments(mat(:,8),  mat(:,20), delay);
        [S_qy,~]= data2timeSegments(mat(:,9),  mat(:,20), delay);
        [S_qz,~]= data2timeSegments(mat(:,10), mat(:,20), delay);
        q_norm1=normalize_quat(S_qw,S_qx,S_qy,S_qz);
        q_norm=cell2mat(q_norm1);
        initialised = mat;
        initialised(:,7:10) = q_norm(2:end,:);
        mat_name = split(mat_name,'.mat');
        mat_name=strcat(mat_name(1),"_INIT",".mat");
        save(mat_name,'initialised'); 
    end
end