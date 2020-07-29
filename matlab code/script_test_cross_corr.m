%function label_mat = xcorr_segments_and_classify(data,times
template_mat = loadTemplateMat;
move_name = "sit_N_tap";
data = loadMeasurmentMat("17_04",move_name,1,"INIT"); %load one data mes
S=data2timeSegmentsOverlapping(data(:,4:6),data(:,20),63,62);
%%  un normlized
op = 'none';%'normalized'%;
t = cellfun(@(x) x(:,4),S,'UniformOutput',false);
t = cell2mat(t);
factor = 0.3;
xcorr1 = xcorr_all_intresting_seg(S,factor,op);
xcorr_mat = cell2mat(xcorr1);
xcorr_swl = xcorr_mat(:,:,:,1);
xcorr_swr = xcorr_mat(:,:,:,2);
xcorr_tap = xcorr_mat(:,:,:,3);
xcorr_anc = xcorr_mat(:,:,:,4);

%%
colors = ["r", "g","b","m"];
% t_new = linspace(0,t(end),length(xcorr_swl));
t_new = linspace(0,length(xcorr_swl),length(xcorr_swl));
op = ["","normalized"];

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
    newStr = strrep(move_name,'_',' ');
    sgtitle([op(1)," cross correlation of " ,newStr]);
%% normlized with ryy for each axe
% need to run 1st section first
template_mat1 = cell2mat(template_mat);
ryy = zeros(1,size(template_mat1,2)); 
for i=1:size(template_mat1,2)
    [tmp_ryy,lags] = xcorr(template_mat1(:,i,1));
    ryy(i) = tmp_ryy(~lags);
end

t = cellfun(@(x) x(:,4),S,'UniformOutput',false);
t = cell2mat(t);
factor = 0.3;

xcorr2 = xcorr_all_intresting_seg(S,factor,'none');
xcorr_mat2 = cell2mat(xcorr2);
xcorr_swl2 = xcorr_mat2(:,:,:,1);
xcorr_swr2 = xcorr_mat2(:,:,:,2);
xcorr_tap2 = xcorr_mat2(:,:,:,3);
xcorr_anc2 = xcorr_mat2(:,:,:,4);

%% 
colors = ["r", "g","b","m"];
% t_new = linspace(0,t(end),length(xcorr_swl));
t_new = linspace(0,length(xcorr_swl2),length(xcorr_swl2));
figure;
i=1;
    for j = 1:4
        
        curr_temp = template_mat{j};
        subplot(3,1,1);
        %start_time = find(corr_mat(:,1,2,j)==-length(curr_temp));
        cx = xcorr_mat2(:,1,1,j)/ryy(i);
        plot(t_new,cx,colors(j));
        title("X");
        hold on;
        subplot(3,1,2);
        %start_time = find(corr_mat(:,2,2,j)==-length(curr_temp));
        cy = xcorr_mat2(:,2,1,j)/ryy(i+1);
        plot(t_new,cy,colors(j));
        title("Y");
        hold on;
        subplot(3,1,3);
        %start_time = find(corr_mat(:,3,2,j)==-length(curr_temp));
        cz = xcorr_mat2(:,3,1,j)/ryy(i+2);
        plot(t_new,cz,colors(j));
        title("Z");
        hold on;
        i=i+3;
    end
    legend("swipe left template","swipe right template","tap template","ankle template");
    newStr = strrep(move_name,'_',' ');
    sgtitle([op(1)," cross correlation of " ,newStr,"normlized with ryy"]);
%% normlized with waited ryy to all axis
tmp = load("./templates/tap_principle_vec");
vec_tap = tmp.tap;
tmp = load("./templates/ank_principle_vec");
vec_ank = tmp.ank;
tmp = load("./templates/swl_principle_vec");
vec_swl = tmp.swl;
tmp = load("./templates/swr_principle_vec");
vec_swr = tmp.swr; 
wight_vec = [vec_swl vec_swr vec_tap vec_ank];
%%
figure;
i=1;
    for j = 1:4
        w = wight_vec(:,j);
        n = ryy(i)*w(1)+ryy(i+1)*w(2)+ryy(i+2)*w(3);
        curr_temp = template_mat{j};
        subplot(3,1,1);
        %start_time = find(corr_mat(:,1,2,j)==-length(curr_temp));
        cx = xcorr_mat2(:,1,1,j)/n;
        plot(t_new,cx,colors(j));
        title("X");
        hold on;
        subplot(3,1,2);
        %start_time = find(corr_mat(:,2,2,j)==-length(curr_temp));
        cy = xcorr_mat2(:,2,1,j)/n;
        plot(t_new,cy,colors(j));
        title("Y");
        hold on;
        subplot(3,1,3);
        %start_time = find(corr_mat(:,3,2,j)==-length(curr_temp));
        cz = xcorr_mat2(:,3,1,j)/n;
        plot(t_new,cz,colors(j));
        title("Z");
        hold on;
        i=i+3;
    end
    legend("swipe left template","swipe right template","tap template","ankle template");
    newStr = strrep(move_name,'_',' ');
    sgtitle([op(1)," cross correlation of " ,newStr,"normlized with wighted ryy"]);
  