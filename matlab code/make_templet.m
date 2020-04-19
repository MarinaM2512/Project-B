%templet - vec
%movments - matrix dims: movment_length X num_of_movments
%           data of the move is in cols
%           each meas is in rows
%note to marina: function to pad with zeros :padarray
function templet = make_templet(movments)
% avreging
movment_length=size(movments,1);
left_border = floor(movment_length)/3;
right_border = movment_length-left_border;
aligned_movments = align_peaks(movments,left_border,right_border);
templet = mean(aligned_movments,2); % mean along rows

end

function aligned_movments = align_peaks(movments,left_border,right_border)
[~,locs1] = findpeaks(movments(:,1),'SortStr','descend','NPeaks',1);
num_of_movments=size(movments,2);
aligned_movments = cell(num_of_movments,1);
aligned_movments(:,1) = movments(:,1);
% find index within borders
for i=2:num_of_movments
    [~,locs] = findpeaks(movments(:,i),'SortStr','descend','NPeaks',1);
    if locs1<=left_border %locs1 is out of borders
        locs1=max(locs1,locs);
    elseif locs1>=right_border
        locs1=min(locs1,locs);
    else
        break
    end
end
%align
for i=1:num_of_movments
    [~,locs] = findpeaks(movments(:,i),'SortStr','descend','NPeaks',1);  
    z=zeros(length(movments(:,i),1));
    shift=locs1-locs;
    if shift<=0
        z(shift+1:end) = movments(1:end-shift,i);
    else
        z(1:end-shift) = movments(shift+1:end,i);
    end
    aligned_movments(i)=z;
end
end
