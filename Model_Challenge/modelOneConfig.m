clear all; close all; clc;

%% Parameters

n_b = 4; % Number of Bolts on Flywheel
n_n = 1; % Number of Nuts on Bolt
pwm = 50; % Percent of PWM signal


%% Model

s = modelConfig(n_b, n_n, pwm);

fprintf("Model Accuracy: %.3f\n", s);