%% INIT Raw data
date = "17_04";
listOfFiles = get_list_of_files(date,"" ,0);
for i= 1:length(listOfFiles)
        mat_name=strcat("..\measurements\",date,"\",listOfFiles{i});
     if(~contains(mat_name,"FILTERED"))
        M=load(mat_name);
        mat=M.final;
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


%% LPF 
LPF_filter_raw_data("17_04",20);

%% Compare LPF filtered and med Filtered 
list_moves_res = get_all_meas_names("17_04","FILTERED_INIT" ,1);
list_moves_LPF = get_all_meas_names("17_04","INIT_LPF_FILTERED" ,0);
for i = 1:length(list_moves_res)
    data_mat_LPF = loadMeasurmentMat("17_04",list_moves_LPF{i},0,"INIT");
    data_mat = loadMeasurmentMat("17_04",list_moves_res{i},1,"INIT");
    t = data_mat(:,20);
    tL = data_mat_LPF(:,20);
    figure(i);
    subplot(4,3,1);
    plot(t,data_mat(:,1),tL,data_mat_LPF(:,1));
    legend("Med","LPF");
    title("accelX");
    subplot(4,3,2);
    plot(t,data_mat(:,2),tL,data_mat_LPF(:,2));
    legend("Med","LPF");
    title("accelY")
    subplot(4,3,3);
    plot(t,data_mat(:,3),tL,data_mat_LPF(:,3));
    legend("Med","LPF");
    title("accelZ");
    subplot(4,3,4);
    plot(t,data_mat(:,4),tL,data_mat_LPF(:,4));
    legend("Med","LPF");
    title("gyrox");
    subplot(4,3,5);
    plot(t,data_mat(:,5),tL,data_mat_LPF(:,5));
    legend("Med","LPF");
    title("gyroy");
    subplot(4,3,6);
    plot(t,data_mat(:,6),tL,data_mat_LPF(:,6));
    legend("Med","LPF");
    title("gyroz");
    subplot(4,3,7);
    plot(t,data_mat(:,end-5),tL,data_mat_LPF(:,end-5));
    legend("Med","LPF");
    title("fsr0");
    subplot(4,3,8);
    plot(t,data_mat(:,end-4),tL,data_mat_LPF(:,end-4));
    legend("Med","LPF");
    title("fsr1");
    subplot(4,3,9);
    plot(t,data_mat(:,end-3),tL,data_mat_LPF(:,end-3));
    legend("Med","LPF");
    title("fsr2");
    subplot(4,3,10);
    plot(t,data_mat(:,end-2),tL,data_mat_LPF(:,end-2));
    legend("Med","LPF");
    title("fsr3");
    subplot(4,3,11);
    plot(t,data_mat(:,end-1),tL,data_mat_LPF(:,end-1));
    legend("Med","LPF");
    title("fsr4");
    plt_title = strcat("17_04"," ",list_moves_res{i});
    newStr = strrep(plt_title,'_',' ');
    sgtitle(newStr(1));
end