function dydt = odefcn(t, y, J, t_s, w_nl)
    % Return numerical solution to be used with ODE45
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = (t_s / J) * (1 - y(2)/w_nl);
end