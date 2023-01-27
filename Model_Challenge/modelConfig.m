function [s] = modelConfig(n_b, n_n, pwm)
    %% Given Parameters
    
    data1 = importdata(sprintf("Data/data_motor_b%d_n%d_pwm%d_t1.csv", n_b, n_n, pwm));
    data2 = importdata(sprintf("Data/data_motor_b%d_n%d_pwm%d_t2.csv", n_b, n_n, pwm));
    
    % Set frame of view (time)
    t_end = 10; % s
    
    % Gear Ratio
    n = 4.43;
    
    %% Parameters
    
    % Stall Torque
    t_s = (0.17 * 9.81 / 100); % Nm
    t_s = t_s * pwm / 100; % PWM Load
    
    % Inertia
    J = inertia(n, n_b, n_n);
    
    % Motor parameters
    V_eff = 12 * pwm /100; % Effective Voltage
%     w_nl = 7910.21; % Pratical No-load Speed
    w_nl = 8200; % Pratical No-load Speed
    
    K = 12 / (w_nl * (2*pi) / 60);
    
    % Pratical Terminal Velocity
    w_tv = V_eff / K; % rads / s
    
    %% Numerical Solution
    
    % Set frame of view (time)
    tspan = [0, t_end];
    % Inital conditions
    y0 = [0, 0];
    
    % Numerical solution defiition
    [t, y] = ode45(@(t,y) odefcn(t, y, J, t_s, w_tv, n, n_b, n_n), tspan, y0);
    
    % Set correct units
    y(:,2) = y(:,2) ./ (2*pi) * 60; % rpm
    
    f_v_m = terminalVelocity(y(:,2));
    t_r_m = riseTime(f_v_m, t, y(:,2)) * 1000; % ms

    t = t(:) * 1000; % ms
    plot(t, y(:,2));
    
    %% Theoretical Results
    
    fprintf("Theoretical Results for %d bolts, %d nuts at %d PWM:\n", n_b, n_n, pwm);
    fprintf("Rise Time: %.3f\n", t_r_m);
    fprintf("Terminal Velocity: %.3f\n\n", f_v_m);
    
    %% Experimental Results
    
    [t1, wf1] = expVelocityPlot(data1);
    [t2, wf2] = expVelocityPlot(data2);
    
    f_v1 = terminalVelocity(wf1);
    f_v2 = terminalVelocity(wf2);
    f_v_r = (f_v1 + f_v2) / 2.0;
    
    t_r_r = (riseTime(f_v1, t1, wf1) + riseTime(f_v2, t2, wf2)) / 2 * 1000; % ms
    
    fprintf("Experimental Results for %d bolts, %d nuts at %d PWM:\n", n_b, n_n, pwm);
    fprintf("Rise Time: %.3f\n", t_r_r);
    fprintf("Terminal Velocity: %.3f\n\n", f_v_r);
    fprintf("------------------------\n");
    
    hold on;
    t1 = t1(:) * 1000;
    plot(t1, wf1);

    %% S

    s = abs(t_r_m - t_r_r)/t_r_r + 4*abs(f_v_m - f_v_r)/f_v_r;
    
    %% Plot
    
    title(sprintf("%d Bolts, %d Nuts at %d PWM", n_b, n_n, pwm));
    xlabel("Time (ms)");
    ylabel("RPM");
    legend("Theory", "Experimental Results", "Location", "southeast");
end