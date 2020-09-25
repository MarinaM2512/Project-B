function PadTemplateMatAndSave
%%Goal: pad template of all moves to be at same size and save
% all template at same size
% num_of_movements = 4;
% template_mat = cell(1,num_of_movements);
t1 = load("./templates/swl_template").swl;
t2 = load("./templates/swr_template").swr;
t3 = load("./templates/tap_template").tap;
t4 = load("./templates/ank_template").ank;
[paded1, paded2, paded3, paded4] = pad_template_to_same_size(t1,t2,t3,t4);
% template_mat{1} = paded1;
% template_mat{2} = paded2;
% template_mat{3} = paded3;
% template_mat{4} = paded4;
name = ["swl" "swr" "tap" "ank"];

    mat_name1=strcat(".\same length templates\",name(1),"_template",".mat");
    save(mat_name1,"paded1");
    
     mat_name2=strcat(".\same length templates\",name(2),"_template",".mat");
    save(mat_name2,"paded2");
    
     mat_name3=strcat(".\same length templates\",name(3),"_template",".mat");
    save(mat_name3,"paded3");
    
     mat_name4=strcat(".\same length templates\",name(4),"_template",".mat");
    save(mat_name4,"paded4");

end
