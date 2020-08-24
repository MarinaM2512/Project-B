function data_mat = loadMeasurmentMat(date,movement_name,resampled,type)
%%Goal: get requaired measurment matrix from mat file 

%%Input Arguments:
% 1.date - the dae folder containing the required measurment
% 2.movement_name - the full name of therequired movement mesurment
% (including the number of the measurment)
% 3.resampled - is the data in the resampled directory (True/False)
% 4.type - which version of the data to look for:
%   '' - raw data with no prosessing
%   'FILTERED' - filtered data
%   'INIT' - after filetring quaternions 
%%Return:
% data_mat: The required data matrix
    if(resampled)
        dir_path ="..\measurements\resample\";
    else
        dir_path ="..\measurements\";
    end
    textFileName= strcat(dir_path,date,"\","*",movement_name,"*",type,".mat");
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
    mat_name=strcat(dir_path,date,"\",listOfFiles{1});
    M=load(mat_name);
    switch type
        case ''
            data_mat = M.final;
        case 'FILTERED'
            data_mat = M.filtered_mat;
        case 'INIT'
            data_mat = M.initialised;
        otherwise
            disp("choose the folowing type: '', 'FILTERED', 'INIT'");
    end
end