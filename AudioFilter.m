[x,fs] = audioread('music_noisy.wav'); % Read in audio signal

% This is the first method - Time Domain
% 'opengl software' command may be required first for some plots to work -
% otherwise 'source width = 0' error occurs

% Plot orignial noisy signal in time domain
t = 0:1/fs:(length(x)-1)/fs;
plot(t,x);

% Plotting fft of signal to view noise
figure
plot(abs(fft(x))); 
% We see noises at 14.886 kHz and 37.214 kHz - we can use bandstop filters
% These noises ar   e above the sampling frequency. So we need to convert them
factor = length(x) / fs;    % This factor will be used to convert the noise frequencies if they were sampled from our sampling length 

% The filter needs some time and space to drop down at stop band,
% thus stopband frequencies are chosen over a range 

% CREATING FIRST FILTER
% First we'll filter the noise at 14.886 kHz
ws1 = (13.0*1000)/factor; % First stopband frequency (Hz) 
ws2 = (17.99*1000)/factor; % Second stopband frequency (Hz)

firstFilter = fir1(256, [ws1 ws2]/(fs/2),'stop');
% Applying this filter to noisy signal
firstSignal = conv(x,firstFilter);

% By plotting and viewing the noise, we can determine at which frequencies
% ws1 and ws2 noise deminishes
figure
plot(abs(fft(firstSignal)))


% CREATING SECOND FILTER AND COMBINING FILTERS
% Now we filter out noise at 37.214 kHz
ws1 = (35.4*1000)/factor; % First stopband frequency (Hz)
ws2 = (39.99*1000)/factor; %  Second stopband frequency (Hz)

secondFilter = fir1(256, [ws1 ws2]/(fs/2),'stop');

% To view the affect of only the second filter on the noisy signal
figure
plot(abs(fft(conv(secondFilter,x))))

% Applying this filter to first filtered signal (combining filters)
finalSignal = conv(firstSignal,secondFilter);

% Plotting helps to determine ws1 and ws2 values
figure
plot(abs(fft(finalSignal)))

% =============================================
% This is the seconod method - Frequency Domain

% We can create the same filters, as in Time domain. For efficiency, we
% will just use the filters already created

% Convert time-domain to frequency-domain
% Reshaping and adding points to filters to ensure they are the same length
fFilter1 = fft(firstFilter,297702)';
fFilter2 = fft(secondFilter,297702)';
fNoisySignal = fft(x);

freqSignal = fFilter1.*fFilter2.*fNoisySignal;
% Convert the frequency signal back to time to be able to hear audio
filteredSignal = ifft(freqSignal);

% ===============================================
% Creating audio file of filtered signal
audiowrite('FilteredAudio.wav',finalSignal,fs);
    
