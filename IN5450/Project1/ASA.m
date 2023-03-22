%
% Script that sets up and runs an anglular spectrum approach simulation
%

%%%%%%%%%%%%%%%%%%
% Parameters read from file

P = ASAparameters;

%%%%%%%%%%%%%%%%%%
% Source, i.e. U(x,y,z_0), defined in separate function

% U0 = ASAsource(P,'piston',15*P.lambda);

U0 = ASAsource(P,'square',15*P.lambda);

%%%%%%%%%%%%%%%%%%
% Define propagator for distance (z-z0)
z = 0.08; % [m]
Prop = ASApropagator(P,z);

U = ifft2t(fft2t(U0).*Prop);
%%
figure(1); imagesc(P.ax,P.ay,db(abs(U))); 
CA = caxis; caxis(CA(2) + [-40 0]); colorbar;
xlabel('x [m]'); ylabel('y [m]'); 
title(['Wave field at depth z = ',num2str(100*z,'%.1f'),' cm. Estimated using ASA.']);
style_plot(gcf(), 'nord');
exportgraphics(gcf(), "1a.pdf", "BackgroundColor", "none", "ContentType", "vector");

%%
figure(2);
plot(P.ax,db(abs(U(:,floor(P.Nx/2)))),'LineWidth',2);
ylim(max(db(abs(U(:))))+[-40 0]); grid on;
xlabel('x [m]'); ylabel('[dB]');
title(['Center cut of wave field at depth z = ',num2str(100*z,'%.1f'),' cm. Estimated using ASA.']);
style_plot(gcf(), 'nord');
exportgraphics(gcf(), "1b.pdf", "BackgroundColor", "none", "ContentType", "vector")



%% Apply Taper
Kernel = hanning(3)*hanning(3).';
Kernel = Kernel/sum(Kernel(:));
U0Mod = conv2(U0, Kernel, 'same');

%%
z = 0.40;
dz = 2*P.lambda;
nZ = round(z/dz);
Zs = linspace(0,z,nZ);
Resp = zeros(P.Nx, nZ);
Prop = ASApropagator(P, dz);
U = ifft2t(fft2t(U0Mod).*Prop);
Resp(:, 1) = U(:, floor(P.Ny/2)).';

for ii = 2:nZ
    if mod(ii, 25) == 0
        fprintf('#')
    end
    U = ifft2t(fft2t(U).*Prop);
    Resp(:, ii) = U(:,floor(P.Ny/2)).';
end
%% Oppgave 2
figure(3); 

imagesc(Zs, P.ax, db(abs(Resp)));
cbar = colorbar; cbar.Label.String = "Pressure [dB]";
clim(max(db(abs(Resp(:))))+[-40 0]);
xlabel("z [m]"); ylabel("x [m]");
title("Wave field for y = 0 along z. Estimated using ASA.")
style_plot(gcf(), "nord");
exportgraphics(gcf, "2a.pdf", "BackgroundColor", "none", "ContentType", "vector")


figure(4); 
subplot(3,1,1);
plot(Zs,db(abs(Resp(floor(P.Nx/2), :)))); 
xlabel("z [m]"); ylabel("Pressure [dB]");
grid on;
title("Pressure along z at x = 0.")

subplot(3,1,2);
nearfar_limit = 0.14;
plot(P.ax, db(abs(Resp(:, floor(nearfar_limit/dz) ))))
xlabel("x [m]"); ylabel("Pressure [dB]");
ylim(max(db(abs(Resp(:))))+[-40 0]); grid on;
title("Center-cut of wave field along x at near-field farfield limit (z=0.14)");

subplot(3,1,3);
plot(P.ax, db(abs(Resp(:, end))))
xlabel("x [m]"); ylabel("Pressure [dB]");
ylim(max(db(abs(Resp(:))))+[-40 0]); grid on;
title("Center-cut of wave field along x at end of simulation at z = 0.4m");
style_plot(gcf(), "nord");
exportgraphics(gcf, "2b.pdf", "BackgroundColor", "none", "ContentType", "vector")