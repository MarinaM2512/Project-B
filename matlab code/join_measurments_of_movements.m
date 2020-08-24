function [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name,delay,thresh_time,thresh,sum_window)
% Goal: create 3 [nXmX2] matrixes of movments detected in all measurments of
% a movment on the given date for gyroX, gyroY, gyroZ for template
% matching.
% n = length of each movment (movements are zero padded to the longest one) 
% m = number of movments detected
% the second dimention are the corresponding times.

% Input Arguments:
% 1.date: required date of measurments
% 2.movement_name: the movement to detect.
% 3.thresh: thereshold applied to Data for movment detection
% 4.thresh_time: a period of time that will filter out short noises that 
% are not long enough to be a movement 
% 5.sum_window: window length that we sum all element in it
matlab_code_path = "C:\Users\Marina\Documents\Technion\Winter semester 2020\Project B\Project-B\matlab code";
curr_dir = pwd;
if(~strcmp(matlab_code_path,curr_dir))
    DirPath = "..\..\measurements\resample";
else
    DirPath = "..\measurements\resample";
end
textFileName= strcat(DirPath,"\",date,"\","*",movement_name,"*","INIT.mat");
DirList = dir(fullfile(textFileName));
listOfFiles = {DirList.name};
Cx_tot = {};
Cy_tot = {};
Cz_tot = {};
CxT_tot = {};
CyT_tot = {};
CzT_tot = {};
    for i= 1:length(listOfFiles)
        mat_name=strcat(DirPath,"\",date,"\",listOfFiles{i});
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
            [moveX_t , timeX_t] = extract_movement(Sx{j},Tx{j},thresh,thresh_time,sum_window);
            [moveY_t , timeY_t] = extract_movement(Sy{j},Ty{j},thresh,thresh_time,sum_window);
            [moveZ_t , timeZ_t] = extract_movement(Sz{j},Tz{j},thresh,thresh_time,sum_window);
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

end

 %% helper func for creating avg mat
 function resized =  combine_to_matrix(move_cell , time_cell)
    maxLen = max(cellfun(@length,move_cell));
    res_move = cellfun(@(x) padarray(x,[(maxLen -length(x)) 0], 0,'post'),move_cell,'UniformOutput',false);
    res_time = cellfun(@(x) padarray(x,[(maxLen -length(x)) 0], x(end),'post'),time_cell,'UniformOutput',false);
    res_move = cell2mat(res_move');
    res_time = cell2mat(res_time');
    resized = cat( 3,res_move , res_time);
end