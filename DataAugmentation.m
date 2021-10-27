% Fish Bombing Detection FYP; DATA AUGMENTATION
% Brendon Soong, 11/2/2021
clc

%% (1) Random Sequential Augmentations (StretchTime, ShiftPitch, ControlVolume, AddNoise, ShiftTime)
% Read in an audio signal
[audioIn,fs] = audioread("AudioFishBomb.wav");

% Create an audioDataAugmenter object
augmenter1 = audioDataAugmenter( ...
    "AugmentationMode","sequential", ...
    "NumAugmentations",5000, ...   
    ...
    "TimeStretchProbability",0.8, ...
    "SpeedupFactorRange", [1.3,1.4], ...
    ...
    "PitchShiftProbability",0.3, ...
    ...
    "VolumeControlProbability",0.8, ...
    "VolumeGainRange",[-5,5], ...
    ...
    "AddNoiseProbability",0.7, ...
    ...
    "TimeShiftProbability",0.8, ...
    "TimeShiftRange", [-500e-3,500e-3]);

% Call augment on the audio to create 5 augmentations. The augmented audio is returned in a table with variables Audio and AugmentationInfo. The number of rows in the table is defined by NumAugmentations.
data1 = augment(augmenter1,audioIn,fs);

% In the current augmentation pipeline, augmentation parameters are assigned randomly from within the specified ranges. To determine the exact parameters used for an augmentation, inspect AugmentationInfo.
augmentationToInspect = 4;
% data.AugmentationInfo(augmentationToInspect)

% Listen to the augmentation you are inspecting. Plot time representation of the original and augmented signals.
augmentation = data1.Audio{augmentationToInspect};
sound(augmentation,fs)

t = (0:(numel(audioIn)-1))/fs;
taug = (0:(numel(augmentation)-1))/fs;
plot(t,audioIn,taug,augmentation)
legend("Original Audio","Augmented Audio")
ylabel("Amplitude")
xlabel("Time (s)")

% Create a new folder in your current folder to hold the augmented data set.
currentDir = pwd;
writeDirectory = fullfile(currentDir,'RandomSequentialAugmentation');
mkdir(writeDirectory)

% Normalize the audio to have a max absolute value of 1.
for i = 1:size(data1,1)
            augmentedAudio = data1.Audio{i};
            augmentedAudio = augmentedAudio/max(abs(augmentedAudio),[],'all');
            augNum = num2str(i);
            if numel(augNum)==1
                iString = ['0',augNum];
            else
                iString = augNum;
            end
            audiowrite(fullfile(writeDirectory,sprintf('%s_RSA_%s.wav',"ReefCheck",iString)),augmentedAudio,fs);
            fprintf("%d",i)
end


% ADD REMOVING NaN values here!!!!




%% (2) Specified Sequential Augmentations
% Read in an audio signal
[audioIn,fs] = audioread("AudioFishBomb.wav");

% Create an audioDataAugmenter object
augmenter2 = audioDataAugmenter( ...
    "AugmentationMode","sequential", ...
    "AugmentationParameterSource","specify", ...
    "NumAugmentations",5000, ...   % 5 Augmentations
    "SpeedupFactor",[0.9,1.1,1.2], ...
    "ApplyTimeStretch",true, ...
    "ApplyPitchShift",true, ...
    "SemitoneShift",[-2,-1,1,2], ...
    "SNR",[10,15], ...
    "ApplyVolumeControl",false, ...
    "ApplyTimeShift",false);

% Call augment on the audio to create 5 augmentations. The augmented audio is returned in a table with variables Audio and AugmentationInfo. The number of rows in the table is defined by NumAugmentations.
data2 = augment(augmenter2,audioIn,fs);

% In the current augmentation pipeline, augmentation parameters are assigned randomly from within the specified ranges. To determine the exact parameters used for an augmentation, inspect AugmentationInfo.
augmentationToInspect = 4;
% data.AugmentationInfo(augmentationToInspect)

