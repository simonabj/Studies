M = 24;
N = 500;
P = ASAparameters;

DXs = [P.lambda/4 P.lambda/2 P.lambda 2*P.lambda];
ks = linspace(-1,1,N);
kx = 2*pi/P.lambda*ks;
weights = ones(M, 1);

figure(4);
t = tiledlayout(4,1);
titles = ["$1/4\lambda$","$1/2\lambda$","$\lambda$","$2\lambda$"];
for dx_idx = 1:numel(DXs)
    dx = DXs(dx_idx);
    D = M*dx;
    xpos = linspace(-D/2, D/2, M);
    
    W = beampattern(xpos, kx, weights);

    nexttile, plot(ks, db(abs(W)))
    title(titles(dx_idx), "Interpreter","latex", "FontSize",15)
end
xlabel(t, "$k_x$", "Interpreter","latex", "FontSize",18);
ylabel(t, "Response [dB]", "FontSize", 14)
style_plot(gcf(), "nord");
exportgraphics(gcf, "4.pdf", "BackgroundColor", "none", "ContentType", "vector")
