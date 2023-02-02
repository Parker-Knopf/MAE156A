clear all; close all; clc;

config = [[8, 2]; [4, 1]; [2, 1]; [4, 2]];
pwm = [100, 75, 50];

plot = true;

if (plot)
    subplot(length(config),length(pwm),1)
end

s = zeros(length(config), length(pwm));
for i = 1:length(config)
    for j = 1:length(pwm)

        if (plot)
            subplot(length(config),length(pwm), length(pwm)*(i-1) + j)
        end

        s(i,j) = modelConfig(config(i, 1), config(i, 2), pwm(j), plot);
    end 
end

if (plot)
    sgtitle("All Configurations: Model vs Results")
end

s = mean(s(:));

fprintf("Model Accuracy: %.4f\n", s);
