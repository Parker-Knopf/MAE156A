function t_d = torqueDrag(w, n, n_b, n_n)
    d = 1.293; % kg / m^3
    cd_b = 0.1;
    b_r = 6.2/2/1000; % m
    b_l = 20/1000; % m
    bh_l = 5/1000; % m
    cd_n = 0.8;
    n_r = 11.6/2/1000; % m
    n_l = 6/1000; % m
    f_r2 = 2 * 0.0254;

    w = w * f_r2; % Convert from radial to linear velocity

    % Bolt Heads
    f_bh = cd_n * (bh_l) * n_r;
    % Bolts
    f_b = cd_b * (b_l - n_n * n_l) * b_r;
    % Nuts
    f_n = cd_n * (n_n * n_l) * n_r;
    % Total
    t_d = (f_b + f_n + f_bh) * d * n_b * w^2 * f_r2^3 / n * 37;
end