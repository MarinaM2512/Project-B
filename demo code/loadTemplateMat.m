function template_mat = loadTemplateMat 
%%Goal: get templates from file same length templates
% and load as matrix from mat file 
%%Return parameters:
% template_mat: cell of templates for all movments
%  template_mat{1} - swipe left template
%  template_mat{2} - swipe right template
%  template_mat{3} - tap template
%  template_mat{4} - side anckle template
% all template at same size
num_of_movements = 4;
template_mat = cell(1,num_of_movements);
template_mat{1} = load("./same length templates/swl_template").paded1;
template_mat{2} = load("./same length templates/swr_template").paded2;
template_mat{3} = load("./same length templates/tap_template").paded3;
template_mat{4} = load("./same length templates/ank_template").paded4;
end
