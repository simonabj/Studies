%% 25 elements

P = ASAparameters;
NEls = 101;
NPos = 25;
d = P.lambda/2;
N = 1000;
u = linspace(-1,1,N); % sin(theta)
kx = 2*pi/P.lambda*u;
weights = ones(NPos, 1);
weights = weights/sum(weights(:));

Reps = 1000; % Repetions

comp = zeros(Reps, 3); % (-3db, -6db, side)

for ii = 1:Reps
    pos = [];
    while length(pos)<NPos - 2
        pos = unique(ceil((NEls-2)*rand(1,NPos*2)),'stable');
    end
    ElPos = [-(NEls-1)/2 sort(pos(1:NPos-2))-(NEls-1)/2 (NEls-1)/2]*d;
    
    Resp = beampattern(ElPos, kx, weights);
    analyze = analyzeBP(u, Resp);
    comp(ii, :) = [ analyze.Three_dB, analyze.Six_dB, analyze.maxSL ];
end

mean_3db = mean(comp(:, 1)); std_3db = std(comp(:, 1));
mean_6db = mean(comp(:, 2)); std_6db = std(comp(:, 2));
mean_slb = mean(comp(:, 3)); max_slb = std(comp(:, 3));

sprintf("======================= 25 elements =======================")
sprintf("Main lobe mean width @ -3dB: %.4f [± %.4f]", mean_3db, std_3db)
sprintf("Main lobe mean width @ -6dB: %.4f [± %.4f]", mean_6db, std_6db)
sprintf("Mean sidelobe level: %.4f\n Max sidelobe level: %.4f", mean_slb, max_slb)

%% 50 elements

P = ASAparameters;
NEls = 101;
NPos = 50;
d = P.lambda/2;
N = 1000;
u = linspace(-1,1,N); % sin(theta)
kx = 2*pi/P.lambda*u;
weights = ones(NPos, 1);
weights = weights/sum(weights(:));

Reps = 1000; % Repetions

comp = zeros(Reps, 3); % (-3db, -6db, side)

for ii = 1:Reps
    pos = [];
    while length(pos)<NPos - 2
        pos = unique(ceil((NEls-2)*rand(1,NPos*2)),'stable');
    end
    ElPos = [-(NEls-1)/2 sort(pos(1:NPos-2))-(NEls-1)/2 (NEls-1)/2]*d;
    
    Resp = beampattern(ElPos, kx, weights);
    analyze = analyzeBP(u, Resp);
    comp(ii, :) = [ analyze.Three_dB, analyze.Six_dB, analyze.maxSL ];
end

mean_3db = mean(comp(:, 1)); std_3db = std(comp(:, 1));
mean_6db = mean(comp(:, 2)); std_6db = std(comp(:, 2));
mean_slb = mean(comp(:, 3)); max_slb = std(comp(:, 3));

sprintf("======================= 50 elements =======================")
sprintf("Main lobe mean width @ -3dB: %.4f [± %.4f]", mean_3db, std_3db)
sprintf("Main lobe mean width @ -6dB: %.4f [± %.4f]", mean_6db, std_6db)
sprintf("Mean sidelobe level: %.4f\n Max sidelobe level: %.4f", mean_slb, max_slb)

%% 75 elements

P = ASAparameters;
NEls = 101;
NPos = 75;
d = P.lambda/2;
N = 1000;
u = linspace(-1,1,N); % sin(theta)
kx = 2*pi/P.lambda*u;
weights = ones(NPos, 1);
weights = weights/sum(weights(:));

Reps = 1000; % Repetions

comp = zeros(Reps, 3); % (-3db, -6db, side)

for ii = 1:Reps
    pos = [];
    while length(pos)<NPos - 2
        pos = unique(ceil((NEls-2)*rand(1,NPos*2)),'stable');
    end
    ElPos = [-(NEls-1)/2 sort(pos(1:NPos-2))-(NEls-1)/2 (NEls-1)/2]*d;
    
    Resp = beampattern(ElPos, kx, weights);
    analyze = analyzeBP(u, Resp);
    comp(ii, :) = [ analyze.Three_dB, analyze.Six_dB, analyze.maxSL ];
end

mean_3db = mean(comp(:, 1)); std_3db = std(comp(:, 1));
mean_6db = mean(comp(:, 2)); std_6db = std(comp(:, 2));
mean_slb = mean(comp(:, 3)); max_slb = std(comp(:, 3));

sprintf("======================= 75 elements =======================")
sprintf("Main lobe mean width @ -3dB: %.4f [± %.4f]", mean_3db, std_3db)
sprintf("Main lobe mean width @ -6dB: %.4f [± %.4f]", mean_6db, std_6db)
sprintf("Mean sidelobe level: %.4f\n Max sidelobe level: %.4f", mean_slb, max_slb)

%% Dense array with same properties

ElPos = linspace(-NEls*d/2, NEls*d/2, NEls);
Resp = beampattern(ElPos, kx, ones(NEls,1));
analyze = analyzeBP(u, Resp);
sprintf("====================== 101 elements =======================")
sprintf("Main lobe width @ -3dB: %.4f", analyze.Three_dB)
sprintf("Main lobe width @ -6dB: %.4f", analyze.Six_dB)
sprintf("Max sidelobe level: %.4f", analyze.maxSL)

%% Optimized for minimum beamwidth

optimized2 = "10000100000000000000000100001000000000001010000001100010010010101111100100010000010010010000000110001";
optimized2_filter = logical(arrayfun(@str2num, convertStringsToChars(optimized2)));
Resp = beampattern(ElPos(optimized2_filter), kx, ones(25,1)/25);
analyze = analyzeBP(u, Resp);
sprintf("====================== Optimized minimum beamwidth =======================")
sprintf("Main lobe width @ -3dB: %.4f", analyze.Three_dB)
sprintf("Main lobe width @ -6dB: %.4f", analyze.Six_dB)
sprintf("Max sidelobe level: %.4f", analyze.maxSL)


%% Optimized for minimum sidelobe level

optimized3 = "10000001000000000000011110101000101101000010110011000110010001100000100100000000000000000000000000001";
optimized3_filter = logical(arrayfun(@str2num, convertStringsToChars(optimized2)));
Resp = beampattern(ElPos(optimized3_filter), kx, ones(25,1)/25);
analyze = analyzeBP(u, Resp);
sprintf("====================== Optimized minimum sidelobe =======================")
sprintf("Main lobe width @ -3dB: %.4f", analyze.Three_dB)
sprintf("Main lobe width @ -6dB: %.4f", analyze.Six_dB)
sprintf("Max sidelobe level: %.4f", analyze.maxSL)
