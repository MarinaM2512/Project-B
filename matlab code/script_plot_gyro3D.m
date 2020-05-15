%% Plot gyro 3D
date = "17_04";
movement_name = ["sit_N_tap" , "sit_N_side_ancle1", "sit_N_swipe_R1", "sit_N_swipe_L1"];
move_gyro = cell(4,1);
move_gyro_T= cell(4,1);
detected = cell(4,1);
times = cell(4,1);
for i = 1:4
    textFileName= strcat("..\measurements\resample\",date,"\","*",movement_name(i),"*","FILTERED_INIT.mat");
    DirList = dir(fullfile(textFileName));
    fileName=strcat("..\measurements\resample\",date,"\",{DirList.name});
    mat=load(fileName);
    m = mat.initialised;
    move_gyro(i,1) = {cat(2,m(:,4),m(:,5),m(:,6))};
    move_gyro_T(i,1) = {cat(2,m(:,4),m(:,5),m(:,6),m(:,20))};
    if(i == 2 || i == 1)
        [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,10,10);
    else
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,10,7); 
    end
    t = m(:,20);
    moveX_t = to_avgX(:,:,2);
    moveX = ismember(t,moveX_t);
    moveY_t = to_avgY(:,:,2);
    moveY = ismember(t,moveY_t);
    moveZ_t = to_avgZ(:,:,2);
    moveZ = ismember(t,moveZ_t);
    movment_idx = bitand( moveX ,moveY );
    movment_idx = bitand(movment_idx , moveZ);
    detected(i,1) = {movment_idx};
%     relTimes = zeros(length(detected)/min([size(to_avgX,2) size(to_avgY,2) size(to_avgZ,2)]),1);
%     for i = 1:size(to_avgX,2)
%         
%     end
end

Gyro_tap = move_gyro{1,1};
Gyro_side = move_gyro{2,1};
Gyro_SR = move_gyro{3,1};
Gyro_SL = move_gyro{4,1};
Gyro_tap = Gyro_tap(detected{1,1},:);
Gyro_side = Gyro_side(detected{2,1},:);
Gyro_SR = Gyro_SR(detected{3,1},:);
Gyro_SL = Gyro_SL(detected{4,1},:);

%For pca
Gyro_tap_T = move_gyro_T{1,1};
Gyro_side_T = move_gyro_T{2,1};
Gyro_SR_T = move_gyro_T{3,1};
Gyro_SL_T = move_gyro_T{4,1};
Gyro_tap_T = Gyro_tap_T(detected{1,1},:);
Gyro_side_T = Gyro_side_T(detected{2,1},:);
Gyro_SR_T= Gyro_SR_T(detected{3,1},:);
Gyro_SL_T = Gyro_SL_T(detected{4,1},:);

figure();
plot3(Gyro_tap(:,1),Gyro_tap(:,2), Gyro_tap(:,3),'o');
hold on;
plot3(Gyro_side(:,1),Gyro_side(:,2), Gyro_side(:,3),'o');
hold on;
plot3(Gyro_SR(:,1),Gyro_SR(:,2), Gyro_SR(:,3),'o');
hold on;
plot3(Gyro_SL(:,1),Gyro_SL(:,2), Gyro_SL(:,3), 'o');
hold on;
legend('walk', 'side ancle', 'swipe right', 'swipe left');
xlabel('x');
ylabel('y');
zlabel('z');
%% PCA of all data
move_combined = cat(1,Gyro_side,Gyro_SL,Gyro_SR,Gyro_tap);
SL = repmat( "swipe L" ,1, length(Gyro_SL));
SR = repmat( "swipe R" ,1, length(Gyro_SR));
Tap = repmat( "Tap" ,1, length(Gyro_tap));
Acncle = repmat( "Side Ancle" ,1, length(Gyro_side));
moves=cat(1,Acncle',SL' , SR' ,Tap');
PlotPCA(move_combined,"PCA for all data",moves,2);
%% PCA of side and tap
st = cat(1,Gyro_side,Gyro_tap);
moves=cat(1,Acncle',Tap');
PlotPCA(st,"PCA side ancle and tap",moves,2);
%% PCA of each movement 
PlotPCA(Gyro_side,"PCA side ancle",Acncle,2);
PlotPCA(Gyro_SL , "PCA swipe left",SL,2);
PlotPCA(Gyro_SR,"PCA swipe right",SR,2);
PlotPCA(Gyro_tap,"PCA tap",Tap,2);
%% Try a single mevement
date = "17_04";
movement_name = ["sit_N_sit_tap1" , "sit_N_sit_side_ancle1", "sit_N_swipe_R1", "sit_N_swipe_L1"];
move_gyro = cell(4,1);
detected = cell(4,1);
for i = 1:4
    textFileName= strcat("..\measurements\",date,"\","*",movement_name(i),"*","_INIT.mat");
    DirList = dir(fullfile(textFileName));
    fileName=strcat("..\measurements\",date,"\",{DirList.name});
    mat=load(fileName);
    m = mat.initialised;
    move_gyro(i,1) = {cat(2,m(:,4),m(:,5),m(:,6))};
    [SegX , SegTX]  = data2timeSegments(m(:,4),m(:,20),10000);
    [SegY , SegTY]  = data2timeSegments(m(:,5),m(:,20),10000);
    [SegZ , SegTZ]  = data2timeSegments(m(:,6),m(:,20),10000);
    if(i == 2 || i == 1)
        [X , TX] = extract_movement(SegX{2,1},SegTX{2,1} ,10,500, 10);
        to_avgX = cat( 3,X , TX);
        [Y , TY] = extract_movement(SegY{2,1},SegTY{2,1},10,500, 10);
        to_avgY = cat( 3,Y , TY);
        [Z, TZ] = extract_movement(SegZ{1,1},SegTZ{1,1} ,10,500, 10);    
        to_avgZ = cat( 3,Z , TZ);
    else
       [X , TX] = extract_movement(SegX{1,1},SegTX{1,1} ,10,500, 7);
       to_avgX = cat( 3,X , TX);
       [Y , TY] = extract_movement(SegY{1,1},SegTY{1,1},10,500, 7);
       to_avgY = cat( 3,Y , TY);
       [Z, TZ] = extract_movement(SegZ{1,1},SegTZ{1,1} ,10,500, 7);  
       to_avgZ = cat( 3,Z , TZ);
    end
    t = m(:,20);
    moveX_t = to_avgX(:,:,2);
    moveX = ismember(t,moveX_t);
    moveY_t = to_avgY(:,:,2);
    moveY = ismember(t,moveY_t);
    moveZ_t = to_avgZ(:,:,2);
    moveZ = ismember(t,moveZ_t);
    movment_idx = bitor( moveX ,moveY );
    movment_idx = bitor(movment_idx , moveZ);
    detected(i,1) = {movment_idx};
end

Gyro_tap = move_gyro{1,1};
Gyro_side = move_gyro{2,1};
Gyro_SR = move_gyro{3,1};
Gyro_SL = move_gyro{4,1};
Gyro_tap = Gyro_tap(detected{1,1},:);
Gyro_side = Gyro_side(detected{2,1},:);
Gyro_SR = Gyro_SR(detected{3,1},:);
Gyro_SL = Gyro_SL(detected{4,1},:);

figure();
plot3(Gyro_tap(:,1),Gyro_tap(:,2), Gyro_tap(:,3),'o');
hold on;
plot3(Gyro_side(:,1),Gyro_side(:,2), Gyro_side(:,3),'o');
hold on;
plot3(Gyro_SR(:,1),Gyro_SR(:,2), Gyro_SR(:,3),'o');
hold on;
plot3(Gyro_SL(:,1),Gyro_SL(:,2), Gyro_SL(:,3), 'o');
hold on;
legend('tap', 'side ancle', 'swipe right', 'swipe left');
xlabel('x');
ylabel('y');
zlabel('z');


%% Tried with extracted meas but not aligned
date = "17_04";
movement_name = ["sit_N_tap1" , "sit_N_side_ancle1", "sit_N_swipe_R1", "sit_N_swipe_L1"];
for i = 1:4
    textFileName= strcat("..\measurements\resample\",date,"\","*",movement_name(i),"*","FILTERED_INIT.mat");
    DirList = dir(fullfile(textFileName));
    fileName=strcat("..\measurements\resample\",date,"\",{DirList.name});
    mat=load(fileName);
    m = mat.initialised;
    if(i == 2 || i == 1)
        [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,10,10);
    else
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,10,7); 
    end
    move_gyro(i,1:3) = [{to_avgX} {to_avgY} {to_avgZ}] ;  
end
 [tap, tTap] = detect_movement(move_gyro(1,1:3));
 [ancle,tAnc] = detect_movement(move_gyro(2,1:3));
 [swipeL,tSL] = detect_movement(move_gyro(3,1:3));
 [swipeR,tSR] = detect_movement(move_gyro(4,1:3));
 
Gyro_tap = tap;
Gyro_side = ancle;
Gyro_SR = swipeR;
Gyro_SL = swipeL;
figure();
 plot3(Gyro_tap(:,1),Gyro_tap(:,2), Gyro_tap(:,3), 'o');
 hold on;
 plot3(Gyro_side(:,1),Gyro_side(:,2), Gyro_side(:,3), 'o');
 hold on;
plot3(Gyro_SR(:,1),Gyro_SR(:,2), Gyro_SR(:,3), 'o');
 hold on;
 plot3(Gyro_SL(:,1),Gyro_SL(:,2), Gyro_SL(:,3), 'o');
 hold on;
 legend('tap', 'side ancle', 'swipe right', 'swipe left');
 
%% PCA with times 
Gyro_tapT = cat(2,tap,tTap);
Gyro_sideT = cat(2,ancle,tAnc);
Gyro_SRT = cat(2,swipeR,tSR);
Gyro_SLT = cat(2,swipeL,tSL);
move_combined = cat(1,Gyro_sideT,Gyro_SLT,Gyro_SRT,Gyro_tapT);
SL = repmat( "swipe L" ,1, length(Gyro_SLT));
SR = repmat( "swipe R" ,1, length(Gyro_SRT));
Tap = repmat( "Tap" ,1, length(Gyro_tapT));
Anckle = repmat( "Side Ancle" ,1, length(Gyro_sideT));
moves=cat(1,Anckle',SL' , SR' ,Tap');
PlotPCA(move_combined,"PCA for all data",moves,2);
%% fit a 3D curve for each movement 
date = "17_04";
list_moves = get_all_meas_names(date,"FILTERED_INIT" ,1);
times = cell(length(list_moves),1);
figure;
for i = 1:length(list_moves)
    data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT");
    if(contains(list_moves{i},"tap") || contains(list_moves{i},"ancle") )
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,7,7);
    else
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,7,7); 
    end
   move_gyro(i,1:3) = [{to_avgX} {to_avgY} {to_avgZ}] ; 
   [move_gyro(i,1:3),times(i,1)] = detect_movement(move_gyro(i,1:3));
   if(contains(list_moves{i},"tap"))
       plot3(move_gyro{i,1},move_gyro{i,2}, move_gyro{i,3}, 'o','Color','b');
   elseif(contains(list_moves{i},"ancle"))
       plot3(move_gyro{i,1},move_gyro{i,2}, move_gyro{i,3}, 'o','Color','r');
   elseif(contains(list_moves{i},"swipeL"))
       plot3(move_gyro{i,1},move_gyro{i,2}, move_gyro{i,3}, 'o','Color','g');
   elseif(contains(list_moves{i},"swipeR"))
       plot3(move_gyro{i,1},move_gyro{i,2}, move_gyro{i,3}, 'o','Color','k');
   else
       plot3(move_gyro{i,1},move_gyro{i,2}, move_gyro{i,3}, 'o','Color','o');
   end
   hold on;
end
%  [tap, tTap] = detect_movement(move_gyro(1,1:3));
%  [ancle,tAnc] = detect_movement(move_gyro(2,1:3));
%  [swipeL,tSL] = detect_movement(move_gyro(3,1:3));
%  [swipeR,tSR] = detect_movement(move_gyro(4,1:3));
%  
% Gyro_tap = tap;
% Gyro_side = ancle;
% Gyro_SR = swipeR;
% Gyro_SL = swipeL;
% figure();
%  plot3(Gyro_tap(:,1),Gyro_tap(:,2), Gyro_tap(:,3), 'o');
%  hold on;
%  plot3(Gyro_side(:,1),Gyro_side(:,2), Gyro_side(:,3), 'o');
%  hold on;
% plot3(Gyro_SR(:,1),Gyro_SR(:,2), Gyro_SR(:,3), 'o');
%  hold on;
%  plot3(Gyro_SL(:,1),Gyro_SL(:,2), Gyro_SL(:,3), 'o');
%  hold on;
%  legend('tap', 'side ancle', 'swipe right', 'swipe left');


%% align times 
function [move_mat times]  = detect_movement(movement_cell)
    gyroX = movement_cell{1};
    gyroY = movement_cell{2};
    gyroZ = movement_cell{3};    
    ColNumsX = repmat(cols,size(gyroX,1),1);
    ColNumsY = repmat(cols,size(gyroY,1),1);
    ColNumsZ = repmat(cols,size(gyroZ,1),1);
    gyroX_N = cat(3,gyroX,ColNumsX);
    gyroY_N = cat(3,gyroY,ColNumsY);
    gyroZ_N = cat(3,gyroZ,ColNumsZ);
    movements = [{gyroX_N} {gyroY_N} {gyroZ_N}] ;  
    col_stacked = cellfun(@(x) reshape(x,size(x(:,:,1),1)*size(x(:,:,1),2),3),movements,'UniformOutput',false);
    reduce_redundant_points = cellfun(@(x) x(find(x(:,1)),:),col_stacked,'UniformOutput',false);
    [~,idx] = min(cellfun(@(x) length(x(:,2)),reduce_redundant_points));
    idx_other = find(1:3 ~=idx);
    other = {reduce_redundant_points{1, idx_other}};
     A = reduce_redundant_points{1, 1:3 == idx};
     A = A(:,2);
     B1 = other{1,1};
     B2 = other{1,2};
     TMP1 = bsxfun(@(x,y) abs(x-y), A(:), reshape(B1(:,2),1,[]));
     TMP2 = bsxfun(@(x,y) abs(x-y), A(:), reshape(B2(:,2),1,[]));
     [D1, idxB1] = min(TMP1,[],2);
     [D2, idxB2] = min(TMP2,[],2);
     B1 = B1(idxB1,:);
     B2 = B2(idxB2,:);
     reduce_redundant_points(1,idx_other(1)) ={B1};
     reduce_redundant_points(1,idx_other(2)) ={B2};
     meas = cellfun(@(x) x(:,1) , reduce_redundant_points ,'UniformOutput',false);
     times = zeros(size(meas{1,1},1),1);
     times_col = reduce_redundant_points{1,1};
     times_col = times_col(:,2:3);
     curr_idx = 1;
     for i = 1:size(gyroX,2)
         tmp = times_col(find(times_col(:,2)==i));
         times(curr_idx:curr_idx+length(tmp)-1) = relative_times(tmp);
         curr_idx =curr_idx+length(tmp);
     end
     move_mat = cat(2,meas{1,1},meas{1,2},meas{1,3});
end

function new_times = relative_times(orig_times)
    new_times =zeros(size(orig_times));
    for i = 1:size(orig_times,2)
        new_times(:,i) = orig_times(:,i)-orig_times(1,i);
    end
end
%% PCA helper func
function []= PlotPCA(mat,title,names,dim)
    [coefs , score] = pca(mat);
    % coeffs are the principle vectors dim_vector x dim_vector
    % score is the coordinates of the samples corresponding each vector
    % n x dim_vector
    vbls = {'X','Y','Z','T'}; % Labels for the variables
    figure;
    h = biplot(coefs(:,1:dim),'Scores',score(:,1:dim),'VarLabels',vbls, 'ObsLabels',names);
    % Identify each handle
    hID = get(h, 'tag'); 
    % Isolate handles to scatter points
    hPt = h(strcmp(hID,'obsmarker')); 
    % Identify cluster groups
    grp = findgroups(names);    %r2015b or later - leave comment if you need an alternative
    grp(isnan(grp)) = max(grp(~isnan(grp)))+1; 
    grpID = 1:max(grp); 
    % assign colors and legend display name
    clrMap = lines(length(unique(grp)));   % using 'lines' colormap
    for i = 1:max(grp)
        set(hPt(grp==i), 'Color', clrMap(i,:), 'DisplayName', sprintf('Cluster %d', grpID(i)))
    end
    % add legend to identify cluster
    [~, unqIdx] = unique(grp);
    legend(hPt(unqIdx));
    sgtitle(title);
end




