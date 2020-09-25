function frame_val_vec = devide_to_farames(vec,frame_len)
%len=length(vec);
% vec_crop=vec(1:len-mod(len,frame_len));
% new_len=length(vec_crop);
% num_frames=new_len/frame_len;
% new_vec=reshape(vec_crop,num_frames,frame_len);
dev=diff(vec);
frame_val_vec=abs(movsum(dev,frame_len));
% if(new_len<len)
%    frame_val_vec(end+1)= mean(vec(new_len:len));
% end
%frame_val_vec=abs(frame_val_vec);
end