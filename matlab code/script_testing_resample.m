% accel_x, accel_y,accel_z ,gyro_x, gyro_y, gyro_z, 
% quat_w, quat_x, quat_y, quat_z,cal,cal,cal,cal, fsr0, fsr1 ,fsr2 ,fsr3, fsr4];
date="17_04";
movement_name = ["sit_N_swipe_L2"    "sit_N_swipe_R2" ...
                 "sit_N_sit_tap1"    "sit_N_sit_side_ancle2"];

for i= 1:length(movement_name)
    full_path=strcat("..\measurements\",date,"\","*",movement_name(i),"*","INIT.mat");
    DirList = dir(fullfile(full_path)); % all files with the name texeFileName
    listOfFiles = {DirList.name};
    fileName=strcat("..\measurements\",date,"\",listOfFiles{1});
    B=load(fileName);
    A=B.initialised;
    t=A(:,20);
    
    full_path_r=strcat("..\measurements\resample\",date,"\","*",movement_name(i),"*","INIT.mat");
    DirList_r = dir(fullfile(full_path_r)); % all files with the name texeFileName
    listOfFiles_r = {DirList_r.name};
    fileName_r=strcat("..\measurements\resample\",date,"\",listOfFiles_r{1});
    Br=load(fileName_r);
    Ar=Br.initialised;
    tr=Ar(:,20);
    
    figure(i);
    subplot(2,3,1);
    plot(t,A(:,1),tr,Ar(:,1));
    legend("1","r");
    title("accelX");
    subplot(2,3,2);
    plot(t,A(:,6),tr,Ar(:,6));
    legend("1","r");
    title("accelZ");
    subplot(2,3,3);
    plot(t,A(:,9),tr,Ar(:,9));
    legend("1","r");
    title("qaut_Y");
    subplot(2,3,4);
    plot(t,A(:,end-3),tr,Ar(:,end-3));
    legend("1","r");
    title("fsr2");
    subplot(2,3,5);
    plot(t,A(:,end-2),tr,Ar(:,end-2));
    legend("1","r");
    title("fsr3");
    subplot(2,3,6);
    plot(t,A(:,end-1),tr,Ar(:,end-1));
    legend("1","r");
    title("fsr4");
end

