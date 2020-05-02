%% Plot gyro 3D
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
movement_name = ["sit_N_sit_tap1" , "sit_N_sit_side_ancle1", "sit_N_swipe_R1", "sit_N_swipe_L1"];
move_gyro = cell(4,1);
detected = cell(4,1);
for i = 1:4
    textFileName= strcat("..\measurements\",date,"\","*",movement_name(i),"*","_INIT.mat");
    DirList = dir(fullfile(textFileName));
    fileName=strcat("..\measurements\",date,"\",{DirList.name});
    mat=load(fileName);
    m = mat.initialised;
    if(i == 2 || i == 1)
        [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,10,10);
    else
       [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,10,7); 
    end
    move_gyro(i,1:3) = [{to_avgX} {to_avgY} {to_avgZ}] ;  
end
%%% inside for
%     [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,movement_name(i),10000,500,10);
%     move_gyro(i,1:3) = [{to_avgX} {to_avgY} {to_avgZ}] ;   
%%%
 tap = detect_movement(move_gyro(1,1:3));
 ancle = detect_movement(move_gyro(2,1:3));
 swipeL = detect_movement(move_gyro(3,1:3));
 swipeR = detect_movement(move_gyro(4,1:3));
 
Gyro_tap = tap;
Gyro_side = ancle;
Gyro_SR = swipeR;
Gyro_SL = swipeL;
figure();
% plot3(Gyro_tap(:,1),Gyro_tap(:,2), Gyro_tap(:,3), 'o');
% hold on;
% plot3(Gyro_side(:,1),Gyro_side(:,2), Gyro_side(:,3), 'o');
% hold on;
plot3(Gyro_SR(:,1),Gyro_SR(:,2), Gyro_SR(:,3), 'o');
% hold on;
% plot3(Gyro_SL(:,1),Gyro_SL(:,2), Gyro_SL(:,3), 'o');
% hold on;
% legend('tap', 'side ancle', 'swipe right', 'swipe left');
 
function move_mat = detect_movement(movement_cell)
    col_stacked = cellfun(@(x) reshape(x,size(x(:,:,1),1)*size(x(:,:,1),2),1,2),movement_cell,'UniformOutput',false);
    reduce_redundant_points = cellfun(@(x) x(x(:,1,1)>0,:,:),col_stacked,'UniformOutput',false);
    [~,idx] = min(cellfun(@(x) length(x(:,:,2)),reduce_redundant_points));
    idx_other = find(1:3 ~=idx);
    other = {reduce_redundant_points{1, idx_other}};
     A = reduce_redundant_points{1, 1:3 == idx};
     A = A(:,:,2);
     B1 = other{1,1};
     B2 = other{1,2};
     TMP1 = bsxfun(@(x,y) abs(x-y), A(:), reshape(B1(:,:,2),1,[]));
     TMP2 = bsxfun(@(x,y) abs(x-y), A(:), reshape(B2(:,:,2),1,[]));
     [D1, idxB1] = min(TMP1,[],2);
     [D2, idxB2] = min(TMP2,[],2);
     B1 = B1(idxB1,:,:);
     B2 = B2(idxB2,:,:);
     reduce_redundant_points(1,idx_other(1)) ={B1};
     reduce_redundant_points(1,idx_other(2)) ={B2};
     meas = cellfun(@(x) x(:,:,1) , reduce_redundant_points ,'UniformOutput',false);
     move_mat = cat(2,meas{1,1},meas{1,2},meas{1,3});
end





%  figure();
%  plot(1:length(move_mat),move_mat(:,1));
%  hold on;
%  plot(1:length(move_mat),move_mat(:,2));
%  hold on;
%  plot(1:length(move_mat),move_mat(:,3));