% Listen to the augmentation you are inspecting. Plot time representation of the original and augmented signals.
augmentation = data2.Audio{augmentationToInspect};
sound(augmentation,fs)

t = (0:(numel(audioIn)-1))/fs;
taug = (0:(numel(augmentation)-1))/fs;
plot(t,audioIn,taug,augmentation)
legend("Original Audio","Augmented Audio")
ylabel("Amplitude")
xlabel("Time (s)")

% Create a new folder in your current folder to hold the augmented data set.
currentDir = pwd;
writeDirectory = fullfile(currentDir,'SpecifiedSequentialAugmentation');
mkdir(writeDirectory)

% Normalize the audio to have a max absolute value of 1.
for i = 1:size(data2,1)
            augmentedAudio = data2.Audio{i};
            augmentedAudio = augmentedAudio/max(abs(augmentedAudio),[],'all');
            augNum = num2str(i);
            if numel(augNum)==1
                iString = ['0',augNum];
            else
                iString = augNum;
            end
            audiowrite(fullfile(writeDirectory,sprintf('%s_SSA_%s.wav',"ReefCheck",iString)),augmentedAudio,fs);
end



%% (3) Random Independent Augmentations
% Read in an audio signal
[audioIn,fs] = audioread("AudioFishBomb.wav");

% Create an audioDataAugmenter object
augmenter3 = audioDataAugmenter( ...
    "AugmentationMode","independent", ...
    "AugmentationParameterSource","random", ...
    "NumAugmentations",5000, ...   % 5 Augmentations
    "ApplyTimeStretch",false, ...
    "ApplyPitchShift",false, ...
    "ApplyVolumeControl",false, ...
    "SNRRange",[0,20], ...
    "TimeShiftRange",[-300e-3,300e-3]);

% Call augment on the audio to create 5 augmentations. The augmented audio is returned in a table with variables Audio and AugmentationInfo. The number of rows in the table is defined by NumAugmentations.
data3 = augment(augmenter3,audioIn,fs);

% In the current augmentation pipeline, augmentation parameters are assigned randomly from within the specified ranges. To determine the exact parameters used for an augmentation, inspect AugmentationInfo.
augmentationToInspect = 4;
% data.AugmentationInfo(augmentationToInspect)

% Listen to the augmentation you are inspecting. Plot time representation of the original and augmented signals.
augmentation = data3.Audio{augmentationToInspect};
sound(augmentation,fs)

t = (0:(numel(audioIn)-1))/fs;
taug = (0:(numel(augmentation)-1))/fs;
plot(t,audioIn,taug,augmentation)
legend("Original Audio","Augmented Audio")
ylabel("Amplitude")
xlabel("Time (s)")

% Create a new folder in your current folder to hold the augmented data set.
currentDir = pwd;
writeDirectory = fullfile(currentDir,'RandomIndependentAugmentation');
mkdir(writeDirectory)

% Normalize the audio to have a max absolute value of 1.
for i = 1:size(data3,1)
            augmentedAudio = data3.Audio{i};
            augmentedAudio = augmentedAudio/max(abs(augmentedAudio),[],'all');
            augNum = num2str(i);
            if numel(augNum)==1
                iString = ['0',augNum];
            else
                iString = augNum;
            end
            audiowrite(fullfile(writeDirectory,sprintf('%s_RIA_%s.wav',"ReefCheck",iString)),augmentedAudio,fs);
end



%% (4) Specified Independent Augmentations
% Read in an audio signal
[audioIn,fs] = audioread("AudioFishBomb.wav");

% Create an audioDataAugmenter object
augmenter4 = audioDataAugmenter( ...
    "AugmentationMode","independent", ...
    "AugmentationParameterSource","specify", ...
     "NumAugmentations",5000, ...   % 15 Augmentations
    "ApplyTimeStretch",false, ...
    "ApplyPitchShift",false, ...
    "VolumeGain", [1:10], ...
    "SNR",[1:5], ...
    "TimeShift",2);

