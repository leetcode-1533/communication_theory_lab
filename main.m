clear all;

N = 50;
data_rate = 1000
% creating N bits, the bit rate is 1000bps(1000 bits per second)

data = randint(N,1);
Fs = 8000; % sampling frequency

samplesPerBit  = Fs/data_rate;

k=1;
for i = 1:N
    for j = 1:samplesPerBit  % these loops create the
        y(k) = data(i);      % bit stream
        k=k+1;
    end
end  
