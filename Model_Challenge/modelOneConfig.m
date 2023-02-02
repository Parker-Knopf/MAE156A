clear all; close all; clc;

%% Parameters

n_b = 8; % Number of Bolts on Flywheel
n_n = 2; % Number of Nuts on Bolt
pwm = 75; % Percent of PWM signal

plot = true; % Plot data bool

%% Model

s = modelConfigOne(n_b, n_n, pwm, plot);

fprintf("Model Accuracy: %.3f\n", s);