function print_templates(x,y,z,t,move_name)
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
