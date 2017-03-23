%Calculation of period using autocorrelation
%Somesh Ganesh
function period = periodAcorr(input,time_stamps)

% acorr_audio1 = xcorr(input);
% acorr_audio = medfilt1(acorr_audio1);

acorr_audio = xcorr(input);
mov_avg_filt_sig = movAvg(acorr_audio,5);


[max_acorr1 index1] = max(mov_avg_filt_sig);
[max_acorr2 index2] = max(mov_avg_filt_sig(1:(length(mov_avg_filt_sig) / 2) - 1));

period = index1 - index2;

while (time_stamps(period) < 0.4) || (time_stamps(period) > 0.5)

% while (time_stamps(period) < 0.3529) || (time_stamps(period) > 0.5455)
    
    
    [max_acorr2 index2] = max(mov_avg_filt_sig(1:(length(mov_avg_filt_sig) / 2) - 1));

    period = index1 - index2;
    
    time_stamps(period);

    mov_avg_filt_sig(index2) = 0;

end

end