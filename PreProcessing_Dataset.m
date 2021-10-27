% Fish Bombing Detection FYP; PRE-PROCESSING DATASET
% Brendon Soong, 11/2/2021
clc; clear all; close all

Test = audioread('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\Training Data\explosion\explosion_training (1).wav');

%% Load Datasets for Training and Validation
adsTrain = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\RandomIndependentAugmentation_10k', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');
adsVal = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\RandomSequentialAugmentation_5k', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');

%% Check training data if 2s duration, if not, add white noise to front and back of audio.
b = audioread('explosion_training (12000).wav');
n = length(b); % length of reef check audio vector is 41444
Y = zeros(18469,1);
R = zeros(18469,1);
fs = 24000;

    % Create a new folder in your current folder to hold the augmented data set.
    currentDir = pwd;
    writeDirectory = fullfile(currentDir,'Testing_Pad_Truncated_Trial3');
    mkdir(writeDirectory)

% PAD OR TRUNC    
for x = 1:10000    % 1:18469
    
    filename = 'explosion_training (%d).wav';
    str = sprintf(filename,x);
    
    [R,fs2] = audioread(str);
    n2 = length(R); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef Check 
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('PadTrunc_Trial3%d.wav',x)),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end

%% For Validation
fs = 24000;
    % Create a new folder in your current folder to hold the augmented data set.
    currentDir = pwd;
    writeDirectory = fullfile(currentDir,'Validation_Pad_Truncated_Trial3');
    mkdir(writeDirectory)
    

for x = 1:5000    % 1:5040
    
    filename = 'explosion_validation (%d).wav';
    str = sprintf(filename,x);
    
    [R,fs2] = audioread(str);
    n2 = length(R); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef > 
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('Val_PadTrunc_Trial3%d.wav',x)),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end


%% PreProcess Noise for testing
fs=24000;
b = audioread('explosion_training (12000).wav');
n = length(b); % length of reef check audio vector is 41444
% Create a new folder in your current folder to hold the augmented data set.
currentDir = pwd;
writeDirectory = fullfile(currentDir,'Testing_Noise_Pad_Truncated');
mkdir(writeDirectory)

% BROWN NOISE PADDING
for x = 1:100    
    
    filename = 'BrownNoise_%d.wav';
    str = sprintf(filename,x);
    
    [R,fs2] = audioread(str);
    n2 = length(R); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef Check bigger than audio
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('NoisePadTrunc%d.wav',x)),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end

% PINK NOISE PADDING
for x = 1:100    
    
    filename = 'PinkNoise_%d.wav';
    str = sprintf(filename,x);
    
    [R,fs2] = audioread(str);
    n2 = length(R); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef Check 
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('NoisePadTrunc%d.wav',(x+100))),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end


% WHITE NOISE PADDING
for x = 1:100    
    
    filename = 'WhiteNoise_%d.wav';
    str = sprintf(filename,x);
    
    [R,fs2] = audioread(str);
    n2 = length(R); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef Check 
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('NoisePadTrunc%d.wav',(x+200))),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end

%% PADDING OR TRUNCATING FOR REDUCED NOISE DATA  
fs=24000;
b = audioread('explosion_training (12000).wav');
n = length(b); % length of reef check audio vector is 41444
% Create a new folder in your current folder to hold the augmented data set.

% BROWN NOISE PADDING
for x = 1:100    
    
    filename = 'ReducBrownNoise_%d.wav';
    str = sprintf(filename,x);
    
    [R,fs2] = audioread(str);
    n2 = length(R); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef Check bigger than audio
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('ReducNoisePadTrunc%d.wav',x)),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end

% PINK NOISE PADDING
for x = 1:100    
    
    filename = 'ReducPinkNoise_%d.wav';
    str = sprintf(filename,x);
    
    [R,fs2] = audioread(str);
    n2 = length(R); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef Check 
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('ReducNoisePadTrunc%d.wav',(x+100))),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end


% WHITE NOISE PADDING
for x = 1:100    
    
    filename = 'ReducWhiteNoise_%d.wav';
    str = sprintf(filename,x);
    
    [R,fs2] = audioread(str);
    n2 = length(R); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef Check 
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('ReducNoisePadTrunc%d.wav',(x+200))),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end


%% TRUNCATING UW NOISE
fs=24000;
b = audioread('explosion_training (12000).wav');
n = length(b); % length of reef check audio vector is 41444
UWNoise = zeros(400000,12);

UWNoiseTest = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\UW Testing audio', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');

    % Create a new folder in your current folder to hold the augmented data set.
    currentDir = pwd;
    writeDirectory = fullfile(currentDir,'UW_Noise_Pad_Truncated');
    mkdir(writeDirectory)
    

for x = 1:16    % 1:5040

     [UWNoise(:,x),fs(x,1)] = audioread(UWNoiseTest.Files{x,1});
    n2 = length(UWNoise(:,x)); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef > 
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('UWNoise_Trunc%d.wav',x)),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end

%% MISC PADDING/TRUNCATING
fs=24000;
b = audioread('Trial4Val_SIA_01.wav');
n = length(b); % length of reef check audio vector is 41444
%Misc = zeros(400000,12);

PaddingTest = audioDatastore('C:\Users\soong\OneDrive\Desktop\DEEP LEARNING FYP\Training_Trial4\Misc', 'IncludeSubfolders', false,'LabelSource', 'foldernames','FileExtensions','.wav');

    % Create a new folder in your current folder to hold the augmented data set.
    currentDir = pwd;
    writeDirectory = fullfile(currentDir,'Misc');
    mkdir(writeDirectory)
    
for x = 1:4    
    
    [R,fs2] = audioread(PaddingTest.Files{x,1});
    n2 = length(R); % length of file that is padded or truncated
    
    ndiff= ((n-n2));
    
    if ndiff > 0% Reef Check 
        R_pad = padarray(R, ndiff, 'replicate','post');
            elseif ndiff < 0
                ndiff = abs(ndiff);
                R_pad = R(1:end-ndiff,1);
            elseif ndiff == 0
                R_pad = R;
    end
  
     audiowrite(fullfile(writeDirectory,sprintf('MiscPadTrunc%d.wav',(x))),R_pad,fs);
     fprintf('Now doing number: %d \n',x);
     
end