function [move_vals , move_times] = extract_movement_from_corr(xcorr,times,thresh_val,thresh_time)
%%Goal: find all sequences above thresh val for longer than thresh time

%%Input Arguments:
% 1.xcorr - data vector of cross corr single channel
% 2.times - times corresponding to xcorr
% 3.thresh_val - thereshold applied to Data 
% 4.thresh_time: a period of time that will filter out short noises that 
% are not long enough to be a movement 

%%Return:
% 1. move_vals: vector that represents the movement values detected in 
% xcorr or [] if not detected.
% 2. move_times: vector that represents the times corresponding to the
% movement values detected in segT or [] if not detected.

move_vals = [];
move_times = [];
is_move = xcorr>thresh_val;
[start, len, num] = ZeroOnesCount(is_move);

if (num > 0)
    move_duration = times(start+len-1)-times(start);
    idx_seq = find(move_duration>thresh_time);
    start_move = start(idx_seq);
    end_move = start_move + len(idx_seq) -1;
    for i=1:length(idx_seq)
        move_vals{i} = xcorr(start_move(i):end_move(i));
        move_times{i} = times(start_move(i):end_move(i));
    end
end
end
        
     
            
    
    
    
        
    

    
