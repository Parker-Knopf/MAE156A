clear all; close all; clc;

%% Parameters

n_b = 8; % Number of Bolts on Flywheel
n_n = 2; % Number of Nuts on Bolt
pwm = 75; % Percent of PWM signal


%% Model

s = modelConfig(n_b, n_n, pwm);

fprintf("Model Accuracy: %.3f\n", s);