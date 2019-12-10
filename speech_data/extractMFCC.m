% extractMFCC extacts Mel-Frequency Cepstrum Coefficients(MFCC) from all
% .wav files in a directory. 
% Inputs:
% ------------------------------------------------------------------------
%   window_type: Type of window to use when taking STFT
%       0: Rectangular
%       1: Hamming
%       2: Bartlett
%       3: Hanning 
%   window_size: Length of window to extract MFCC (in ms)
%   overlap: overlap between windows (in percent)
%   voiced_extract: 1 to only extract MFCCs on windows with voiced
%   sound. 0 to extract on all windows.
% Outputs:
% ------------------------------------------------------------------------
%   MFCC: Matrix storing progression of all 13 MFCC values throughout time

function MFCC = extractMFCC(window_type, window_size, overlap, voiced_extract)
    CUTOFF = 2000;
    files = dir('*.wav');
    
    MFCC = zeros(CUTOFF, 13, length(files));
    
    % Loop through all files in the directory and extract filenames
    for i=1:length(files)
        file_name = files(i).name;

        [audio_signal, Fs] = audioread(file_name);
        window_len = floor(window_size*Fs/1000);
        
        % Create window from user parameter
        switch window_type
            case 0
                window = rectwin(window_len);
            case 1
                window = hamming(window_len, "periodic");
            case 2
                window = bartlett(window_len);
            case 3
                window = hann(window_len, "periodic");
            otherwise
                disp("Invalid input for window type. Please try again.");
                return;
        end
        
        % Perform Short Time Fourier Transform using window recently built
        % Overlap is determined by taking a percent of window length
        S = stft(audio_signal,Fs, "Window", window, "OverlapLength", floor(overlap), "Centered", false);
        temp = mfcc(S, Fs, "LogEnergy", "Ignore");
        
        if(size(temp,1) > CUTOFF)
            temp = temp(1:CUTOFF,:);
        end
        
        MFCC(:,:,i) = vertcat(temp,zeros(CUTOFF - length(temp), 13));
    end
    
    for i=1:CUTOFF
        temp = squeeze(MFCC(i,:,:)).';
        var_vec = var(temp);
        mean_vec = mean(temp);

        for j=1:13
            temp(:,j) = (temp(:,j) - mean_vec(j)) / var_vec(j);
        end

        MFCC(i,:,:) = temp.';
    end
end
