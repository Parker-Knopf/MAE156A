clear all; close all; clc;

config = [[8, 2]; [4, 1]; [2, 1]; [4, 2]];
pwm = [100, 75, 50];

subplot(length(config),length(pwm),1)

s = zeros(length(config), length(pwm));
for i = 1:length(config)
    for j = 1:length(pwm)

        subplot(length(config),length(pwm), length(pwm)*(i-1) + j)

        s(i,j) = modelConfig(config(i, 1), config(i, 2), pwm(j));
    end 
end

sgtitle("All Configurations: Model vs Results")

s = mean(s(:));

fprintf("Model Accuracy: %.3f\n", s);