% Call augment on the audio to create 5 augmentations. The augmented audio is returned in a table with variables Audio and AugmentationInfo. The number of rows in the table is defined by NumAugmentations.
data4 = augment(augmenter4,audioIn,fs);

% In the current augmentation pipeline, augmentation parameters are assigned randomly from within the specified ranges. To determine the exact parameters used for an augmentation, inspect AugmentationInfo.
augmentationToInspect = 15;
% data.AugmentationInfo(augmentationToInspect)

% Listen to the augmentation you are inspecting. Plot time representation of the original and augmented signals.
%augmentation = data4.Audio{augmentationToInspect};
%sound(augmentation,fs)

t = (0:(numel(audioIn)-1))/fs;
taug = (0:(numel(augmentation)-1))/fs;
plot(t,audioIn,taug,augmentation)
legend("Original Audio","Augmented Audio")
ylabel("Amplitude")
xlabel("Time (s)")

% Create a new folder in your current folder to hold the augmented data set.
currentDir = pwd;
writeDirectory = fullfile(currentDir,'SpecifiedIndependentAugmentation');
mkdir(writeDirectory)

% Normalize the audio to have a max absolute value of 1.
for i = 1:size(data4,1)
            augmentedAudio = data4.Audio{i};
            augmentedAudio = augmentedAudio/max(abs(augmentedAudio),[],'all');
            augNum = num2str(i);
            if numel(augNum)==1
                iString = ['0',augNum];
            else
                iString = augNum;
            end
            audiowrite(fullfile(writeDirectory,sprintf('%s_SIA_%s.wav',"ReefCheck",iString)),augmentedAudio,fs);
end


%% (5) GENEREATE WHITE NOISE FOR TESTING NEURAL NETWORK
adsTrain = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\Training Data\explosion', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');
fs = 24000;
duration = 1.6;
N = duration*fs;

% Generate noise
wNoise = 2*rand([N,100]) - 1;      % White noise
bNoise = filter(1,[1,-0.999],wNoise);       % Brown noise
bNoise = bNoise./max(abs(bNoise),[],'all');     
pNoise = pinknoise([N,100]);       % Pink noise

reduced_wNoise =0.015*wNoise;
reduced_bNoise =0.015*bNoise;
reduced_pNoise =0.015*pNoise;

figure
plot(wNoise(:,1))
hold on 
plot(reduced_wNoise(:,1))
hold on
plot(Train(:,1))
title("Plot of White Noise, Reduced White Noise (0.015), Explosion Audio")

%% Write noise files to deep learning folder
currentDir = pwd;
writeDirectory = fullfile(currentDir,'ReducTesting Noise_not trunc');
mkdir(writeDirectory)

for i = 1:100
    audiowrite(fullfile(writeDirectory,sprintf('ReducWhiteNoise_%d.wav',i)),reduced_wNoise(:,i),fs);
    audiowrite(fullfile(writeDirectory,sprintf('ReducBrownNoise_%d.wav',i)),reduced_bNoise(:,i),fs);
    audiowrite(fullfile(writeDirectory,sprintf('ReducPinkNoise_%d.wav',i)),reduced_pNoise(:,i),fs);
    fprintf("%d \n",i)
end


%% (6) Re-Augmenting Reef Check Audio but just changing the amplitude, dont add noise (Specified Independent Augmentations)
% TRAINING AUDIO
% Read in an audio signal
[audioIn,fs] = audioread("AudioFishBomb.wav");

