% Lab2B
clear all; close all; clc;

dataA = importdata("motor_flywheelA_data.csv");
dataB = importdata("motor_flywheelB_data.csv");
dataC = importdata("motor_flywheelC_data.csv");
dataC2 = importdata("motor_flywheelC2_data.csv");

config = {dataB, dataC, dataC2};
for j = 1:length(config)

    data = cell2mat(config(j));
    time = data(:, 1) ./ 10^6; % min

    % cpr
    cpr = 211.2 / 4.4;
    data = data(:, 2) ./ cpr;

    w = zeros(length(data), 1);
    for i = 1:length(data)-1
        w(i) = (data(i+1) - data(i)) / (time(i+1) - time(i));
    end
    
    w = w(:) .* 60; % RMP
    
    t_f = 0.005;
    wf = zeros(length(data), 1);
    for i = 2:length(data)
        b = (time(i)-time(i-1)) / (time(i)-time(i-1) + t_f);
        wf(i) = b* w(i) + (1 - b) * wf(i-1);
    end
    
    hold on;
    plot(time, wf)

end

title("Various Motor Configurations RPM")
xlabel("Time (s)");
ylabel("RPM");
legend("ConfigB", "ConfigC (Wingnuts tangential)", "ConfigC (Wingnuts perpendicular)", "Location", "southeast");