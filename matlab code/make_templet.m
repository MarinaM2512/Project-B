%templet - vec
%movments - matrix dims: 2 X movment_length (or duration_time) X num_of_movments
%           movments(1,:,:)-data of move in cols
%           movments(2,:,:)-times in cols  
%note to marina: function to pad with zeros :padarray
function templet = make_templet(movments)
templet=zeros(size(movments));
% avreging
movment_length=size(movments,2);
left_border = floor(movment_length)/3;
right_border = movment_length-left_border;
aligned_movments = align_peaks(movments,left_border,right_border);
% mean along rows
templet(1,:,:) = mean(aligned_movments(1,:,:),2); %data
templet(2,:,:) = mean(aligned_movments(2,:,:),2); %duration
end

function aligned_movments = align_peaks(movments,left_border,right_border)
num_of_movments=size(movments,3);
movment_length=size(movments,2);

% assume first move is aligned and align in relation to it
aligned_movments = zeros(size(movments));
aligned_movments(1,:,1) = movments(1,:,1); 
% to align the durationtime as well
relative_times=relative_times_in_seg(movments(2,:,:),num_of_movments);

% init starting indx
[~,locs1] = findpeaks(movments(1,:,1),'SortStr','descend','NPeaks',1);
% find index within borders and align in relation to it
for i=2:num_of_movments %run along rows -->
    [~,locs] = findpeaks(movments(1,:,i),'SortStr','descend','NPeaks',1);
    if locs1<=left_border %locs1 is out of borders
        locs1=max(locs1,locs);
    elseif locs1>=right_border
        locs1=min(locs1,locs);
    else
        break
    end
end
%align
for i=1:num_of_movments %run along rows -->
    [~,locs] = findpeaks(movments(1,:,i),'SortStr','descend','NPeaks',1);
    z=zeros(movment_length,1);
    t=zeros(movment_length,1);
    shift=locs1-locs;
    if shift<=0
        z(shift+1:end) = movments(1,1:end-shift,i);
        t(shift+1:end) = relative_times(1,1:end-shift,i);
    else
        z(1:end-shift) = movments(shift+1:end,i);
        t(1:end-shift) = relative_times(shift+1:end,i);
    end
    aligned_movments(1,:,i)=z;
    aligned_movments(2,:,i)=t;
end
end
function relative_times=relative_times_in_seg(times,num_of_movments)
%times- dim size: duration_time_of_movment X num_of_movments
relative_times = zeros(size(times));
for i=1:num_of_movments %run along rows -->
    t0=times(1,i);
    t=times(:,i);
    relative_times(:,i) = t-t0;
end
end