% Create an audioDataAugmenter object
augmenter6 = audioDataAugmenter( ...
    "AugmentationMode","independent", ...
    "AugmentationParameterSource","random", ...
    "NumAugmentations",10000, ... 
    "TimeStretchProbability", 0, ...
    "SpeedupFactorRange", [0 0], ...
    "ApplyTimeStretch", false, ...
    "SpeedupFactor", 0, ...
    "PitchShiftProbability", 0, ...
    "SemitoneShiftRange", [0 0], ...
    "ApplyPitchShift", false, ...
    "SemitoneShift", 0, ...
    "VolumeControlProbability" ,1, ... % 
    "VolumeGainRange", [-10, -1], ...  % "VolumeGain", [40], ...
    "ApplyVolumeControl", true, ...
    "AddNoiseProbability", 0, ...
    "SNRRange", [0 0], ...
    "ApplyAddNoise", false, ...
    "SNR", 0, ...
    "TimeShiftProbability", 0, ...
    "TimeShiftRange", [0 0], ...
    "ApplyTimeShift", false, ...
    "TimeShift", 0);

% Call augment on the audio to create 5 augmentations. The augmented audio is returned in a table with variables Audio and AugmentationInfo. The number of rows in the table is defined by NumAugmentations.
data6 = augment(augmenter6,audioIn,fs);

% In the current augmentation pipeline, augmentation parameters are assigned randomly from within the specified ranges. To determine the exact parameters used for an augmentation, inspect AugmentationInfo.
augmentationToInspect = 1000;

% Listen to the augmentation you are inspecting. Plot time representation of the original and augmented signals.
augmentation6 = data6.Audio{augmentationToInspect};
sound(augmentation6,fs)

t = (0:(numel(audioIn)-1))/fs;
taug = (0:(numel(augmentation6)-1))/fs;
plot(t,audioIn,taug,augmentation6)
legend("Original Audio","Augmented Audio")
ylabel("Amplitude")
xlabel("Time (s)")

% Create a new folder in your current folder to hold the augmented data set.
currentDir = pwd;
writeDirectory = fullfile(currentDir,'Explosion');
mkdir(writeDirectory)

% Normalize the audio to have a max absolute value of 1.
for i = 1:size(data6,1)
            augmentedAudio = data6.Audio{i};
            augmentedAudio = augmentedAudio/max(abs(augmentedAudio),[],'all');
            augNum = num2str(i);
            if numel(augNum)==1
                iString = ['0',augNum];
            else
                iString = augNum;
            end
            audiowrite(fullfile(writeDirectory,sprintf('%s_SIA_%s.wav',"Trial4Train",iString)),augmentedAudio,fs);
end

%% (7) Re-Augmenting Reef Check Audio but just changing the amplitude, dont add noise (Specified Independent Augmentations)
% TESTING AUDIO
% Read in an audio signal
[audioIn,fs] = audioread("AudioFishBomb.wav");

% Create an audioDataAugmenter object
augmenter7 = audioDataAugmenter( ...
    "AugmentationMode","independent", ...
    "AugmentationParameterSource","random", ...
    "NumAugmentations",5000, ... 
    "TimeStretchProbability", 0, ...
    "SpeedupFactorRange", [0 0], ...
    "ApplyTimeStretch", false, ...
    "SpeedupFactor", 0, ...
    "PitchShiftProbability", 0, ...
    "SemitoneShiftRange", [0 0], ...
    "ApplyPitchShift", false, ...
    "SemitoneShift", 0, ...
    "VolumeControlProbability" ,1, ... % 
    "VolumeGainRange", [-20, -1], ...  % "VolumeGain", [40], ...
    "ApplyVolumeControl", true, ...
    "AddNoiseProbability", 0, ...
    "SNRRange", [0 0], ...
    "ApplyAddNoise", false, ...
    "SNR", 0, ...
    "TimeShiftProbability", 0, ...
    "TimeShiftRange", [0 0], ...
    "ApplyTimeShift", false, ...
    "TimeShift", 0);

% Call augment on the audio to create 5 augmentations. The augmented audio is returned in a table with variables Audio and AugmentationInfo. The number of rows in the table is defined by NumAugmentations.
data7 = augment(augmenter7,audioIn,fs);

% In the current augmentation pipeline, augmentation parameters are assigned randomly from within the specified ranges. To determine the exact parameters used for an augmentation, inspect AugmentationInfo.
augmentationToInspect = 500;

