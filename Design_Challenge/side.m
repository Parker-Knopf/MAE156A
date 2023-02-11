function s = side(l1, l2, ang)
    s = sqrt(l1^2+l2^2-2*l1*l2*cos(ang));
end