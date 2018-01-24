%Tempo, beat and downbeat estimation
%Somesh Ganesh

clc;
clear all;
close all;


bp_filt = designfilt('bandpassfir', 'StopbandFrequency1', 1,...
    'PassbandFrequency1', 50, 'PassbandFrequency2', 400,...
    'StopbandFrequency2', 450, 'StopbandAttenuation1', 60,...
    'PassbandRipple', 3, 'StopbandAttenuation2', 60, 'SampleRate', 44100);


%%

files = dir('/Users/someshganesh/Documents/GaTech/Spring 2017/MUSI 7100/Datasets/Gaint Steps/giantsteps-tempo-dataset-master/audio');

for song_counter = 4 : 40
    song_counter
    
    [stereo_audio,fs] = audioread(strcat(files(song_counter).folder,'/',files(song_counter).name));
    
    [path,name,ext] = fileparts(strcat(files(song_counter).folder,'/',files(song_counter).name));
    
    bpmfile = fopen(strcat('/Users/someshganesh/Documents/GaTech/Spring 2017/MUSI 7100/Datasets/Gaint Steps/giantsteps-tempo-dataset-master/annotations/tempo/',name,'.bpm'));
    true_bpm(song_counter) = fscanf(bpmfile,'%f'); 

% [stereo_audio,fs] = audioread('/Users/someshganesh/Documents/GaTech/Spring 2017/MUSI 7100/Datasets/Loop based EM/ISMIR16-EM-Patterns-Audio/dataset/125_acid_drums.wav');
% [stereo_audio,fs] = audioread('/Users/someshganesh/Documents/GaTech/Spring 2017/MUSI 7100/Downbeat Detection/150_juke_drums.wav');
mono_audio = stereo_audio(:,1);
audio = normalizeIntensityLevel(mono_audio,fs);
t = 0:1/fs:(length(audio)-1)/fs;
f = 1:fs/2048:fs;

% figure;
% plot(t,audio); axis tight;
% title('Time domain representation of audio input');
% figure;
% spectrogram(audio,hamming(1024),512,1024,fs,'yaxis'); 
% ax = caxis;
% title('Spectrogram of original audio (1 channel)');
%%
%Bandpass filtering input signal

bp_filtered_signal = bpass(bp_filt,audio,fs);
%%
%Dividing the file into blocks

%Function arguments for reference
%function [t,X] = generateBlocks(x, sample_rate_Hz, block_size, hop_size)
block_size = 1024;
hop_size = 256;

[time_stamps,audio_blocks] = generateBlocks(bp_filtered_signal, fs, block_size, hop_size);
%%
%Calculating RMS for each block

rms_audio_blocks = rmsCal(audio_blocks,fs);

% sflux_audio_blocks = sflux(audio_blocks,block_size,fs);
%%
%Calculating first derivative of RMS

diff_rms = diff([0 rms_audio_blocks]);
diff_rms = normalizeIntensityLevel(diff_rms,fs);

% diff_rms = medfilt1(diff_rms1,10);

% figure;
% subplot(3,1,1);
% plot(t,bp_filtered_signal); axis tight;
% title('RMS & diff(RMS)');
% subplot(3,1,2);
% plot(time_stamps(1:end),rms_audio_blocks); axis tight;
% subplot(3,1,3);
% plot(time_stamps(1:end),diff_rms); axis tight;
%%
%New beat detection section


% update beat detection algorithm
% 	choose highest diff rms
[max_drms, loc] = max(diff_rms(2:end));

% 	xcorr and find period
period = periodAcorr(diff_rms(2:end),time_stamps);

tempo(song_counter) = crossGrid(diff_rms, period, time_stamps);

% 	up and down to find max diff rms in a tolerance range
% [beats, computed_period] = beatDetect(diff_rms,bp_filtered_signal,period,loc,t,time_stamps);

% computed_bpm = 60 / time_stamps(computed_period);
% computed_bpm(song_counter) = 60 / time_stamps(computed_period);

% 	xcorr and find period again
% 	go in the same direction till end on both sides
% 	avg period?
% 	mark beats for this avg period
%%
%Moving average filtering

% mov_avg_filt_sig = movAvg(diff_rms,5);
%%
%Thresholding

% [max_drms, thresh_diff_rms] = thresh(bp_filtered_signal,diff_rms,time_stamps,t);
% %%
% %Finding period of audio using autocorrelation
% 
% period = periodAcorr(thresh_diff_rms);
% 
% 
% 
% % period = periodAcorr(bp_filtered_signal);
% 
% %%
% %Locating tolerance positions of diff_rms and using BPM to find approximate
% %distance between downbeats
% 
% [max_drms, loc] = max(thresh_diff_rms(2:end));
% 
% bpm = 128; %Assuming 4/4
% 
% downbeat_dist = bpm / 60;
% %%
% %Find Beats using period
% 
% beats = beatDetect(rms_audio_blocks,bp_filtered_signal,period,loc,t,time_stamps);
% 
% computed_bpm = 60 / time_stamps(period)
% %%
% %Extracting downbeats from beats
% % a = xcorr(thresh_diff_rms);
% % b = a(1:(length(a)/2)+1);
% 
% % downbeats = downbeatDetect(bp_filtered_signal,beats,loc,downbeat_dist,time_stamps,fs,hop_size,t);
% 
% %%
% %Segment using sflux
% 
% 
% 
% % smooth_sflux = movAvg(sflux_audio_blocks,1);
% %     
% % diff_sflux = diff(smooth_sflux);
% % figure;
% % subplot(2,1,1);
% % plot(smooth_sflux); axis tight;
% % title('Diff input & output');
% % subplot(2,1,2);
% % plot(diff_sflux); axis tight;
% 
% 
%    
%         

%%
% %Evaluation parameters
main_tempo_diff = zeros(1, 6);
main_tempo_diff(1,1) = true_bpm(song_counter) - tempo(song_counter);
main_tempo_diff(1,2) = true_bpm(song_counter) - 2 * tempo(song_counter);
main_tempo_diff(1,3) = true_bpm(song_counter) - 4 * tempo(song_counter);
main_tempo_diff(1,4) = true_bpm(song_counter) - 8 * tempo(song_counter);
main_tempo_diff(1,5) = true_bpm(song_counter) - 16 * tempo(song_counter);
main_tempo_diff(1,6) = true_bpm(song_counter) - 32 * tempo(song_counter);

difference_bpm(song_counter - 3) = min(abs(main_tempo_diff));

disp(difference_bpm(song_counter - 3));
disp(true_bpm(song_counter));


end 

mean_difference = mean(difference_bpm);

std_result = std(difference_bpm);