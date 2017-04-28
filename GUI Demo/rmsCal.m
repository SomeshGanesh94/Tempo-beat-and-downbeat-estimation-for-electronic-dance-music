%RMS calculation for each block
%Somesh Ganesh
function rms_audio_blocks = rmsCal(audio_blocks,fs)

for i =1:length(audio_blocks(1,:))
    rms_audio_blocks(i) = rms(audio_blocks(:,i));
end
rms_audio_blocks = normalizeIntensityLevel(rms_audio_blocks,fs);

end