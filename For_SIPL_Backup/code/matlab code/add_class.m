function labels_out = add_class(labels_in)
% func adds non-movment-class
% when a row in labels has num_of_movement zeros 
or_result = labels_in(:,1) | labels_in(:,2) | labels_in(:,3) | labels_in(:,4);
vec =(~or_result);

labels_out = cat(2,labels_in,vec);
    
end