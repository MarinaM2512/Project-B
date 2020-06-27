function xcorr = xcorr_all_intresting_seg(S,factor,op)
% casing func for xcorr_to_intresting_seg
% run on all segs and do xcorr only for "intresting" segs
% "intresting" means seg we suspect movement happened 
% INPUT
% 1. Sd - cell array of all data segments 
%   in each cel :{x,y,z,T}
% 2. factor - err factor above which we suspect movement occurence
% OUTPUT:
% xcorr - cell array same size as Sd in each cell:
% xcorr{i}(:,:,:,1) - normlized cross corr result of seg{i} with swipe L template
% xcorr{i}(:,:,:,2) - normlized cross corr result of seg{i} with swipe R template
% xcorr{i}(:,:,:,3) - normlized cross corr result of seg{i} with tap template
% xcorr{i}(:,:,:,4) - normlized cross corr result of seg{i} with side anckle template
template_mat = loadTemplateMat; %pedded to same size
num_of_params = 3;
Sd = cellfun(@(x) x(:,1:num_of_params),S,'UniformOutput',false);
num_of_seg = length(Sd);
xcorr = cell(num_of_seg,1);
    % always cal for first seg
    [xcorr_swl,xcorr_swr,xcorr_tap,xcorr_anc] = ...
        gyro_cross_corr_normlized(template_mat,Sd{1},num_of_params,op);
    xcorr{1} = cat(4,xcorr_swl,xcorr_swr,xcorr_tap,xcorr_anc);
    for i=2:num_of_seg
        [xcorr_swl,xcorr_swr,xcorr_tap,xcorr_anc] = ...
                    xcorr_to_intresting_seg(template_mat,Sd{i},Sd{i-1},factor,op);
    xcorr{i} = cat(4,xcorr_swl,xcorr_swr,xcorr_tap,xcorr_anc);
 
    end
%  xcorr = cell2mat(xcorr);   
end