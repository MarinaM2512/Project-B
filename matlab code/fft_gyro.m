close all; clc;
%%
date = "17_04";
movement_name = ["sit_N_swipe_L2"    "sit_N_swipe_R2" ...
                 "sit_N_tap1"    "sit_N_side_ancle2"];

             
for i = 1:length(movement_name)
    [to_avgX, to_avgY, to_avgZ] = ...
    join_measurments_of_movements(date,movement_name(i),10000,500,10,7);
    figure();
    plot_fft(to_avgX);
    grid on;
    plot_fft(to_avgY);
    plot_fft(to_avgZ);
    legend('x','y','z');
    sgtitle(movement_name(i));
end

%% functions
function plot_fft(joined_data)
% input arguments:
% joined_data - matrix of one parameter in the segmented data
%               in each col the movement is "pure" ( signal without margines )
%         dims: length of movment X num of muvments X data type
%               joined_data(:,:,1)- sampled data
%               joined_data(:,:,2)- time stemps
% output:
% function resample data with even sample time and plots DFT by fft algorithem
% the output is figure in each subplot appears DFT for each movment
v = joined_data(:,:,1);
t = joined_data(:,:,2);
for i=1:size(t,2)
    tr = linspace(min(t(:,i)), max(t(:,i)), size(t,1)); % Uniformly-Sampled Time Vector
    vr = resample(v(:,i), tr);                          % Resampled Signal Vector
    L = length(tr);                                     % Signal Length
    Ts = 1e-3 * mean(diff(tr));                         % Sampling Interval
    Fs = 1/Ts;                                          % Sampling Frequency
    Fn = Fs/2;                                          % Nyquist Frequency
    FTvr = fft(vr)/L;                                   % Fourier Transform
    Fv = linspace(0, 1, fix(L/2)+1)*Fn;                 % Frequency Vector
    Iv = 1:length(Fv);                                  % Index Vector
    subplot(2,5,i);
    plot(Fv, abs(FTvr(Iv))*2)
    txt=['movment num ',num2str(i)];
    title(txt);
    hold on;
    grid on;
end
end