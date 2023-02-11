function t_d = dragTorque(a, w, c)
    % Constants
    c_d = 0;
    p = 0;
    t = 0;

    ang1 = @(x) 180 - angle(c.l_p, x, a);
    ang2 = @(x) angle(c.l_p, x, a);
    s1 = @(x) side(x, c.l_p, (180 - a - ang1(x)));
    s2 = @(x) side(x, c.l_p, (180 - a - ang2(x)));
    fuc1 = @(x) abs(x^2 * s1(x) * sin(ang1(x)));
    fuc2 = @(x) abs(x^2 * s2(x) * sin(ang2(x)));

    s0 = c.l_p;
    s1 = c.l_p * sin(a);
    s2 = side(c.l, c.l_p, a);

    t_d = c_d * p * t / 2 * w^2 * (integral(fuc1, s1, s2) + integral(fuc2, s1, s0));
end