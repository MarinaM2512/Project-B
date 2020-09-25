%% fit a 3D curve for each movement 
date = "17_04";
list_moves = get_all_meas_names(date,"FILTERED_INIT" ,1);
%init
times = cell(length(list_moves),1);
Gyro_side = zeros(1,3);
Gyro_SL =zeros(1,3);
Gyro_SR =zeros(1,3);
Gyro_tap = zeros(1,3);
Gyro_other = zeros(1,3);
% for all measurments join all the movemnts of the same type together 
for i = 1:length(list_moves)
   data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT");
   [to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,list_moves{i},10000,500,7,7);  
   move_gyro(i,1:3) = [{to_avgX} {to_avgY} {to_avgZ}] ;
   [move,~,time] = detect_movement(move_gyro(i,1:3));
   times(i,1) = {time};
   move_gyro(i,1) = {move};
   if(contains(list_moves{i},"tap"))
       Gyro_tap = cat(1,Gyro_tap,move);
   elseif(contains(list_moves{i},"ancle"))
       Gyro_side = cat(1,Gyro_side,move);
   elseif(contains(list_moves{i},"swipe_L"))
       Gyro_SL = cat(1,Gyro_SL,move);
   elseif(contains(list_moves{i},"swipe_R"))
       Gyro_SR = cat(1,Gyro_SR,move);
   else
       Gyro_other = cat(1,Gyro_other,move);
   end
end
%% Plot data with principle vectors and save them
[vecsAnc , ~]=pca(Gyro_side);
[vecsSL , ~]=pca(Gyro_SL);
[vecsSR , ~]=pca(Gyro_SR);
[vecsTap , ~]=pca(Gyro_tap);
figure;
plot3(Gyro_tap(:,1),Gyro_tap(:,2), Gyro_tap(:,3),'bo');
hold on;
plot3(Gyro_side(:,1),Gyro_side(:,2), Gyro_side(:,3),'ro');
hold on;
plot3(Gyro_SR(:,1),Gyro_SR(:,2), Gyro_SR(:,3),'go');
hold on;
plot3(Gyro_SL(:,1),Gyro_SL(:,2), Gyro_SL(:,3), 'mo');
hold on;
plot3(Gyro_other(:,1),Gyro_other(:,2), Gyro_other(:,3), 'o');
hold on;
legend('tap', 'side ancle', 'swipe right', 'swipe left' , 'walking');
xlabel('x');
ylabel('y');
zlabel('z');
 plot3(500*[-vecsAnc(1,1) -vecsSL(1,1) -vecsSR(1,1) -vecsTap(1,1);vecsAnc(1,1),vecsSL(1,1),vecsSR(1,1) ,vecsTap(1,1)],...
     500*[-vecsAnc(2,1) -vecsSL(2,1) -vecsSR(2,1) -vecsTap(2,1);vecsAnc(2,1),vecsSL(2,1),vecsSR(2,1) ,vecsTap(2,1)],...
     500*[-vecsAnc(3,1) -vecsSL(3,1) -vecsSR(3,1) -vecsTap(3,1);vecsAnc(3,1),vecsSL(3,1),vecsSR(3,1) ,vecsTap(3,1)]);
ank =  vecsAnc(:,1);
swl =  vecsSL(:,1);
swr =  vecsSR(:,1);
tap =  vecsTap(:,1);
%save first principal vector (with the largest data variance) for each
%movemnt type a weights
name = ["swl" "swr" "tap" "ank"];
for i = 1:4
    mat_name=strcat(".\templates\",name(i),"_principle_vec",".mat");
    save(mat_name,name(i));
end