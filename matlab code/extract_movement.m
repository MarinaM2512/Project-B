function [move_vals , move_times] = extract_movement(segD,segT ,thresh_val,thresh_time)
%%Goal: extract movement vector inside segment

%%Input Arguments:
% 1.SegD - a single segment of data
% 2.SegT - a single segment of times corresponding to data in SegD
% 3.thresh_val - thereshold applied to Data (over a sum of 7 neighboring
% points - 3 from each side) 
% 4.thresh_time: a period of time that will filter out short noises that 
% are not long enough to be a movement 

%%Return:
% 1. move_vals: vector that represents the movement values detected in 
% segment or [] if not detected.
% 2. move_times: vector that represents the times corresponding to the
% movement values detected in segment or [] if not detected.

move_vals = [];
move_times = [];
is_move = movsum(abs(segD),7)>thresh_val;
[start, len, num] = ZeroOnesCount(is_move);
if (num > 0)
    times = segT(start+len-1)-segT(start);
    [longest_time,start_time_idx] = max(times);
    if (longest_time > thresh_time)
        start_move = start(start_time_idx);
        end_move = start_move + len(start_time_idx) -1;
        move_vals = segD(start_move:end_move);
        move_times = segT(start_move:end_move);
    end 
end
end
        
     
            
    
    
    
        
    

    
