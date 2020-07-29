function [xcorr,times] = xcorr_all_intresting_data(data,factor,norm,endOrStart)
% casing func for xcorr_to_intresting_seg
% run on all segs and do xcorr only for "intresting" segs
% "intresting" means seg we suspect movement happened 
% INPUT
% 1. the whole data vector of one mesurment organized as  :{x,y,z,T}
%   
% 2. factor - err factor above which we suspect movement occurence
% 3. norm - 'none' - raw xcorr
%       - 'normalized' - normelized by template and signal autocorr
%       - 'sig' - normalized by signal power
%        - 'temp' - normalized by template power
% 4. endOrStart - "start" - to take the start time of the movement as the correlation time
% "end" - to take the end time of the movement as the correlation time
% OUTPUT:
% xcorr - array of size Nx3x4 in which the first and second dimentions contains a Nx3 matrix of
% cross correlation N is maximum lags fit in data vector, 3 is x,y,z.
% xcorr(:,:,1) - cross corr result with swipe L template
% xcorr(:,:,2) - cross corr result with swipe R template
% xcorr(:,:,3) - cross corr result with tap template
% xcorr(:,:,4) - cross corr result with side anckle template
% all resultes normlized according to 'op'
% times- the xcorr times
if (norm == "none" || norm == "sig" || norm == "temp")
    op = 'none';
else
    op = 'normalized';
end
template_mat = loadTemplateMat; %Padded to same length
% Templates power 
temp_power = cellfun(@(x) sum(x(:,:,1).^2),template_mat,'UniformOutput',false);
temp_power = reshape(cell2mat(temp_power),[3,4]);
tempLength = length(template_mat{1});
seg = data2timeSegmentsOverlapping(data(:,1:3),data(:,4),tempLength,tempLength-1);
Ts = data(2,4)-data(1,4);
data_seg = cellfun(@(x) x(:,1:3),seg,'UniformOutput',false); % extract data from S
num_of_seg = length(seg);
xcorr = zeros(num_of_seg,3,4);
times = zeros(num_of_seg,1);
% always cal for first seg
sig_power = sum(data_seg{1}.^2);
sig_power = repmat(sig_power',1,4);
[xcorr_swl,xcorr_swr,xcorr_tap,xcorr_anc] = ...
xcorr_to_intresting_data(template_mat,data_seg{1},data_seg{1},-1,op);
if ( norm == "temp")
    xcorr(1,1:3,1:4) = cat(2,xcorr_swl',xcorr_swr',xcorr_tap',xcorr_anc')./temp_power;
elseif( norm == "sig")
    xcorr(1,1:3,1:4) = cat(2,xcorr_swl',xcorr_swr',xcorr_tap',xcorr_anc')./sig_power;
else
    xcorr(1,1:3,1:4) = cat(2,xcorr_swl',xcorr_swr',xcorr_tap',xcorr_anc');
end
times(1,1) = Ts*(tempLength-1)*(endOrStart == "end");
for i=2:num_of_seg
    [xcorr_swl,xcorr_swr,xcorr_tap,xcorr_anc] = ...
                xcorr_to_intresting_data(template_mat,data_seg{i},data_seg{i-1},factor,op);
    tmp = cat(2,xcorr_swl',xcorr_swr',xcorr_tap',xcorr_anc');
    if(~isempty(tmp))
        if ( norm == "temp")
            xcorr(i,1:3,1:4) = cat(2,xcorr_swl',xcorr_swr',xcorr_tap',xcorr_anc')./temp_power;
        elseif( norm == "sig")
            xcorr(i,1:3,1:4) = cat(2,xcorr_swl',xcorr_swr',xcorr_tap',xcorr_anc')./sig_power;
        else
            xcorr(i,1:3,1:4) = cat(2,xcorr_swl',xcorr_swr',xcorr_tap',xcorr_anc');
        end
        times(i,1) = times(1,1)+Ts*(i-1);
    else
        times(i,1) = times(1,1)+Ts*(i-1);
        xcorr(i,1:3,1:4) = zeros(3,4);
    end
end
end