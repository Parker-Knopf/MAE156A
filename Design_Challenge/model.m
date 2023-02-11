function m = model(retract)
    % Geometric Constants
    
    c.l = 0;
    c.l_c = 0; % m
    c.l_p = 0;
    
    % Constant Friction Force
    t_f = 0; % N-m

    % Non-linear Friction Hook Torque
    t_fh = 0; % N-m

    m = centrifugalTorque(a, w, c) + dragTorque(a, w, c) - springTorque(a, c) - t_f;

    if (retract)
        m = m + t_fh;
    end
end