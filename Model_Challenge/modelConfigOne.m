function [s] = modelConfigOne(n_b, n_n, pwm, ploting)
    %% Given Parameters

    % Indiviusal Figures if desired
%     fig = figure(1);
%     clf(fig);
    
    data1 = importdata(sprintf("Data/data.csv"));
%     data2 = importdata(sprintf("Data/data_motor_b%d_n%d_pwm%d_t2.csv", n_b, n_n, pwm));
    
    % Set frame of view (time)
    t_end = 10; % s
    
    % Gear Ratio
    n = 4.43;
    
    %% Parameters
    
    % Stall Torque
    t_s = (0.175 * 9.81 / 100); % Nm
    t_s = t_s * pwm / 100; % PWM Load
    
    % Inertia
    J = inertia(n, n_b, n_n);
    
    % Motor parameters
    V_eff = 12 * pwm /100; % Effective Voltage
%     w_nl = 7910.21; % Pratical No-load Speed
    w_nl = 8100; % Pratical No-load Speed
    
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

    if (ploting)
        t = t(:) * 1000; % ms
        plot(t, y(:,2), "color", "blue");
        yline(f_v_m, "color", "cyan");
        xline(t_r_m, "color", "cyan");
    end
    
    %% Theoretical Results
    
    if (ploting)
        fprintf("Theoretical Results for %d bolts, %d nuts at %d PWM:\n", n_b, n_n, pwm);
        fprintf("Rise Time: %.3f\n", t_r_m);
        fprintf("Terminal Velocity: %.3f\n\n", f_v_m);
    end
    
    %% Experimental Results
    
    [t1, wf1] = expVelocityPlot(data1);
%     [t2, wf2] = expVelocityPlot(data2);
    
    f_v1 = terminalVelocity(wf1);
%     f_v2 = terminalVelocity(wf2);
%     f_v_r = (f_v1 + f_v2) / 2.0;
    f_v_r = f_v1;
    
%     t_r_r = (riseTime(f_v1, t1, wf1) + riseTime(f_v2, t2, wf2)) / 2 * 1000; % ms
    t_r_r = riseTime(f_v1, t1, wf1) * 1000; % ms
    
    if (ploting)
        fprintf("Experimental Results for %d bolts, %d nuts at %d PWM:\n", n_b, n_n, pwm);
        fprintf("Rise Time: %.3f\n", t_r_r);
        fprintf("Terminal Velocity: %.3f\n\n", f_v_r);
        fprintf("------------------------\n");
        
        hold on;
        t1 = t1(:) * 1000;
        plot(t1, wf1, "color", "red");
        yline(f_v_r, "color", "yellow");
        xline(t_r_r, "color", "yellow");
    end

    %% S

    s = abs(t_r_m - t_r_r)/t_r_r + 4*abs(f_v_m - f_v_r)/f_v_r;
    
    %% Plot

    if (ploting)
        title(sprintf("%d Bolts, %d Nuts at %d PWM", n_b, n_n, pwm));
        xlabel("Time (ms)");
        ylabel("RPM");
        legend("Theory", "Theory t_r, f_v", "", "Experimental Results", "Experimental t_r, f_v", "Location", "southeast");
        % Save Indiviusal Figures if desired
%         saveas(fig, sprintf("Figures/b_%dn_%dpwm_%d.png", n_b, n_n, pwm))
    end
end