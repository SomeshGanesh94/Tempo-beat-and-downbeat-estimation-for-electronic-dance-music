%Spectral Centroid
%Somesh Ganesh

function spec_centroid_blocks = specCentroid(audio_blocks, block_size, fs)

spec_centroid_blocks = zeros(1,block_size / 2);

for i = 1:length(audio_blocks(1,:))
    x1 = abs(fft(audio_blocks(:,i).*hamming(block_size),block_size));
    x12 = x1(1:block_size/2);
    
    if (sum(x12) == 0)
        speccent = 0;
    else
        temp = 0;
    
        for j = 1 : block_size / 2
            f(j) = j * fs / block_size;
            temp = temp + (f(j) * x12(j));
        end
    
        speccent = temp / (sum(x12)); 
    end
    
    spec_centroid_blocks(i) = speccent; 
end

end