function is_mov_detect = main_analysis(src)

% This function is the main analysis function.
% This function is activated only when the buffer is full and a new
% data-point arrived.
%
% src is a structure contains the following (but not only):
%
% src.currentData -     cell array of the window width length contains a string
%                       of the data sent by the foot controller (each row is a new cell)
% src.Msg.mov_num -     the movement number that was detected (1-4)
% src.analyzedData -    currently an empty cell array. can be used if a data
%                       need to be transfer from one iteration to another
%
% if a hand movement command was detected, the function returns: 
%                                   is_mov_detect = true
% if not, this function returns:    is_mov_detect = false


%%%%%%%%%%%%%%% analysis function example %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if contains(src.currentData{end},'100')
    
    is_mov_detect = true;
    src.Msg.mov_num = 1;
elseif contains(src.currentData{end},'200')
    is_mov_detect = true;
    src.Msg.mov_num = 2; 
else
    is_mov_detect = false;
end
%%%%%%%%%%%%%%% analysis function example  - end %%%%%%%%%%%%%%%%%%%%%%%%

end