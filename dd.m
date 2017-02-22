%Downbeat Detection
%Somesh Ganesh

clc;
clear all;
close all;

[stereo_audio,fs] = audioread('/Users/someshganesh/Documents/GaTech/Spring 2017/MUSI 7100/Downbeat Detection/120_jd_drums_1.wav');
mono_audio = stereo_audio(:,1);
audio = normalizeIntensityLevel(mono_audio,fs);
t = 0:1/fs:(length(audio)-1)/fs;
f = 1:fs/2048:fs;

figure;
plot(t,audio); axis tight;
title('Time domain representation of audio input');
figure;
spectrogram(audio,hamming(1024),512,1024,fs,'yaxis'); 
ax = caxis;
title('Spectrogram of original audio (1 channel)');
%%
%Bandpass filtering input signal

bp_filtered_signal = bpass(audio,fs,ax);
%%
%Dividing the file into blocks

%Function arguments for reference
%function [t,X] = generateBlocks(x, sample_rate_Hz, block_size, hop_size)
[time_stamps,audio_blocks] = generateBlocks(bp_filtered_signal, fs, 1024, 256);
%%
%Difference function on audio file

% diff_aud = [0;diff(bp_filtered_signal)];
% diff_aud = normalizeIntensityLevel(diff_aud,fs);
% 
% figure;
% subplot(2,1,1);
% plot(t,bp_filtered_signal); axis tight;
% title('Difference of filtered audio file');
% subplot(2,1,2);
% plot(t,diff_aud); axis tight;
%%
%Calculating RMS for each block

rms_audio_blocks = rmsCal(audio_blocks,fs);
%%
%Calculating first derivative of RMS

diff_rms = diff([0 rms_audio_blocks]);
diff_rms = normalizeIntensityLevel(diff_rms,fs);

figure;
subplot(3,1,1);
plot(t,bp_filtered_signal); axis tight;
title('RMS & diff(RMS)');
subplot(3,1,2);
plot(time_stamps(1:end),rms_audio_blocks); axis tight;
subplot(3,1,3);
plot(time_stamps(1:end),diff_rms); axis tight;
%%
%Finding peaks

% [peaks1,locations1] = findpeaks(rms_audio_blocks,fs);
% [peaks2,locations2] = findpeaks(diff_rms,fs);
% 
% figure;
% subplot(3,1,1);
% plot(t,bp_filtered_signal); axis tight;
% subplot(3,1,2);
% plot(locations1,peaks1); axis tight;
% subplot(3,1,3);
% plot(locations2,peaks2); axis tight;
%%
%Combining features

% peak_sig1 = rms_audio_blocks + [0 diff_rms];
% peak_sig2 = rms_audio_blocks .* [0 diff_rms];
% 
% figure;
% subplot(3,1,1);
% plot(t,bp_filtered_signal); axis tight;
% subplot(3,1,2);
% plot(time_stamps(1:end),peak_sig1); axis tight;
% subplot(3,1,3);
% plot(time_stamps(1:end),peak_sig2); axis tight;
%%
%Thresholding

% max_daud = max(diff_aud(2:end));
% for i=1:length(diff_aud)
%     if diff_aud(i)<=(0.5*max_daud)
%         diff_aud(i) = 0;
%     end
% end

[max_drms thresh_diff_rms] = thresh(bp_filtered_signal,diff_rms,time_stamps,t);
%%

   
        
        