%% read data from dates 11_04 17_04
%read_data_to_mat("11_04")
med_filter_all_data("11_04",5)
%read_data_to_mat("17_04")
med_filter_all_data("17_04",5)
%% Normalise all data and plot 
for date = ["11_04" "17_04"]
    textFileName= strcat("..\measurements\",date,"\","*","FILTERED.mat");
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
    for i= 1:length(listOfFiles)
        mat_name=strcat("..\measurements\",date,"\",listOfFiles{i});
        M=load(mat_name);
        mat=M.filtered_mat;
        delay=200;
        [S_qw,T_qw]= data2timeSegments(mat(:,7),  mat(:,20), delay);
        [S_qx,T_qx]= data2timeSegments(mat(:,8),  mat(:,20), delay);
        [S_qy,T_qy]= data2timeSegments(mat(:,9),  mat(:,20), delay);
        [S_qz,T_qz]= data2timeSegments(mat(:,10), mat(:,20), delay);
        q_norm1=normalize_quat(S_qw,S_qx,S_qy,S_qz);
        q_norm=cell2mat(q_norm1);
        t=mat(:,20);
        initialised = mat;
        initialised(:,7:10) = q_norm(2:end,:);
        figure();
        subplot(2,2,1);
        plot(t,q_norm(1:end-1,1));
        title('w');
        subplot(2,2,2);
        plot(t,q_norm(1:end-1,2));
        title('x');
        subplot(2,2,3);
        plot(t,q_norm(1:end-1,3));
        title('y');
        subplot(2,2,4);
        plot(t,q_norm(1:end-1,4));
        title('z');
        plt_title = strcat(date," ",listOfFiles{i});
        newStr = strrep(plt_title,'_',' ');
        newStr = split(newStr,'.');
        sgtitle(newStr(1));
        mat_name = split(mat_name,'.mat');
        mat_name=strcat(mat_name(1),"_INIT",".mat");
        save(mat_name,'initialised'); 
    end
end
%% join measurments of movements
date = "17_04";
delay = 10000;
movement_name = "sit_N_swipe_L1";
textFileName= strcat("..\measurements\",date,"\","*",movement_name,"*","INIT.mat");
DirList = dir(fullfile(textFileName));
listOfFiles = {DirList.name};
thresh  =10;
Cx_tot = {};
Cy_tot = {};
Cz_tot = {};
CxT_tot = {};
CyT_tot = {};
CzT_tot = {};
for i= 1:length(listOfFiles)
%     if( strfind(listOfFiles{i}, "swipe"))
%         thresh_x = 10
%         thresh_x = 10
%         thresh_z =
    mat_name=strcat("..\measurements\",date,"\",listOfFiles{i});
    M=load(mat_name);
    mat=M.initialised;
    [Sx , Tx] = data2timeSegments(mat(:,4),mat(:,20),delay);
    [Sy , Ty] = data2timeSegments(mat(:,5),mat(:,20),delay);
    [Sz , Tz] = data2timeSegments(mat(:,6),mat(:,20),delay);
    CxD = cell(length(Sx),1);
    CyD = cell(length(Sy),1);
    CzD = cell(length(Sz),1);
    CxT = cell(length(Sx),1);
    CyT = cell(length(Sx),1);
    CzT = cell(length(Sx),1);
    for j = 1:length(Sx)
        [moveX_t , timeX_t] = extract_movement(Sx{j},Tx{j},thresh);
        [moveY_t , timeY_t] = extract_movement(Sy{j},Ty{j},thresh);
        [moveZ_t , timeZ_t] = extract_movement(Sz{j},Tz{j},thresh);
        if (~isempty(moveX_t))
            CxD{j,1} = moveX_t;
            CxT{j,1} = timeX_t;
        end
        if (~isempty(moveY_t))
            CyD{j,1} = moveY_t;
            CyT{j,1} = timeY_t;
        end
        if (~isempty(moveZ_t))
            CzD{j,1} = moveZ_t;
            CzT{j,1} = timeZ_t;
        end
    end
    if (i == 1)
        Cx_tot = CxD(~cellfun('isempty',CxD));
        Cy_tot = CyD(~cellfun('isempty',CyD));
        Cz_tot = CzD(~cellfun('isempty',CzD));
        CxT_tot = CxT(~cellfun('isempty',CxT));
        CyT_tot = CyT(~cellfun('isempty',CyT));
        CzT_tot = CzT(~cellfun('isempty',CzT));
    else
        Cx_tot = cat(1,Cx_tot,CxD(~cellfun('isempty',CxD)));
        Cy_tot = cat(1,Cy_tot,CyD(~cellfun('isempty',CyD)));
        Cz_tot = cat(1,Cz_tot,CzD(~cellfun('isempty',CzD)));
        CxT_tot = cat(1,CxT_tot,CxT(~cellfun('isempty',CxT)));
        CyT_tot = cat(1,CyT_tot,CyT(~cellfun('isempty',CyT)));
        CzT_tot = cat(1,CzT_tot,CzT(~cellfun('isempty',CzT)));
    end
end
    to_avgX = combine_to_matrix(Cx_tot , CxT_tot);
    to_avgY = combine_to_matrix(Cy_tot , CyT_tot);
    to_avgZ= combine_to_matrix(Cz_tot , CzT_tot);
 


%% check movement finding
t = mat(:,20);
% moveX = zeros(size(t));
% moveY = moveX;
% moveZ = moveX;
moveX_t = to_avgX(:,:,2);
moveX = ismember(t,moveX_t)*200;
moveY_t = to_avgY(:,:,2);
moveY = ismember(t,moveY_t)*200;
moveZ_t = to_avgZ(:,:,2);
moveZ = ismember(t,moveZ_t)*200;
figure();
subplot(3,1,1)
plot(t,mat(:,4));
hold on;
plot(t,moveX);
title('x');
subplot(3,1,2)
plot(t,mat(:,5));
hold on;
plot(t,moveY);
title('y');
subplot(3,1,3)
plot(t,mat(:,6));
hold on;
plot(t,moveZ);
title('z');



 %% helper func for creating avg mat
 function resized =  combine_to_matrix(move_cell , time_cell)
    maxLen = max(cellfun(@length,move_cell));
%     toResize1 = move_cell{1:idx};
%     toResize2 =move_cell{idx+1 : end};
    res_move = cellfun(@(x) padarray(x,[(maxLen -length(x)) 0], 0,'post'),move_cell,'UniformOutput',false);
    res_time = cellfun(@(x) padarray(x,[(maxLen -length(x)) 0], x(end),'post'),time_cell,'UniformOutput',false);
    res_move = cell2mat(res_move');
    res_time = cell2mat(res_time');
    resized = cat( 3,res_move , res_time);
end

