function [data_template , time_template] = make_template(movments,border_factor)
% function uses all peaks in segmented data,aligne in relation to the first one in
% chosen borders, then changes the time for each seg to be relative to when
% the movment started, and at last averaging all to one template.
% output:
%       *data_template - average template of data of one parameter of one
%        movment kind after resampling
%       *time_template - average template of time stemps after resampling
% input:
%       *movments - segmented data of one parameter of one movment
%       matrix dims: movment_length (or duration_time) X num_of_segments
%                                                   X 2
%       movments(:,:,1)-segmented data of move in cols
%       movments(:,:,2)-times in cols  
%       *border_factor - to select relative peak 

% avreging
movment_length=size(movments,1);
left_border  = floor(border_factor*movment_length);
right_border = movment_length-left_border;
aligned_movments = align_peaks(movments,left_border,right_border);
% mean along rows
data_tmp = mean(aligned_movments(:,:,1),2); %data
t_tmp    = mean(aligned_movments(:,:,2),2); %duration
time_template = linspace(min(t_tmp), max(t_tmp), length(t_tmp))'; % Uniformly-Sampled Time Vector
data_template = resample(data_tmp, time_template); 
end

function aligned_movments = align_peaks(movments,left_border,right_border)
% align_peaks shifts all segs to the first peak in
% range [left_border,right_border]
num_of_segments = size(movments,2);
movment_length = size(movments,1);

% assume first move is aligned and align in relation to it
aligned_movments = zeros(size(movments));
aligned_movments(:,1,1) = movments(:,1,1); 
% to align the durationtime as well
relative_times=relative_times_in_seg(movments(:,:,2),num_of_segments);

% init starting indx
[~,locs1] = findpeaks(movments(:,1,1),'SortStr','descend','NPeaks',1);
% find index within borders and align in relation to it
for i=2:num_of_segments %run along rows -->
    [~,locs] = findpeaks(movments(:,i,1),'SortStr','descend','NPeaks',1);
    if locs1<=left_border %locs1 is out of borders
        locs1=max(locs1,locs);
    elseif locs1>=right_border
        locs1=min(locs1,locs);
    else
        break
    end
end
%align
for i=1:num_of_segments %run along rows -->
    [~,locs] = findpeaks(movments(:,i,1),'SortStr','descend','NPeaks',1);
    z=zeros(movment_length,1);
    t=zeros(movment_length,1);
    shift=locs1-locs;
    if shift>=0
        z(shift+1:end) = movments(1:end-shift,i,1);
        t(shift+1:end) = relative_times(1:end-shift,i);
    else
        shift=abs(shift);
        z(1:end-shift) = movments(shift+1:end,i,1);
        t(1:end-shift) = relative_times(shift+1:end,i);
    end
    aligned_movments(:,i,1)=z;
    aligned_movments(:,i,2)=t;
end
end
function relative_times=relative_times_in_seg(times,num_of_segments)
% relative_times_in_seg returns for each seg time vector t-t0
% times- original time stemps
%       dim size: duration_time_of_movment X num_of_segments
relative_times = zeros(size(times));
for i=1:num_of_segments %run along rows -->
    t0=times(1,i);
    t=times(:,i);
    relative_times(:,i) = t-t0;
end
end
