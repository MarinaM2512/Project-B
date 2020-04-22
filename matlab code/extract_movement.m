function [move_vals , move_times] = extract_movement(segD,segT ,thresh_val)
move_vals = [];
move_times = [];
thresh_time = 500; 
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
    %     movement = [move_vals ; move_times];
    end 
end
end
        
     
            
    
    
    
        
    

    
