clear all; close all; clc;

config = [[8, 2]; [4, 1]; [2, 1]; [4, 2]];
pwm = [100, 75, 50];

plot = false;

if (plot)
    subplot(length(config),length(pwm),1)
end
jma = linspace(4.5*10^(-7), 4.5*10^(-7), 1);
mewa = linspace(.16,.16,1);
cda = linspace(25, 25, 1);
o=1;
p=1;
s = zeros(length(config), length(pwm));
for i = 1:length(config)
    for j = 1:length(pwm)
        for k=1:length(jma)
            for l=1:length(mewa)
                for m=1:length(cda)
                    if (plot)
                        subplot(length(config),length(pwm), length(pwm)*(i-1) + j)
                    end
                    Jm=jma(m);
                    mew=mewa(l);
                    Cad=cda(k);

                    s(p,o) = modelConfig(config(i, 1), config(i, 2), pwm(j), plot,mew,Jm,Cad)
                    p=p+1;
                end
            end
        end
        p=1;
        o=o+1;
    end 
end

if (plot)
    sgtitle("All Configurations: Model vs Results")
end
% for i=1:1000
%     b(i) = mean(s(i,:));
% end



%fprintf("Model Accuracy: %.3f\n", b);
