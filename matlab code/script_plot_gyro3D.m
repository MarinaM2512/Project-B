%% Plot gyro 3D
date = "17_04";
movement_name = ["sit_N_tap1" , "sit_N_side_ancle1", "sit_N_swipe_R1", "sit_N_swipe_L1"];
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
legend('tap', 'side ancle', 'swipe right', 'swipe left');
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
PlotPCA(move_combined,"PCA for all data",moves,3);
%% PCA of side and tap
st = cat(1,Gyro_side,Gyro_tap);
moves=cat(1,Acncle',Tap');
PlotPCA(st,"PCA side ancle and tap",moves,2);
%% PCA of each movement 
[vecsAnc , ~]=PlotPCA(Gyro_side,"PCA side ancle",Acncle,2);
[vecsSL , ~]=PlotPCA(Gyro_SL , "PCA swipe left",SL,2);
[vecsSR , ~]=PlotPCA(Gyro_SR,"PCA swipe right",SR,2);
[vecsTap , ~]=PlotPCA(Gyro_tap,"PCA tap",Tap,2);
figure;
 plot3([0 0 0 0;vecsAnc(1,1),vecsSL(1,1),vecsSR(1,1) ,vecsTap(1,1)],...
     [0 0 0 0;vecsAnc(2,1),vecsSL(2,1),vecsSR(2,1) ,vecsTap(2,1)],...
     [0 0 0 0;vecsAnc(3,1),vecsSL(3,1),vecsSR(3,1) ,vecsTap(3,1)]);
 legend('ancle','swipe left','swipe right','tap');

%% Try a single mevement
date = "17_04";
movement_name = ["sit_N_tap1" , "sit_N_side_ancle1", "sit_N_swipe_R1", "sit_N_swipe_L1"];
move_gyro = cell(4,1);
detected = cell(4,1);
for i = 1:4
    textFileName= strcat("..\measurements\",date,"\","*",movement_name(i),"*","FILTERED_INIT.mat");
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


%% Extracted Meas
date = "17_04";
movement_name = ["sit_N_tap1" , "sit_N_side_ancle1", "sit_N_swipe_R1", "sit_N_swipe_L1"];
for i = 1:4
    textFileName= strcat("..\measurements\resample\",date,"\","*",movement_name(i),"*","FILTERED_INIT.mat");
    DirList = dir(fullfile(textFileName));
    fileName=strcat("..\measurements\resample\",date,"\",{DirList.name});
    mat=load(fileName);
    m = mat.initialised;
    t = m(:,20);
    Fs = 1000/(t(2)-t(1));
    if(i == 2 || i == 1)
        [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,10,10);
    else
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,10,7); 
    end
    move_gyro(i,1:3) = [{to_avgX} {to_avgY} {to_avgZ}] ;  
end
 [tap,~,tTap] = detect_movement(move_gyro(1,1:3));
 [ancle,~,tAnc] = detect_movement(move_gyro(2,1:3));
 [swipeL,~,tSL] = detect_movement(move_gyro(3,1:3));
 [swipeR,~,tSR] = detect_movement(move_gyro(4,1:3));
 
Gyro_tap =numeric_diff_shunit(tap,Fs,'poly',100,1);
Gyro_side = numeric_diff_shunit(ancle,Fs,'poly',100,1);
Gyro_SR = numeric_diff_shunit(swipeL,Fs,'poly',100,1);
Gyro_SL = numeric_diff_shunit(swipeR,Fs,'poly',100,1);
figure();
 plot3(Gyro_tap(:,1),Gyro_tap(:,2), Gyro_tap(:,3), 'o');
 hold on;
 plot3(Gyro_side(:,1),Gyro_side(:,2), Gyro_side(:,3), 'o');
 hold on;
plot3(Gyro_SR(:,1),Gyro_SR(:,2), Gyro_SR(:,3), 'o');
 hold on;
 plot3(Gyro_SL(:,1),Gyro_SL(:,2), Gyro_SL(:,3), 'o');
 hold on;
 plot3(500*[-vecsAnc(1,1) -vecsSL(1,1) -vecsSR(1,1) -vecsTap(1,1);vecsAnc(1,1),vecsSL(1,1),vecsSR(1,1) ,vecsTap(1,1)],...
     500*[-vecsAnc(2,1) -vecsSL(2,1) -vecsSR(2,1) -vecsTap(2,1);vecsAnc(2,1),vecsSL(2,1),vecsSR(2,1) ,vecsTap(2,1)],...
     500*[-vecsAnc(3,1) -vecsSL(3,1) -vecsSR(3,1) -vecsTap(3,1);vecsAnc(3,1),vecsSL(3,1),vecsSR(3,1) ,vecsTap(3,1)]);
 


%% fit a 3D curve for each movement  without diff
date = "17_04";
list_moves = get_all_meas_names(date,"FILTERED_INIT" ,1);
times = cell(length(list_moves),1);
figure;
for i = 1:length(list_moves)
    data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT");
    if(contains(list_moves{i},"tap") || contains(list_moves{i},"ancle") )
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,list_moves{i},10000,500,7,7);
    else
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,list_moves{i},10000,500,7,7); 
    end
   move_gyro(i,1:3) = [{to_avgX} {to_avgY} {to_avgZ}] ; 
   [move,~,time] = detect_movement(move_gyro(i,1:3));
   times(i,1) = {time};
   move_gyro(i,1) = {move};
   if(contains(list_moves{i},"tap"))
       plot3(move(:,1),move(:,2), move(:,3), 'o','Color','b');
   elseif(contains(list_moves{i},"ancle"))
       plot3(move(:,1),move(:,2), move(:,3), 'o','Color','r');
   elseif(contains(list_moves{i},"swipe_L"))
       plot3(move(:,1),move(:,2), move(:,3), 'o','Color','g');
   elseif(contains(list_moves{i},"swipe_R"))
       plot3(move(:,1),move(:,2), move(:,3), 'o','Color','k');
   else
       plot3(move(:,1),move(:,2), move(:,3), 'o','Color','m');
   end
   hold on;
