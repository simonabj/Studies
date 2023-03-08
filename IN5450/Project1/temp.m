spacings = [P.lambda 2*P.lambda];  % different element spacings
kx = 2*pi/P.lambda*linspace(-1,1,500);  % where the response is to be computed
weights = ones(1,24);  % uniform weights
weights = weights / sum(weights);  % normalized

W = zeros(length(kx),length(spacings));

for ii=1:length(spacings)
    element_factor = sin(kx*spacings(ii)/2)./(kx/2);
    xpos = linspace(1,24,24).*spacings(ii);  % element positions
    W(:,ii) = beampattern(xpos,kx,weights); 
    W(:,ii) = W(:,ii).'.*element_factor;
end

plot(db(abs(W)))