 % the code is to get all the related data from a single execution
    snr = 4; % 4db
    N = 500;
    data_rate = 1000;
    % creating N bits, the bit rate is 1000bps(1000 bits per second)

    data = randint(N,1);
    Fs = 8000; % sampling frequency
    data_t = 0:1/data_rate:(N-1)/data_rate;
    samplesPerBit  = Fs/data_rate;

    k=1;
    for i = 1:N
        for j = 1:samplesPerBit  % these loops create the
            y(k) = data(i);      % bit stream: y is 8000hz(8000 samples per second), data is 1000 samples per second
            k=k+1;
        end 
    end  

    end_time = length(y)*(1/Fs);
    t = linspace(0,0.05,length(y));
    fc = 2000;
    carrier = cos(2*pi*fc*t);
    % plot(carrier)

    modulated_signal = carrier.*y;

    % snr = 3; %3db
    noised_signal = awgn(modulated_signal,snr,'measured');

    demodulate_signal = noised_signal.*carrier;

    [b,a] = butter(5,fc/Fs);
    Filtered_signal = filtfilt(b,a,demodulate_signal);

    new_data = zeros(1,length(data));
    for index = 1:samplesPerBit:length(y)
        temp = Filtered_signal(index:index+samplesPerBit-1);
        new_data(ceil(index/8)) = mean(temp) > 0.25;  %attundate by half
    end
    ber = length(find(data==new_data'))/length(data);
%%%%
iter = 1:100;
cell_event1 = 'Binary signal';
cell_event2 =  'Sampled signal';
cell_event3 = 'Filtered signal';
cell_event4 = 'Modulated signal';
cell_event5 = 'Received signal';

events = {cell_event1;cell_event2;cell_event3;cell_event4;cell_event5};
for iter_event = 1:length(events)
    cell_event = events{iter_event};
    appe = ' for SNR=4 dBs'; 
    str = strcat(cell_event,appe);
    switch cell_event
        case{'Binary signal'}
            stem(data_t(iter),data(iter))
            title(str)
        case{'Sampled signal'}
            stem(y(iter))
            title(str)
        case{'Modulated signal'}
            stem(t(iter),modulated_signal(iter))
            title(str)
        case{'Received signal'}
            stem(t(iter),noised_signal(iter))
            title(str)
        case{'Filtered signal'}
            stem(Filtered_signal(iter)) 
            title(str)
    end
     print(str,'-dpng');
end



