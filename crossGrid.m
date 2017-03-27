%Finding tempo using cross grid method
%Somesh Ganesh
function [tempo] = crossGrid(signal, period, time_stamps)

%Defining range of period to consider
lperiod = round(0.8 * period);
hperiod = round(1.2 * period);

%Calculating corresponding bpms
lbpm = 60 / time_stamps(lperiod);
hbpm = 60 / time_stamps(hperiod);

%Loop for cross correlation of period signal with different bpms under
%consideration
val = zeros(1,length(signal));
counter = 1;
for i = floor(hbpm) : 0.00625 : ceil(lbpm)
    impulse_amplitude = 0;
    grid = zeros(1,length(signal));
    time_of_grid_period = 60 / i;
    grid_period = length(time_stamps(time_stamps < time_of_grid_period));
    for j = 1 : grid_period : length(signal)
        grid(1,j) = 1;
        impulse_amplitude = impulse_amplitude + 1;
    end
    grid = grid ./ impulse_amplitude;
    
    [val(1,counter), beat_loc(counter)] = max(xcorr(grid , signal));
    counter = counter + 1;
end

[max_val, max_loc] = max(val);

tempo = floor(hbpm) + (max_loc - 1) * 0.00625;

end