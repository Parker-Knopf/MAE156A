function [time, wf] = expVelocityPlot(data)

    time = data(:, 1) ./ 10^6; % min
    
    % cpr
    cpr = 211.2/4.4;
    data = data(:, 2) ./ cpr;
    
    % Take derivative of data
    w = zeros(length(data), 1);
    for i = 1:length(data)-1
        w(i) = (data(i+1) - data(i)) / (time(i+1) - time(i));
    end
    
    w = w(:) .* 60; % RMP
    
    % Filter Data
    t_f = 0.005;
    wf = zeros(length(data), 1);
    for i = 2:length(data)
        b = (time(i)-time(i-1)) / (time(i)-time(i-1) + t_f);
        wf(i) = b* w(i) + (1 - b) * wf(i-1);
    end

end