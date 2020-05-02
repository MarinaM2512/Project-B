% med_filter_all_data("17_04",5);
B=load("..\measurements\17_04\Data_extraction_sit_N_swipe_L1_FILTERED_INIT");
sw_L=B.initialised;
%%
B=load("..\measurements\17_04\Data_extraction_sit_N_swipe_R1_FILTERED_INIT");
sw_R=B.initialised;
%%
B=load("..\measurements\17_04\Data_extraction_sit_N_sit_tap1_FILTERED_INIT");
tap=B.initialised;
%%
B=load("..\measurements\17_04\Data_extraction_sit_N_sit_side_ancle1_FILTERED_INIT");
sid_ancl=B.initialised;
%%
SL = repmat( "swipe L" ,1, length(sw_R));
SR = repmat( "swipe R" ,1, length(sw_L));
Tap = repmat( "Tap" ,1, length(tap));
Acncle = repmat( "Side Ancle" ,1, length(sid_ancl));
moves=cat(1,SL' , SR' ,Tap' ,Acncle');
meas=cat(1,sw_L, sw_R ,tap ,sid_ancl);
valid_idx = [1:10 ,15:19];
gyro_idx = 4:10;
Y = tsne(meas(:,gyro_idx));
gscatter(Y(:,1),Y(:,2),moves)