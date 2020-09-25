function data_mat = load_measurment_mat_from_dir(DirPath,date,movement_name,type)
%%Goal: get requaired measurment matrix from mat file 

%%Input Arguments:
% 1.DirPath - the relatime path to the measurments from current folder
% 1.date - the date folder containing the required measurment
% 2.movement_name - the full name of therequired movement mesurment
% (including the number of the measurment)
% 3.resampled - is the data in the resampled directory (True/False)
% 4.type - which version of the data to look for:
%   '' - raw data with no prosessing
%   'FILTERED_INIT' - filtered data
%%Return:
% data_mat: The required data matrix
    if(~strcmp(type,""))
        textFileName= strcat(DirPath,"\",date,"\","*",movement_name,"*",type,"*.mat");
    else
        textFileName= strcat(DirPath,"\",date,"\","*",movement_name,"*",type,".mat");
    end
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
    mat_name=strcat(DirPath,"\",date,"\",listOfFiles{1});
    M=load(mat_name);
    switch type
        case ''
            data_mat = M.final;
        case 'FILTERED_INIT'
            data_mat = M.initialised;
        otherwise
            disp("choose the folowing type: '', 'FILTERED_INIT'");
    end
end