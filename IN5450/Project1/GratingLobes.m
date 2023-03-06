%% Task 4
M = 24;
N = 5000;
P = ASAparameters;

DXs = [P.lambda/4 P.lambda/2 P.lambda 2*P.lambda];
ks = linspace(-1,1,N); % sin(theta)
kx = 2*pi/P.lambda*ks;
weights = ones(M, 1);

figure(4);
t = tiledlayout(2,2, "TileSpacing", "tight");
titles = ["$1/4\lambda$","$1/2\lambda$","$\lambda$","$2\lambda$"];
for dx_idx = 1:numel(DXs)
    dx = DXs(dx_idx);
    D = M*dx;
    xpos = linspace(-D/2, D/2, M);
    
    W = beampattern(xpos, kx, weights);

    nexttile, plot(ks, db(abs(W)/max(abs(W))))
    title(titles(dx_idx), "Interpreter","latex", "FontSize",15)
    ylim([-50 0])
end
xlabel(t, "$k_x$", "Interpreter","latex", "FontSize",18);
ylabel(t, "Response [dB]", "FontSize", 14)
style_plot(gcf(), "nord");
exportgraphics(gcf, "4.pdf", "BackgroundColor", "none", "ContentType", "vector")

%% Task 5.1

% Array
M = 24;
d = P.lambda/2;
D = M*d;
xpos = linspace(-D/2, D/2, M);

tau = cos(linspace(0,pi,N)) * d / P.c;
a = exp(-1j*kx.*tau).';

betas = 0:0.5:5;
comp = zeros(size(betas, 2), 4); % (-3, -6, side, GW)

for beta_idx = 1:numel(betas)
    beta = betas(beta_idx);
    win = kaiser(M, beta);
    norm_win = win / sum(win(:));
    W = beampattern(xpos, kx, norm_win);

    analyze = analyzeBP(ks, W);

    GW = 1 / norm(norm_win)^2;

    comp(beta_idx, :) = [analyze.Three_dB, analyze.Six_dB, analyze.maxSL, GW];
end

figure(5);
t = tiledlayout(2,2, "TileSpacing", "tight");
nexttile, plot(betas, comp(:,1)); xlim([0 5]);
title("-3 dB width [sin(θ)]");
nexttile, plot(betas, comp(:,2)); xlim([0 5]);
title("-6 dB width [sin(θ)]")
nexttile, plot(betas, comp(:,3)); xlim([0 5]);
title("Sidelobe height [dB]")
nexttile, plot(betas, comp(:,4)); xlim([0 5]);
title("White noise gain")
xlabel(t, "$\beta$", "Interpreter", "latex", "FontSize", 18)
ylabel(t, "Value", "FontSize", 14)
style_plot(gcf(), "nord")
exportgraphics(gcf, "5.pdf", "BackgroundColor", "none", "ContentType", "vector")
