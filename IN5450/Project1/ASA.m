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

figure(2); subplot(2,1,1); 
plot(P.ax,db(abs(U(:,floor(P.Nx/2)))),'LineWidth',2);
ylim(max(db(abs(U(:))))+[-40 0]); grid on;
xlabel('x [m]'); ylabel('[dB]');
title(['Center cut of wave field at depth z = ',num2str(100*z,'%.1f'),' cm. Estimated using ASA.']);

