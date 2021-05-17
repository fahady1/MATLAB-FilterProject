%EECS3451 Mini Project

%Q1
fs = 8000;    % Sampling freqeuency
F = [500 1500 2000 3000]; % Frequency array needs to be 2*length(A) - 2
A = [0 1 0];                   % 0 is for stopband, 1 for passband
dev = [0.01 0.01 0.001];  % The ripple from 0-500, 1500-2000, and 3000-4000 respectivily 
 
[N,Fi,Ai,W] = firpmord(F,A,dev,fs);  % Creating filter

h=firpm(N,Fi,Ai,W); % To find filter coefficients 

% N is filter order, h contains filter coefficients

freqz(h,1,512,fs)