%Spectral Flux
%Somesh Ganesh
function sflux_audio_blocks = sflux(audio_blocks,block_size,fs)

for i = 1:length(audio_blocks(1,:))
    x1 = abs(fft(audio_blocks(:,i).*hamming(block_size),block_size));
    x12 = x1(1:block_size/2);
    if i~=1
        x2 = abs(fft(audio_blocks(:,i-1).*hamming(block_size),block_size));
    else
        x2 = x1;
    end
    x22 = x2(1:block_size/2);
    sflx = sum((x12-x22).^2);
    sflux_audio_blocks(i) = sflx; 
end

figure;
plot(sflux_audio_blocks); axis tight;

end