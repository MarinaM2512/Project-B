%function label_mat = xcorr_segments_and_classify(data,times
template_mat = loadTemplateMat;
data = loadMeasurmentMat("17_04","sit_N_tap1",1,"INIT"); %load one data mes
S=data2timeSegmentsOverlapping(data(:,4:6),data(:,20),63,60);
%% 
op = 'none'; % 'normalized'
t = cellfun(@(x) x(:,4),S,'UniformOutput',false);
t = cell2mat(t);
factor = 0.3;
xcorr = xcorr_all_intresting_seg(S,factor,op);
xcorr_mat = cell2mat(xcorr);
xcorr_swl = xcorr_mat(:,:,:,1);
xcorr_swr = xcorr_mat(:,:,:,2);
xcorr_tap = xcorr_mat(:,:,:,3);
xcorr_anc = xcorr_mat(:,:,:,4);

%%
colors = ["r", "g","b","m"];
% t_new = linspace(0,t(end),length(xcorr_swl));
t_new = linspace(0,length(xcorr_swl),length(xcorr_swl));

figure;

    for j = 1:4
        curr_temp = template_mat{j};
        subplot(3,1,1);
        %start_time = find(corr_mat(:,1,2,j)==-length(curr_temp));
        plot(t_new,xcorr_mat(:,1,1,j),colors(j));
        title("X");
        hold on;
        subplot(3,1,2);
        %start_time = find(corr_mat(:,2,2,j)==-length(curr_temp));
        plot(t_new,xcorr_mat(:,2,1,j),colors(j));
        title("Y");
        hold on;
        subplot(3,1,3);
        %start_time = find(corr_mat(:,3,2,j)==-length(curr_temp));
        plot(t_new,xcorr_mat(:,3,1,j),colors(j));
        title("Z");
        hold on;
    end
    legend("swipe left template","swipe right template","tap template","ankle template");
    %newStr = strrep(list_moves{i},'_',' ');
    sgtitle("normlized cross correlation of sit N tap1 data" );