%Genearing blocks
%Somesh Ganesh
function [t,X] = generateBlocks(x, sample_rate_Hz, block_size, hop_size)

block_duration = block_size/sample_rate_Hz;
no_of_frames = ceil(length(x)/hop_size);

x = vertcat(x,zeros(block_size,1));

for fr_no = 0:no_of_frames-1
    Xtemp = x(((fr_no*hop_size)+1:(fr_no*hop_size)+block_size),1);
    X(1:block_size,fr_no+1) = Xtemp';
    ttemp(fr_no+1) = fr_no*hop_size/sample_rate_Hz;
    
end

t = ttemp';

end