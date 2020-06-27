function xcorr = xcorr_all_intresting_seg(Sd,factor)
% casing func for xcorr_to_intresting_seg
% run on all segs and do xcorr only for "intresting" segs
% "intresting" means seg we suspect movement happened 
% INPUT
% 1. Sd - cell array of all data segments
% 2. factor - err factor above which we suspect movement occurence
% OUTPUT:
% xcorr - cell array same size as Sd in each cell:
% xcorr{i}(:,:,1) - normlized cross corr result of seg{i} with swipe L template
% xcorr{i}(:,:,2) - normlized cross corr result of seg{i} with swipe R template
% xcorr{i}(:,:,3) - normlized cross corr result of seg{i} with tap template
% xcorr{i}(:,:,4) - normlized cross corr result of seg{i} with side anckle template
template_mat = loadTemplateMat; %pedded to same size
num_of_params = 3;
num_of_seg = length(Sd);
xcorr = cell(num_of_seg,1);
    
    xcorr{1} = gyro_cross_corr_normlized(template_mat,Sd{1},num_of_params);
   
    for i=2:num_of_seg
        [xcorr_swl,xcorr_swr,xcorr_tap,xcorr_anc] = ...
                    xcorr_to_intresting_seg(Sd{i},Sd{i-1},factor);
         swl = xcorr_swl(:,:,1);
         swr = xcorr_swr(:,:,1);
         tap = xcorr_tap(:,:,1);
         anc = xcorr_anc(:,:,1);
         xcorr{i} = cat(3,swl,swr,tap,anc);  
    end
%  xcorr = cell2mat(xcorr);   
end