end
 plot3(500*[-vecsAnc(1,1) -vecsSL(1,1) -vecsSR(1,1) -vecsTap(1,1);vecsAnc(1,1),vecsSL(1,1),vecsSR(1,1) ,vecsTap(1,1)],...
     500*[-vecsAnc(2,1) -vecsSL(2,1) -vecsSR(2,1) -vecsTap(2,1);vecsAnc(2,1),vecsSL(2,1),vecsSR(2,1) ,vecsTap(2,1)],...
     500*[-vecsAnc(3,1) -vecsSL(3,1) -vecsSR(3,1) -vecsTap(3,1);vecsAnc(3,1),vecsSL(3,1),vecsSR(3,1) ,vecsTap(3,1)]);
%% Try plot with diff and join points to mat
date = "17_04";
list_moves = get_all_meas_names(date,"FILTERED_INIT" ,1);
all_moves = cell(4,1);
figure;
num_tap = 0;
num_sr = 0;
num_sl = 0;
num_anc = 0;
for i = 1:length(list_moves)
    data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT");
    t = data_mat(:,20);
    Fs = 1000/(t(2)-t(1));
    if(contains(list_moves{i},"tap") || contains(list_moves{i},"ancle") )
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,list_moves{i},10000,500,7,7);
    else
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,list_moves{i},10000,500,7,7); 
    end
   move_gyro(i,1:3) = [{to_avgX} {to_avgY} {to_avgZ}] ; 
   [move,~,time] = detect_movement(move_gyro(i,1:3));
   move_diff = numeric_diff_shunit(move,Fs,'poly',100,1);
   if(contains(list_moves{i},"tap"))
       plot3(move_diff(:,1),move_diff(:,2), move_diff(:,3), 'o','Color','b');
       if (num_tap == 0)
           all_moves{1} = move_diff;
       end
       all_moves{1} = cat(1,all_moves{1},move_diff);
       num_tap =num_tap+1;
   elseif(contains(list_moves{i},"ancle"))
       plot3(move_diff(:,1),move_diff(:,2), move_diff(:,3), 'o','Color','r');
       if (num_anc ==0)
           all_moves{2} = move_diff;
       end
       all_moves{2} = cat(1,all_moves{2},move_diff);
       num_anc = num_anc+1;
   elseif(contains(list_moves{i},"swipe_L"))
       plot3(move_diff(:,1),move_diff(:,2), move_diff(:,3), 'o','Color','g');
       if (num_sl ==0)
           all_moves{3} = move_diff;
       end
       all_moves{3} = cat(1,all_moves{3},move_diff);
       num_sl = num_sl+1;
   elseif(contains(list_moves{i},"swipe_R"))
       plot3(move_diff(:,1),move_diff(:,2), move_diff(:,3), 'o','Color','k');
       if (num_sr ==0)
           all_moves{4} = move_diff;
       end
       all_moves{4} = cat(1,all_moves{4},move_diff);
       num_sr = num_sr+1;
   else
       plot3(move_diff(:,1),move_diff(:,2), move_diff(:,3), 'o','Color','m');
   end
   hold on;
