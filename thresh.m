%Thresholding for diff(RMS)
%Somesh Ganesh
function [max_drms thresh_diff_rms] = thresh(bp_filtered_signal,diff_rms,time_stamps,t)

max_drms = max(diff_rms(2:end));
for i=1:length(diff_rms)
    if diff_rms(i)<=(0.5*max_drms)
        thresh_diff_rms(i) = 0;
    else
        thresh_diff_rms(i) = diff_rms(i);
end

figure;
subplot(3,1,1);
plot(t,bp_filtered_signal); axis tight;
title('Thresholding for diff(rms)');
subplot(3,1,2);
plot(time_stamps(1:end),diff_rms); axis tight;
subplot(3,1,3);
plot(xcorr(diff_rms)); axis tight;

end