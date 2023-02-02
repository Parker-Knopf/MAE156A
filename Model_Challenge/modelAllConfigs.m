clear all; close all; clc;

config = [[8, 2]; [4, 1]; [2, 1]; [4, 2]];
pwm = [100, 75, 50];

plot = false;

if (plot)
    subplot(length(config),length(pwm),1)
end
jma = linspace(3.5*10^(-7), 5.5*10^(-7), 20);
mewa = linspace(.11,.20,20);
cda = linspace(24, 33, 20);

%cda=cda(14);
%mewa=mewa(1);
%jma=jma(5);

tot=length(mewa)*length(cda)*length(jma);

o=1;
p=1;
indx=zeros(tot,3);
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

                    s(p,o) = modelConfig(config(i, 1), config(i, 2), pwm(j), plot,mew,Jm,Cad);
                    indx(p,:)=[m,l,k];
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
for i=1:tot
    b(i) = mean(s(i,:));
end
[M,I]=min(b)
c=[indx(I,:)];
CDnew=cda(c(3))
Mewnew=mewa(c(2))
Jmnew=jma(c(1))

fprintf("Model Accuracy: %.3f\n", M);
