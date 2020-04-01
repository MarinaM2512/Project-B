function [fil1,fil2,fil3,fil4,fil5]=median_filt(data,x1,x2,n)
    arguments
        data (:,3,:) double
        x1   (:,1,:) double
        x2   (:,1,:) double
        n  double
    end
fil1=medfilt1(data(:,1,:),n);
fil2=medfilt1(data(:,2,:),n);
fil3=medfilt1(data(:,3,:),n);
fil4=medfilt1(x1,n);
fil5=medfilt1(x2,n);
end