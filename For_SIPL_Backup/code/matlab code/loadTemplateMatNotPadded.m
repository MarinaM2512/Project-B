function template_mat = loadTemplateMatNotPadded 
%%Goal: get templates from file and load as matrix from mat file 
%%Return parameters:
% template_mat: cell of templates for all movments
%  template_mat{1} - swipe left template
%  template_mat{2} - swipe right template
%  template_mat{3} - tap template
%  template_mat{4} - side anckle template
num_of_movements = 4;
template_mat = cell(1,num_of_movements);
template_mat{1} = load("./templates/swl_template").swl;
template_mat{2} = load("./templates/swr_template").swr;
template_mat{3} = load("./templates/tap_template").tap;
template_mat{4} = load("./templates/ank_template").ank;
end