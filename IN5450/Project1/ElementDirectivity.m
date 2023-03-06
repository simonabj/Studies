P = ASAparameters;
M = 24;
N = 1000;

% d=lambda
figure(11);
subplot(2,1,1);
d = P.lambda;
xpos = linspace(-d*M/2, d*M/2, M);
ks = linspace(-1,1,N); % sin(theta)
kx = 2*pi/P.lambda*ks;
weights = ones(M, 1);
weights = weights/sum(weights(:));

We = sin(kx*d/2) ./ (kx / 2);
Wa = beampattern(xpos, kx, weights);
Wtot = We.'.*Wa;


plot(ks, db(abs(Wa)/max(abs(Wa))));
hold on;
plot(ks, db(abs(Wtot)/max(abs(Wtot))));
hold off;
legend(["Single Point", "Finite width"]);
ylim([-60 0])
xlabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 14)
ylabel("Response [dB]")
title("Array pattern with finite element size $d=\lambda$", ...
    "Interpreter","latex", "FontSize", 14);
style_plot(gcf(), "nord");

% d = 2lambda
subplot(2,1,2);
d = 2*P.lambda;
xpos = linspace(-d*M/2, d*M/2, M);
ks = linspace(-1,1,N); % sin(theta)
kx = 2*pi/P.lambda*ks;
weights = ones(M, 1);
weights = weights/sum(weights(:));

We = sin(kx*d/2) ./ (kx / 2);
Wa = beampattern(xpos, kx, weights);
Wtot = We.'.*Wa;

plot(ks, db(abs(Wa)/max(abs(Wa))))
hold on;
plot(ks, db(abs(Wtot)/max(abs(Wtot))))
hold off;
legend(["Single Point", "Finite width"])
ylim([-60 0])
xlabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 14)
ylabel("Response [dB]")
title("Array pattern with finite element size $d=2\lambda$", ...
    "Interpreter","latex", "FontSize", 14);
style_plot(gcf(), "nord");
exportgraphics(gcf, "11.pdf", "BackgroundColor", "none", "ContentType", "vector")

%% Introduce steering
k0 = sin(-pi/6);

% d=lambda
figure(12);
subplot(2,1,1);
d = P.lambda;
xpos = linspace(-d*M/2, d*M/2, M);
ks = linspace(-1,1,N); % sin(theta)
kx = 2*pi/P.lambda*(ks-k0);
weights = ones(M, 1);
weights = weights/sum(weights(:));

We = sin(kx*d/2) ./ (kx / 2);
Wa = beampattern(xpos, kx - k0, weights);
Wtot = We.'.*Wa;


plot(ks, db(abs(Wa)/max(abs(Wa))));
hold on;
plot(ks, db(abs(Wtot)/max(abs(Wtot))));
hold off;
legend(["Single Point", "Finite width"]);
ylim([-60 0])
xlabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 14)
ylabel("Response [dB]")
title("Array pattern with finite element size $d=\lambda$ steered to $\theta=-30^\circ$", ...
    "Interpreter","latex", "FontSize", 14);
style_plot(gcf(), "nord");

% d = 2lambda
subplot(2,1,2);
d = 2*P.lambda;
xpos = linspace(-d*M/2, d*M/2, M);
ks = linspace(-1,1,N); % sin(theta)
kx = 2*pi/P.lambda*(ks-k0);
weights = ones(M, 1);
weights = weights/sum(weights(:));

We = sin(kx*d/2) ./ (kx / 2);
Wa = beampattern(xpos, kx, weights);
Wtot = We.'.*Wa;

plot(ks, db(abs(Wa)/max(abs(Wa))))
hold on;
plot(ks, db(abs(Wtot)/max(abs(Wtot))))
hold off;
legend(["Single Point", "Finite width"])
ylim([-60 0])
xlabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 14)
ylabel("Response [dB]")
title("Array pattern with finite element size $d=2\lambda$ steered to $\theta=-30^\circ$", ...
    "Interpreter","latex", "FontSize", 14);
style_plot(gcf(), "nord");
exportgraphics(gcf, "12.pdf", "BackgroundColor", "none", "ContentType", "vector")