end
 plot3(15000*[-vecsAnc(1,1) -vecsSL(1,1) -vecsSR(1,1) -vecsTap(1,1);vecsAnc(1,1),vecsSL(1,1),vecsSR(1,1) ,vecsTap(1,1)],...
     15000*[-vecsAnc(2,1) -vecsSL(2,1) -vecsSR(2,1) -vecsTap(2,1);vecsAnc(2,1),vecsSL(2,1),vecsSR(2,1) ,vecsTap(2,1)],...
     15000*[-vecsAnc(3,1) -vecsSL(3,1) -vecsSR(3,1) -vecsTap(3,1);vecsAnc(3,1),vecsSL(3,1),vecsSR(3,1) ,vecsTap(3,1)]);
%% PCA for each movement 
SL = repmat( "swipe L" ,1, length(all_moves{3}));
SR = repmat( "swipe R" ,1, length(all_moves{4}));
Tap = repmat( "Tap" ,1, length(all_moves{1}));
Anckle = repmat( "Side Ancle" ,1, length(all_moves{2}));
[vecsAnc , scoresAnc]=PlotPCA(all_moves{2},"PCA side ancle",Anckle,3);
[vecsSL , scoresSL]=PlotPCA(all_moves{3} , "PCA swipe left",SL,3);
[vecsSR , scoresSR]=PlotPCA(all_moves{4},"PCA swipe right",SR,3);
[vecsTap , scoresTap]=PlotPCA(all_moves{1},"PCA tap",Tap,3);
figure;
 plot3([0 0 0 0;vecsAnc(1,1),vecsSL(1,1),vecsSR(1,1) ,vecsTap(1,1)],...
     [0 0 0 0;vecsAnc(2,1),vecsSL(2,1),vecsSR(2,1) ,vecsTap(2,1)],...
     [0 0 0 0;vecsAnc(3,1),vecsSL(3,1),vecsSR(3,1) ,vecsTap(3,1)]);
 legend('ancle','swipe left','swipe right','tap');
 %% PCA for all data with diff 
move_combined = cat(1,all_moves{2},all_moves{3},all_moves{4},all_moves{1});
SL = repmat( "swipe L" ,1, length(all_moves{3}));
SR = repmat( "swipe R" ,1, length(all_moves{4}));
Tap = repmat( "Tap" ,1, length(all_moves{1}));
Anckle = repmat( "Side Ancle" ,1, length(all_moves{2}));
moves=cat(1,Anckle',SL' , SR' ,Tap');
PlotPCA(move_combined,"PCA for all data",moves,3);
%% PCA with times doesnt work well
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
PlotPCA(move_combined,"PCA for all data",moves,3);

%% PCA helper func
function [coefs , score]= PlotPCA(mat,title,names,dim)
    [coefs , score] = pca(mat);
    % coeffs are the principle vectors dim_vector x dim_vector
    % score is the coordinates of the samples corresponding each vector
    % n x dim_vector
    vbls = {'X','Y','Z','T'}; % Labels for the variables
    figure;
    h = biplot(coefs(:,1:dim),'Scores',score(:,1:dim),'VarLabels',vbls(1:size(coefs,1)), 'ObsLabels',names);
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




