% Fish Bombing Detection FYP; DEEP LEARNING, Trial 4 - FullNoise and UW
% train
% Brendon Soong, 11/2/2021
clc;close all;clear all

%% Datasets 
clc
fs = 24000; % 48kHz
segmentDuration = 1.7; % 2 seconds
segmentSamples = round(segmentDuration*fs);


% Load Dataset, Separate Dataset into Train and Validation
adsTrain = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\Training_Trial4\Train', 'IncludeSubfolders', true,'LabelSource', 'foldernames','FileExtensions','.wav');
adsVal = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\Training_Trial4\Val', 'IncludeSubfolders', true,'LabelSource', 'foldernames','FileExtensions','.wav');
filenametest = 'PadTrunc2.wav';
[y,fs] = audioread(filenametest);

%% Storing training audio data into arrays

for x = 1:11900  %2900 (without the reefcheckRSA)
    [Train(:,x),fs(x,1)] = audioread(adsTrain.Files{x,1});
    fprintf('Train: %d \n',x);
end

%%
for x = 1:6100  %2100
    [Val(:,x),fs2(x,1)] = audioread(adsVal.Files{x,1});
    fprintf('Val: %d \n',x);
end

%% Extract Features
fs24 = 24000;
ReefCheckTrain = audioread('AudioFishBomb.wav');
ReefCheckVal = audioread('AudioFishBomb.wav');
aFE = audioFeatureExtractor("SampleRate",fs24, ...
    "SpectralDescriptorInput","melSpectrum", ...
    "mfcc",true, ...
    "spectralCentroid",true, ...
    "spectralEntropy",true, ...
    "mfccDelta", true, ...
    "pitch",true, ...
    "harmonicRatio",true);

for x = 1:11900
    featuresTrain{x} = extract(aFE,Train(:,x));  
    [numHopsPerSequence,numFeatures,numSignals] = size(featuresTrain);
    %featuresTrain(x) = num2cell(featuresTrain(x));
    fprintf('TrainFeatures: %d \n',x)
end 

% Treat the extclcracted features as sequences and use a sequenceInputLayer as the first layer of your deep learning model
%[numFeatures,numHopsPerSequence] = size(featuresTrain{1,1}{1,1});
featuresTrain = permute(featuresTrain,[2,1,3]);
numFeatures = 79;
numHopsPerSequence = 30;
%featuresTrain = cell2mat(featuresTrain);
numSignals = numel(featuresTrain);
%[numFeatures,numHopsPerSequence] = size(featuresTrain{1,1}{1,1});

%% Extract validation features
for x = 1:6100
    featuresValidation{x} = extract(aFE,Val(:,x));
    fprintf('ValFeatures: %d \n',x)
end
featuresValidation = permute(featuresValidation,[2,1,3]);
%featuresValidation = squeeze(num2cell(featuresValidation,[1,2]));


%% VISUALIZE DATA

for i = 1:3
    [x,fs] = audioread(adsTrain.Files{i,1});
    subplot(3,3,i)
    plot(x)
    axis tight
    %title(string(adsTrain.Labels{i,1}))

    subplot(3,3,i+3)
    tem = featuresTrain{i,1};
    spectrogram(tem(:,i));
  
    subplot(3,3,i+6)
    spectrogram(x);
    
    %shading flat

    %sound(x,fs)
    %pause(2)
end



%% Define and train the network
    % Labels = Labels(1:15000,1);
% Define Layers
layers = [ ...
    sequenceInputLayer(numFeatures) % Input layer
    bilstmLayer(50,"OutputMode","last") % Sequence layer
    fullyConnectedLayer(numel(unique(adsTrain.Labels))) % convolution and fully connected layer adsTrain.Labels
    softmaxLayer
    classificationLayer]

% Define Training options
miniBatchSize = 27;
options = trainingOptions("adam", ...
    'ExecutionEnvironment','cpu', ... %
    "Shuffle","every-epoch", ...
    'MiniBatchSize',miniBatchSize, ... %
    "ValidationData",{featuresValidation,adsVal.Labels}, ...
    "Plots","training-progress", ...
    "Verbose",false)

% Train network
net = trainNetwork(featuresTrain,adsTrain.Labels,layers,options);

%% Test network
% Load test data, actual reef check
adsTest = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\SpecifiedIndependentAugmentation_16', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');

%Testing with all gunshot
%adsTest = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\Testing_Pad_Truncated_Trial3', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');

% Combine White, Brown, Pink test
NoiseTest =  audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\Testing_Noise_Pad_Truncated', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');

% Reduced Noise + Full Noise Dataset (600)
ReducNoiseTest =  audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\Testing_Noise_Pad_Truncated', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');

% Underwater Noise
UWNoiseTest = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\UW Testing audio\Truncated', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');

% Gunshot and Pool Dataset
Gun_Pool_Test = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\Training_Trial4\GunPoolMisc', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');


for x = 1:16
    %[Test(:,x),fs(x,1)] = audioread(adsTest.Files{x+10000,1});
    [Test(:,x),fs(x,1)] = audioread(adsTest.Files{x,1});
    fprintf('Train: %d \n',x);
end

for x = 1:300
    [Noise(:,x),fs(x,1)] = audioread(NoiseTest.Files{x,1});
    fprintf('NoiseTrain: %d \n',x);
end

