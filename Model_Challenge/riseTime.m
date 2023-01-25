function rise_t = riseTime(fv, time, data)
    val = (exp(1) -1) / exp(1);
    for i = 1:length(data)
        if data(i) >= val * fv
            rise_t = time(i);
            break
        end
    end
end