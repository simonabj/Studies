%% Variables and parameters

global IQdata
applyClutterFilter=1;


%% Loading the data

load('carotidRecording.mat');
IQdata=double(complex(I,Q));


%% Display one image

h=msgbox({'Please Wait...' 'Generating image'});
figure(10)
subplot(3,1,1)
im = imagesc(squeeze(abs(IQdata(:,:,1))));
colormap(gray)
axis image
title('B-mode image')
try
close(h)
end

%%
% Filter the data with a the given FIR filter (complete the code)
if(applyClutterFilter)
end

%%
% Function that runs when clicked on the image
figure(10)
ax = gca;
im.PickableParts = 'none';
ax.ButtonDownFcn = @mouseClick;


function mouseClick(~,~)
global IQdata

%Extract the data
currentCoordinates= round(get(gca,'CurrentPoint'));
figure(10)
subplot(3,1,1)
hold on
rect = findall(gcf, 'Type', 'Rectangle'); 
delete(rect); 
rectangle('Position',[currentCoordinates(1,1,1) currentCoordinates(1,2,1) 2 2], 'LineWidth',2, 'EdgeColor','b');

% Extract the data from the clicked coordinates
extractedData= IQdata(currentCoordinates(1,2,1),currentCoordinates(1,1,1),:);

%Estimate the Welch and minimum-variance spectrograms (complete the code)


%% Plot the spectrograms
% Welch spectrogram (complete the code)
figure(10)
subplot(3,1,2)


%Minimum-variance spectrogram (complete the code)
subplot(3,1,3)


end