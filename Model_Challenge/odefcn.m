function dydt = odefcn(t, y, J, t_s, w_tv, n, n_b, n_n)
    % Return numerical solution to be used with ODE45
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = (1 / J) * ((t_s *(1 - y(2)/w_tv)) - torqueDrag(y(2), n, n_b, n_n) - stallTorqueFriction(n, n_b, n_n));
end