% Listen to the augmentation you are inspecting. Plot time representation of the original and augmented signals.
augmentation7 = data7.Audio{augmentationToInspect};
sound(augmentation7,fs)

t = (0:(numel(audioIn)-1))/fs;
taug = (0:(numel(augmentation7)-1))/fs;
plot(t,audioIn,taug,augmentation7)
legend("Original Audio","Augmented Audio")
ylabel("Amplitude")
xlabel("Time (s)")

% Create a new folder in your current folder to hold the augmented data set.
currentDir = pwd;
writeDirectory = fullfile(currentDir,'Explosion');
mkdir(writeDirectory)

% Normalize the audio to have a max absolute value of 1.
for i = 1:size(data7,1)
            augmentedAudio = data7.Audio{i};
            augmentedAudio = augmentedAudio/max(abs(augmentedAudio),[],'all');
            augNum = num2str(i);
            if numel(augNum)==1
                iString = ['0',augNum];
            else
                iString = augNum;
            end
            audiowrite(fullfile(writeDirectory,sprintf('%s_SIA_%s.wav',"Trial4Val",iString)),augmentedAudio,fs);
end


%% (8) Augmenting UW Noise (TRAIN VolumeGainRange = -10 -1, Val = -15 -10
% Read in an audio signal
[audioIn,fs] = audioread("WindTurbine_Trunc.wav");

% Create an audioDataAugmenter object
augmenter8 = audioDataAugmenter( ...
    "AugmentationMode","independent", ...
    "AugmentationParameterSource","random", ...
    "NumAugmentations",50, ... 
    "TimeStretchProbability", 0, ...
    "SpeedupFactorRange", [0 0], ...
    "ApplyTimeStretch", false, ...
    "SpeedupFactor", 0, ...
    "PitchShiftProbability", 0, ...
    "SemitoneShiftRange", [0 0], ...
    "ApplyPitchShift", false, ...
    "SemitoneShift", 0, ...
    "VolumeControlProbability" ,1, ... % 
    "VolumeGainRange", [-15, -10], ...  % "VolumeGain", [40], ...
    "ApplyVolumeControl", true, ...
    "AddNoiseProbability", 0, ...
    "SNRRange", [0 0], ...
    "ApplyAddNoise", false, ...
    "SNR", 0, ...
    "TimeShiftProbability", 0, ...
    "TimeShiftRange", [0 0], ...
    "ApplyTimeShift", false, ...
    "TimeShift", 0);

% Call augment on the audio to create 5 augmentations. The augmented audio is returned in a table with variables Audio and AugmentationInfo. The number of rows in the table is defined by NumAugmentations.
data8 = augment(augmenter8,audioIn,fs);

% In the current augmentation pipeline, augmentation parameters are assigned randomly from within the specified ranges. To determine the exact parameters used for an augmentation, inspect AugmentationInfo.
augmentationToInspect = 10;

% Listen to the augmentation you are inspecting. Plot time representation of the original and augmented signals.
augmentation8 = data8.Audio{augmentationToInspect};
sound(augmentation8,fs)

t = (0:(numel(audioIn)-1))/fs;
taug = (0:(numel(augmentation8)-1))/fs;
plot(t,audioIn,taug,augmentation8)
legend("Original Audio","Augmented Audio")
ylabel("Amplitude")
xlabel("Time (s)")

% Create a new folder in your current folder to hold the augmented data set.
currentDir = pwd;
writeDirectory = fullfile(currentDir,'Truncated_Augmented_Val');
mkdir(writeDirectory)

% Normalize the audio to have a max absolute value of 1.
for i = 1:size(data8,1)
            augmentedAudio = data8.Audio{i};
            augmentedAudio = augmentedAudio/max(abs(augmentedAudio),[],'all');
            augNum = num2str(i);
            if numel(augNum)==1
                iString = ['0',augNum];
            else
                iString = augNum;
            end
            audiowrite(fullfile(writeDirectory,sprintf('%s_AugVal_%s.wav',"WindTurbine",iString)),augmentedAudio,fs);
end