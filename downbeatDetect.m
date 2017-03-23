%Detecting downbeats from beats
%Somesh Ganesh
function downbeats = downbeatDetect(bp_filtered_signal,beats,loc,downbeat_dist,time_stamps,fs,hop_size,t)

downbeats = zeros(1,length(beats));
downbeats(loc) = 1;


literations = floor(time_stamps(loc) / downbeat_dist);
hiterations = floor((time_stamps(end) - time_stamps(loc)) / downbeat_dist);

downbeat_period_frames = downbeat_dist * fs / hop_size;

for i=1:literations
    for j=round(loc - i * 1.1 * downbeat_period_frames):round(loc - i * 0.9 * downbeat_period_frames)
        if j > 0 & j < length(beats)
            if beats(j) ~= 0
                downbeats(j) = 1;
            end
        end    
    end
end

for i=1:hiterations
    for j=round(loc + i * 0.9 * downbeat_period_frames):round(loc + i * 1.1 * downbeat_period_frames)
        if j > 0 & j < length(beats)
            if beats(j) == 1
                downbeats(j) = 1;
            end
        end 
    end
end

figure;
subplot(2,1,1);
plot(t,bp_filtered_signal); axis tight;
title('Downbeats');
subplot(2,1,2);
plot(time_stamps(1:end),downbeats); axis tight;


end