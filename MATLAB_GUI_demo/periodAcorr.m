%Calculation of period using autocorrelation
%Somesh Ganesh
function [period, acorr_bpm] = periodAcorr(input,time_stamps)

% acorr_audio1 = xcorr(input);
% acorr_audio = medfilt1(acorr_audio1);

acorr_audio = xcorr(input);
% mov_avg_filt_sig = movAvg(acorr_audio,5);


[max_acorr1 index1] = max(acorr_audio);

acorr_audio(index1) = 0;

[max_acorr2 index2] = max(acorr_audio);
% [max_acorr2 index2] = max(acorr_audio(1:(length(acorr_audio) / 2) - 1));

period = abs(index1 - index2);

% lower_limit = length(time_stamps(time_stamps < 0.75));
% higher_limit = length(time_stamps(time_stamps < 0.375));
% 
% range = time_stamps(lower_limit : higher_limit);


% while ((time_stamps(period) > 0.75) || (time_stamps(period) < 0.375))
%     acorr_audio(index2) = 0;
%     
%     [max_acorr2 index2] = max(acorr_audio);
%     
%     period = abs(index1 - index2);
% end
% figure;
% subplot(2,1,1);
% plot(input); axis tight;
% subplot(2,1,2);
% plot(acorr_audio); axis tight;

while ((60 / time_stamps(period)) < 80)
    period = round(period / 2);
end

while ((60 / time_stamps(period)) > 160)
    period = round(period * 2);
end 

acorr_bpm = 60 / time_stamps(period);
%Range for bpm from 80 to 160
% while (time_stamps(period) < 0.75) || (time_stamps(period) > 0.375)
% 
% % while (time_stamps(period) < 0.3529) || (time_stamps(period) > 0.5455)
%     
%     
%     [max_acorr2 index2] = max(mov_avg_filt_sig(1:(length(mov_avg_filt_sig) / 2) - 1));
% 
%     period = index1 - index2;
%     
%     time_stamps(period);
% 
%     mov_avg_filt_sig(index2) = 0;
% 
% end

end