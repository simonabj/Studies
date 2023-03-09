%% Beamwidth for kx
M = 24;
N = 5000;
P = ASAparameters;
D = M*d;
xpos = linspace(-D/2, D/2, M);

DXs = [P.lambda/4 P.lambda/2 P.lambda 2*P.lambda];
ks = linspace(-1,1,N);
kx = 2*pi/P.lambda*ks;

weights = ones(M, 1);

% Array "Case B"
n = 1:2:24;
d  = P.lambda/2; % Corresponding to lambda/2
e_n = [-0.017 -0.538 -0.617 -1.000 -1.142 -1.372 -1.487 ...
       -1.555 -1.537 -1.300 -0.772 -0.242];

d_n = (n/2 + e_n)*d;
ElPos = [-fliplr(d_n) d_n];

Wold = beampattern(xpos, kx, weights);
W = beampattern(ElPos, kx, weights);

figure(6);
plot(ks, db(abs(Wold)/max(abs(Wold))));
hold on; plot(ks, db(abs(W)/max(abs(W(:))))); hold off;
grid on; title("Array pattern of irregular linear array")
ylim([-50 0])
xlabel("$\sin(\theta)$", "Interpreter","latex", "FontSize",18);
ylabel("Response [dB]", "FontSize", 14)
legend(["ULA", "Irregular"])
style_plot(gcf(), "nord");
exportgraphics(gcf, "6a.pdf", "BackgroundColor", "none", "ContentType", "vector")

%% Mainlobe width, sidelobe height and gain

% Array
d = P.lambda/2; % Corresponding to lambda/2
e_n = [-0.017 -0.538 -0.617 -1.000 -1.142 -1.372 -1.487 ...
       -1.555 -1.537 -1.300 -0.772 -0.242];

d_n = (n/2 + e_n)*d;
ElPos = [-fliplr(d_n) d_n];

M = numel(ElPos);
a = exp(-1j * ElPos.' * 0);

betas = 0:0.5:5;

win = ones(M,1);

norm_win = win/sum(win(:));
W = beampattern(ElPos, kx, norm_win);

analyze = analyzeBP(ks, W);
    
GW = (norm(a * W')^2) / (W'*W);

%% Steering (7)
N = 5000;
ks = linspace(-2, 2, N);
kx = 2*pi/P.lambda*ks;
k0 = pi/(3*d);
norm_win=weights/sum(weights(:));
W1 = beampattern(ElPos, kx - k0, norm_win);
W2 = beampattern(ElPos, kx, norm_win);

figure(8);close(8);figure(8);
hold on;
plot(ks, db(abs(W2)), "LineWidth", 0.7);
plot(ks, db(abs(W1)), "LineWidth", 0.7);
hold off;
legend(["Unsteered", "Steered 60deg"]);
xlabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 15);
ylabel("Response [dB]");
title("Non-uniform linear array steered by 60deg")
ylim([-50 0])
style_plot(gcf(), "nord");
exportgraphics(gcf, "7a.pdf", "BackgroundColor", "none", "ContentType", "vector")

%% Steering Uniform array (7.2)
W1 = beampattern(xpos, kx - k0, norm_win);
W2 = beampattern(xpos, kx, norm_win);

figure(9);close(9);figure(9);
hold on;
plot(ks, db(abs(W2)), "LineWidth", 0.7);
plot(ks, db(abs(W1)), "LineWidth", 0.7);
hold off;
legend(["Unsteered", "Steered 60deg"]);
xlabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 15);
ylabel("Response [dB]");
title("Uniform linear array steered by 60deg");
ylim([-50 0]);
style_plot(gcf(), "nord");
exportgraphics(gcf, "7b.pdf", "BackgroundColor", "none", "ContentType", "vector")

%% Compute (8)

N = 500;
ks = linspace(-1,1,N);
kx = 2*pi/P.lambda*ks;
k0 = linspace(-pi/d, pi/d, N);
k0 = k0(100:400);

comp3 = zeros(numel(k0), 2); % (-3db, -6db)

for idx = 1:numel(k0)
    W = beampattern(ElPos, kx - k0(idx), norm_win);
    analyze = analyzeBP(ks, W);
    comp3(idx, :) = [analyze.Three_dB, analyze.Six_dB];
end

%% Report (8.1)

figure(10);

y_lim1 = [0.95*min(comp3(:)) 1.05*max(comp3(:))];
y_lim2 = rad2deg(asin(y_lim1));

sin_theta = k0*(d/2); 
x1 = sin_theta;
y1 = comp3(:, 1);
y2 = comp3(:, 2);
grid on;
yyaxis left;
plot(x1,comp3(:,:), "Color", "#D95319");
legend(["-3dB" "-6dB"]);

ylim(y_lim1);
xlabel("Steering angle $[\sin( \theta )]$", "Interpreter","latex");
ylabel("k");

yyaxis right;
ylim(y_lim2);
ylabel("deg", "Interpreter","latex");
title("-3dB Width of mainlobe with steering");
style_plot(gcf(), "nord");
exportgraphics(gcf, "8.pdf", "BackgroundColor", "none", "ContentType", "vector");