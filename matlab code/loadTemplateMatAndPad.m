function template_mat = loadTemplateMatAndPad
%%Goal: get requaired measurment matrix from mat file 
%%Return:
% template_mat: cell of templates for all movments
%  template_mat{1} - swipe left template
%  template_mat{2} - swipe right template
%  template_mat{3} - tap template
%  template_mat{4} - side anckle template
% all template at same size
num_of_movements = 4;
template_mat = cell(1,num_of_movements);
t1 = load("./templates/swl_template").swl;
t2 = load("./templates/swr_template").swr;
t3 = load("./templates/tap_template").tap;
t4 = load("./templates/ank_template").ank;
[paded1, paded2, paded3, paded4] = pad_template_to_same_size(t1,t2,t3,t4);
template_mat{1} = paded1;
template_mat{2} = paded2;
template_mat{3} = paded3;
template_mat{4} = paded4;
end
