%Finding beats using period 
%Somesh Ganesh
function [beats, new_avg_period] = beatDetect(diff_rms,bp_filtered_signal,period,loc,t,time_stamps)

beats = zeros(1,length(diff_rms(1,:)));
beats(loc) = 1;

% 	up and down to find max diff rms in a tolerance range
% 	xcorr and find period again
% 	go in the same direction till end on both sides
% 	avg period?
% 	mark beats for this avg period
period_array = zeros(7,1);
period_array(1,1) = period;
new_avg_period = period;
lmax_position1 = loc;

diff_temp1 = diff_rms;
diff_temp2 = diff_rms;

for i = 1 : 3
    midval = lmax_position1 + (round(0.9 * new_avg_period) : round(1.1 * new_avg_period));
    midval(1);
    diff_temp1 = [diff_temp1 zeros(1,round(1.2 * new_avg_period))];
    [local_maxima,lmax_position2] = max(diff_temp1(round(midval)));
    period_array(i+1,1) = lmax_position2 + (round(0.8 * new_avg_period));
    lmax_position1 = lmax_position1 + new_avg_period;
%     new_avg_period = mean(period_array);
end


lmax_position1 = loc;
for i = 1 : 3
    midval = lmax_position1 - (round(0.8 * new_avg_period) : round(1.2 * new_avg_period));
    midval(1);
    if(isempty(midval(midval<0)) == 0)
        break;
    end
    diff_temp2 = [zeros(1,round(1.2 * new_avg_period)) diff_temp2];
    [local_maxima,lmax_position2] = max(diff_temp2(round(midval)));
    period_array(i+4,1) = lmax_position1 - midval(lmax_position2);
    lmax_position1 = lmax_position1 - new_avg_period;
%     new_avg_period = mean(period_array);
end 

new_avg_period = mean(period_array);
new_avg_period = round(new_avg_period);

%Beats after LOC
hrange = length(beats) - loc;
hiterations = floor(hrange/new_avg_period);

for i = 1:hiterations
    beats(loc + (i*new_avg_period)) = 1;
end

%Beats before LOC
lrange = loc;
literations = floor(lrange/new_avg_period);

for i = 1:literations
    beats((loc - (i*new_avg_period))+1) = 1;
end

% figure;
% subplot(2,1,1);
% plot(t,bp_filtered_signal); axis tight;
% title('Beats');
% subplot(2,1,2);
% plot(time_stamps(1:end),beats); axis tight;

end