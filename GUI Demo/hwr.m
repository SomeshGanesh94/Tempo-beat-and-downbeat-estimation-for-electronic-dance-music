%Half Wave Rectification
%Somesh Ganesh
function output = hwr(audio)

output = audio.*((sign(audio)+1)/2);

end