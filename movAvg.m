%Moving Average Filter
%Somesh Ganesh

function y = movAvg(x,win_size)

b = (1/win_size)*ones(1, win_size);
a = 1;

y = filter(b, a, x);

% figure;
% subplot(2,1,1);
% plot(x); axis tight;
% title('Moving average filter input & output');
% subplot(2,1,2);
% plot(y); axis tight;

end