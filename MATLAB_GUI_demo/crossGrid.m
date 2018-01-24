%Finding tempo using cross grid method
%Somesh Ganesh
function [tempo] = crossGrid(signal, period, time_stamps)

%Defining range of period to consider
lperiod = round(0.95 * period);
hperiod = round(1.05 * period);

%Calculating corresponding bpms
lbpm = 60 / time_stamps(lperiod);
hbpm = 60 / time_stamps(hperiod);

% if(lbpm > 160)
%     lbpm = 160;
% end
% 
% if(hbpm < 80)
%     hbpm = 80;
% end

%Loop for cross correlation of period signal with different bpms under
%consideration
padded_signal = [zeros(1,length(signal)) signal zeros(1,length(signal))];
val = zeros(1,length(signal));
counter = 1;
for i = floor(hbpm) : 0.125 : ceil(lbpm)
    impulse_amplitude = 0;
    grid = zeros(1,length(padded_signal));
    time_of_grid_period = 60 / i;
    grid_period = length(time_stamps(time_stamps < time_of_grid_period));
    grid_window = hamming(grid_period + 1)';
    for j = hperiod : grid_period : length(padded_signal)
%         counter = 1;
%         for arg = j - 0.5 * grid_period : j + 0.5 * grid_period
%             grid(1,arg) = grid_window(1, counter);
%             counter = counter + 1;
%         end
        
        grid(1,(j - 0.5 * grid_period : j + 0.5 * grid_period)) = grid_window';
        impulse_amplitude = impulse_amplitude + 1;
    end
    grid = grid ./ impulse_amplitude;
    
    [val(1,counter)] = max(xcorr(grid , padded_signal, 2 * hperiod));
%     [val(1,counter)] = max(cconv((fliplr(grid)) , padded_signal));
    counter = counter + 1;
end

[max_val, max_loc] = max(val);

tempo = floor(hbpm) + (max_loc - 1) * 0.125;

% while (tempo < 80)
%     tempo = tempo * 2;
% end
% 
% while (tempo > 160)
%     tempo = tempo / 2;
% end 

end