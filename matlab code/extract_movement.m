function movement = extract_movement(seg_D,segT)
%%% movemts have to be the same length add padding!!

thresh = 2;
sequence_len = 0;
for i = 1: length(seg_D)
    cur_seg = abs(seg_D{i});
    is_move = movsum(cur_seg,5)>thresh;
    [start, len, k1] = ZeroOnesCount(move_idx)
    ~,idx_move =max(len);
        
     
            
    
    
    
        
    

    
