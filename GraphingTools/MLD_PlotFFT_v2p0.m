function Output = MLD_PlotFFT_v2p0(InputTimeData,SamplingFreq,FigHandle,Style,N_FFT)
%% Time specifications:
InputTimeData(isnan(InputTimeData)) = [];
dt = 1/SamplingFreq;                     % seconds per sample
StopTime = 1;                  % seconds
t = linspace(0, dt*(length(InputTimeData) - 1), length(InputTimeData))';

if nargin < 5
    N = length(InputTimeData);
else
    N = N_FFT;
end


InpLen = length(InputTimeData);
%% Fourier Transform:
InputTimeData = interp1(linspace(0, 1, length(InputTimeData)), InputTimeData, linspace(0, 1, N));
InputFreqData = fftshift(fft(InputTimeData));

%% Frequency specifications:
dF = SamplingFreq/N;                     % hertz
f = -SamplingFreq/2 + dF*(0:N-1);        % hertz

dF2 = SamplingFreq/InpLen;                  % hertz
f2 = -SamplingFreq/2 + dF*(0:InpLen-1);           % hertz
xticks(f);
xticklabels()

%% Plot the spectrum:
if nargin <= 2
    figure;
elseif FigHandle == -1
else
    figure(FigHandle);
end

if nargin < 4
    Style = 'b';
end

AmplitudeValues = (abs(InputFreqData)/N).^0.5;

plot(f, AmplitudeValues, Style);
xlabel('Frequency [Hz]');
title('Magnitude Response');
axis([0 SamplingFreq/2 0 (max(AmplitudeValues)*1.05)]);
grid on;
end
