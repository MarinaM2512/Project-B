function [move_vals, move_times] = extract_movement_all_meas(date,movement_names,delay,thresh_time,thresh,sum_window)
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

Cx_tot =  {};
Cy_tot =  {};
Cz_tot =  {};
CxT_tot = {};
CyT_tot = {};
CzT_tot = {};

    for i= 1:length(movement_names)
          
            mat = loadMeasurmentMat(date,movement_names(i),1,"INIT");
          
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
 end