% FULL NOISE AND ACTUAL (100 Actual, 600 Noise)
for x = 1:16
    [Noise_and_Actual(:,x),fs(x,1)] = audioread(adsTest.Files{x,1}); % ACTUAL
    fprintf('NoiseActualTrain: %d \n',x);
end

for x = 1:600
    [Noise_and_Actual(:,x+16),fs(x,1)] = audioread(NoiseTest.Files{x,1}); % NOISE
    fprintf('NoiseActualTrain: %d \n',x+16);
end

% Full Noise + Reduc Noise
for x = 1:600
    [Noise_and_Reduc(:,x),fs(x,1)] = audioread(ReducNoiseTest.Files{x,1}); % NOISE
    fprintf('NoiseReducTrain: %d \n',x);
end

% UW Noise
for x = 1:16
     [UWNoise(:,x),fs(x,1)] = audioread(UWNoiseTest.Files{x,1});
     fprintf('UWNoiseTrain: %d \n',x);
end

% GunPool
for x = 1:82
     [GunPool(:,x),fs(x,1)] = audioread(Gun_Pool_Test.Files{x,1});
     fprintf('GunPoolMiscTrain: %d \n',x);
end


%%
for x = 1:16
    ActualTest{x} = extract(aFE,Test(:,x)); % Reef check augmented data
    fprintf('TEST: %d \n',x)
end 

for x = 1:300
    NoisePadded{x} = extract(aFE,Noise(:,x));
    fprintf('NoisePadTEST: %d \n',x)
end 

for x = 1:616
     Noise_and_Actual_Extract{x} = extract(aFE,Noise_and_Actual(:,x));
    fprintf('NoiseActualPadTEST: %d \n',x)
end 

for x = 1:600
     Noise_and_Reduc_Extract{x} = extract(aFE,Noise_and_Reduc(:,x));
    fprintf('NoiseReducPadTEST: %d \n',x)
end 

for x = 1:16
    UWNoise_Extract{x} = extract(aFE, UWNoise(:,x)); 
    fprintf('UWNoiseTEST: %d \n',x)
end

for x = 1:82
    GunPool_Extract{x} = extract(aFE, GunPool(:,x)); 
    fprintf('UWNoiseTEST: %d \n',x)
end

ActualTest = permute(ActualTest,[2,1,3]);
NoiseTest_Actual = permute(NoisePadded,[2,1,3]);
Noise_and_Actual_Test = permute(Noise_and_Actual_Extract,[2,1,3]);
Noise_and_Reduc_Test = permute(Noise_and_Reduc_Extract,[2,1,3]);
UWNoise_Test = permute( UWNoise_Extract,[2,1,3]);
GunPool_Test = permute( GunPool_Extract,[2,1,3]);

% Remove NaN values from cells
for x = 1:16
    % Extract cell into variable
    temp = ActualTest{x,1};
        % Loop through array
            TF = isnan(temp);
            temp(TF) = 0;
            %temp = mat2cell(temp);
                % Concatenate array back into cell
                    ActualTest{x,1} = temp;
end

for x = 1:300
    % Extract cell into variable
    noisetemp = NoiseTest_Actual{x,1};
        % Loop through array
            TF = isnan(noisetemp);
            noisetemp(TF) = 0;
            %temp = mat2cell(temp);
                % Concatenate array back into cell
                    NoiseTest_Actual{x,1} = noisetemp;
end

for x = 1:616
    % Extract cell into variable
    noisetemp = Noise_and_Actual_Test{x,1};
        % Loop through array
            TF = isnan(noisetemp);
            noisetemp(TF) = 0;
            %temp = mat2cell(temp);
                % Concatenate array back into cell
                    Noise_and_Actual_Test{x,1} = noisetemp;
end

for x = 1:600
    % Extract cell into variable
    noisetemp = Noise_and_Reduc_Test{x,1};
        % Loop through array
            TF = isnan(noisetemp);
            noisetemp(TF) = 0;
            %temp = mat2cell(temp);
                % Concatenate array back into cell
                    Noise_and_Reduc_Test{x,1} = noisetemp;
end

for x = 1:16
        % Extract cell into variable
    noisetemp = UWNoise_Test{x,1};
        % Loop through array
            TF = isnan(noisetemp);
            noisetemp(TF) = 0;
            %temp = mat2cell(temp);
                % Concatenate array back into cell
                   UWNoise_Test{x,1} = noisetemp;
    
end

for x = 1:82
        % Extract cell into variable
    noisetemp = GunPool_Test{x,1};
        % Loop through array
            TF = isnan(noisetemp);
            noisetemp(TF) = 0;
            %temp = mat2cell(temp);
                % Concatenate array back into cell
                   GunPool_Test{x,1} = noisetemp;
    
end

%% Test
[YPred,score] = classify(net,ActualTest); % Actual reef check
[combinedNoisePred,Noise_score] = classify(net, NoiseTest_Actual) ;  % full noise (not reduced)
[NoiseAndActualPred,NAA_score] = classify(net, Noise_and_Actual_Test); % Reduced noise and actual reef check
[NoiseAndReducPred,NAR_score] = classify(net, Noise_and_Reduc_Test);
[UWNoisePred,UW_score] = classify(net, UWNoise_Test);
[GunPoolPred,GP_score] = classify(net, GunPool_Test);

fprintf('\nDone classifying \n');

