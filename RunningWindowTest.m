% Running Window 1

% Audiostream from file use dsp.AudioFileReader
% Audiostream from a device use audioDeviceReader
clc; close all;

%% Process Reef Check GoPro recording
% Driver, device (sound card), sample rate, bit depth, buffer size, and channel mapping
% Input: dspAudioFileReader
% Output: audioDeviceWriter

% Sound In Mic -> ADC -> Buffer -> Driver -> Matlab

% Read audio file
% frameLength = 1024;
% fileReader = dsp.AudioFileReader( ...
%     'VID 20200825 WA0000.wav', ...
%     'SamplesPerFrame',frameLength);

% Load Dataset, Separate Dataset into Train and Validation

%[GoproSignal,fsGopro] = audioread('AudioFishBomb.wav');
[GoproSignal,fsGopro] = audioread('VID 20200825 WA0000_downsampled.wav');
%[GoproSignal,fsGopro] = audioread('Humpback Whales.wav');
%[GoproSignal,fsGopro] = audioread('Snapping Shrimp.wav');
%[GoproSignal,fsGopro] = audioread('boat_runningWindow.wav');
%[GoproSignal,fsGopro] = audioread('ocean_storm_runningWindow.wav');
%[GoproSignal,fsGopro] = audioread('method2_water_balloon_unedited.wav');
%[GoproSignal,fsGopro] = audioread('method2_water_fireworks_unedited.wav');
%[GoproSignal,fsGopro] = audioread('Dredging.wav');
%[GoproSignal,fsGopro] = audioread('Outboard Motor sound.wav');
%[GoproSignal,fsGopro] = audioread('Seismic airgun.wav');
%[GoproSignal,fsGopro] = audioread('Ship noise.wav');
%[GoproSignal,fsGopro] = audioread('Jet ski.wav');
%[GoproSignal,fsGopro] = audioread('Waves.wav');

[row,col] =size(GoproSignal); % 944111 rows, 1 column

%% Defining audioFeatureExtractor
fs24 = 24000;
aFE = audioFeatureExtractor("SampleRate",fs24, ...
    "SpectralDescriptorInput","melSpectrum", ...
    "mfcc",true, ...
    "spectralCentroid",true, ...
    "spectralEntropy",true, ...
    "mfccDelta", true, ...
    "pitch",true, ...
    "harmonicRatio",true);

y=1;
z=1;
interval = 10000;
finalLength = row-41444; % 902667
f = [1 2; 2 3; 3 4; 4 1];
plot(GoproSignal)

for x = 1:interval:finalLength    % 1:20722:902667 is half of one frame
    
    SignalFeatures{y,1} = extract(aFE, GoproSignal((x:(41444+x)),1));   % There is overlap
    
    % Remove NaN values from cells
    Signal_temp = SignalFeatures{y,1};
        % Loop through array
            TF = isnan(Signal_temp);
            Signal_temp(TF) = 0;
            %temp = mat2cell(temp);
                % Concatenate array back into cell
                    SignalFeatures{y,1} = Signal_temp;
                    
    % Classify                
    [framePred(z,1),frameScore(z,:)] = classify(net,SignalFeatures{y,1}); % Actual reef check
    
    y = y+1;
    z = z+1;
    
    % loop plot 
    % if....redbox 
    v = [x -1; x 1 ; x+41444 1; x+41444 -1]; 
    
    if framePred(z-1,1) == "Noise"
        pTemp = patch('Faces',f, 'Vertices',v, 'EdgeColor','green','FaceColor','none','LineWidth',2);
        title("Noise")
        
    elseif framePred(z-1,1) == "Explosion"
            pTemp = patch('Faces',f, 'Vertices',v, 'EdgeColor','red','FaceColor','none','LineWidth',2);
            title("Explosion")
    end
    
    %textTemp = text(framePred(z-1,1));
    pause(0.2)
    delete(pTemp); 
    %delete(textTemp)
    
    fprintf("x = %d, %s\n",x,framePred(z-1,1));
    
end

fprintf("Finish Extracting\n");

%title("Boat")
%title("Ocean Storm")

% IS IT BECAUSE SAMPLE RATE OF GOPRO IS 44100 BUT I TRAINED WITH 24000?
% I converted 44100 to 24000 through audacity, need more preprocessing filter?
% WHY DID I TRAIN WITH LOWER SAMPLE? TO HAVE LESS NOISE/UNWANTED___?

%% Plot the explosion part on the figure

% plot(GoproSignal)
%hold on
%plot(ReefCheckTrain)
% title("Explosion")

% x = 0:row;
% index = 330000+41444;
% y = (max(GoproSignal(33000:index,1)))/2;
% f = [1 2; 2 3; 3 4; 4 1];
% v = [330000 -1; 330000 1 ; 371444 1; 371444 -1]; 

% hold on
% patch('Faces',f, 'Vertices',v, 'EdgeColor','red','FaceColor','none','LineWidth',2);
% 
% 
% fprintf("Patch Plotted\n");




%signalFeatures = permute(signalFeatures,[2,1,3]);
%numFeatures = 79;
%numHopsPerSequence = 30;
%numSignals = numel(signalFeatures);

% %% Audio Stream Loop
% % Read a frame -> Extract features
% while ~isDone(fileReader)                   %<--- new lines of code
%     signal = fileReader();                  %<---
%     signalFeatures{x} = extract(aFE,signal);  
%     [numHopsPerSequence,numFeatures,numSignals] = size(signalFeatures);
%     [row,col] = size(signalFeatures);
%     
%     % Convert to 82x1 rows
%     if col>1
%         signalFeatures = signalFeatures';
%     end
%     
%     % Remove NaN values from cells
%     signal_temp = signalFeatures{x,1};
%         % Loop through array
%             TF = isnan(signal_temp);
%             signal_temp(TF) = 0;
%             %temp = mat2cell(temp);
%                 % Concatenate array back into cell
%                     signalFeatures{x,1} = signal_temp;
%                     [framePred,frameScore] = classify(net,signalFeatures); % Actual reef check
% end                                   
% 
% release(fileReader)                     
% fprintf('\nDone classifying \n');
