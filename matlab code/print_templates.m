function print_templates(x,y,z,t,move_name)
% in one figure plot in each subplot one axie template. 
% subplot(3,1,1) : x template
% subplot(3,1,2) : y template
% subplot(3,1,3) : z template
% all tha templates belong to same movement in move_name
% INPUT:
% x- data of x template
% y- data of y template
% z- data of z template
% t- cell 1 X 3 in each cell times compatible with the data in x,y,z
% move_name - for title of figure. The movemant name we plot the template
% for.
figure;
    subplot(3,1,1);
    plot(t{1},x);
    title("X");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    subplot(3,1,2);
    plot(t{2},y);
    title("Y");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    subplot(3,1,3);
    plot(t{3},z);
    title("Z");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    sgtitle(move_name);
end
