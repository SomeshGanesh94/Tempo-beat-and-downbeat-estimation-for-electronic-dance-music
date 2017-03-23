%Bandpass filtering the input signal
%Somesh Ganesh
function bp_filtered_signal = bpass(bp_filt,audio,fs)

% bp_filt = designfilt('bandpassfir', 'StopbandFrequency1', 1,...
%     'PassbandFrequency1', 50, 'PassbandFrequency2', 400,...
%     'StopbandFrequency2', 450, 'StopbandAttenuation1', 60,...
%     'PassbandRipple', 3, 'StopbandAttenuation2', 60, 'SampleRate', fs);

bp_filtered_signal = filtfilt(bp_filt,audio);

% figure;
% spectrogram(bp_filtered_signal,hamming(1024),512,1024,fs,'yaxis'); 
% caxis(ax);
% title('Bandpass filtered signal');

end